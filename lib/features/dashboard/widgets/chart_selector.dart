import 'package:flutter/material.dart';

import '../models/dashboard_chart_type.dart';

class ChartSelector extends StatelessWidget {
  const ChartSelector({
    super.key,
    required this.selectedChartType,
    required this.onSelected,
  });

  final DashboardChartType selectedChartType;
  final ValueChanged<DashboardChartType> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: DashboardChartType.values.length,
        itemBuilder: (context, index) {
          final chartType = DashboardChartType.values[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(chartType.title),
              selected: selectedChartType == chartType,
              onSelected: (_) => onSelected(chartType),
              backgroundColor: Colors.grey[800],
              selectedColor: Colors.blue,
            ),
          );
        },
      ),
    );
  }
}
