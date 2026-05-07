import 'package:flutter/material.dart';

class StatsCardsSection extends StatelessWidget {
  const StatsCardsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _StatCard(
            card: _StatCardData(
              title: 'Total Revenue',
              value: '\$12,345',
              color: Colors.green,
              icon: Icons.trending_up,
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            card: _StatCardData(
              title: 'Active Users',
              value: '1,234',
              color: Colors.blue,
              icon: Icons.people,
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            card: _StatCardData(
              title: 'Growth Rate',
              value: '+23%',
              color: Colors.orange,
              icon: Icons.show_chart,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.card});

  final _StatCardData card;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: card.color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(card.icon, color: card.color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  card.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(color: Colors.grey[400], fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            card.value,
            style: TextStyle(
              color: card.color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCardData {
  const _StatCardData({
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
