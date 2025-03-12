import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:omnyqr/commons/constants/omny_colors.dart';
import '../../../commons/constants/omny_typography.dart';

class UtilsListElement extends StatelessWidget {
  final String? icon;
  final String? title;
  final String? content;
  final Color? color;
  final void Function()? onTap;

  const UtilsListElement(
      {this.color, this.onTap, this.content, this.icon, this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 25.h),
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  icon ?? '',
                  height: 24.h,
                  width: 24.w,
                  colorFilter: ColorFilter.mode(
                      color ?? const Color.fromARGB(0, 0, 9, 9),
                      BlendMode.srcIn),
                ),
                SizedBox(
                  width: 15.w,
                ),
                Text(
                  title?.toUpperCase() ?? '',
                  style: AppTypografy.common16
                      .copyWith(fontWeight: FontWeight.w700, color: color),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 40.w,
                ),
                Expanded(
                  child: Text(
                    content ?? '',
                    style: AppTypografy.common13.copyWith(
                        fontWeight: FontWeight.w400,
                        color: AppColors.commonBlack),
                  ),
                ),
                Icon(Icons.chevron_right, size: 24.h, color: color),
              ],
            )
          ],
        ),
      ),
    );
  }
}
