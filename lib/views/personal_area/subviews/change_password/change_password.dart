import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:omnyqr/commons/constants/omny_images.dart';
import 'package:omnyqr/commons/dialog/password_dialog.dart';
import 'package:omnyqr/commons/utils/validation_utils.dart';
import 'package:omnyqr/commons/widgets/common_app_bar.dart';
import 'package:omnyqr/commons/widgets/common_app_small.dart';
import 'package:omnyqr/commons/widgets/common_page_header.dart';
import 'package:omnyqr/commons/widgets/loader/loading_view.dart';
import 'package:omnyqr/repositories/user/user_repository.dart';
import 'package:omnyqr/views/personal_area/subviews/change_password/bloc/change_password_bloc.dart';
import '../../../../commons/widgets/common_form_field.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});
  static final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChangePasswordBloc(context.read<UserRepository>()),
      child: BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
        listener: (context, state) {
          PasswordDialog.callDialog(state.status, context);
        },
        builder: (context, state) {
          return Form(
            key: _key,
            child: Scaffold(
              appBar: const CommonAppBar(),
              body: ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(overscroll: false),
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.only(left: 30.w, right: 30.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20.h,
                            ),
                            CommonHeader(
                              icon: AppImages.account,
                              title: tr('modify_password').toUpperCase(),
                            ),
                            SizedBox(
                              height: 30.h,
                            ),
                            CommonFormField(
                              title: tr('old_password'),
                              hint: tr('password'),
                              obscured: !state.showOldPassword,
                              icon: GestureDetector(
                                  onTap: () {
                                    context
                                        .read<ChangePasswordBloc>()
                                        .add(ToggleShowOldPasswordEvent());
                                  },
                                  child: Icon(state.showOldPassword == true
                                      ? Icons.visibility_off_sharp
                                      : Icons.visibility_sharp)),
                              validate: (p0) {
                                return AppValidationUtils.isPasswordValid(
                                    p0 ?? '');
                              },
                              onChange: (p0) {
                                context.read<ChangePasswordBloc>().add(
                                    OldPasswordChangeEvent(oldPassword: p0));
                              },
                            ),
                            CommonFormField(
                              title: tr('new_password'),
                              hint: tr('password'),
                              obscured: !state.showNewPassword,
                              icon: GestureDetector(
                                  onTap: () {
                                    context
                                        .read<ChangePasswordBloc>()
                                        .add(ToggleShowNewPasswordEvent());
                                  },
                                  child: Icon(state.showNewPassword == true
                                      ? Icons.visibility_off_sharp
                                      : Icons.visibility_sharp)),
                              validate: (p0) {
                                return AppValidationUtils.isNewPasswordValid(
                                    state.oldPassword ?? '', p0 ?? '');
                              },
                              onChange: (p0) {
                                context.read<ChangePasswordBloc>().add(
                                    NewPasswordChangeEvent(newPassword: p0));
                              },
                            ),
                            CommonFormField(
                              title: tr('repeat_new_password'),
                              hint: tr('password'),
                              obscured: !state.showRepeatPassword,
                              icon: GestureDetector(
                                  onTap: () {
                                    context
                                        .read<ChangePasswordBloc>()
                                        .add(ToggleShowConfirmPasswordEvent());
                                  },
                                  child: Icon(state.showRepeatPassword == true
                                      ? Icons.visibility_off_sharp
                                      : Icons.visibility_sharp)),
                              validate: (p0) {
                                return AppValidationUtils
                                    .isConfirmPasswordValid(
                                        state.newPassword ?? '', p0 ?? '');
                              },
                              onChange: (p0) {
                                context.read<ChangePasswordBloc>().add(
                                    ConfirmNewPasswordChangeEvent(
                                        confirmPassword: p0));
                              },
                            ),
                            SizedBox(
                              height: 40.h,
                            ),
                            CommonButtonSmall(
                              title: tr('modify_and_save'),
                              onTap: () {
                                if (_key.currentState?.validate() == true) {
                                  context
                                      .read<ChangePasswordBloc>()
                                      .add(SendPasswordFormEvent());
                                } else {}
                              },
                            ),
                            SizedBox(
                              height: 40.h,
                            ),
                          ],
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
              ),
            ),
          );
        },
      ),
    );
  }
}
