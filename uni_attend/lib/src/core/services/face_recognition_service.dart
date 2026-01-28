import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class FaceRecognitionService {
  late Interpreter _interpreter;
  bool _isModelLoaded = false;

  static const int inputSize = 112;
  static const double threshold = 0.75;

  Future<void> loadModel() async {
    print('--- LOADING FACE RECOGNITION MODEL ---');
    try {
      _interpreter =
          await Interpreter.fromAsset('assets/models/mobilefacenet.tflite');
      _isModelLoaded = true;
      print('SUCCESS: Face recognition model loaded');
    } catch (e) {
      print(
          'ERROR: Failed to load model. Check if assets/models/mobilefacenet.tflite exists. Error: $e');
      _isModelLoaded = false;
    }
    print('---------------------------------------');
  }

  bool get isModelLoaded => _isModelLoaded;

  /// Generates a 128-D embedding for the given crop
  List<double> generateEmbedding(img.Image faceCrop) {
    if (!_isModelLoaded) {
      print('LOG: Cannot generate embedding - Model NOT loaded');
      return [];
    }

    try {
      print(
          'LOG: Preprocessing face crop of size ${faceCrop.width}x${faceCrop.height}');
      // 1. Resize to 112x112
      img.Image resized =
          img.copyResize(faceCrop, width: inputSize, height: inputSize);

      // 2. Preprocess: Normalize to [-1, 1]
      var input = Float32List(1 * inputSize * inputSize * 3);
      var buffer = Float32List.view(input.buffer);
      int pixelIndex = 0;
      for (int y = 0; y < inputSize; y++) {
        for (int x = 0; x < inputSize; x++) {
          var pixel = resized.getPixel(x, y);
          buffer[pixelIndex++] = (pixel.r - 127.5) / 127.5;
          buffer[pixelIndex++] = (pixel.g - 127.5) / 127.5;
          buffer[pixelIndex++] = (pixel.b - 127.5) / 127.5;
        }
      }

      // 3. Reshape input for TFLite [1, 112, 112, 3]
      var inputReshaped = input.reshape([1, inputSize, inputSize, 3]);

      // 4. Output buffer [1, 192] (Matched to your model's requirement)
      var output = Float32List(1 * 192).reshape([1, 192]);

      // 5. Run inference
      print('LOG: Running TFLite inference...');
      _interpreter.run(inputReshaped, output);

      // 6. Extract embedding and L2 Normalize
      List<double> embedding = List<double>.from(output[0]);
      var normalized = _l2Normalize(embedding);
      print(
          'LOG: Successfully generated 192-D embedding (first 5): ${normalized.take(5).toList()}');
      return normalized;
    } catch (e) {
      print('ERROR: Face recognition processing failed: $e');
      return [];
    }
  }

  List<double> _l2Normalize(List<double> embedding) {
    double sum = 0;
    for (var x in embedding) {
      sum += x * x;
    }
    double norm = math.sqrt(sum);
    if (norm == 0) return embedding;
    return embedding.map((x) => x / norm).toList();
  }

  double compareEmbeddings(List<double> emb1, List<double> emb2) {
    return _cosineSimilarity(emb1, emb2);
  }

  double _cosineSimilarity(List<double> emb1, List<double> emb2) {
    double dotProduct = 0;
    for (int i = 0; i < emb1.length; i++) {
      dotProduct += emb1[i] * emb2[i];
    }
    // Since embeddings are L2 normalized, cosine similarity is just the dot product
    return dotProduct;
  }

  void dispose() {
    if (_isModelLoaded) {
      _interpreter.close();
    }
  }
}
