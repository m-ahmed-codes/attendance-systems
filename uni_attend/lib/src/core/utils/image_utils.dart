import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class ImageUtils {
  static img.Image convertCameraImage(CameraImage image) {
    if (image.format.group == ImageFormatGroup.nv21) {
      return _convertNV21(image);
    } else if (image.format.group == ImageFormatGroup.yuv420) {
      return _convertYUV420(image);
    } else if (image.format.group == ImageFormatGroup.bgra8888) {
      return _convertBGRA8888(image);
    }
    throw Exception('Unsupported image format');
  }

  static img.Image _convertBGRA8888(CameraImage image) {
    return img.Image.fromBytes(
      width: image.width,
      height: image.height,
      bytes: image.planes[0].bytes.buffer,
      order: img.ChannelOrder.bgra,
    );
  }

  static img.Image _convertYUV420(CameraImage image) {
    final width = image.width;
    final height = image.height;
    final uvRowStride = image.planes[1].bytesPerRow;
    final uvPixelStride = image.planes[1].bytesPerPixel!;

    final outImg = img.Image(width: width, height: height);

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final uvIndex =
            uvRowStride * (y / 2).floor() + uvPixelStride * (x / 2).floor();
        final index = y * width + x;

        final yp = image.planes[0].bytes[index];
        final up = image.planes[1].bytes[uvIndex];
        final vp = image.planes[2].bytes[uvIndex];

        int r = (yp + (1.4075 * (vp - 128))).round().clamp(0, 255);
        int g = (yp - (0.3455 * (up - 128)) - (0.7169 * (vp - 128)))
            .round()
            .clamp(0, 255);
        int b = (yp + (1.7790 * (up - 128))).round().clamp(0, 255);

        outImg.setPixelRgb(x, y, r, g, b);
      }
    }
    return outImg;
  }

  static img.Image _convertNV21(CameraImage image) {
    // Basic NV21 implementation if needed
    return _convertYUV420(image); // Often similar enough for simple fallback
  }

  static img.Image cropFace(img.Image image, Face face) {
    final rect = face.boundingBox;

    // Safety clamping
    int x = rect.left.toInt().clamp(0, image.width);
    int y = rect.top.toInt().clamp(0, image.height);
    int w = rect.width.toInt().clamp(0, image.width - x);
    int h = rect.height.toInt().clamp(0, image.height - y);

    return img.copyCrop(image, x: x, y: y, width: w, height: h);
  }
}
