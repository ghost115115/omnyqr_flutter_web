import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:omnyqr/commons/constants/omny_typography.dart';
import 'package:omnyqr/commons/dialog/password_reset_dialog.dart';
import 'package:omnyqr/commons/utils/validation_utils.dart';
import 'package:omnyqr/commons/widgets/common_app_bar.dart';
import 'package:omnyqr/commons/widgets/common_app_button.dart';
import 'package:omnyqr/commons/widgets/common_form_field.dart';
import 'package:omnyqr/commons/widgets/loader/loading_view.dart';
import 'package:omnyqr/repositories/auth/auth_repository.dart';
import 'package:omnyqr/views/password_reset/bloc/password_reset_bloc.dart';

import '../../commons/constants/omny_images.dart';

class PasswordResetPage extends StatelessWidget {
  const PasswordResetPage({super.key});
  static final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PasswordResetBloc(context.read<AuthRepository>()),
      child: BlocConsumer<PasswordResetBloc, PasswordResetState>(
        listener: (context, state) {
   PasswordReset.callDialog(state.status, context);
        },
        builder: (context, state) {
          return Scaffold(
            appBar: CommonAppBar(
              title: tr('set_password_title'),
            ),
            body: Stack(
              children: [
                Form(
                  key: _key,
                  child: Padding(
                    padding: EdgeInsets.only(left: 30.w, right: 30.w),
                    child: ScrollConfiguration(
                      behavior: const ScrollBehavior().copyWith(overscroll: false),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                  left: 30.w,
                                  right: 30.w,
                                  top: 100.h,
                                  bottom: 100.h),
                              width: double.infinity,
                              child: SvgPicture.asset(
                                AppImages.logo,
                                height: 130.h,
                              ),
                            ),
                            Text(
                              tr('set_email'),
                              maxLines: 2,
                              style: AppTypografy.common20,
                            ),
                            SizedBox(
                              height: 30.h,
                            ),
                            CommonFormField(
                              hint: tr('email'),
                              icon: const Icon(Icons.email_outlined),
                              validate: (p0) {
                                return AppValidationUtils.isEmailValid(p0 ?? '');
                              },
                              onChange: (p0) {
                                context
                                    .read<PasswordResetBloc>()
                                    .add(EmailChangeEvent(value: p0));
                              },
                            ),
                            CommonButton(
                              title: tr('set'),
                              onTap: () {
                                if (_key.currentState?.validate() == true) {
                                  context
                                      .read<PasswordResetBloc>()
                                      .add(SendEmailEvent());
                                } else {}
                              },
                            ),
                            SizedBox(
                              height: 25.h,
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
            ),
          );
        },
      ),
    );
  }
}
