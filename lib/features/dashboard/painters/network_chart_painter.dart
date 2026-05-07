import 'package:flutter/material.dart';

import '../models/network_link.dart';
import '../models/network_node.dart';

class NetworkChartPainter extends CustomPainter {
  const NetworkChartPainter({
    required this.nodes,
    required this.links,
    required this.activeNodeId,
  });

  final List<NetworkNode> nodes;
  final List<NetworkLink> links;
  final int? activeNodeId;

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..strokeWidth = 1;

    for (double x = 40; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    for (double y = 40; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final nodeMap = {
      for (final node in nodes)
        node.id: Offset(
          node.position.dx * size.width,
          node.position.dy * size.height,
        ),
    };

    for (final link in links) {
      final from = nodeMap[link.fromId];
      final to = nodeMap[link.toId];
      if (from == null || to == null) {
        continue;
      }

      final isHighlighted =
          link.fromId == activeNodeId || link.toId == activeNodeId;

      final paint = Paint()
        ..shader = LinearGradient(
          colors: [
            Colors.cyanAccent.withValues(alpha: isHighlighted ? 0.95 : 0.35),
            Colors.deepPurpleAccent.withValues(
              alpha: isHighlighted ? 0.85 : 0.25,
            ),
          ],
        ).createShader(Rect.fromPoints(from, to))
        ..strokeWidth = isHighlighted
            ? 2.6 + link.strength
            : 1.2 + link.strength
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final path = Path()
        ..moveTo(from.dx, from.dy)
        ..quadraticBezierTo(
          (from.dx + to.dx) / 2,
          ((from.dy + to.dy) / 2) - 26,
          to.dx,
          to.dy,
        );

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant NetworkChartPainter oldDelegate) {
    return oldDelegate.nodes != nodes ||
        oldDelegate.links != links ||
        oldDelegate.activeNodeId != activeNodeId;
  }
}
