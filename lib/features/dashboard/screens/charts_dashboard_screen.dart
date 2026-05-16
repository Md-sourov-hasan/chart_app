import 'dart:async';

import 'package:flutter/material.dart';

import '../../app_protection/widgets/app_protection_card.dart';
import '../data/dashboard_chart_data.dart';
import '../models/dashboard_chart_type.dart';
import '../models/dashboard_live_data.dart';
import '../models/network_node.dart';
import '../widgets/chart_selector.dart';
import '../widgets/dashboard_main_chart.dart';
import '../widgets/secondary_charts_section.dart';
import '../widgets/stats_cards_section.dart';

class ChartsDashboardScreen extends StatefulWidget {
  const ChartsDashboardScreen({super.key});

  @override
  State<ChartsDashboardScreen> createState() => _ChartsDashboardScreenState();
}

class _ChartsDashboardScreenState extends State<ChartsDashboardScreen> {
  DashboardChartType _selectedChartType = DashboardChartType.network;
  int? _activeNodeId = 2;
  late final Timer _liveDataTimer;
  late DashboardLiveData _dashboardData;

  late final List<NetworkNode> _initialNetworkNodes =
      DashboardChartData.initialNetworkNodes();
  late List<NetworkNode> _networkNodes = _cloneNodes(_initialNetworkNodes);

  @override
  void initState() {
    super.initState();
    _dashboardData = DashboardChartData.generateLiveData();
    _liveDataTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _dashboardData = DashboardChartData.generateLiveData();
      });
    });
  }

  static List<NetworkNode> _cloneNodes(List<NetworkNode> nodes) {
    return nodes.map((node) => node.copyWith()).toList();
  }

  void _resetNetworkLayout() {
    setState(() {
      _networkNodes = _cloneNodes(_initialNetworkNodes);
      _activeNodeId = 2;
    });
  }

  void _selectChart(DashboardChartType chartType) {
    setState(() {
      _selectedChartType = chartType;
    });
  }

  void _selectNode(int nodeId) {
    setState(() {
      _activeNodeId = nodeId;
    });
  }

  void _refreshCharts() {
    setState(() {
      _dashboardData = DashboardChartData.generateLiveData();
    });
  }

  void _resetNetworkAndRefreshCharts() {
    setState(() {
      _networkNodes = _cloneNodes(_initialNetworkNodes);
      _activeNodeId = 2;
      _dashboardData = DashboardChartData.generateLiveData();
    });
  }

  void _updateNodePosition(
    NetworkNode node,
    DragUpdateDetails details,
    Size canvasSize,
  ) {
    final horizontalPadding = (node.size / canvasSize.width).clamp(0.06, 0.18);
    final verticalPadding = (node.size / canvasSize.height).clamp(0.08, 0.20);

    final updatedX = (node.position.dx + (details.delta.dx / canvasSize.width))
        .clamp(horizontalPadding, 1 - horizontalPadding);
    final updatedY = (node.position.dy + (details.delta.dy / canvasSize.height))
        .clamp(verticalPadding, 1 - verticalPadding);

    setState(() {
      _networkNodes = _networkNodes.map((currentNode) {
        if (currentNode.id != node.id) {
          return currentNode;
        }

        return currentNode.copyWith(position: Offset(updatedX, updatedY));
      }).toList();
      _activeNodeId = node.id;
    });
  }

  @override
  void dispose() {
    _liveDataTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Charts Dashboard'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _selectedChartType == DashboardChartType.network
                ? _resetNetworkAndRefreshCharts
                : _refreshCharts,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppProtectionCard(),
            const SizedBox(height: 20),
            ChartSelector(
              selectedChartType: _selectedChartType,
              onSelected: _selectChart,
            ),
            const SizedBox(height: 20),
            DashboardMainChart(
              selectedChartType: _selectedChartType,
              liveData: _dashboardData,
              networkNodes: _networkNodes,
              networkLinks: DashboardChartData.networkLinks,
              activeNodeId: _activeNodeId,
              onResetNetwork: _resetNetworkLayout,
              onNodeTap: _selectNode,
              onNodeDrag: _updateNodePosition,
            ),
            const SizedBox(height: 20),
            StatsCardsSection(cards: _dashboardData.stats),
            const SizedBox(height: 20),
            SecondaryChartsSection(liveData: _dashboardData),
          ],
        ),
      ),
    );
  }
}
