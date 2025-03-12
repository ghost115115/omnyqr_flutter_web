import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:omnyqr/commons/constants/omny_colors.dart';

class AppTypografy {
  static const String inter = 'Inter';

  // AppBarTitle
  static TextStyle mainContainerAppBarTitle = TextStyle(
      fontSize: 18.sp,
      fontFamily: inter,
      fontWeight: FontWeight.w500,
      color: AppColors.appBarTitleGrey);
  // FormHintText
  static TextStyle formHint = TextStyle(
      fontSize: 18.sp,
      fontFamily: inter,
      fontWeight: FontWeight.w400,
      color: AppColors.formHintColor);
  // Forget Password
  static TextStyle forgetPassword = TextStyle(
    fontSize: 13.sp,
    fontFamily: inter,
    fontWeight: FontWeight.w500,
    decoration: TextDecoration.underline,
    color: AppColors.lightBlue,
  );
  // Button Text
  static TextStyle common11 = TextStyle(
    fontSize: 11.sp,
    fontFamily: inter,
    fontWeight: FontWeight.w700,
    color: AppColors.commonGrey,
  );
  // Button Text
  static TextStyle common13 = TextStyle(
    fontSize: 13.sp,
    fontFamily: inter,
    fontWeight: FontWeight.w400,
    color: AppColors.commonGrey,
  ); // HEADER TEXT
  static TextStyle header = TextStyle(
    fontSize: 16.sp,
    fontFamily: inter,
    fontWeight: FontWeight.w700,
    color: AppColors.mainBlue,
  );
  // common 14
  static TextStyle common14 = TextStyle(
    fontSize: 14.sp,
    fontFamily: inter,
    fontWeight: FontWeight.w400,
    color: AppColors.mainBlue,
  );
// common 16
  static TextStyle common16 = TextStyle(
    fontSize: 16.sp,
    fontFamily: inter,
    fontWeight: FontWeight.w700,
    color: AppColors.mainBlue,
  );
  // common 16
  static TextStyle commonBlack16 = TextStyle(
    fontSize: 16.sp,
    fontFamily: inter,
    fontWeight: FontWeight.w400,
    color: AppColors.commonBlack,
  );
  static TextStyle commonBlack16W700 = TextStyle(
    fontSize: 16.sp,
    fontFamily: inter,
    fontWeight: FontWeight.w700,
    color: AppColors.commonBlack,
  );
  // common 18
  static TextStyle common18 = TextStyle(
    fontSize: 18.sp,
    fontFamily: inter,
    fontWeight: FontWeight.w400,
    color: AppColors.commonBlack,
  );
  // common 20
  static TextStyle common20 = TextStyle(
    fontSize: 20.sp,
    fontFamily: inter,
    fontWeight: FontWeight.w500,
    color: AppColors.commonBlack,
  );

  static TextStyle getStyleByPremiumStatus(String status) {
    switch (status.toLowerCase()) {
      case 'free':
        return TextStyle(
          fontSize: 16.sp,
          fontFamily: inter,
          fontWeight: FontWeight.w700,
          color: AppColors.freeColor,
        );

      case 'pro':
        return TextStyle(
          fontSize: 16.sp,
          fontFamily: inter,
          fontWeight: FontWeight.w700,
          color: AppColors.proColor,
        );
      case 'enterprise':
        return TextStyle(
          fontSize: 16.sp,
          fontFamily: inter,
          fontWeight: FontWeight.w700,
          color: AppColors.enterpriseColor,
        );
      case 'business':
        return TextStyle(
          fontSize: 16.sp,
          fontFamily: inter,
          fontWeight: FontWeight.w700,
          color: AppColors.enterpriseColor,
        );

      default:
        return AppTypografy.common16;
    }
  }
}
