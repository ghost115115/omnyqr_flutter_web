import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:omnyqr/commons/constants/omny_message_type.dart';
import 'package:omnyqr/commons/dialog/message_dialog.dart';
import 'package:omnyqr/commons/widgets/common_app_bar.dart';
import 'package:omnyqr/commons/widgets/common_rounded_container_small.dart';
import 'package:omnyqr/commons/widgets/loader/loading_view.dart';
import 'package:omnyqr/repositories/message/message_repository.dart';
import 'package:omnyqr/views/tab_message/subviews/bloc/message_bloc.dart';
import 'package:omnyqr/views/tab_utilities/widgets/skeleton_card.dart';
import 'package:shimmer/shimmer.dart';
import '../../../commons/constants/omny_colors.dart';
import '../../../commons/constants/omny_images.dart';
import '../../../commons/constants/omny_typography.dart';
import '../../../commons/widgets/common_dialog_button.dart';
import '../../../commons/widgets/common_page_header.dart';

class MessageDetails extends StatelessWidget {
  const MessageDetails({super.key});

  @override
  Widget build(BuildContext context) {
    String? id = ModalRoute.of(context)!.settings.arguments as String?;
    return BlocProvider(
      create: (context) => MessageBloc(context.read<MessageRepository>())
        ..add(InitEvemt(id: id)),
      child: BlocConsumer<MessageBloc, MessageState>(
        listener: (context, state) {
          MessageDialog.callDialog(state.status, context);
        },
        builder: (context, state) {
          return Scaffold(
            appBar: const CommonAppBar(),
            body: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 30.w, right: 30.w),
                  child: ScrollConfiguration(
                    behavior:
                        const ScrollBehavior().copyWith(overscroll: false),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20.h,
                          ),
                          CommonHeader(
                            icon: AppImages.tab3,
                            title: state.messages?[0].fullName ?? '',
                          ),
                          SizedBox(
                            height: 25.h,
                          ),
                          ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              reverse: true,
                              itemCount: state.messages?.length ?? 10,
                              itemBuilder: (context, index) {
                                if (state.isLoading == true) {
                                  return Shimmer.fromColors(
                                      baseColor: AppColors.commonBlack,
                                      highlightColor: AppColors.mainBlue,
                                      child: const SkeletonCard());
                                } else {
                                  DateTime dateTime = DateTime.parse(
                                      state.messages?[index].date ?? '');

                                  String formattedString =
                                      DateFormat('dd/MM/yyyy HH:mm')
                                          .format(dateTime);
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 10.h),
                                    child: RoundBorderContainerSmall(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          top: 12.h,
                                          bottom: 12.h,
                                          left: 20.w,
                                          right: 20.w,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              formattedString,
                                              style: AppTypografy.common13
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: AppColors
                                                          .commonBlack),
                                            ),
                                            SizedBox(
                                              height: 5.h,
                                            ),
                                            Text(
                                              state.messages?[index].text ?? '',
                                              style: AppTypografy.commonBlack16,
                                            ),
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                            if (getMessageType(state
                                                            .messages?[index]
                                                            .actionType ??
                                                        '') ==
                                                    MsgType.invitation ||
                                                getMessageType(state
                                                            .messages?[index]
                                                            .actionType ??
                                                        '') ==
                                                    MsgType
                                                        .unavailableInvitation)
                                              Row(
                                                children: [
                                                  Expanded(
                                                      child: CommonDialogButton(
                                                    title: tr('refuse'),
                                                    txtColor:
                                                        AppColors.commonWhite,
                                                    backgroundColor:
                                                        AppColors.mainBlue,
                                                    onTap: () {
                                                      context
                                                          .read<MessageBloc>()
                                                          .add(AceptInvitation(
                                                              messageId: state
                                                                  .messages?[
                                                                      index]
                                                                  .id,
                                                              value: false));
                                                    },
                                                  )),
                                                  SizedBox(
                                                    width: 10.w,
                                                  ),
                                                  Expanded(
                                                      child: CommonDialogButton(
                                                    title: tr('accept'),
                                                    txtColor:
                                                        AppColors.commonWhite,
                                                    backgroundColor:
                                                        AppColors.commonGreen,
                                                    onTap: () {
                                                      context
                                                          .read<MessageBloc>()
                                                          .add(AceptInvitation(
                                                              messageId: state
                                                                  .messages?[
                                                                      index]
                                                                  .id,
                                                              value: true));
                                                    },
                                                  )),
                                                ],
                                              )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              })
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                    visible: state.status == MessageStatus.sending,
                    child: const LoadingView())
              ],
            ),
          );
        },
      ),
    );
  }
}
