import 'package:flutter/material.dart';

import '../models/network_link.dart';
import '../models/network_node.dart';
import '../painters/network_chart_painter.dart';

class NetworkChartView extends StatelessWidget {
  const NetworkChartView({
    super.key,
    required this.nodes,
    required this.links,
    required this.activeNodeId,
    required this.onReset,
    required this.onNodeTap,
    required this.onNodeDrag,
  });

  final List<NetworkNode> nodes;
  final List<NetworkLink> links;
  final int? activeNodeId;
  final VoidCallback onReset;
  final ValueChanged<int> onNodeTap;
  final void Function(NetworkNode, DragUpdateDetails, Size) onNodeDrag;

  @override
  Widget build(BuildContext context) {
    final activeNode = activeNodeId == null
        ? null
        : nodes.cast<NetworkNode?>().firstWhere(
            (node) => node?.id == activeNodeId,
            orElse: () => null,
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Interactive Network',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Circle gula drag korle connection line live move korbe.',
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  ),
                ],
              ),
            ),
            TextButton.icon(
              onPressed: onReset,
              icon: const Icon(Icons.restart_alt),
              label: const Text('Reset'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF111827),
                  const Color(0xFF0F172A),
                  Colors.blueGrey.shade900,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: Colors.white10),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final canvasSize = Size(
                  constraints.maxWidth,
                  constraints.maxHeight,
                );

                return Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: NetworkChartPainter(
                          nodes: nodes,
                          links: links,
                          activeNodeId: activeNodeId,
                        ),
                      ),
                    ),
                    ...nodes.map(
                      (node) => _DraggableNetworkNode(
                        node: node,
                        canvasSize: canvasSize,
                        isActive: activeNodeId == node.id,
                        onTap: () => onNodeTap(node.id),
                        onDrag: (details) =>
                            onNodeDrag(node, details, canvasSize),
                      ),
                    ),
                    if (activeNode != null)
                      Positioned(
                        left: 16,
                        right: 16,
                        bottom: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.30),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: activeNode.color.withValues(alpha: 0.45),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: activeNode.color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  '${activeNode.label} node selected • drag kore position change koro',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _DraggableNetworkNode extends StatelessWidget {
  const _DraggableNetworkNode({
    required this.node,
    required this.canvasSize,
    required this.isActive,
    required this.onTap,
    required this.onDrag,
  });

  final NetworkNode node;
  final Size canvasSize;
  final bool isActive;
  final VoidCallback onTap;
  final GestureDragUpdateCallback onDrag;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: (node.position.dx * canvasSize.width) - node.size,
      top: (node.position.dy * canvasSize.height) - node.size,
      child: GestureDetector(
        onTap: onTap,
        onPanUpdate: onDrag,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: node.size * 2,
          height: node.size * 2,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                Colors.white.withValues(alpha: 0.95),
                node.color.withValues(alpha: 0.95),
                node.color.withValues(alpha: 0.45),
              ],
            ),
            border: Border.all(
              color: isActive
                  ? Colors.white
                  : node.color.withValues(alpha: 0.65),
              width: isActive ? 3 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: node.color.withValues(alpha: 0.45),
                blurRadius: isActive ? 22 : 14,
                spreadRadius: isActive ? 3 : 1,
              ),
            ],
          ),
          child: Text(
            node.label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}
