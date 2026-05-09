import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../models/dashboard_live_data.dart';
import '../models/network_link.dart';
import '../models/network_node.dart';

class DashboardChartData {
  const DashboardChartData._();

  static List<NetworkNode> initialNetworkNodes() {
    return const [
      NetworkNode(
        id: 1,
        label: 'API',
        position: Offset(0.18, 0.22),
        color: Colors.cyan,
        size: 28,
      ),
      NetworkNode(
        id: 2,
        label: 'AI Core',
        position: Offset(0.48, 0.18),
        color: Colors.orange,
        size: 34,
      ),
      NetworkNode(
        id: 3,
        label: 'Data',
        position: Offset(0.80, 0.28),
        color: Colors.pinkAccent,
        size: 28,
      ),
      NetworkNode(
        id: 4,
        label: 'Users',
        position: Offset(0.22, 0.72),
        color: Colors.greenAccent,
        size: 30,
      ),
      NetworkNode(
        id: 5,
        label: 'Agent',
        position: Offset(0.52, 0.58),
        color: Colors.deepPurpleAccent,
        size: 30,
      ),
      NetworkNode(
        id: 6,
        label: 'Cloud',
        position: Offset(0.80, 0.76),
        color: Colors.amber,
        size: 28,
      ),
    ];
  }

  static const List<NetworkLink> networkLinks = [
    NetworkLink(fromId: 1, toId: 2, strength: 0.9),
    NetworkLink(fromId: 2, toId: 3, strength: 0.8),
    NetworkLink(fromId: 2, toId: 4, strength: 0.5),
    NetworkLink(fromId: 2, toId: 5, strength: 1.0),
    NetworkLink(fromId: 3, toId: 5, strength: 0.7),
    NetworkLink(fromId: 4, toId: 5, strength: 0.8),
    NetworkLink(fromId: 5, toId: 6, strength: 0.9),
  ];

  static const List<List<double>> heatMapData = [
    [
      0.2,
      0.3,
      0.1,
      0.0,
      0.0,
      0.1,
      0.4,
      0.7,
      0.8,
      0.9,
      1.0,
      0.8,
      0.7,
      0.6,
      0.5,
      0.4,
      0.3,
      0.2,
      0.1,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
    ],
    [
      0.1,
      0.2,
      0.0,
      0.0,
      0.0,
      0.0,
      0.3,
      0.6,
      0.7,
      0.8,
      0.9,
      0.7,
      0.6,
      0.5,
      0.4,
      0.3,
      0.2,
      0.1,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
    ],
    [
      0.0,
      0.1,
      0.0,
      0.0,
      0.0,
      0.0,
      0.2,
      0.5,
      0.6,
      0.7,
      0.8,
      0.6,
      0.5,
      0.4,
      0.3,
      0.2,
      0.1,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
    ],
    [
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.1,
      0.3,
      0.4,
      0.5,
      0.6,
      0.7,
      0.5,
      0.4,
      0.3,
      0.2,
      0.1,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
    ],
    [
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.1,
      0.2,
      0.3,
      0.4,
      0.5,
      0.3,
      0.2,
      0.1,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
    ],
    [
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.1,
      0.2,
      0.3,
      0.4,
      0.2,
      0.1,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
    ],
    [
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.1,
      0.2,
      0.3,
      0.1,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
    ],
  ];

  static const List<String> heatMapDays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  static const List<String> heatMapHours = [
    '12a',
    '1a',
    '2a',
    '3a',
    '4a',
    '5a',
    '6a',
    '7a',
    '8a',
    '9a',
    '10a',
    '11a',
    '12p',
    '1p',
    '2p',
    '3p',
    '4p',
    '5p',
    '6p',
    '7p',
    '8p',
    '9p',
    '10p',
    '11p',
  ];

  static DashboardLiveData generateLiveData([DateTime? timestamp]) {
    final now = timestamp ?? DateTime.now();
    final random = Random(now.microsecondsSinceEpoch);
    final phase = now.second / 60 + now.millisecond / 60000;

    final areaSpots = _buildSeries(
      random: random,
      pointCount: 12,
      minY: 1.0,
      maxY: 5.6,
      phase: phase,
      frequency: 1.7,
      trend: 0.10,
    );
    final lineSpots = _buildSeries(
      random: random,
      pointCount: 12,
      minY: 2.0,
      maxY: 6.0,
      phase: phase + 0.25,
      frequency: 2.1,
      trend: 0.06,
    );
    final barValues = _buildBarValues(random);
    final pieValues = _buildPieValues(random);
    final radarSets = _buildRadarSets(random);
    final heatMap = _buildHeatMap(random, phase);
    final scatterSpots = _buildScatterSpots(random);
    final bubbleValues = _buildBubbleValues(random);
    final miniLineSpots = _buildSeries(
      random: random,
      pointCount: 8,
      minY: 1.0,
      maxY: 4.0,
      phase: phase + 0.45,
      frequency: 1.4,
      trend: 0.04,
    );
    final miniBarValues = _buildMiniBarValues(random);

    return DashboardLiveData(
      stats: _buildStats(lineSpots, barValues, pieValues, random),
      areaSpots: areaSpots,
      lineSpots: lineSpots,
      barValues: barValues,
      pieValues: pieValues,
      radarSets: radarSets,
      heatMapData: heatMap,
      scatterSpots: scatterSpots,
      bubbleValues: bubbleValues,
      miniLineSpots: miniLineSpots,
      miniBarValues: miniBarValues,
      lastUpdated: now,
    );
  }

