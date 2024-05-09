import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MySVGIcon extends StatelessWidget {
  final String iconPath;
  final double size;
  final bool isSelected;

  const MySVGIcon({super.key, 
    required this.iconPath,
    required this.isSelected,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    Color color = isSelected ? Theme.of(context).primaryColor : Colors.grey;

    return SvgPicture.asset(
      iconPath,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn)
    );
  }
}