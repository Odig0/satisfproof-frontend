import 'package:flutter/material.dart';

class EpicRpgBackground extends StatelessWidget {
  final Widget child;

  const EpicRpgBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0A0F3C),
                Color(0xFF1E1567),
                Color(0xFF371C85),
                Color(0xFF4A2296),
              ],
              stops: [0.0, 0.35, 0.70, 1.0],
            ),
          ),
        ),

        Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0, -0.15),
              radius: 1.3,
              colors: [Colors.white.withOpacity(0.12), Colors.transparent],
            ),
          ),
        ),

        child,
      ],
    );
  }
}
