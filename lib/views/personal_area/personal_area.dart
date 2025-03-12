import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:omnyqr/commons/constants/omny_colors.dart';
import 'package:omnyqr/commons/constants/omny_images.dart';
import 'package:omnyqr/commons/constants/omny_typography.dart';
import 'package:omnyqr/commons/dialog/account_deleted_dialog.dart';
import 'package:omnyqr/commons/widgets/common_app_bar.dart';
import 'package:omnyqr/commons/widgets/common_app_button_withicon.dart';
import 'package:omnyqr/commons/widgets/common_page_header.dart';
import 'package:omnyqr/commons/widgets/loader/loading_view.dart';
import 'package:omnyqr/models/user.dart';
import 'package:omnyqr/repositories/user/user_repository.dart';
import 'package:omnyqr/services/signaling_service.dart';
import 'package:omnyqr/views/main_container/bloc/container_bloc.dart';
import 'package:omnyqr/views/main_container/bloc/container_state.dart';
import 'package:omnyqr/views/personal_area/bloc/personal_area_bloc.dart';
import '../../commons/constants/omny_routes.dart';
import '../../commons/dialog/incognito_dialog.dart';
import '../../commons/widgets/common_app_dialog.dart';
import '../../commons/widgets/common_rounded_container_small.dart';
import '../main_container/bloc/container_event.dart';

class PersonalAreaPage extends StatelessWidget {
  const PersonalAreaPage({super.key});

