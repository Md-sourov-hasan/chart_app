import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../data/dashboard_chart_data.dart';
import '../models/dashboard_chart_type.dart';
import '../models/dashboard_live_data.dart';
import '../models/network_link.dart';
import '../models/network_node.dart';
import 'network_chart_view.dart';

class DashboardMainChart extends StatelessWidget {
  const DashboardMainChart({
    super.key,
    required this.selectedChartType,
    required this.liveData,
    required this.networkNodes,
    required this.networkLinks,
    required this.activeNodeId,
    required this.onResetNetwork,
    required this.onNodeTap,
    required this.onNodeDrag,
  });

  final DashboardChartType selectedChartType;
  final DashboardLiveData liveData;
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
        DashboardChartType.area => _AreaChartView(spots: liveData.areaSpots),
        DashboardChartType.line => _LineChartView(spots: liveData.lineSpots),
        DashboardChartType.bar => _BarChartView(values: liveData.barValues),
        DashboardChartType.pie => _PieChartView(values: liveData.pieValues),
        DashboardChartType.radar => _RadarChartView(sets: liveData.radarSets),
        DashboardChartType.heatMap => _HeatMapView(data: liveData.heatMapData),
        DashboardChartType.scatter => _ScatterPlotView(
          spots: liveData.scatterSpots,
        ),
        DashboardChartType.bubble => _BubbleChartView(
          values: liveData.bubbleValues,
        ),
      },
    );
  }
}

class _AreaChartView extends StatelessWidget {
  const _AreaChartView({required this.spots});

  final List<FlSpot> spots;

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
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => Colors.black87,
            getTooltipItems: (spots) {
              return spots.map((spot) {
                return LineTooltipItem(
                  'M${spot.x.toInt() + 1}: ${spot.y.toStringAsFixed(1)}',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                );
              }).toList();
            },
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.35,
            gradient: const LinearGradient(
              colors: [Color(0xFF22C55E), Color(0xFF06B6D4)],
            ),
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF22C55E).withValues(alpha: 0.45),
                  const Color(0xFF06B6D4).withValues(alpha: 0.22),
                  const Color(0xFF0F172A).withValues(alpha: 0.02),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LineChartView extends StatelessWidget {
  const _LineChartView({required this.spots});

  final List<FlSpot> spots;

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
            spots: spots,
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
  const _BarChartView({required this.values});

  final List<DashboardBarValue> values;

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
          ...values.map(
            (value) => _buildBarGroup(value.x, value.y, value.color),
          ),
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
  const _PieChartView({required this.values});

  final List<DashboardPieValue> values;

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(touchCallback: (event, pieTouchResponse) {}),
        borderData: FlBorderData(show: false),
        sectionsSpace: 2,
        centerSpaceRadius: 60,
        sections: values
            .map((value) => _section(value.color, value.value))
            .toList(),
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
  const _RadarChartView({required this.sets});

  final List<List<double>> sets;

  @override
  Widget build(BuildContext context) {
    return RadarChart(
      RadarChartData(
        dataSets: [
          RadarDataSet(
            fillColor: Colors.blue.withValues(alpha: 0.3),
            borderColor: Colors.blue,
            entryRadius: 3,
            dataEntries: sets.first
                .map((value) => RadarEntry(value: value))
                .toList(),
          ),
          RadarDataSet(
            fillColor: Colors.red.withValues(alpha: 0.3),
            borderColor: Colors.red,
            entryRadius: 3,
            dataEntries: sets.last
                .map((value) => RadarEntry(value: value))
                .toList(),
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
  const _HeatMapView({required this.data});

  final List<List<double>> data;

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
                  children: data.map((dayData) {
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
  const _ScatterPlotView({required this.spots});

  final List<FlSpot> spots;

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
            spots: spots,
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
  const _BubbleChartView({required this.values});

  final List<DashboardBubbleValue> values;

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
          ...values.map(
            (value) => _bubbleGroup(value.x, value.y, value.color, value.width),
          ),
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
