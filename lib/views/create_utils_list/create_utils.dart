import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:omnyqr/commons/constants/omny_colors.dart';
import 'package:omnyqr/commons/constants/omny_images.dart';
import 'package:omnyqr/commons/constants/omny_typography.dart';
import 'package:omnyqr/commons/widgets/common_app_bar.dart';
import 'package:omnyqr/commons/widgets/common_page_header.dart';
import 'package:omnyqr/models/associations.dart';
import 'package:omnyqr/views/create_utils_list/widgets/list_element.dart';
import '../../commons/constants/omny_qr_type.dart';
import '../../commons/constants/omny_routes.dart';
import '../../models/association_wrapper.dart';

class CreateUtilsPage extends StatelessWidget {
  const CreateUtilsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 30.w, right: 30.w),
            child: Column(
              children: [
                SizedBox(
                  height: 20.h,
                ),
                CommonHeader(
                  icon: AppImages.tab2,
                  color: AppColors.commonBlack,
                  title: tr('add_utilities').toUpperCase(),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Text(
                  tr('choose_type'),
                  style: AppTypografy.common16.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.commonBlack),
                ),
                SizedBox(
                  height: 30.h,
                ),
                UtilsListElement(
                  color: AppColors.mineColor,
                  onTap: () {
                    Navigator.of(context).pushNamed(Routes.createEditQr,
                        arguments: AssociationWrapper(
                            association:
                                Association(associationType: qrType[0]),
                            index: 0));
                  },
                  title: tr('mine_title'),
                  content: tr('mine_type'),
                  icon: AppImages.mine,
                ),
                UtilsListElement(
                  color: AppColors.businessColor,
                  onTap: () {
                    Navigator.of(context).pushNamed(Routes.createEditQr,
                        arguments: AssociationWrapper(
                            association:
                                Association(associationType: qrType[1]),
                            index: 0));
                  },
                  title: tr('business_title'),
                  content: tr('business_type'),
                  icon: AppImages.business,
                ),
                UtilsListElement(
                  color: AppColors.lostColor,
                  onTap: () {
                    Navigator.of(context).pushNamed(Routes.createEditQr,
                        arguments: AssociationWrapper(
                            association:
                                Association(associationType: qrType[2]),
                            index: 0));
                  },
                  title: tr('lost_title'),
                  content: tr('lost_type'),
                  icon: AppImages.lost,
                ),
                UtilsListElement(
                  color: AppColors.goingColor,
                  onTap: () {
                    Navigator.of(context).pushNamed(Routes.createEditQr,
                        arguments: AssociationWrapper(
                            association:
                                Association(associationType: qrType[3]),
                            index: 0));
                  },
                  title: tr('going_on_title'),
                  content: tr('going_on_type'),
                  icon: AppImages.calendar,
                ),
                UtilsListElement(
                  color: AppColors.emergencyColor,
                  onTap: () {
                    Navigator.of(context).pushNamed(Routes.createEditQr,
                        arguments: AssociationWrapper(
                            association:
                                Association(associationType: qrType[4]),
                            index: 0));
                  },
                  title: tr('emergency_title'),
                  content: tr('emergency_type'),
                  icon: AppImages.car,
                ),
                UtilsListElement(
                  color: AppColors.priceColor,
                  onTap: () {
                    Navigator.of(context).pushNamed(Routes.createEditQr,
                        arguments: AssociationWrapper(
                            association:
                                Association(associationType: qrType[5]),
                            index: 0));
                  },
                  title: tr('fork_title'),
                  content: tr('fork_type'),
                  icon: AppImages.fork,
                ),
                UtilsListElement(
                  color: AppColors.assistanceColor,
                  onTap: () {
                    Navigator.of(context).pushNamed(Routes.createEditQr,
                        arguments: AssociationWrapper(
                            association:
                                Association(associationType: qrType[6]),
                            index: 0));
                  },
                  title: tr('assistance_title'),
                  content: tr('assistance_type'),
                  icon: AppImages.life,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
