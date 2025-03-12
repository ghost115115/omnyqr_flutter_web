import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../commons/constants/omny_colors.dart';
import '../../../commons/constants/omny_images.dart';
import '../../../commons/constants/omny_typography.dart';
import '../../../commons/widgets/common_rounded_container_small.dart';

class MessageCard extends StatelessWidget {
  final void Function()? onTap;
  final String? name;
  final String? date;
  final String? message;
  const MessageCard(
      {this.onTap, this.message, this.name, this.date, super.key});

  @override
  Widget build(BuildContext context) {
    // Parsing della stringa in un oggetto DateTime
    DateTime dateTime = DateTime.parse(date ?? '');

    // Formattazione della data nel formato desiderato "dd/MM/yyyy"
    String formattedString = DateFormat('dd/MM/yyyy HH:mm').format(dateTime);

    return Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: InkWell(
        onTap: onTap,
        child: RoundBorderContainerSmall(
            child: Padding(
          padding:
              EdgeInsets.only(top: 12.h, bottom: 12.h, left: 20.w, right: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          AppImages.bell,
                          height: 16.h,
                          width: 16.h,
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          name ?? '',
                          style: AppTypografy.common13.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.mainBlue),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      formattedString,
                      style: AppTypografy.common13.copyWith(
                          fontWeight: FontWeight.w400,
                          color: AppColors.commonBlack),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      message ?? '',
                      maxLines: 2,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypografy.commonBlack16,
                    )
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.mainBlue,
              )
            ],
          ),
        )),
      ),
    );
  }
}
