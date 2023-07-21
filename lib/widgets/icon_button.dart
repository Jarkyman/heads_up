import 'package:flutter/material.dart';

import '../helper/dimensions.dart';

class IconBtn extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;

  const IconBtn({
    Key? key,
    required this.onTap,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: Dimensions.width10 * 3.2,
        width: Dimensions.width10 * 3.2,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
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
