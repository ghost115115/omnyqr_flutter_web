import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:omnyqr/commons/constants/omny_colors.dart';
import 'package:omnyqr/commons/widgets/common_rounded_container_small.dart';

class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: InkWell(
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
                        Container(
                          height: 13.h,
                          width: 100.w,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              border: Border.all(
                                color: AppColors.containerSmall,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.r))),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Container(
                      height: 13.h,
                      width: 200.w,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border.all(
                            color: AppColors.containerSmall,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(8.r))),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Container(
                      height: 13.h,
                      width: 150.w,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border.all(
                            color: AppColors.containerSmall,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(8.r))),
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
