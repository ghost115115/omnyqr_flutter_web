// ignore_for_file: prefer_const_constructors, use_build_context_synchronously
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:omnyqr/commons/constants/omny_colors.dart';
import 'package:omnyqr/commons/constants/omny_images.dart';
import 'package:omnyqr/commons/constants/omny_typography.dart';
import 'package:omnyqr/commons/dialog/avaliabilities_dialog.dart';
import 'package:omnyqr/commons/widgets/common_app_bar.dart';
import 'package:omnyqr/commons/widgets/common_app_button.dart';
import 'package:omnyqr/commons/widgets/common_app_dialog.dart';
import 'package:omnyqr/commons/widgets/common_app_small.dart';
import 'package:omnyqr/commons/widgets/common_page_header.dart';
import 'package:omnyqr/commons/widgets/loader/loading_view.dart';
import 'package:omnyqr/models/utility.dart';
import 'package:omnyqr/repositories/utilities/utility_repo.dart';
import 'package:omnyqr/views/availability/bloc/availabilities_bloc.dart';
import 'package:omnyqr/views/tab_utilities/widgets/skeleton_card.dart';
import 'package:shimmer/shimmer.dart';

class AvailabilitiesPage extends StatelessWidget {
  const AvailabilitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    Utility? params = ModalRoute.of(context)!.settings.arguments as Utility?;
    return BlocProvider(
      create: (context) => AvailabilitiesBloc(context.read<UtilityRepository>())
        ..add(InitEvent(id: params?.id)),
      child: BlocConsumer<AvailabilitiesBloc, AvailabilitiesState>(
        listener: (context, state) {
          AvaliabilyDialog.callDialog(state.status, context);
        },
        builder: (context, state) {
          return Scaffold(
            appBar: const CommonAppBar(),
            body: ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(overscroll: false),
                child: Stack(
                  children: [
                    SingleChildScrollView(
                        child: Padding(
                            padding: EdgeInsets.only(left: 25.w, right: 25.w),
                            child: Column(children: [
                              SizedBox(
                                height: 20.h,
                              ),
                              CommonHeader(
                                icon: AppImages.bell,
                                color: AppColors.commonBlack,
                                title: params?.type,
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Text(
                                params?.intercomName?.toUpperCase() ?? '',
                                style: AppTypografy.common11,
                              ),
                              SizedBox(
                                height: 30.h,
                              ),
                              Text(
                                tr('set_availabilities_title').toUpperCase(),
                                style: AppTypografy.common18
                                    .copyWith(fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: state.availabilities?.length ?? 10,
                                  itemBuilder: (context, index) {
                                    if (state.isloading == true) {
                                      return Shimmer.fromColors(
                                          baseColor: AppColors.commonBlack,
                                          highlightColor: AppColors.mainBlue,
                                          child: const SkeletonCard());
                                    } else {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                            top: 5.h, bottom: 5.h),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color:
                                                      AppColors.containerSmall,
                                                  width: 1.5),
                                              borderRadius:
                                                  BorderRadius.circular(8.h),
                                              color: AppColors.commonWhite),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 20.w, right: 20.w),
                                                child: Row(
                                                  children: [
                                                    Text(days[index]),
                                                    const Spacer(),
                                                    Checkbox(
                                                      activeColor: AppColors
                                                          .formFieldColor,
                                                      checkColor:
                                                          AppColors.mainBlue,
                                                      value: state
                                                          .availabilities?[
                                                              index]
                                                          .isActive,
                                                      onChanged: (value) {
                                                        context
                                                            .read<
                                                                AvailabilitiesBloc>()
                                                            .add(ToggleDay(
                                                                value: value,
                                                                index: index));
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 20.w, right: 20.w),
                                                child: Row(
                                                  children: [
                                                    CommonButton(
                                                        title:
                                                            "${tr('from_hour')} ${state.availabilities?[index].start}",
                                                        txtclr:
                                                            AppColors.mainBlue,
                                                        backgroundColor:
                                                            AppColors
                                                                .commonWhite,
                                                        borderClr:
                                                            AppColors.mainBlue,
                                                        txtSize: 16,
                                                        givenHeight: 30.h,
                                                        givenWidth: 125.w,
                                                        onTap: () async {
                                                          AvailabilitiesBloc
                                                              bloc =
                                                              context.read();
                                                          var time =
                                                              await showTimePicker(
                                                            context: context,
                                                            initialTime:
                                                                TimeOfDay.now(),
                                                            builder:
                                                                (BuildContext?
                                                                        context,
                                                                    Widget?
                                                                        child) {
                                                              return MediaQuery(
                                                                  data: MediaQuery.of(
                                                                          context!)
                                                                      .copyWith(
                                                                          alwaysUse24HourFormat:
                                                                              false),
                                                                  child: Theme(
                                                                    data: Theme.of(
                                                                            context)
                                                                        .copyWith(
                                                                      colorScheme:
                                                                          const ColorScheme
                                                                              .light(
                                                                        primary:
                                                                            AppColors.mainBlue,
                                                                        onPrimary:
                                                                            Colors.white,
                                                                        onSurface:
                                                                            Colors.black,
                                                                      ),
                                                                      textButtonTheme:
                                                                          TextButtonThemeData(
                                                                        style: TextButton
                                                                            .styleFrom(
                                                                          foregroundColor:
                                                                              Colors.black45,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    child:
                                                                        child!,
                                                                  ));
                                                            },
                                                          );
                                                          if (time != null) {
                                                            TimeOfDay orario1 =
                                                                time; // 14:30
                                                            TimeOfDay orario2 =
                                                                state.endTime ??
                                                                    TimeOfDay
                                                                        .now(); // 16:45

                                                            if (orario1.hour <
                                                                    orario2
                                                                        .hour ||
                                                                (orario1.hour ==
                                                                        orario2
                                                                            .hour &&
                                                                    orario1.minute <
                                                                        orario2
                                                                            .minute)) {
                                                              bloc.add(
                                                                  StartDateChangeEvent(
                                                                      value:
                                                                          time,
                                                                      index:
                                                                          index));
                                                            } else if (orario1
                                                                        .hour >
                                                                    orario2
                                                                        .hour ||
                                                                (orario1.hour ==
                                                                        orario2
                                                                            .hour &&
                                                                    orario1.minute >
                                                                        orario2
                                                                            .minute)) {
                                                              bloc.add(
                                                                  StartDateChangeEvent(
                                                                      value:
                                                                          time,
                                                                      index:
                                                                          index));
                                                              bloc.add(
                                                                  EndDateChangeEvent(
                                                                      value:
                                                                          time,
                                                                      index:
                                                                          index));
                                                            } else {}
                                                          }
                                                        }),
                                                    const Spacer(),
                                                    CommonButton(
                                                      txtclr:
                                                          AppColors.mainBlue,
                                                      backgroundColor:
                                                          AppColors.commonWhite,
                                                      borderClr:
                                                          AppColors.mainBlue,
                                                      title:
                                                          "${tr('to_hour')} ${state.availabilities?[index].end}",
                                                      txtSize: 16,
                                                      givenHeight: 30.h,
                                                      givenWidth: 125.w,
                                                      onTap: () async {
                                                        AvailabilitiesBloc
                                                            bloc =
                                                            context.read();
                                                        var time =
                                                            await showTimePicker(
                                                          context: context,
                                                          initialTime: state
                                                                  .startTime ??
                                                              TimeOfDay.now(),
                                                          builder:
                                                              (BuildContext?
                                                                      context,
                                                                  Widget?
                                                                      child) {
                                                            return MediaQuery(
                                                                data: MediaQuery.of(
                                                                        context!)
                                                                    .copyWith(
                                                                        alwaysUse24HourFormat:
                                                                            false),
                                                                child: Theme(
                                                                  data: Theme.of(
                                                                          context)
                                                                      .copyWith(
                                                                    colorScheme:
                                                                        const ColorScheme
                                                                            .light(
                                                                      primary:
                                                                          AppColors
                                                                              .mainBlue,
                                                                      onPrimary:
                                                                          Colors
                                                                              .white,
                                                                      onSurface:
                                                                          Colors
                                                                              .black,
                                                                    ),
                                                                    textButtonTheme:
                                                                        TextButtonThemeData(
                                                                      style: TextButton
                                                                          .styleFrom(
                                                                        foregroundColor:
                                                                            Colors.black45,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  child: child!,
                                                                ));
                                                          },
                                                        );
                                                        if (time != null) {
                                                          TimeOfDay orario1 = state
                                                                  .startTime ??
                                                              TimeOfDay
                                                                  .now(); // 14:30
                                                          TimeOfDay orario2 =
                                                              time; // 16:45

                                                          if (orario1.hour <
                                                                  orario2
                                                                      .hour ||
                                                              (orario1.hour ==
                                                                      orario2
                                                                          .hour &&
                                                                  orario1.minute <
                                                                      orario2
                                                                          .minute)) {
                                                            bloc.add(
                                                                EndDateChangeEvent(
                                                                    value: time,
                                                                    index:
                                                                        index));
                                                          } else if (orario1
                                                                      .hour >
                                                                  orario2
                                                                      .hour ||
                                                              (orario1.hour ==
                                                                      orario2
                                                                          .hour &&
                                                                  orario1.minute >
                                                                      orario2
                                                                          .minute)) {
                                                            showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return CommonDialog(
                                                                        btn2Label:
                                                                            tr('ok'),
                                                                        isBtn1Enabled:
                                                                            false,
                                                                        title: tr(
                                                                            'time_error'),
                                                                        onTap2:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                      );
                                                                    })
                                                                .then(
                                                                    (value) {});
                                                          } else {
                                                            showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return CommonDialog(
                                                                        btn2Label:
                                                                            tr('ok'),
                                                                        isBtn1Enabled:
                                                                            false,
                                                                        title: tr(
                                                                            'time_error'),
                                                                        onTap2:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                      );
                                                                    })
                                                                .then(
                                                                    (value) {});
                                                          }
                                                        }
                                                      },
                                                    )
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                  }),
                              SizedBox(
                                height: 30.h,
                              ),
                              CommonButtonSmall(
                                title: tr('save'),
                                onTap: () {
                                  context
                                      .read<AvailabilitiesBloc>()
                                      .add(UpdateAvailabilitiesEvent());
                                },
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                            ]))),
                    Visibility(
                        visible: state.isloading ?? true,
                        child: const Center(
                          child: LoadingView(),
                        ))
                  ],
                )),
          );
        },
      ),
    );
  }
}
