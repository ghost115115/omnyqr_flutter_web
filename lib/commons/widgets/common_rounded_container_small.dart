import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:omnyqr/commons/constants/omny_colors.dart';

class RoundBorderContainerSmall extends StatelessWidget {
  final Widget? child;
  final double? givenWidth;
  final Color? color;
  const RoundBorderContainerSmall(
      {this.child, this.givenWidth, this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            width: givenWidth ?? 1,
            color: color ?? AppColors.containerSmall,
          ),
          borderRadius: BorderRadius.all(Radius.circular(8.r))),
      child: child,
    );
  }
}
