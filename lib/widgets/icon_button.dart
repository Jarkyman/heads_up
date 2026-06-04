import 'dart:ui';

import 'package:flutter/material.dart';

import '../helper/app_colors.dart';
import '../helper/dimensions.dart';

class IconBtn extends StatefulWidget {
  final VoidCallback onTap;
  final IconData icon;

  const IconBtn({
    super.key,
    required this.onTap,
    required this.icon,
  });

  @override
  State<IconBtn> createState() => _IconBtnState();
}

class _IconBtnState extends State<IconBtn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.08,
    );
    _scale = Tween<double>(begin: 1.0, end: 0.88).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Dimensions.width10 * 3.8;
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(size / 2),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              height: size,
              width: size,
              decoration: BoxDecoration(
                color: AppColors.glassWhite,
                borderRadius: BorderRadius.circular(size / 2),
                border: Border.all(
                  color: AppColors.glassBorder,
                  width: 1.2,
                ),
              ),
              child: Icon(
                widget.icon,
                color: Colors.white,
                size: Dimensions.iconSize24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