  static List<FlSpot> _buildSeries({
    required Random random,
    required int pointCount,
    required double minY,
    required double maxY,
    required double phase,
    required double frequency,
    required double trend,
  }) {
    final center = (minY + maxY) / 2;
    final amplitude = (maxY - minY) / 2.35;

    return List.generate(pointCount, (index) {
      final progress = pointCount == 1 ? 0.0 : index / (pointCount - 1);
      final primaryWave = sin(
        (progress * pi * 2 * frequency) + (phase * pi * 2),
      );
      final secondaryWave = cos((progress * pi * frequency) - (phase * pi));
      final noise = (random.nextDouble() - 0.5) * 0.45;
      final y =
          center +
          (primaryWave * amplitude) +
          (secondaryWave * amplitude * 0.32) +
          (index * trend) +
          noise;

      return FlSpot(index.toDouble(), _clamp(y, minY, maxY));
    });
  }

  static List<DashboardBarValue> _buildBarValues(Random random) {
    const colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.purple,
      Colors.teal,
      Colors.pink,
    ];

    return List.generate(colors.length, (index) {
      return DashboardBarValue(
        x: index,
        y: _clamp(2 + random.nextDouble() * 4, 1.6, 6.0),
        color: colors[index],
      );
    });
  }

  static List<DashboardPieValue> _buildPieValues(Random random) {
    const colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.purple,
    ];
    final rawValues = List.generate(
      colors.length,
      (_) => 12 + random.nextDouble() * 20,
    );
    final total = rawValues.reduce((sum, value) => sum + value);
    var remaining = 100.0;

    return List.generate(colors.length, (index) {
      final percentage = index == colors.length - 1
          ? remaining
          : ((rawValues[index] / total) * 100);
      remaining -= percentage;

      return DashboardPieValue(color: colors[index], value: percentage);
    });
  }

  static List<List<double>> _buildRadarSets(Random random) {
    return List.generate(2, (setIndex) {
      return List.generate(5, (valueIndex) {
        final base = setIndex == 0 ? 3.1 : 3.4;
        return _clamp(base + random.nextDouble() * 2.2, 2.0, 5.8);
      });
    });
  }

  static List<List<double>> _buildHeatMap(Random random, double phase) {
    return List.generate(heatMapDays.length, (dayIndex) {
      return List.generate(heatMapHours.length, (hourIndex) {
        final daytimeCurve = sin(((hourIndex - 6) / 24) * pi * 2);
        final weekdayBoost = (dayIndex / heatMapDays.length) * 0.22;
        final randomDrift = (random.nextDouble() - 0.5) * 0.16;
        final livePhase = sin((phase * pi * 2) + (dayIndex * 0.55));
        final value =
            (daytimeCurve * 0.42) +
            0.28 +
            weekdayBoost +
            (livePhase * 0.10) +
            randomDrift;

        return _clamp(value, 0.0, 1.0);
      });
    });
  }

  static List<FlSpot> _buildScatterSpots(Random random) {
    return List.generate(12, (index) {
      return FlSpot(
        index.toDouble(),
        _clamp(1.4 + random.nextDouble() * 4.2, 1.0, 5.8),
      );
    });
  }

  static List<DashboardBubbleValue> _buildBubbleValues(Random random) {
    const colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.purple,
      Colors.teal,
    ];

    return List.generate(colors.length, (index) {
      return DashboardBubbleValue(
        x: index,
        y: _clamp(2.2 + random.nextDouble() * 3.6, 1.8, 6.0),
        width: 24 + random.nextDouble() * 24,
        color: colors[index],
      );
    });
  }

  static List<DashboardBarValue> _buildMiniBarValues(Random random) {
    return List.generate(5, (index) {
      return DashboardBarValue(
        x: index,
        y: _clamp(1.4 + random.nextDouble() * 2.2, 1.0, 4.0),
        color: Colors.orange,
      );
    });
  }

  static List<DashboardStatCardData> _buildStats(
    List<FlSpot> lineSpots,
    List<DashboardBarValue> barValues,
    List<DashboardPieValue> pieValues,
    Random random,
  ) {
    final revenue =
        10000 +
        (lineSpots.fold<double>(0, (sum, spot) => sum + spot.y) * 190).round();
    final activeUsers =
        900 +
        (barValues.fold<double>(0, (sum, bar) => sum + bar.y) * 42).round();
    final growthRate =
        8 + (pieValues.first.value / 2).round() + random.nextInt(6);

    return [
      DashboardStatCardData(
        title: 'Total Revenue',
        value: '\$${_formatNumber(revenue)}',
        color: Colors.green,
        icon: Icons.trending_up,
      ),
      DashboardStatCardData(
        title: 'Active Users',
        value: _formatNumber(activeUsers),
        color: Colors.blue,
        icon: Icons.people,
      ),
      DashboardStatCardData(
        title: 'Growth Rate',
        value: '+$growthRate%',
        color: Colors.orange,
        icon: Icons.show_chart,
      ),
    ];
  }

  static double _clamp(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  static String _formatNumber(int value) {
    final digits = value.toString();
    final buffer = StringBuffer();

    for (var index = 0; index < digits.length; index++) {
      final reversedIndex = digits.length - index;
      buffer.write(digits[index]);
      if (reversedIndex > 1 && reversedIndex % 3 == 1) {
        buffer.write(',');
      }
    }

    return buffer.toString();
  }
}
