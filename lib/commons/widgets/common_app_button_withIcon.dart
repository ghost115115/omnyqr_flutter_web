import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:omnyqr/commons/constants/omny_colors.dart';

class CommonInconButton extends StatelessWidget {
  final String? title;
  final String? icon;
  final Color? brColor;
  final Color? txtColor;
  final double? height;
  final void Function()? onTap;
  final double? radius;
  const CommonInconButton(
      {this.brColor,
      this.txtColor,
      this.height,
      this.title,
      this.icon,
      this.onTap,
      this.radius,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        Flexible(
          flex: 6,
          child: SizedBox(
              child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                    color: brColor ?? AppColors.mainBlue, width: 1.5),
                borderRadius: BorderRadius.circular(radius ?? 25.h),
                color: AppColors.commonWhite),
            width: double.infinity,
            child: InkWell(
              borderRadius: BorderRadius.circular(radius ?? 25.h),
              enableFeedback: true,
              onTap: onTap,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 10.h,
                          bottom: 10.h,
                        ),
                        child: Text(
                          title ?? "",
                          maxLines: 2,
                          style: TextStyle(
                              color: txtColor ?? AppColors.mainBlue,
                              fontWeight: FontWeight.w700,
                              fontSize: 16.sp),
                        ),
                      ),
                    ),
                  ),
                  icon != null
                      ? Padding(
                          padding: EdgeInsets.only(right: 20.w),
                          child: SvgPicture.asset(
                            icon ?? '',
                            height: 30.h,
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          )),
        ),
        const Spacer()
      ],
    );
  }
}
