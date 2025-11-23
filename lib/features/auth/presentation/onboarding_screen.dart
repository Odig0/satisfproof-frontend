import 'package:flutter/material.dart';
import 'package:pos/core/theme/colors.dart';
import 'package:pos/features/auth/presentation/auth_screen.dart';
import 'package:pos/features/shared/widgets/draggi_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(gradient: appIconGradient),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/icons/dragon_front.png'),
              Text(
                'Comparte tu opinion y ayuda a mejorar los eventos de tu comunidad',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              DraggiButton(
                text: 'Comenzar',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) {
                        return AuthScreen();
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
