// ignore_for_file: use_build_context_synchronously
import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:omnyqr/commons/constants/omny_colors.dart';
import 'package:omnyqr/commons/constants/omny_images.dart';
import 'package:omnyqr/commons/constants/omny_routes.dart';
import 'package:omnyqr/commons/constants/omny_typography.dart';
import 'package:omnyqr/commons/widgets/common_app_bar.dart';
import 'package:omnyqr/commons/widgets/common_app_dialog.dart';
import 'package:omnyqr/commons/widgets/common_overview_form_field.dart';
import 'package:omnyqr/commons/widgets/common_page_header.dart';
import 'package:omnyqr/models/user.dart';
import 'package:omnyqr/models/utility.dart';
import 'package:omnyqr/views/call_screen/call_screen.dart';
import 'package:omnyqr/views/main_container/bloc/container_bloc.dart';
import 'package:omnyqr/models/referent.dart';


class UtilitySectionPage extends StatefulWidget {
  const UtilitySectionPage({super.key});

  @override
  State<UtilitySectionPage> createState() => _UtilitySectionPageState();
}

class _UtilitySectionPageState extends State<UtilitySectionPage> {
  @override
  Widget build(BuildContext context) {
    Utility? params = ModalRoute.of(context)!.settings.arguments as Utility?;


    User? user = context.select((ContainerBloc bloc) => bloc.state.user);
    joinCall({
      required String callerId,
      required String calleeId,
      dynamic offer,
    }) async {
      var result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CallScreen(
            callerId: callerId,
            calleeId: calleeId,
            offer: offer,
            name: user?.name,
            surname: user?.surname,
            isCaller: true,
            nameToCallee: params?.intercomName ?? '',
          ),
        ),
      );
      inspect(result);
      if (result == 'rejected') {
        if (mounted) {
          showDialog(
              context: context,
              builder: (context) {
                return CommonDialog(
                  isBtn1Enabled: true,
                  btn1Label: tr('yes'),
                  btn2Label: tr('no'),
                  title: tr('call_refused'),
                  onTap1: () {
                    Navigator.pop(context);
                    Navigator.of(context)
                        .pushNamed(Routes.messagePage, arguments: calleeId);
                  },
                  btn2BackGroundColor: AppColors.mainBlue,
                  btn2txtColor: AppColors.commonWhite,
                  onTap2: () {
                    Navigator.pop(context);
                  },
                );
              });
        }
      }
    }

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
                  title: params?.details,
                  icon: AppImages.tab2,
                ),
                SizedBox(
                  height: 30.h,
                ),
                Visibility(
                  visible: params?.type == 'event',
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 20.w, right: 20.w, top: 10.h, bottom: 5.h),
                    child: CommonOverViewFormField(
                      title: tr('start_date'),
                      text: params?.startDate != null
                          ? formatter(params?.startDate ?? '')
                          : '',
                    ),
                  ),
                ),
                Visibility(
                  visible: params?.type == 'event',
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 20.w, right: 20.w, top: 5.h, bottom: 5.h),
                    child: CommonOverViewFormField(
                      title: tr('end_date'),
                      text: params?.endDate != null
                          ? formatter(params?.endDate ?? '')
                          : '',
                    ),
                  ),
                ),
                Visibility(
                  visible: params?.type == 'event',
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 20.w, right: 20.w, top: 5.h, bottom: 5.h),
                    child: CommonOverViewFormField(
                      title: tr('address_only'),
                      text: params?.address,
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: params?.referents?.length ?? 0,
                  itemBuilder: (context, index) {
                    if (params?.referents?[index].status == 'accepted') {
                      return Padding(
                        padding: EdgeInsets.only(
                            left: 20.w, right: 20.w, top: 10.h, bottom: 10.h),
                        child: InkWell(
                          onTap: () async {
                            // TODO: !!! if (params?.unavailableReferents) {}
                            final String userToDeviate =
                                params?.unavailableReferents?.firstWhere(
                                      (element) =>
                                          element ==
                                          params?.referents?[index].user,
                                      orElse: () => "",
                                    ) ??
                                    "";
                            if (userToDeviate.isNotEmpty) {
                              final bool? result = await showDialog(
                                context: context,
                                builder: (context) {
                                  return CommonDialog(
                                    title: tr("deviation_message"),
                                    btn2Label: tr('yes'),
                                    btn1Label: tr('no'),
                                    btn1BackGroundColor: AppColors.mainBlue,
                                    onTap2: () {
                                      Navigator.of(context).pop(true);
                                    },
                                    onTap1: () {
                                      Navigator.of(context).pop(false);
                                    },
                                  );
                                },
                              );

                              if (result ?? false) {
                                if (params?.canCall == true) {
                                  final calleeId = params?.backupReferent?.user;
                                  if (calleeId != null && calleeId.isNotEmpty) {
                                     joinCall(
                                      callerId: user?.id ?? '',
                                      calleeId: calleeId,
                                      );
                                     } else {
                                        print('❌ Nessun backupReferent valido selezionato');
                                       }

                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return CommonDialog(
                                          isBtn1Enabled: false,
                                          btn2Label: tr('ok'),
                                          title: tr('not_available'),
                                          onTap2: () {
                                            Navigator.pop(context);
                                          },
                                        );
                                      });
                                }
                              }
                            } else {
                              if (params?.canCall == true) {
                                final calleeId = params?.referents?[index].user;
                                if (calleeId != null && calleeId.isNotEmpty) {
                                  joinCall(
                                    callerId: user?.id ?? '',
                                    calleeId: calleeId,
                                  );
                                } else {
                                  print('❌ Nessun referent valido selezionato');
                                }
                              }
                              else {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return CommonDialog(
                                        isBtn1Enabled: false,
                                        btn2Label: tr('ok'),
                                        title: tr('not_available'),
                                        onTap2: () {
                                          Navigator.pop(context);
                                        },
                                      );
                                    });
                              }
                            }
                          },
                          child: Row(
                            children: [
                              Container(
                                height: 50.h,
                                width: 50.h,
                                decoration: BoxDecoration(
                                    color: AppColors.containerSmall,
                                    border: Border.all(
                                      color: Colors.transparent,
                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(100.r))),
                                child: Padding(
                                  padding: EdgeInsets.all(10.h),
                                  child: SvgPicture.asset(AppImages.bell),
                                ),
                              ),
                              SizedBox(
                                width: 20.w,
                              ),
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppColors.containerSmall,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(10.h),
                                    child: Row(children: [
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${params?.referents?[index].name} ${params?.referents?[index].surname}",
                                              style: AppTypografy.common16
                                                  .copyWith(
                                                      color: AppColors
                                                          .commonBlack),
                                            ),
                                            Text(
                                              "${params?.details ?? params?.intercomName}",
                                              style: AppTypografy.common13,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        Icons.chevron_right,
                                        color: AppColors.mainBlue,
                                        size: 30.h,
                                      ),
                                      SizedBox(
                                        height: 10.w,
                                      )
                                    ]),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return Container();
                  },
                ),
              ],
            ),
          )),
    );
  }

  String formatter(String date) {
    String inputString = date;
    DateTime dateTime = DateTime.parse(inputString);
    String formattedDate = DateFormat('dd/MM/yyyy - HH:mm').format(dateTime);
    return formattedDate;
  }
}

/*
 context.read<ContainerBloc>().add(SendNotificationEvent(
            id: params
                ?.referents?[context.read<ContainerBloc>().state.callIndex]
                .user,
            type: 'CALL'));
             */
