import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helper/app_colors.dart';
import '../helper/dimensions.dart';

class ChameleonStartOrderButton extends StatelessWidget {
  const ChameleonStartOrderButton({
    super.key,
    required this.randomStart,
    required this.size,
    required this.onChanged,
  });

  final bool randomStart;
  final double size;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(Dimensions.radius20);
    final shape = RoundedRectangleBorder(borderRadius: borderRadius);
    final label = randomStart
        ? 'Random starting player'.tr
        : 'Start with first player'.tr;
    final duration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : const Duration(milliseconds: 360);

    return Semantics(
      button: true,
      toggled: randomStart,
      label: label,
      child: Tooltip(
        message: label,
        excludeFromSemantics: true,
        child: ClipRRect(
          borderRadius: borderRadius,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                color: AppColors.glassWhite,
                border: Border.all(color: AppColors.glassBorder, width: 1.2),
              ),
              child: Material(
                color: Colors.transparent,
                shape: shape,
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  customBorder: shape,
                  splashFactory: NoSplash.splashFactory,
                  overlayColor: const WidgetStatePropertyAll(
                    Colors.transparent,
                  ),
                  onTap: () => onChanged(!randomStart),
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: duration,
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      transitionBuilder: (child, animation) => FadeTransition(
                        opacity: animation,
                        child: RotationTransition(
                          turns: Tween<double>(
                            begin: -0.125,
                            end: 0,
                          ).animate(animation),
                          child: ScaleTransition(
                            scale: Tween<double>(
                              begin: 0.75,
                              end: 1,
                            ).animate(animation),
                            child: child,
                          ),
                        ),
                      ),
                      child: Icon(
                        randomStart
                            ? Icons.shuffle_rounded
                            : Icons.repeat_rounded,
                        key: ValueKey(randomStart),
                        color: Colors.white,
                        size: Dimensions.iconSize32,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
