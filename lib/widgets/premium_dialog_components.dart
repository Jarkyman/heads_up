import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/settings_controller.dart';
import '../helper/app_colors.dart';
import '../helper/dimensions.dart';

class PremiumBottomSheet extends StatelessWidget {
  const PremiumBottomSheet({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final bottomSafeArea = MediaQuery.paddingOf(context).bottom;

    return SafeArea(
      top: false,
      bottom: false,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(Dimensions.radius30),
          topLeft: Radius.circular(Dimensions.radius30),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            height: Dimensions.screenHeight * 0.62,
            width: Dimensions.screenWidth > 600
                ? Dimensions.screenWidth / 1.6
                : Dimensions.screenWidth,
            padding: EdgeInsets.fromLTRB(
              Dimensions.width20,
              Dimensions.height20,
              Dimensions.width20,
              Dimensions.height20 + bottomSafeArea,
            ),
            decoration: BoxDecoration(
              color: AppColors.glassWhiteStrong,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(Dimensions.radius30),
                topLeft: Radius.circular(Dimensions.radius30),
              ),
              border: Border(
                top: BorderSide(color: AppColors.glassBorder, width: 1.4),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class PremiumSheetHandle extends StatelessWidget {
  const PremiumSheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimensions.width45,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }
}

class PremiumHeroIcon extends StatelessWidget {
  const PremiumHeroIcon({
    super.key,
    required this.icon,
    this.accentColor = AppColors.greenColor,
  });

  final IconData icon;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final size = Dimensions.width45 * 2.35;

    return ClipRRect(
      borderRadius: BorderRadius.circular(size / 2),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.28),
            borderRadius: BorderRadius.circular(size / 2),
            border: Border.all(
              color: accentColor.withValues(alpha: 0.72),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: accentColor.withValues(alpha: 0.18),
                blurRadius: 18,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: Dimensions.iconSize32 * 1.6,
          ),
        ),
      ),
    );
  }
}

class PremiumTextPanel extends StatelessWidget {
  const PremiumTextPanel({
    super.key,
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(Dimensions.height20),
      decoration: BoxDecoration(
        color: AppColors.glassWhite,
        borderRadius: BorderRadius.circular(Dimensions.radius20),
        border: Border.all(
          color: AppColors.glassBorder,
          width: 1.2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}

class PremiumBodyText extends StatelessWidget {
  const PremiumBodyText(
    this.text, {
    super.key,
    this.fontWeight = FontWeight.w600,
  });

  final String text;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: Dimensions.font16,
        color: Colors.white.withValues(alpha: 0.88),
        fontWeight: fontWeight,
        height: 1.25,
      ),
    );
  }
}

class PremiumActionButton extends StatefulWidget {
  const PremiumActionButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    required this.accentColor,
    this.price = '',
    this.textColor = Colors.white,
    this.isTimer = false,
    this.enabled = true,
  });

  final VoidCallback onTap;
  final String title;
  final String price;
  final IconData icon;
  final Color accentColor;
  final Color textColor;
  final bool isTimer;
  final bool enabled;

  @override
  State<PremiumActionButton> createState() => _PremiumActionButtonState();
}

class _PremiumActionButtonState extends State<PremiumActionButton> {
  Timer? _countdownTimer;
  Duration myDuration = Duration.zero;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    if (widget.isTimer) {
      startTimer();
    }
  }

  @override
  void didUpdateWidget(covariant PremiumActionButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.isTimer && widget.isTimer) {
      startTimer();
    } else if (oldWidget.isTimer && !widget.isTimer) {
      _countdownTimer?.cancel();
      _countdownTimer = null;
      myDuration = Duration.zero;
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  Future<void> startTimer() async {
    _countdownTimer?.cancel();
    myDuration = await Get.find<SettingsController>().getTimeToNewTry();
    if (!mounted) return;

    setState(() {});
    _countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => setCountDown(),
    );
  }

  void setCountDown() {
    final seconds = myDuration.inSeconds - 1;
    if (seconds < 0) {
      _countdownTimer?.cancel();
      _countdownTimer = null;
      Get.find<SettingsController>().resetTries();
      return;
    }

    if (!mounted) return;
    setState(() {
      myDuration = Duration(seconds: seconds);
    });
  }

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');

    final hours = strDigits(myDuration.inHours.remainder(24));
    final minutes = strDigits(myDuration.inMinutes.remainder(60));
    final seconds = strDigits(myDuration.inSeconds.remainder(60));
    final countdown = '$hours:$minutes:$seconds';
    final textColor = widget.enabled
        ? widget.textColor
        : Colors.white.withValues(alpha: 0.42);
    final backgroundColor = widget.enabled
        ? widget.accentColor.withValues(alpha: 0.34)
        : Colors.white.withValues(alpha: 0.08);
    final borderColor = widget.enabled
        ? widget.accentColor.withValues(alpha: 0.72)
        : AppColors.glassBorder;

    return GestureDetector(
      onTapDown: widget.enabled
          ? (_) {
              setState(() {
                _isPressed = true;
              });
            }
          : null,
      onTapUp: widget.enabled
          ? (_) {
              setState(() {
                _isPressed = false;
              });
              widget.onTap();
            }
          : null,
      onTapCancel: () {
        if (!widget.enabled) return;
        setState(() {
          _isPressed = false;
        });
      },
      child: AnimatedScale(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        scale: _isPressed ? 0.97 : 1,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Container(
              height: Dimensions.height30 * 2,
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(horizontal: Dimensions.width15),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(Dimensions.radius15),
                border: Border.all(
                  color: borderColor,
                  width: 1.2,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    widget.icon,
                    color: textColor,
                    size: Dimensions.iconSize24,
                  ),
                  SizedBox(width: Dimensions.width10),
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.title,
                            style: TextStyle(
                              color: textColor,
                              fontSize: Dimensions.font16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (widget.price.isNotEmpty)
                            Text(
                              ' ${widget.price}',
                              style: TextStyle(
                                color: textColor,
                                fontSize: Dimensions.font16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          if (widget.isTimer && countdown != '00:00:00')
                            Text(
                              ' $countdown',
                              style: TextStyle(
                                color: textColor,
                                fontSize: Dimensions.font16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: Dimensions.width10),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: textColor.withValues(alpha: 0.78),
                    size: Dimensions.iconSize24,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
