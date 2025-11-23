import 'package:flutter/material.dart';
import 'package:pos/features/event_details/presentation/screens/event_details_screen.dart';

class EventsList extends StatelessWidget {
  const EventsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(100),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withAlpha(50)),
      ),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        itemCount: _mockEvents.length,
        separatorBuilder: (_, __) =>
            Divider(color: Colors.white.withOpacity(0.08)),
        itemBuilder: (context, index) {
          final event = _mockEvents[index];
          return _EventTile(event: event);
        },
      ),
    );
  }
}

class EventItem {
  final String name;
  final String address;
  final String imageUrl;
  final bool isLive;

  EventItem({
    required this.name,
    required this.address,
    required this.imageUrl,
    this.isLive = true,
  });
}

final List<EventItem> _mockEvents = [
  EventItem(
    name: 'Ethereum Day · Devconnect Buenos Aires',
    address: 'La Rural · Palermo · Buenos Aires',
    imageUrl:
        'https://images.pexels.com/photos/7134984/pexels-photo-7134984.jpeg',
  ),
  EventItem(
    name: 'Urbe.eth Campus Bootcamp',
    address: 'Huerta Coworking · Av. Dorrego 2133 · Buenos Aires',
    imageUrl:
        'https://images.pexels.com/photos/1181675/pexels-photo-1181675.jpeg',
    isLive: false,
  ),
  EventItem(
    name: 'ETHGlobal Hackathon · Devconnect',
    address: 'Venue por confirmar · Buenos Aires',
    imageUrl:
        'https://images.pexels.com/photos/1181675/pexels-photo-1181675.jpeg',
  ),
  EventItem(
    name: 'L2 Scaling Summit · Devconnect',
    address: 'Cerca de La Rural · Palermo · Buenos Aires',
    imageUrl:
        'https://images.pexels.com/photos/1181243/pexels-photo-1181243.jpeg',
  ),
];

class _EventTile extends StatelessWidget {
  final EventItem event;

  const _EventTile({required this.event});

  @override
  Widget build(BuildContext context) {
    final statusLabel = event.isLive ? 'En progreso' : 'Próximo';

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) {
              return EventDetailsScreen(event: event);
            },
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    event.imageUrl,
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  left: 4,
                  top: 4,
                  child: _LiveBadge(isLive: event.isLive),
                ),
              ],
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    event.address,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _StatusChip(label: statusLabel, isLive: event.isLive),
                    ],
                  ),
                ],
              ),
            ),

            const Icon(Icons.chevron_right_rounded, color: Colors.white70),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final bool isLive;

  const _StatusChip({required this.label, required this.isLive});

  @override
  Widget build(BuildContext context) {
    final Color baseColor = isLive
        ? const Color(0xFF22C55E)
        : const Color(0xFF6366F1);

    final Color textColor = isLive
        ? const Color(0xFFBBF7D0)
        : const Color(0xFFE0E7FF);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: baseColor.withOpacity(0.16),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: baseColor.withOpacity(0.7)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 8, color: baseColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _LiveBadge extends StatelessWidget {
  final bool isLive;

  const _LiveBadge({required this.isLive});

  @override
  Widget build(BuildContext context) {
    final Color baseColor = isLive
        ? const Color(0xFF22C55E)
        : const Color(0xFF6366F1);

    final String text = isLive ? 'LIVE' : 'SOON';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        gradient: LinearGradient(
          colors: [baseColor.withOpacity(0.95), baseColor.withOpacity(0.7)],
        ),
        boxShadow: [
          BoxShadow(
            color: baseColor.withOpacity(0.6),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}
