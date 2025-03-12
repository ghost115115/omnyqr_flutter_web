import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:omnyqr/commons/widgets/common_app_bar.dart';
import 'package:omnyqr/repositories/utilities/utility_repo.dart';
import 'package:omnyqr/views/call_deviation/bloc/call_deviation_bloc.dart';

import '../../commons/constants/omny_colors.dart';
import '../../commons/constants/omny_typography.dart';
import '../../commons/dialog/deviation_dialog.dart';
import '../../commons/widgets/common_app_dialog.dart';
import '../../commons/widgets/common_app_small.dart';
import '../../commons/widgets/common_rounded_container_small.dart';
import '../../commons/widgets/loader/loading_view.dart';

class CallDeviation extends StatelessWidget {
  const CallDeviation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CallDeviationBloc(
        context.read<UtilityRepository>(),
      )..add(InitEvent()),
      child: BlocConsumer<CallDeviationBloc, CallDeviationState>(
        listener: (context, state) {
          final bloc = context.read<CallDeviationBloc>();
          DeviationDialog.callDialog(context, state.message);
          bloc.add(ResetAlert());
        },
        builder: (context, state) {
          return Scaffold(
            appBar: const CommonAppBar(),
            body: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              tr("call_deviation_title"),
                              textAlign: TextAlign.center,
                              style: AppTypografy.common16
                                  .copyWith(color: AppColors.commonBlack),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: state.utilityUnavailability?.isEmpty ?? false,
                      child: Text(
                        tr(
                          "call_deviation_empty_state",
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.utilityUnavailability?.length ?? 0,
                        padding: EdgeInsets.all(15),
                        itemBuilder: (context, index) {
                          final element = state.utilityUnavailability?[index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: 20.w),
                            child: RoundBorderContainerSmall(
                              child: Container(
                                color: !(element?.hasBackupReferent ?? false)
                                    ? Colors.grey.withOpacity(0.2)
                                    : Colors.transparent,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 12.h,
                                      bottom: 12.h,
                                      left: 20.w,
                                      right: 20.w),
                                  child: Column(
                                    children: [
                                      Row(
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
                                                  element?.name ?? "",
                                                  style: AppTypografy.common16
                                                      .copyWith(
                                                          color: AppColors
                                                              .commonBlack),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5.h,
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          Visibility(
                                            visible:
                                                (element?.hasBackupReferent ??
                                                    true),
                                            child: Checkbox(
                                              activeColor:
                                                  AppColors.formFieldColor,
                                              checkColor: AppColors.mainBlue,
                                              value: element?.isUnavailable ??
                                                  false,
                                              onChanged:
                                                  (element?.hasBackupReferent ??
                                                          true)
                                                      ? (value) {
                                                          context
                                                              .read<
                                                                  CallDeviationBloc>()
                                                              .add(
                                                                  SelectCheckboxEvent(
                                                                      index,
                                                                      value));
                                                        }
                                                      : null,
                                            ),
                                          ),
                                          Visibility(
                                            visible:
                                                !(element?.hasBackupReferent ??
                                                    true),
                                            child: IconButton(
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return CommonDialog(
                                                        isBtn1Enabled: false,
                                                        btn2Label: tr('ok'),
                                                        title: tr(
                                                            'no_backup_referent_explain'),
                                                        onTap2: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      );
                                                    });
                                              },
                                              icon: const Icon(
                                                  Icons.info_outline),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Visibility(
                                        visible: !(element?.hasBackupReferent ??
                                            true),
                                        child: Row(
                                          children: [
                                            Text(
                                              tr('no_backup_referent'),
                                              style: AppTypografy.commonBlack16
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w700),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Material(
                  color: Colors.white,
                  child: Padding(
                    padding:
                        EdgeInsets.only(bottom: 40.h, left: 30.w, right: 30.w),
                    child: CommonButtonSmall(
                      title: tr('save'),
                      onTap: () {
                        context.read<CallDeviationBloc>().add(SaveEvent());
                      },
                    ),
                  ),
                ),
                Visibility(
                  visible: state.isLoading ?? true,
                  child: const Center(
                    child: LoadingView(),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
