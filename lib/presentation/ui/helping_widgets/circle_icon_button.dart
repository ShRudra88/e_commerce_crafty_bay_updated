import 'package:flutter/material.dart';

class CircleIconButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData iconData;

  /// NEW optional parameters
  final double size;      // diameter of button
  final double iconSize;  // size of the icon

  const CircleIconButton({
    super.key,
    required this.onTap,
    required this.iconData,
    this.size = 40,        // default size (bigger than before)
    this.iconSize = 20,    // icon size
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(size / 2),
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey.shade300,
        ),
        child: Icon(
          iconData,
          size: iconSize,
          color: Colors.grey.shade800,
        ),
      ),
    );
  }
}
