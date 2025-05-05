import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:omnyqr/commons/constants/omny_account_config.dart';
import 'package:omnyqr/commons/constants/omny_account_type.dart';
import 'package:omnyqr/commons/constants/omny_colors.dart';
import 'package:omnyqr/commons/constants/omny_typography.dart';
import 'package:omnyqr/commons/widgets/common_app_dialog.dart';
import 'package:omnyqr/commons/widgets/common_page_header.dart';
import 'package:omnyqr/models/associations.dart';
import 'package:omnyqr/views/main_container/bloc/container_bloc.dart';
import 'package:omnyqr/views/main_container/bloc/container_event.dart';
import 'package:omnyqr/views/tab_utilities/widgets/skeleton_card.dart';
import 'package:omnyqr/views/tab_utilities/widgets/utilities_card.dart';
import 'package:shimmer/shimmer.dart';
import '../../commons/constants/omny_images.dart';
import '../../commons/constants/omny_routes.dart';
import '../../commons/widgets/common_app_small.dart';
import '../../models/association_wrapper.dart';
import '../main_container/bloc/container_state.dart';

class UtilitiesPage extends StatelessWidget {
  const UtilitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Association>? associationsList =
        context.select((ContainerBloc bloc) => bloc.state.associations);
    UtilityStatus? status =
        context.select((ContainerBloc bloc) => bloc.state.status);
    AccountType? accountType =
        context.select((ContainerBloc bloc) => bloc.state.accountType);

    return Scaffold(
        body: Padding(
      padding: EdgeInsets.only(left: 30.w, right: 30.w),
      child: ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(overscroll: false),
          child: associationsList?.isEmpty != true
              ? RefreshIndicator(
                  color: AppColors.mainBlue,
                  onRefresh: () {
                    return Future.delayed(const Duration(seconds: 0), () {
                      context.read<ContainerBloc>().add(RefreshUtilities());
                      print('[DEBUG] RefreshUtilities inviato  da pull');

                    });
                  },
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20.h,
                      ),
                      CommonHeader(
                        icon: AppImages.tab2,
                        title: tr('utilities_tab'),
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      Text(
                        tr('scroll_down'),
                        style: AppTypografy.common14,
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      const Icon(
                        Icons.arrow_downward_sharp,
                        color: AppColors.mainBlue,
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      Expanded(
                          child: ListView.builder(
                        itemCount: associationsList?.length ?? 1,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          if (status != UtilityStatus.loaded) {
                            return Shimmer.fromColors(
                                baseColor: AppColors.commonBlack,
                                highlightColor: AppColors.mainBlue,
                                child: const SkeletonCard());
                          } else {
                            return UtilitiesCard(
                              title: associationsList?[index].name,
                              uid: associationsList?[index].uid,
                              iAmOwner: associationsList?[index].amIOwner,
                              name: associationsList?[index]
                                  .associationType
                                  ?.replaceFirst(
                                      associationsList[index]
                                              .associationType?[0] ??
                                          '',
                                      associationsList[index]
                                              .associationType?[0]
                                              .toUpperCase() ??
                                          ''),
                              address: associationsList?[index].address,
                              onTap: () {
                                if (associationsList?[index]
                                        .isRealAssociation ==
                                    true) {
                                  Navigator.of(context).pushNamed(
                                      Routes.associationOverView,
                                      arguments: associationsList?[index]);
                                } else {
                                  Navigator.of(context).pushNamed(
                                      Routes.utilityOverView,
                                      arguments: AssociationWrapper(
                                          isEdit: true,
                                          association: associationsList?[index],
                                          isReal: associationsList?[index]
                                              .isRealAssociation,
                                          index: 0));
                                }
                              },
                            );
                          }
                        },
                      )),
                      SizedBox(
                        height: 20.h,
                      ),
                      Visibility(
                        visible: status == UtilityStatus.loaded,
                        child: CommonButtonSmall(
                          title: tr('add_utilities'),
                          onTap: () {
                            if ((associationsList?.length ?? 0) >=
                                getAccountUtilitiesLimit(
                                    accountType ?? AccountType.free)) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return CommonDialog(
                                      isBtn1Enabled: true,
                                      btn1Label: tr('ok'),
                                      btn2Label: tr('go_to_shop'),
                                      title: tr('utility_limit'),
                                      onTap2: () {
                                        Navigator.of(context).pushNamed(
                                          Routes.inAppPurchase,
                                        );
                                      },
                                      onTap1: () {
                                        Navigator.pop(context);
                                      },
                                    );
                                  });
                            } else {
                              Navigator.of(context)
                                  .pushNamed(Routes.createUtils);
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                    ],
                  ))
              : RefreshIndicator(
                  color: AppColors.mainBlue,
                  onRefresh: () {
                    return Future.delayed(const Duration(seconds: 0), () {
                      context.read<ContainerBloc>().add(RefreshUtilities());
                    });
                  },
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20.h,
                      ),
                      CommonHeader(
                        icon: AppImages.tab2,
                        title: tr('utilities_tab'),
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      Expanded(
                          child: ListView.builder(
                        itemCount: status != UtilityStatus.loaded ? 5 : 1,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          if (status != UtilityStatus.loaded) {
                            return Shimmer.fromColors(
                                baseColor: AppColors.commonBlack,
                                highlightColor: AppColors.mainBlue,
                                child: const SkeletonCard());
                          } else {
                            return SizedBox(
                                height: 300.h,
                                child: Center(
                                    child: Text(tr('utilities_not_found'))));
                          }
                        },
                      )),
                      SizedBox(
                        height: 20.h,
                      ),
                      Visibility(
                        visible: status == UtilityStatus.loaded,
                        child: CommonButtonSmall(
                          title: tr('add_utilities'),
                          onTap: () {
                            Navigator.of(context).pushNamed(Routes.createUtils);
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                    ],
                  ))),
    ));
  }
}
