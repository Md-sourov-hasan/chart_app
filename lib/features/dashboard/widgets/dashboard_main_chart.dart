import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../data/dashboard_chart_data.dart';
import '../models/dashboard_chart_type.dart';
import '../models/network_link.dart';
import '../models/network_node.dart';
import 'network_chart_view.dart';

class DashboardMainChart extends StatelessWidget {
  const DashboardMainChart({
    super.key,
    required this.selectedChartType,
    required this.networkNodes,
    required this.networkLinks,
    required this.activeNodeId,
    required this.onResetNetwork,
    required this.onNodeTap,
    required this.onNodeDrag,
  });

  final DashboardChartType selectedChartType;
  final List<NetworkNode> networkNodes;
  final List<NetworkLink> networkLinks;
  final int? activeNodeId;
  final VoidCallback onResetNetwork;
  final ValueChanged<int> onNodeTap;
  final void Function(NetworkNode, DragUpdateDetails, Size) onNodeDrag;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: selectedChartType == DashboardChartType.network ? 360 : 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: switch (selectedChartType) {
        DashboardChartType.network => NetworkChartView(
          nodes: networkNodes,
          links: networkLinks,
          activeNodeId: activeNodeId,
          onReset: onResetNetwork,
          onNodeTap: onNodeTap,
          onNodeDrag: onNodeDrag,
        ),
        DashboardChartType.line => const _LineChartView(),
        DashboardChartType.bar => const _BarChartView(),
        DashboardChartType.pie => const _PieChartView(),
        DashboardChartType.radar => const _RadarChartView(),
        DashboardChartType.heatMap => const _HeatMapView(),
        DashboardChartType.scatter => const _ScatterPlotView(),
        DashboardChartType.bubble => const _BubbleChartView(),
      },
    );
  }
}

class _LineChartView extends StatelessWidget {
  const _LineChartView();

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: _gridData(),
        titlesData: _titlesData(),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey[700]!),
        ),
        minX: 0,
        maxX: 11,
        minY: 0,
        maxY: 6,
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 3),
              FlSpot(1, 2.5),
              FlSpot(2, 4),
              FlSpot(3, 3.5),
              FlSpot(4, 5),
              FlSpot(5, 4.5),
              FlSpot(6, 6),
              FlSpot(7, 5.5),
              FlSpot(8, 4),
              FlSpot(9, 5),
              FlSpot(10, 5.5),
              FlSpot(11, 6),
            ],
            isCurved: true,
            gradient: LinearGradient(
              colors: [
                Colors.blue.withValues(alpha: 0.8),
                Colors.purple.withValues(alpha: 0.8),
              ],
            ),
            barWidth: 5,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: Colors.white,
                  strokeWidth: 2,
                  strokeColor: Colors.blue,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Colors.blue.withValues(alpha: 0.3),
                  Colors.purple.withValues(alpha: 0.1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BarChartView extends StatelessWidget {
  const _BarChartView();

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        titlesData: _titlesData(),
        borderData: FlBorderData(show: false),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (group) => Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${group.x.toInt()}\n',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: '${rod.toY.round()}',
                    style: const TextStyle(color: Colors.yellow),
                  ),
                ],
              );
            },
          ),
        ),
        barGroups: [
          _buildBarGroup(0, 3, Colors.blue),
          _buildBarGroup(1, 2.5, Colors.green),
          _buildBarGroup(2, 4, Colors.orange),
          _buildBarGroup(3, 3.5, Colors.red),
          _buildBarGroup(4, 5, Colors.purple),
          _buildBarGroup(5, 4.5, Colors.teal),
          _buildBarGroup(6, 6, Colors.pink),
        ],
      ),
    );
  }

  BarChartGroupData _buildBarGroup(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 20,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 6,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}

class _PieChartView extends StatelessWidget {
  const _PieChartView();

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(touchCallback: (event, pieTouchResponse) {}),
        borderData: FlBorderData(show: false),
        sectionsSpace: 2,
        centerSpaceRadius: 60,
        sections: [
          _section(Colors.blue, 30),
          _section(Colors.green, 25),
          _section(Colors.orange, 20),
          _section(Colors.red, 15),
          _section(Colors.purple, 10),
        ],
      ),
    );
  }

  PieChartSectionData _section(Color color, double value) {
    return PieChartSectionData(
      color: color,
      value: value,
      title: '${value.toInt()}%',
      radius: 50,
      titleStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}

class _RadarChartView extends StatelessWidget {
  const _RadarChartView();

  @override
  Widget build(BuildContext context) {
    return RadarChart(
      RadarChartData(
        dataSets: [
          RadarDataSet(
            fillColor: Colors.blue.withValues(alpha: 0.3),
            borderColor: Colors.blue,
            entryRadius: 3,
            dataEntries: const [
              RadarEntry(value: 4),
              RadarEntry(value: 5),
              RadarEntry(value: 3),
              RadarEntry(value: 4.5),
              RadarEntry(value: 3.5),
            ],
          ),
          RadarDataSet(
            fillColor: Colors.red.withValues(alpha: 0.3),
            borderColor: Colors.red,
            entryRadius: 3,
            dataEntries: const [
              RadarEntry(value: 3),
              RadarEntry(value: 4),
              RadarEntry(value: 5),
              RadarEntry(value: 3.5),
              RadarEntry(value: 4.5),
            ],
          ),
        ],
        radarShape: RadarShape.polygon,
        radarBackgroundColor: Colors.transparent,
        borderData: FlBorderData(show: false),
        tickCount: 6,
        ticksTextStyle: const TextStyle(color: Colors.white, fontSize: 10),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 12),
        getTitle: (index, angle) {
          const titles = ['Speed', 'Power', 'Defense', 'Attack', 'Health'];
          if (index >= 0 && index < titles.length) {
            return RadarChartTitle(text: titles[index], angle: angle);
          }
          return const RadarChartTitle(text: '');
        },
      ),
    );
  }
}

