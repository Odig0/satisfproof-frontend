import 'package:flutter/material.dart';
import 'package:pos/features/event_questions/presentation/review_question.dart';
import 'package:pos/features/events/presentation/widget/events_list.dart';
import 'package:pos/features/shared/widgets/epic_rpg_background.dart';

class EventDetailsScreen extends StatelessWidget {
  final EventItem event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    const bool hasReviewed = false;
    const String eventDateRange = 'Jul 20 · 18:00 — Jul 22 · 23:00';

    final String eventTitle = event.name;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF080B2A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        titleSpacing: 0,
        title: _HeaderTitle(title: eventTitle, dateRange: eventDateRange),
      ),
      body: EpicRpgBackground(
        child: SafeArea(
          top: false,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            children: [
              const SizedBox(height: 8),

              _DragonHero(hasReviewed: hasReviewed),
              const SizedBox(height: 20),

              _EventHeaderCard(event: event),
              const SizedBox(height: 20),

              if (!hasReviewed) ...[_RewardsCard()],

              if (hasReviewed) ...[
                const SizedBox(height: 16),
                const _ReviewsSection(),
              ],

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderTitle extends StatelessWidget {
  final String title;
  final String dateRange;

  const _HeaderTitle({required this.title, required this.dateRange});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _MarqueeText(
          text: title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          dateRange,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
        ),
      ],
    );
  }
}

class _MarqueeText extends StatefulWidget {
  final String text;
  final TextStyle style;

  const _MarqueeText({required this.text, required this.style});

  @override
  State<_MarqueeText> createState() => _MarqueeTextState();
}

class _MarqueeTextState extends State<_MarqueeText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textPainter = TextPainter(
          text: TextSpan(text: widget.text, style: widget.style),
          maxLines: 1,
          textDirection: TextDirection.ltr,
        )..layout();

        final textWidth = textPainter.width;
        final maxWidth = constraints.maxWidth;

        if (textWidth <= maxWidth) {
          return Text(
            widget.text,
            style: widget.style,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        }

        const gap = 40.0;

        return ClipRect(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final scrollableWidth = textWidth + gap;
              final offset = -_controller.value * scrollableWidth;

              return Transform.translate(
                offset: Offset(offset, 0),
                child: SizedBox(
                  width: scrollableWidth * 2,
                  child: Row(
                    children: [
                      SizedBox(
                        width: textWidth,
                        child: Text(
                          widget.text,
                          style: widget.style,
                          maxLines: 1,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                      const SizedBox(width: gap),
                      SizedBox(
                        width: textWidth,
                        child: Text(
                          widget.text,
                          style: widget.style,
                          maxLines: 1,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _DragonHero extends StatelessWidget {
  final bool hasReviewed;

  const _DragonHero({required this.hasReviewed});

  @override
  Widget build(BuildContext context) {
    const int tokensPerParticipant = 10;

    final assetPath = hasReviewed
        ? 'assets/images/icons/dragon_happy.png'
        : 'assets/images/icons/dragon_thinking.png';

    final title = hasReviewed
        ? 'Mission completed!'
        : 'Help Draggi protect his tribe';

    final subtitle = hasReviewed
        ? 'Your review is already helping others discover better events.'
        : 'Leave your honest review to unlock rewards and keep events safe.';

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 190,
          width: 200,
          child: Image.asset(assetPath, fit: BoxFit.contain),
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 13,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 10),
        if (!hasReviewed) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/icons/coin.png', width: 22),
              const SizedBox(width: 6),
              Text(
                '$tokensPerParticipant tokens per review',
                style: const TextStyle(
                  color: Colors.amber,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: 220,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              onPressed: () async {
                final result = await Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const EventReviewScreen()),
                );

                if (result != null) {}
              },

              child: const Text(
                'Give your review',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ] else ...[
          const SizedBox(height: 8),
          const Text(
            'Thanks for protecting the tribe! 🐉',
            style: TextStyle(
              color: Color(0xFF4ADE80),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}

class _EventHeaderCard extends StatelessWidget {
  final EventItem event;

  const _EventHeaderCard({required this.event});

  @override
  Widget build(BuildContext context) {
    const description =
        'Comparte tu experiencia en este evento y ayuda a otros a decidir mejor.';
    const location = 'Centro de Convenciones';
    const participantsCount = 600;

    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.30),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(event.imageUrl, fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 13,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.place_rounded,
                      size: 16,
                      color: Colors.white70,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        location,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    const _ParticipantsAvatars(),
                    const SizedBox(width: 6),
                    Text(
                      '$participantsCount participants',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ParticipantsAvatars extends StatelessWidget {
  const _ParticipantsAvatars();

  @override
  Widget build(BuildContext context) {
    const avatars = ['A', 'M', 'J'];

    return SizedBox(
      width: 50,
      height: 22,
      child: Stack(
        children: [
          for (int i = 0; i < avatars.length; i++)
            Positioned(
              left: i * 14,
              child: CircleAvatar(
                radius: 11,
                backgroundColor: Colors.white.withOpacity(0.15),
                child: Text(
                  avatars[i],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _RewardsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const timeLeft = '2h 15m left';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF22C55E),
            ),
            child: const Icon(
              Icons.lock_open_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rewards available',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Complete your review before the timer expires to earn your rewards.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            children: [
              const Icon(Icons.timer_rounded, color: Colors.white70, size: 18),
              const SizedBox(height: 2),
              Text(
                timeLeft,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReviewsSection extends StatelessWidget {
  const _ReviewsSection();

  @override
  Widget build(BuildContext context) {
    final reviews = [
      'Amazing vibe and great music. Loved the murals!',
      'Well organized, but the food lines were a bit long.',
      'Perfect place to meet new people and discover artists.',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Community reviews',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        ...reviews.map(
          (text) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.35),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.white24,
                  child: Icon(
                    Icons.person_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