  @override
  Widget build(BuildContext context) {
    ContainerState? contState =
        context.select((ContainerBloc bloc) => bloc.state);
    User? user = contState?.user;

    return BlocProvider(
      create: (context) => PersonalAreaBloc(
          context.read<UserRepository>(), context.read<ContainerBloc>())
        ..add(InitEvent(user?.isIncognito)),
      child: BlocConsumer<PersonalAreaBloc, PersonalAreaState>(
        listener: (context, state) {
          DeleteAccountDialog.callDialog(state.status, context);
          IncognitoDialog.callDialog(state.upStatus, context);
        },
        builder: (context, state) {
          return Scaffold(
            appBar: const CommonAppBar(),
            body: Stack(
              children: [
                ScrollConfiguration(
                  behavior: const ScrollBehavior().copyWith(overscroll: false),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(left: 30.w, right: 30.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 20.h,
                          ),
                          CommonHeader(
                            icon: AppImages.account,
                            title: tr("personal_area"),
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          Text(
                            "${contState?.user?.name?.toUpperCase() ?? ''} ${contState?.user?.surname?.toUpperCase() ?? ''}",
                            style: AppTypografy.common16
                                .copyWith(color: AppColors.commonBlack),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            '${contState?.user?.uid ?? ''}'.toUpperCase(),
                            style: AppTypografy.common16,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          RichText(
                            text: TextSpan(
                              style: AppTypografy.common16,
                              children: [
                                TextSpan(
                                  text:
                                      "${tr('account_level')}:  ".toUpperCase(),
                                ),
                                TextSpan(
                                  text: contState?.user?.premiumStatus
                                          ?.toUpperCase() ??
                                      'FREE',
                                  style: AppTypografy.getStyleByPremiumStatus(
                                      contState?.user?.premiumStatus ?? 'free'),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return CommonDialog(
                                            isBtn1Enabled: false,
                                            btn2Label: tr('ok'),
                                            title: tr('hide_text'),
                                            onTap2: () {
                                              Navigator.pop(context);
                                            },
                                          );
                                        });
                                  },
                                  icon: const Icon(Icons.info_outline)),
                              Text(
                                tr('hide_account'),
                                style: AppTypografy.commonBlack16
                                    .copyWith(fontWeight: FontWeight.w700),
                              ),
                              const Spacer(),
                              Switch(
                                value: state.isIncognito ?? false,
                                activeColor: AppColors.mainBlue,
                                activeTrackColor: AppColors.commonGreen,
                                inactiveThumbColor: AppColors.mainBlue,
                                onChanged: (value) {
                                  context
                                      .read<PersonalAreaBloc>()
                                      .add(ToggleHideShowEvent());
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  Routes.personalInformation,
                                  arguments: user);
                            },
                            child: RoundBorderContainerSmall(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 12.h,
                                    bottom: 12.h,
                                    left: 20.w,
                                    right: 20.w),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6,
                                          child: Text(
                                            tr('personal_information'),
                                            maxLines: 2,
                                            softWrap: true,
                                            style: AppTypografy.common16
                                                .copyWith(
                                                    color:
                                                        AppColors.commonBlack),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6,
                                          child: Text(
                                            tr("your_profile_info"),
                                            style: AppTypografy.common13,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Icon(
                                      Icons.chevron_right,
                                      color: AppColors.mainBlue,
                                      size: 30.h,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(Routes.changePassword);
                            },
                            child: RoundBorderContainerSmall(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 12.h,
                                    bottom: 12.h,
                                    left: 20.w,
                                    right: 20.w),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6,
                                          child: Text(
                                            tr("password_manage"),
                                            style: AppTypografy.common16
                                                .copyWith(
                                                    color:
                                                        AppColors.commonBlack),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6,
                                          child: Text(
                                            tr("change_password"),
                                            style: AppTypografy.common13,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Icon(
                                      Icons.chevron_right,
                                      color: AppColors.mainBlue,
                                      size: 30.h,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                Routes.inAppPurchase,
                              );
                            },
                            child: RoundBorderContainerSmall(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 12.h,
                                    bottom: 12.h,
                                    left: 20.w,
                                    right: 20.w),
                                child: Row(
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          tr('become_pro'),
                                          style: AppTypografy.common16.copyWith(
                                              color: AppColors.commonBlack),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Icon(
                                      Icons.chevron_right,
                                      color: AppColors.mainBlue,
                                      size: 30.h,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                Routes.callDeviation,
                              );
                            },
                            child: RoundBorderContainerSmall(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 12.h,
                                    bottom: 12.h,
                                    left: 20.w,
                                    right: 20.w),
                                child: Row(
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          tr('manage_deviation'),
                                          style: AppTypografy.common16.copyWith(
                                              color: AppColors.commonBlack),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Icon(
                                      Icons.chevron_right,
                                      color: AppColors.mainBlue,
                                      size: 30.h,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40.h,
                          ),
                          CommonInconButton(
                            title: tr('logout'),
                            height: 40.h,
                            onTap: () {
                              SignallingService.instance.socket!.disconnect();
                              context.read<ContainerBloc>().add(LogoutEvent());
                              Navigator.of(context)
                                  .popUntil(ModalRoute.withName(Routes.main));
                            },
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          SizedBox(
                              width: 100.w,
                              child: const Divider(
                                thickness: 2,
                              )),
                          SizedBox(
                            height: 15.h,
                          ),
                          CommonInconButton(
                            height: 40.h,
                            title: tr("delete_account"),
                            brColor: AppColors.lightGrey,
                            txtColor: AppColors.lightGrey,
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (_) {
                                    return CommonDialog(
                                      btn2Label: tr('no'),
                                      btn1Label: tr('yes'),
                                      isBtn1Enabled: true,
                                      title: tr('account_delete'),
                                      onTap2: () {
                                        Navigator.pop(context);
                                      },
                                      onTap1: () {
                                        context
                                            .read<PersonalAreaBloc>()
                                            .add(DeleteAccount());
                                        Navigator.pop(context);
                                      },
                                    );
                                  });
                            },
                          ),
                          SizedBox(
                            height: 50.h,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                    visible: state.upStatus == UpdateStatus.loading,
                    child: const Center(
                      child: LoadingView(),
                    ))
              ],
            ),
          );
        },
      ),
    );
  }
}
