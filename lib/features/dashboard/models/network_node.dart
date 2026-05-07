import 'dart:ui';

import 'package:flutter/material.dart';

class NetworkNode {
  const NetworkNode({
    required this.id,
    required this.label,
    required this.position,
    required this.color,
    required this.size,
  });

  final int id;
  final String label;
  final Offset position;
  final Color color;
  final double size;

  NetworkNode copyWith({
    int? id,
    String? label,
    Offset? position,
    Color? color,
    double? size,
  }) {
    return NetworkNode(
      id: id ?? this.id,
      label: label ?? this.label,
      position: position ?? this.position,
      color: color ?? this.color,
      size: size ?? this.size,
    );
  }
}
