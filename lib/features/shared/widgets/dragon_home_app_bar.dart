import 'package:flutter/material.dart';

class DragonHomeAppBar extends StatefulWidget {
  final String name;
  final int coins;

  const DragonHomeAppBar({super.key, required this.name, required this.coins});

  @override
  State<DragonHomeAppBar> createState() => _DragonHomeAppBarState();
}

class _DragonHomeAppBarState extends State<DragonHomeAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _coinsAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _setupAnimation();
    _controller.forward();
  }

  void _setupAnimation() {
    _coinsAnimation = IntTween(
      begin: 0,
      end: widget.coins,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  void didUpdateWidget(covariant DragonHomeAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.coins != widget.coins) {
      _controller.reset();
      _setupAnimation();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatCoins(int value) {
    final chars = value.toString().split('').reversed.toList();
    final buffer = StringBuffer();
    for (var i = 0; i < chars.length; i++) {
      if (i != 0 && i % 3 == 0) buffer.write(',');
      buffer.write(chars[i]);
    }
    return buffer.toString().split('').reversed.join();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Hello, ${widget.name}',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Row(
            children: [
              Image.asset('assets/images/icons/coin.png', width: 32),
              const SizedBox(width: 6),
              AnimatedBuilder(
                animation: _coinsAnimation,
                builder: (context, child) {
                  final value = _coinsAnimation.value;
                  return Text(
                    _formatCoins(value),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
