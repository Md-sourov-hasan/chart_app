import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DashboardLiveData {
  const DashboardLiveData({
    required this.stats,
    required this.areaSpots,
    required this.lineSpots,
    required this.barValues,
    required this.pieValues,
    required this.radarSets,
    required this.heatMapData,
    required this.scatterSpots,
    required this.bubbleValues,
    required this.miniLineSpots,
    required this.miniBarValues,
    required this.lastUpdated,
  });

  final List<DashboardStatCardData> stats;
  final List<FlSpot> areaSpots;
  final List<FlSpot> lineSpots;
  final List<DashboardBarValue> barValues;
  final List<DashboardPieValue> pieValues;
  final List<List<double>> radarSets;
  final List<List<double>> heatMapData;
  final List<FlSpot> scatterSpots;
  final List<DashboardBubbleValue> bubbleValues;
  final List<FlSpot> miniLineSpots;
  final List<DashboardBarValue> miniBarValues;
  final DateTime lastUpdated;
}

class DashboardStatCardData {
  const DashboardStatCardData({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  final String title;
  final String value;
  final Color color;
  final IconData icon;
}

class DashboardBarValue {
  const DashboardBarValue({
    required this.x,
    required this.y,
    required this.color,
  });

  final int x;
  final double y;
  final Color color;
}

class DashboardPieValue {
  const DashboardPieValue({required this.color, required this.value});

  final Color color;
  final double value;
}

class DashboardBubbleValue {
  const DashboardBubbleValue({
    required this.x,
    required this.y,
    required this.width,
    required this.color,
  });

  final int x;
  final double y;
  final double width;
  final Color color;
}
