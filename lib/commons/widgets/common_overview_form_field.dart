import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:omnyqr/commons/constants/omny_typography.dart';
import '../constants/omny_colors.dart';

class CommonOverViewFormField extends StatelessWidget {
  final String? title;
  final String? text;
  final double? givenHeight;
  final double? bottomPadding;

  const CommonOverViewFormField(
      {this.title, this.text, this.givenHeight, this.bottomPadding, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title ?? '',
          style: AppTypografy.common13,
        ),
        SizedBox(
          height: 5.h,
        ),
        Container(
          width: double.infinity,
         
          decoration: BoxDecoration(
            color: AppColors.commonWhite,
            border: Border.all(
              color: AppColors.containerSmall,
              width: 2,
            ),
            borderRadius: BorderRadius.all(Radius.circular(3.r)),
          ),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 20.w, top: 20.h, bottom: 20.h,right: 20.w),
                child: Text(
                  text ?? '',
                  maxLines: 3,
                  style: AppTypografy.common18,
                ),
              )),
        ),
        SizedBox(
          height: bottomPadding ?? 20.h,
        ),
      ],
    );
  }
}
