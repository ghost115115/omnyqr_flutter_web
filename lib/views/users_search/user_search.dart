import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:omnyqr/commons/constants/omny_colors.dart';
import 'package:omnyqr/commons/constants/omny_images.dart';
import 'package:omnyqr/commons/constants/omny_typography.dart';
import 'package:omnyqr/commons/dialog/user_search_dialog.dart';
import 'package:omnyqr/commons/utils/validation_utils.dart';
import 'package:omnyqr/commons/widgets/common_app_bar.dart';
import 'package:omnyqr/commons/widgets/common_app_small.dart';
import 'package:omnyqr/commons/widgets/common_form_field.dart';
import 'package:omnyqr/commons/widgets/loader/loading_view.dart';
import 'package:omnyqr/repositories/search/search_repository.dart';
import 'package:omnyqr/views/users_search/bloc/user_search_bloc.dart';

class UserSearchPage extends StatelessWidget {
  const UserSearchPage({super.key});
  static final GlobalKey<FormState> _key2 = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserSearchBloc(context.read<SearchRepository>())
        ..add(UserSearchInitEvent()),
      child: BlocConsumer<UserSearchBloc, UserSearchState>(
        listener: (context, state) {
          UserSearchDialog.callDialog(state.status, context);
        },
        builder: (context, state) {
          return Scaffold(
            appBar: const CommonAppBar(),
            body: Stack(
              children: [
                ScrollConfiguration(
                  behavior: const ScrollBehavior().copyWith(overscroll: false),
                  child: Form(
                    key: _key2,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.only(left: 20.w, right: 20.w),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20.h,
                            ),
                            Text(
                              tr('add_member'),
                              style: AppTypografy.commonBlack16
                                  .copyWith(fontWeight: FontWeight.w700),
                            ),
                            SizedBox(
                              height: 30.h,
                            ),
                            CommonFormField(
                              hint: tr('name_search'),
                              validate: (p0) {
                                return AppValidationUtils.isNameValid(p0 ?? '');
                              },
                              onChange: (p0) {
                                context
                                    .read<UserSearchBloc>()
                                    .add(OnFieldChangveEvemt(value: p0));
                              },
                              icon: Padding(
                                padding: EdgeInsets.all(10.h),
                                child: InkWell(
                                  child: SvgPicture.asset(
                                    AppImages.magnify,
                                  ),
                                  onTap: () {
                                    if (_key2.currentState?.validate() ==
                                        true) {
                                      context.read<UserSearchBloc>().add(
                                          OnSearchSendEvent(value: state.name));
                                    } else {}
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: CommonButtonSmall(
                                givenWidth: 100.w,
                                title: tr('search'),
                                onTap: () {
                                  if (_key2.currentState?.validate() == true) {
                                    context.read<UserSearchBloc>().add(
                                        OnSearchSendEvent(value: state.name));
                                  } else {}
                                },
                              ),
                            ),
                            SizedBox(height: 20.h),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.users?.length ?? 0,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.pop(context, state.users?[index]);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 10.h),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.commonWhite,
                                        border: Border.all(
                                            color: AppColors.containerSmall),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.r)),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 12.h,
                                            bottom: 12.h,
                                            left: 20.w,
                                            right: 20.w),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${state.users?[index].name ?? ''} ${state.users?[index].surname ?? ''}",
                                              style: AppTypografy.common13
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: AppColors
                                                          .commonBlack),
                                            ),
                                            Text(
                                              state.users?[index].uid ?? '',
                                              style: AppTypografy.common13
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: AppColors
                                                          .commonBlack),
                                            ),
                                            Text(
                                              state.users?[index].role ?? '',
                                              style: AppTypografy.common13
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: AppColors
                                                          .commonBlack),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                    visible: state.isLoading ?? true,
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
