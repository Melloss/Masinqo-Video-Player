import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../utilities/media_query.dart';

class MasinqoLoadingAnimation extends StatefulWidget {
  const MasinqoLoadingAnimation({super.key});

  @override
  State<MasinqoLoadingAnimation> createState() =>
      _MasinqoLoadingAnimationState();
}

class _MasinqoLoadingAnimationState extends State<MasinqoLoadingAnimation>
    with TickerProviderStateMixin {
  late Animation<double> masinqoAnimation;
  late AnimationController masinqoController;

  @override
  void initState() {
    masinqoController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));
    masinqoAnimation = Tween(begin: 10.0, end: 40.0).animate(
      CurvedAnimation(parent: masinqoController, curve: Curves.linear),
    );
    masinqoController.forward();
    masinqoController.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        masinqoController.forward();
      } else if (status == AnimationStatus.completed) {
        masinqoController.reverse();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    masinqoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        alignment: Alignment.center,
        width: screenWidth(context) * 0.8,
        height: screenHeight(context) * 0.35,
        child: Stack(
          children: [
            Image.asset('assets/masinko_box.png'),
            AnimatedBuilder(
              animation: masinqoAnimation,
              builder: (context, child) {
                return Positioned(
                    left: masinqoAnimation.value,
                    right: 30,
                    top: -masinqoAnimation.value,
                    child: child!);
              },
              child: Transform.rotate(
                angle: -math.pi * 0.25,
                child: Image.asset('assets/masinqo_ejeta.png'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
