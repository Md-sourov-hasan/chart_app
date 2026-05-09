import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/dashboard_live_data.dart';

class SecondaryChartsSection extends StatelessWidget {
  const SecondaryChartsSection({super.key, required this.liveData});

  final DashboardLiveData liveData;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SecondaryChartCard(
            child: _MiniLineChart(spots: liveData.miniLineSpots),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SecondaryChartCard(
            child: _MiniBarChart(values: liveData.miniBarValues),
          ),
        ),
      ],
    );
  }
}

class _SecondaryChartCard extends StatelessWidget {
  const _SecondaryChartCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}

class _MiniLineChart extends StatelessWidget {
  const _MiniLineChart({required this.spots});

  final List<FlSpot> spots;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: 7,
        minY: 0,
        maxY: 4,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.green,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.green.withValues(alpha: 0.2),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniBarChart extends StatelessWidget {
  const _MiniBarChart({required this.values});

  final List<DashboardBarValue> values;

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: values
            .map((value) => _buildBarGroup(value.x, value.y))
            .toList(),
      ),
    );
  }

  BarChartGroupData _buildBarGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: Colors.orange,
          width: 12,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
      ],
    );
  }
}
