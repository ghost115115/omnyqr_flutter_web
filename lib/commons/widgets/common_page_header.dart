// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:omnyqr/commons/constants/omny_typography.dart';

class CommonHeader extends StatelessWidget {
  final String? icon;
  final Color? color;
  final String? title;
  const CommonHeader({this.icon, this.title, this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          icon ?? '',
          height: 20.h,
          width: 20.w,
          color: color,
        ),
        SizedBox(
          width: 5.w,
        ),
        Flexible(
          child: Text(
            title ?? '',
            maxLines: 2,
            style: AppTypografy.header.copyWith(color: color),
          ),
        )
      ],
    );
  }
}
