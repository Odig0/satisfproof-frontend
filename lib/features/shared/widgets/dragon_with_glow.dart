import 'package:flutter/material.dart';

class DragonWithGlow extends StatelessWidget {
  const DragonWithGlow({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 260,
          height: 260,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                blurRadius: 60,
                spreadRadius: 25,
              ),
            ],
          ),
        ),
        Image.asset('assets/images/icons/dragon_egg.png'),
      ],
    );
  }
}
