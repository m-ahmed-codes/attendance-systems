import 'package:flutter/material.dart';

class StatsCard extends StatelessWidget {
  final String label;
  final String value;
  final String subtext;
  final Color iconColor;
  final IconData icon;

  const StatsCard({
    super.key,
    required this.label,
    required this.value,
    required this.subtext,
    required this.iconColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors
              .white, // In screenshot lightly distinct or white. Assuming white.
          borderRadius: BorderRadius.circular(16),
          // border: Border.all(color: Colors.grey[200]!), // Detailed look might not have border, checking... screenshot looks like just shadow or flat white on grey bg.
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: iconColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: iconColor,
                      letterSpacing: 0.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF101922),
                  ),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    subtext,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[500],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
