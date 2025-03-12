import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:omnyqr/bloc/authentication_bloc.dart';
import 'package:omnyqr/commons/constants/omny_colors.dart';
import 'package:omnyqr/commons/constants/omny_images.dart';
import 'package:omnyqr/commons/constants/omny_typography.dart';
import 'package:omnyqr/commons/dialog/login_dialog.dart';
import 'package:omnyqr/commons/utils/validation_utils.dart';
import 'package:omnyqr/commons/widgets/common_app_button.dart';
import 'package:omnyqr/commons/widgets/common_form_field.dart';
import 'package:omnyqr/commons/widgets/loader/loading_view.dart';
import 'package:omnyqr/repositories/auth/auth_repository.dart';
import 'package:omnyqr/repositories/device/device_repository.dart';
import 'package:omnyqr/repositories/preferences/preferences_repo.dart';
import 'package:omnyqr/views/user_login/bloc/login_bloc.dart';
import '../../commons/constants/omny_routes.dart';

class LoginPage extends StatelessWidget {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => LoginBloc(
              context.read<AuthenticationBloc>(),
              context.read<AuthRepository>(),
              context.read<DeviceRepository>(),
              context.read<PreferencesRepo>(),
            )..add(LoginInitEvent()),
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            LoginDialog.callDialog(state.status, context);
          },
          builder: (context, state) {
            return Scaffold(
                body: Stack(
              children: [
                ScrollConfiguration(
                  behavior: const ScrollBehavior().copyWith(overscroll: false),
                  child: Form(
                    key: _formkey,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.only(left: 30.w, right: 30.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                  top: 110.h,
                                  left: 30.w,
                                  right: 30.w,
                                  bottom: 20.h),
                              width: double.infinity,
                              child: SvgPicture.asset(
                                AppImages.logo,
                                height: 130.h,
                              ),
                            ),
                            SizedBox(
                              height: 30.h,
                            ),
                            CommonFormField(
                              hint: tr('email'),
                              title: tr('email'),
                              icon: const Icon(Icons.email_outlined),
                              onChange: (value) {
                                context
                                    .read<LoginBloc>()
                                    .add(EmailChangeEvent(value: value));
                              },
                              validate: (value) {
                                return AppValidationUtils.isEmailValid(
                                    value ?? '');
                              },
                            ),
                            CommonFormField(
                                title: tr('password'),
                                hint: tr('password'),
                                obscured: !state.showPassword,
                                onChange: (value) {
                                  context
                                      .read<LoginBloc>()
                                      .add(PasswordChangeEvent(value: value));
                                },
                                validate: (value) {
                                  return AppValidationUtils.isNotEmpty(
                                      value ?? '');
                                },
                                icon: GestureDetector(
                                    onTap: () {
                                      context
                                          .read<LoginBloc>()
                                          .add(ToggleShowPasswordEvent());
                                    },
                                    child: Icon(state.showPassword == true
                                        ? Icons.visibility_off_sharp
                                        : Icons.visibility_sharp))),
                            SizedBox(
                              height: 20.h,
                            ),
                            Center(
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(Routes.passwordReset);
                                },
                                child: Text(
                                  tr('forget_password'),
                                  style: AppTypografy.forgetPassword,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 40.h,
                            ),
                            CommonButton(
                              borderClr: AppColors.mainBlue,
                              backgroundColor: AppColors.commonWhite,
                              title: tr('access'),
                              txtclr: AppColors.mainBlue,
                              onTap: () {
                                if (_formkey.currentState?.validate() == true) {
                                  context
                                      .read<LoginBloc>()
                                      .add(SendLoginEvent());
                                } else {}
                              },
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Center(
                              child: Text(
                                tr('other'),
                                style: AppTypografy.common13,
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            CommonButton(
                              title: tr('register'),
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(Routes.register);
                              },
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
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
            ));
          },
        ));
  }
}