class _HeatMapView extends StatelessWidget {
  const _HeatMapView();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 32),
          child: Row(
            children: DashboardChartData.heatMapHours.map((hour) {
              return Expanded(
                child: Text(
                  hour,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[400], fontSize: 8),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 4),
        Expanded(
          child: Row(
            children: [
              Column(
                children: DashboardChartData.heatMapDays.map((day) {
                  return Expanded(
                    child: Container(
                      height: 30,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        day,
                        style: TextStyle(color: Colors.grey[400], fontSize: 10),
                      ),
                    ),
                  );
                }).toList(),
              ),
              Expanded(
                child: Column(
                  children: DashboardChartData.heatMapData.map((dayData) {
                    return Expanded(
                      child: Row(
                        children: dayData.map((value) {
                          return Expanded(
                            child: Container(
                              margin: const EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                color: _heatMapColor(value),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Less',
              style: TextStyle(color: Colors.grey[400], fontSize: 12),
            ),
            const SizedBox(width: 8),
            Container(
              width: 100,
              height: 12,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.grey[800]!,
                    Colors.blue.withValues(alpha: 0.3),
                    Colors.blue.withValues(alpha: 0.6),
                    Colors.blue.withValues(alpha: 0.9),
                    Colors.blue,
                  ],
                ),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'More',
              style: TextStyle(color: Colors.grey[400], fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  Color _heatMapColor(double value) {
    if (value == 0.0) {
      return Colors.grey[800]!;
    }
    if (value <= 0.2) {
      return Colors.blue.withValues(alpha: 0.3);
    }
    if (value <= 0.4) {
      return Colors.blue.withValues(alpha: 0.5);
    }
    if (value <= 0.6) {
      return Colors.blue.withValues(alpha: 0.7);
    }
    if (value <= 0.8) {
      return Colors.blue.withValues(alpha: 0.9);
    }
    return Colors.blue;
  }
}

class _ScatterPlotView extends StatelessWidget {
  const _ScatterPlotView();

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: _gridData(),
        titlesData: _titlesData(),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey[700]!),
        ),
        minX: 0,
        maxX: 11,
        minY: 0,
        maxY: 6,
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 2.5),
              FlSpot(1, 3.2),
              FlSpot(2, 1.8),
              FlSpot(3, 4.1),
              FlSpot(4, 2.9),
              FlSpot(5, 5.2),
              FlSpot(6, 3.8),
              FlSpot(7, 4.5),
              FlSpot(8, 2.1),
              FlSpot(9, 3.7),
              FlSpot(10, 4.8),
              FlSpot(11, 5.5),
            ],
            isCurved: false,
            color: Colors.transparent,
            barWidth: 0,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 6,
                  color: Colors.purple,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BubbleChartView extends StatelessWidget {
  const _BubbleChartView();

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        titlesData: _titlesData(),
        borderData: FlBorderData(show: false),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (group) => Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                'Value: ${rod.toY.round()}',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
        barGroups: [
          _bubbleGroup(0, 2.5, Colors.blue, 30),
          _bubbleGroup(1, 4.2, Colors.green, 40),
          _bubbleGroup(2, 3.1, Colors.orange, 25),
          _bubbleGroup(3, 5.8, Colors.red, 50),
          _bubbleGroup(4, 2.9, Colors.purple, 35),
          _bubbleGroup(5, 4.5, Colors.teal, 45),
        ],
      ),
    );
  }

  BarChartGroupData _bubbleGroup(int x, double y, Color color, double width) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color.withValues(alpha: 0.6),
          width: width,
          borderRadius: BorderRadius.circular(width / 2),
        ),
      ],
    );
  }
}

FlGridData _gridData() {
  return FlGridData(
    show: true,
    drawVerticalLine: true,
    getDrawingHorizontalLine: (value) {
      return FlLine(color: Colors.grey[700], strokeWidth: 1);
    },
    getDrawingVerticalLine: (value) {
      return FlLine(color: Colors.grey[700], strokeWidth: 1);
    },
  );
}

FlTitlesData _titlesData() {
  return FlTitlesData(
    show: true,
    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 30,
        interval: 1,
        getTitlesWidget: _bottomTitleWidgets,
      ),
    ),
    leftTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        interval: 1,
        reservedSize: 42,
        getTitlesWidget: _leftTitleWidgets,
      ),
    ),
  );
}

Widget _bottomTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 12,
  );

  final text = switch (value.toInt()) {
    1 => 'JAN',
    3 => 'MAR',
    5 => 'MAY',
    7 => 'JUL',
    9 => 'SEP',
    11 => 'NOV',
    _ => '',
  };

  return Text(text, style: style);
}

Widget _leftTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 12,
  );

  final text = switch (value.toInt()) {
    1 => '1K',
    2 => '2K',
    3 => '3K',
    4 => '4K',
    5 => '5K',
    6 => '6K',
    _ => '',
  };

  return Text(text, style: style);
}
