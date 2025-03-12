import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'omny_colors.dart';
import 'omny_images.dart';
import 'omny_typography.dart';

class DottedContainer extends StatelessWidget {
  final void Function()? onTap;
  final String? title;
  const DottedContainer({this.onTap, this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: DottedBorder(
        radius: Radius.circular(10.r),
        borderType: BorderType.RRect,
        color: AppColors.mainBlue,
        dashPattern: [3.w, 2.w],
        strokeWidth: 1,
        child: SizedBox(
          height: 200.h,
          width: double.maxFinite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                AppImages.addFile,
                height: 36.h,
                width: 36.w,
              ),
              SizedBox(
                height: 15.h,
              ),
              Text(
                title ?? tr('add_file_action'),
                style: AppTypografy.common14,
              )
            ],
          ),
        ),
      ),
    );
  }
}
