import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:omnyqr/commons/constants/omny_colors.dart';

class CommonButtonSmall extends StatelessWidget {
  final String? title;
  final Color? backgroundColor;
  final Color? borderClr;
  final double? borderWidth;
  final VoidCallback? onTap;
  final bool isEnabled;
  final double? givenWidth;
  final double? givenHeight;
  final Color? splashColor;
  final Color? txtclr;
  const CommonButtonSmall(
      {super.key,
      this.title,
      this.backgroundColor = AppColors.lightBlue,
      this.onTap,
      this.isEnabled = true,
      this.splashColor,
      this.givenWidth,
      this.givenHeight,
      this.txtclr,
      this.borderClr,
      this.borderWidth});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: givenWidth ?? double.infinity,
        height: givenHeight ?? 40.h,
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                  color: borderClr ?? Colors.transparent,
                  width: borderWidth ?? 1.5),
              borderRadius: BorderRadius.circular(25.h),
              color: backgroundColor),
          width: givenWidth ?? double.infinity,
          height: 41.h,
          child: InkWell(
            splashColor: splashColor,
            borderRadius: BorderRadius.circular(25.h),
            enableFeedback: true,
            onTap: isEnabled ? onTap ?? () {} : null,
            child: Center(
                child: Text(
              title ?? "",
              style: TextStyle(
                  color: txtclr ?? AppColors.commonWhite,
                  fontWeight: FontWeight.w700,
                  fontSize: 16.sp),
            )),
          ),
        ));
  }
}
