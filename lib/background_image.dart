import 'package:animated_background/animated_background.dart';
import 'package:flutter/material.dart';
import 'package:heads_up/controllers/event_controller.dart';
import 'package:heads_up/helper/app_colors.dart';
import 'package:get/get.dart';

class BackgroundImage extends StatefulWidget {
  final Widget child;
  bool showAnimation;

  BackgroundImage({Key? key, required this.child, this.showAnimation = false})
      : super(key: key);

  @override
  State<BackgroundImage> createState() => _BackgroundImageState();
}

class _BackgroundImageState extends State<BackgroundImage>
    with SingleTickerProviderStateMixin {
  ParticleOptions particles = const ParticleOptions(
    image: Image(
      image: AssetImage('assets/images/snowflake.png'),
    ),
    spawnOpacity: 0.0,
    opacityChangeRate: 0.15,
    minOpacity: 0.1,
    maxOpacity: 0.3,
    particleCount: 60,
    spawnMaxRadius: 30.0,
    spawnMaxSpeed: 100.0,
    spawnMinSpeed: 30,
    spawnMinRadius: 7.0,
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.darkPurpleColor,
        image: DecorationImage(
          image: AssetImage("assets/bg.jpg"),
          fit: BoxFit.cover,
          colorFilter:
              ColorFilter.mode(AppColors.darkPurpleColor, BlendMode.luminosity),
        ),
      ),
      child:
          Get.find<EventController>().getEventStatus == EventStatus.christmas &&
                  widget.showAnimation
              ? AnimatedBackground(
                  behaviour: RandomParticleBehaviour(
                    options: particles,
                  ),
                  vsync: this,
                  child: widget.child,
                )
              : widget.child,
    );
  }
}
