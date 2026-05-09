import 'package:flutter/material.dart';

import '../models/dashboard_live_data.dart';

class StatsCardsSection extends StatelessWidget {
  const StatsCardsSection({super.key, required this.cards});

  final List<DashboardStatCardData> cards;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var index = 0; index < cards.length; index++) ...[
          Expanded(child: _StatCard(card: cards[index])),
          if (index != cards.length - 1) const SizedBox(width: 12),
        ],
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.card});

  final DashboardStatCardData card;

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
