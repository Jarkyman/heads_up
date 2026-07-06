import 'package:flutter/material.dart';

import '../helper/app_constants.dart';
import '../helper/dimensions.dart';

class AppLogoHero extends StatelessWidget {
  const AppLogoHero({
    super.key,
    required this.height,
  });

  final double height;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: AppConstants.LOGO_TAG,
      flightShuttleBuilder: (
        flightContext,
        animation,
        flightDirection,
        fromHeroContext,
        toHeroContext,
      ) {
        return const _AppLogoImage();
      },
      child: SizedBox(
        height: height,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.width45),
          child: const _AppLogoImage(),
        ),
      ),
    );
  }
}

class _AppLogoImage extends StatelessWidget {
  const _AppLogoImage();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/Icon.png',
      fit: BoxFit.contain,
    );
  }
}
