import 'package:flutter/material.dart';

import '../helper/dimensions.dart';

class IconBtn extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;

  const IconBtn({
    super.key,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: Dimensions.width10 * 3.2,
        width: Dimensions.width10 * 3.2,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(Dimensions.radius10 * 3.2),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: Dimensions.iconSize24,
        ),
      ),
    );
  }
}
