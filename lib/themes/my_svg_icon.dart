import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// ignore: must_be_immutable
class MySVGIcon extends StatelessWidget {
  final String iconPath;
  final double size;
  final bool isSelected;
  Color primaryColor;

  MySVGIcon({super.key, 
    required this.iconPath,
    required this.isSelected,
    required this.primaryColor,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    Color color = isSelected ? primaryColor : Colors.grey;

    return SvgPicture.asset(
      iconPath,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn)
    );
  }
}