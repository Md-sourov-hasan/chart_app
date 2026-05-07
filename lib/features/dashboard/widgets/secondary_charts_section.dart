import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SecondaryChartsSection extends StatelessWidget {
  const SecondaryChartsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: _SecondaryChartCard(child: _MiniLineChart())),
        SizedBox(width: 12),
        Expanded(child: _SecondaryChartCard(child: _MiniBarChart())),
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
  const _MiniLineChart();

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
            spots: const [
              FlSpot(0, 1),
              FlSpot(1, 1.5),
              FlSpot(2, 2),
              FlSpot(3, 1.8),
              FlSpot(4, 2.5),
              FlSpot(5, 3),
              FlSpot(6, 3.5),
              FlSpot(7, 4),
            ],
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
  const _MiniBarChart();

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: [
          _buildBarGroup(0, 2),
          _buildBarGroup(1, 3),
          _buildBarGroup(2, 1.5),
          _buildBarGroup(3, 2.5),
          _buildBarGroup(4, 3.5),
        ],
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
