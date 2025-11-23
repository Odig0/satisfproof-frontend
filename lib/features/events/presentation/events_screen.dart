import 'package:flutter/material.dart';
import 'package:pos/features/events/presentation/widget/events_list.dart';
import 'package:pos/features/shared/widgets/dragon_home_app_bar.dart';
import 'package:pos/features/shared/widgets/dragon_with_glow.dart';
import 'package:pos/features/shared/widgets/epic_rpg_background.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EpicRpgBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DragonHomeAppBar(name: 'Josué', coins: 100),
                const DragonWithGlow(),
                Expanded(child: EventsList()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
