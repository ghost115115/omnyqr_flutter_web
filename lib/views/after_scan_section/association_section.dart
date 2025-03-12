import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:omnyqr/commons/constants/omny_colors.dart';
import 'package:omnyqr/commons/constants/omny_images.dart';
import 'package:omnyqr/commons/constants/omny_routes.dart';
import 'package:omnyqr/commons/constants/omny_typography.dart';
import 'package:omnyqr/commons/widgets/common_app_bar.dart';
import 'package:omnyqr/commons/widgets/common_page_header.dart';
import '../../models/associations.dart';

class AssociationSectionPage extends StatelessWidget {
  const AssociationSectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    Association? params =
        ModalRoute.of(context)!.settings.arguments as Association?;
    return Scaffold(
      appBar: const CommonAppBar(),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20.h,
              ),
              CommonHeader(
                icon: AppImages.tab2,
                title: params?.name,
                color: AppColors.commonBlack,
              ),
              SizedBox(
                height: 20.h,
              ),
              params?.utilities?.isNotEmpty == true
                  ? ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: params?.utilities?.length ?? 10,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                Routes.utilitySection,
                                arguments: params?.utilities?[index]);
                          },
                          child: Padding(
                              padding: EdgeInsets.only(
                                  left: 30.w, right: 30.w, top: 15.h),
                              child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppColors.containerSmall,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 20.w,
                                        top: 12.h,
                                        right: 20.w,
                                        bottom: 12.h),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 50,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                params?.utilities?[index]
                                                        .intercomName ??
                                                    '',
                                                style: AppTypografy.common16
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: AppColors
                                                            .commonBlack),
                                              ),
                                              Text(params?.utilities?[index]
                                                      .details ??
                                                  '')
                                            ],
                                          ),
                                        ),
                                        const Spacer(
                                          flex: 5,
                                        ),
                                        SvgPicture.asset(AppImages.forwardIcon)
                                      ],
                                    ),
                                  ))),
                        );
                      },
                    )
                  : SizedBox(
                      height: 300.h,
                      child: Center(
                        child: Text(tr('no_utility_found')),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
