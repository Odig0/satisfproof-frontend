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
              const SizedBox(height: 24),
              const Text(
                '¡Bienvenido a SatisProof!',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Comparte tu opinión y ayuda a mejorar los eventos de tu comunidad',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
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
