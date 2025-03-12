import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:omnyqr/commons/constants/omny_colors.dart';

import '../constants/omny_typography.dart';

class CommonDialogButton extends StatelessWidget {
  final String? title;
  final void Function()? onTap;
  final Color? txtColor;
  final Color? backgroundColor;
  const CommonDialogButton(
      {this.title, this.onTap, this.txtColor, this.backgroundColor, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38.h,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.transparent, width: 1.5),
            borderRadius: BorderRadius.circular(25.h),
            color: backgroundColor ?? AppColors.commonGreen),
        height: 41.h,
        child: InkWell(
          splashColor: Colors.transparent,
          borderRadius: BorderRadius.circular(25.h),
          enableFeedback: true,
          onTap: onTap,
          child: Center(
              child: Text(
            title ?? '',
            textAlign: TextAlign.center,
            style: AppTypografy.common16
                .copyWith(color: txtColor ?? AppColors.commonWhite),
          )),
        ),
      ),
    );
  }
}
