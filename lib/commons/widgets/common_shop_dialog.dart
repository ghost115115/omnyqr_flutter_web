import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:omnyqr/commons/constants/omny_colors.dart';
import 'package:omnyqr/commons/constants/omny_typography.dart';
import 'package:omnyqr/commons/widgets/common_dialog_button.dart';
import 'package:url_launcher/url_launcher.dart';

class CommonDialogShop extends StatelessWidget {
  final String? title;
  final bool? isBtn1Enabled;
  final String? btn1Label;
  final Color? btn1txtColor;
  final Color? btn1BackGroundColor;
  final String? body;
  final bool? isBtn2Enabled;
  final String? btn2Label;
  final Color? btn2txtColor;
  final Color? btn2BackGroundColor;
  final void Function()? onTap1;
  final void Function()? onTap2;

  const CommonDialogShop(
      {this.title,
      this.btn1BackGroundColor,
      this.btn1txtColor,
      this.btn2BackGroundColor,
      this.btn2txtColor,
      this.isBtn1Enabled,
      this.isBtn2Enabled,
      this.btn1Label,
      this.body,
      this.btn2Label,
      this.onTap1,
      this.onTap2,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(20.h),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title ?? '',
                style: AppTypografy.common16
                    .copyWith(color: AppColors.commonBlack),
              ),
              SizedBox(
                height: 40.h,
              ),
              Text(
                body ?? '',
                style: AppTypografy.common13
                    .copyWith(color: AppColors.commonBlack),
              ),
              TextButton(
                onPressed: () async {
                  launchUrl(Uri.parse("https://omnyqr.com/termofuse/"));
                },
                child: Text(
                  tr('common_shop_dialog_terms_and_conditions'),
                ),
              ),
              TextButton(
                onPressed: () async {
                  launchUrl(Uri.parse("https://omnyqr.com/omnyqrpolicy/"));
                },
                child: Text(
                  tr('common_shop_dialog_privacy'),
                ),
              ),
              SizedBox(
                height: 40.h,
              ),
              Row(
                children: [
                  Visibility(
                      visible: isBtn1Enabled ?? true,
                      child: Expanded(
                          child: CommonDialogButton(
                        title: btn1Label,
                        txtColor: btn1txtColor,
                        backgroundColor: btn1BackGroundColor,
                        onTap: onTap1,
                      ))),
                  Visibility(
                      visible: isBtn1Enabled ?? true,
                      child: SizedBox(
                        width: 30.w,
                      )),
                  Visibility(
                    visible: isBtn2Enabled ?? true,
                    child: Expanded(
                      child: CommonDialogButton(
                        title: btn2Label,
                        txtColor: btn2txtColor,
                        backgroundColor: btn2BackGroundColor,
                        onTap: onTap2,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
