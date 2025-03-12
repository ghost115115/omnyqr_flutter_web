import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:omnyqr/commons/constants/omny_colors.dart';
import 'package:omnyqr/commons/constants/omny_typography.dart';
import 'package:omnyqr/commons/dialog/register_dialog.dart';
import 'package:omnyqr/commons/utils/formatters_utils.dart';
import 'package:omnyqr/commons/utils/validation_utils.dart';
import 'package:omnyqr/commons/widgets/common_app_bar.dart';
import 'package:omnyqr/commons/widgets/common_app_button.dart';
import 'package:omnyqr/commons/widgets/common_form_field.dart';
import 'package:omnyqr/repositories/auth/auth_repository.dart';
import 'package:omnyqr/views/user_registration/bloc/register_bloc.dart';

import '../../commons/widgets/loader/loading_view.dart';

class RegistrationPage extends StatelessWidget {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterBloc(context.read<AuthRepository>())
        ..add(RegisterInitEvent()),
      child: BlocConsumer<RegisterBloc, RegisterState>(
        listener: (context, state) {
          RegisterDialog.callDialog(state.status, context);
        },
        builder: (context, state) {
          return Scaffold(
              appBar: CommonAppBar(
                title: tr('register_title'),
              ),
              body: Stack(
                children: [
                  ScrollConfiguration(
                    behavior:
                        const ScrollBehavior().copyWith(overscroll: false),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 30.h, left: 30.w, right: 30.w),
                          child: Column(
                            children: [
                              CommonFormField(
                                hint: tr('name'),
                                onChange: (value) {
                                  context
                                      .read<RegisterBloc>()
                                      .add(NameChangeEvent(value: value));
                                },
                                validate: (value) {
                                  return AppValidationUtils.isNameValid(
                                      value ?? '');
                                },
                                formatters: [
                                  AppFormatters.onlyLettersAndSpace()
                                ],
                              ),
                              CommonFormField(
                                hint: tr('surname'),
                                onChange: (value) {
                                  context
                                      .read<RegisterBloc>()
                                      .add(SurnameChangeEvent(value: value));
                                },
                                validate: (value) {
                                  return AppValidationUtils.isSurnameValid(
                                      value ?? '');
                                },
                                formatters: [
                                  AppFormatters.onlyLettersAndSpace()
                                ],
                              ),
                              CommonFormField(
                                hint: tr('email'),
                                icon: const Icon(Icons.mail_outline),
                                validate: (value) {
                                  return AppValidationUtils.isEmailValid(
                                      value ?? '');
                                },
                                onChange: (value) {
                                  context
                                      .read<RegisterBloc>()
                                      .add(EmailChangeEvent(value: value));
                                },
                              ),
                              CommonFormField(
                                obscured: !state.showPassword,
                                title: tr('password'),
                                hint: tr('password'),
                                onChange: (p0) {
                                  context
                                      .read<RegisterBloc>()
                                      .add(PasswordChangeEvent(value: p0));
                                },
                                validate: (value) {
                                  return AppValidationUtils.isPasswordValid(
                                      value ?? '');
                                },
                                icon: InkWell(
                                  child: Icon(state.showPassword == true
                                      ? Icons.visibility_off_sharp
                                      : Icons.visibility_sharp),
                                  onTap: () {
                                    context
                                        .read<RegisterBloc>()
                                        .add(ToggleShowPasswordEvent());
                                  },
                                ),
                              ),
                              CommonFormField(
                                obscured: !state.showConfirmPassword,
                                hint: tr('password'),
                                title: tr('confirm_password'),
                                onChange: (p0) {
                                  context.read<RegisterBloc>().add(
                                      ConfirmPasswordChangeEvent(value: p0));
                                },
                                validate: (value) {
                                  return AppValidationUtils
                                      .isConfirmPasswordValid(
                                          value ?? '', state.password ?? '');
                                },
                                icon: InkWell(
                                  child: Icon(state.showConfirmPassword == true
                                      ? Icons.visibility_off_sharp
                                      : Icons.visibility_sharp),
                                  onTap: () {
                                    context
                                        .read<RegisterBloc>()
                                        .add(ToggleShowConfirmPasswordEvent());
                                  },
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(top: 15.h, bottom: 15.h),
                                child: Divider(
                                  thickness: 1.5.h,
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Transform.scale(
                                    scale: 1.5,
                                    child: Checkbox(
                                      activeColor: AppColors.formFieldColor,
                                      checkColor: AppColors.mainBlue,
                                      value: state.showAdminField,
                                      onChanged: (value) {
                                        context
                                            .read<RegisterBloc>()
                                            .add(ToggleShowAdminFieldsEvent());
                                      },
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        child: Text(
                                          tr('registration_hint_first'),
                                          style: AppTypografy.common16.copyWith(
                                              fontWeight: FontWeight.w300,
                                              color: AppColors.commonGrey),
                                          maxLines: 4,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        child: Text(
                                          tr('registration_hint_second'),
                                          style: AppTypografy.common13.copyWith(
                                              fontWeight: FontWeight.w500),
                                          maxLines: 4,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              Visibility(
                                visible: state.showAdminField,
                                child: CommonFormField(
                                  hint: tr('vat'),
                                  onChange: (p0) {
                                    context
                                        .read<RegisterBloc>()
                                        .add(VatChangeEvent(value: p0));
                                  },
                                  validate: (p0) {
                                    return state.showAdminField == true
                                        ? AppValidationUtils.isVatValid(
                                            p0 ?? '')
                                        : null;
                                  },
                                ),
                              ),
                              Visibility(
                                visible: state.showAdminField,
                                child: CommonFormField(
                                  hint: tr('register_registration'),
                                  onChange: (p0) {
                                    context.read<RegisterBloc>().add(
                                        ProfessionaRegisterChangeEvent(
                                            value: p0));
                                  },
                                  validate: (p0) {
                                    return state.showAdminField == true
                                        ? AppValidationUtils.isProfessionValid(
                                            p0 ?? '')
                                        : null;
                                  },
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(top: 20.h),
                                  child: CommonButton(
                                    title: tr('register'),
                                    onTap: () {
                                      if (_formKey.currentState?.validate() ==
                                          true) {
                                        context
                                            .read<RegisterBloc>()
                                            .add(SendRegister());
                                      } else {}
                                    },
                                  )),
                              SizedBox(
                                height: 20.h,
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
              ));
        },
      ),
    );
  }
}
