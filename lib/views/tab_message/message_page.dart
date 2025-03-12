import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:omnyqr/commons/constants/omny_colors.dart';
import 'package:omnyqr/commons/constants/omny_typography.dart';
import 'package:omnyqr/models/thread.dart';
import 'package:omnyqr/views/main_container/bloc/container_bloc.dart';
import 'package:omnyqr/views/main_container/bloc/container_event.dart';
import 'package:omnyqr/views/main_container/bloc/container_state.dart';
import 'package:shimmer/shimmer.dart';
import '../../commons/constants/omny_images.dart';
import '../../commons/constants/omny_routes.dart';
import '../../commons/widgets/common_page_header.dart';
import '../tab_utilities/widgets/skeleton_card.dart';
import 'widgets/message_container.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Thread>? threadList =
        context.select((ContainerBloc bloc) => bloc.state.threads);
    UtilityStatus? status =
        context.select((ContainerBloc bloc) => bloc.state.status);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: 30.w, right: 30.w),
        child: ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(overscroll: false),
          child: RefreshIndicator(
            color: AppColors.mainBlue,
            onRefresh: () {
              return Future.delayed(const Duration(seconds: 0), () {
                context
                    .read<ContainerBloc>()
                    .add((const RefreshThreadsEvent()));
              });
            },
            child: Column(
              children: [
                SizedBox(
                  height: 20.h,
                ),
                CommonHeader(
                  icon: AppImages.tab3,
                  title: tr('message_header'),
                ),
                SizedBox(
                  height: 25.h,
                ),
                Text(
                  tr('omny_message_tab_subtitle'),
                  style: AppTypografy.forgetPassword,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 25.h,
                ),
                Visibility(
                    visible: threadList?.isEmpty == true,
                    child: Padding(
                        padding: EdgeInsets.only(top: 120.h),
                        child: Text(
                          tr('omny_no_message_found'),
                          style: AppTypografy.common14,
                        ))),
                Expanded(
                  child: ListView.builder(
                    itemCount: threadList?.length ?? 0,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      ContainerBloc bloc = context.read<ContainerBloc>();
                      if (status == UtilityStatus.loading) {
                        return Shimmer.fromColors(
                            baseColor: AppColors.commonBlack,
                            highlightColor: AppColors.mainBlue,
                            child: const SkeletonCard());
                      } else {
                        return MessageCard(
                          name: threadList?[index].counterpartName,
                          date: threadList?[index].lastDate,
                          message: threadList?[index].lastMessage,
                          onTap: () async {
                            var response = await Navigator.of(context)
                                .pushNamed(Routes.msgDetails,
                                    arguments:
                                        threadList?[index].counterpartId);

                            if (response == true) {
                              bloc.add((const RefreshThreadsEvent()));
                            }
                          },
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
