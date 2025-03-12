import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:omnyqr/commons/dialog/personal_info_dialog.dart';
import 'package:omnyqr/commons/utils/validation_utils.dart';
import 'package:omnyqr/commons/widgets/loader/loading_view.dart';
import 'package:omnyqr/repositories/user/user_repository.dart';
import 'package:omnyqr/views/main_container/bloc/container_bloc.dart';
import 'package:omnyqr/views/personal_area/subviews/personal_information/bloc/personal_information_bloc.dart';
import '../../../../commons/constants/omny_images.dart';
import '../../../../commons/widgets/common_app_bar.dart';
import '../../../../commons/widgets/common_app_small.dart';
import '../../../../commons/widgets/common_form_field.dart';
import '../../../../commons/widgets/common_page_header.dart';

class PersonalInformationPage extends StatelessWidget {
  static final GlobalKey<FormState> _key = GlobalKey<FormState>();
  const PersonalInformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => PersonalInformationBloc(
            context.read<ContainerBloc>(), context.read<UserRepository>())
          ..add(InitEvent()),
        child: BlocConsumer<PersonalInformationBloc, PersonalInformationState>(
          listener: (context, state) {
            PersonalInfoDialog.callDialog(state.status, context);
          },
          builder: (context, state) {
            return state.name != null &&
                    state.surname != null &&
                    state.email != null
                ? Form(
                    key: _key,
                    child: Scaffold(
                      appBar: const CommonAppBar(),
                      body: Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 30.w, right: 30.w),
                            child: ScrollConfiguration(
                              behavior: const ScrollBehavior()
                                  .copyWith(overscroll: false),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    CommonHeader(
                                      icon: AppImages.account,
                                      title: tr('personal_information')
                                          .toUpperCase(),
                                    ),
                                    SizedBox(
                                      height: 30.h,
                                    ),
                                    CommonFormField(
                                      title: tr('name'),
                                      hint: state.nameHint,
                                      text: state.name,
                                      validate: (p0) {
                                        return AppValidationUtils.isNameValid(
                                            p0 ?? '');
                                      },
                                      onChange: (p0) {
                                        context
                                            .read<PersonalInformationBloc>()
                                            .add(NameChangeEvemt(value: p0));
                                      },
                                    ),
                                    CommonFormField(
                                      title: tr('surname'),
                                      hint: tr('surname'),
                                      text: state.surname ?? '',
                                      validate: (p0) {
                                        return AppValidationUtils
                                            .isSurnameValid(p0 ?? '');
                                      },
                                      onChange: (p0) {
                                        context
                                            .read<PersonalInformationBloc>()
                                            .add(SurnameChangeEvent(value: p0));
                                      },
                                    ),
                                    CommonFormField(
                                      hint: tr('email'),
                                      title: tr('email'),
                                      text: state.email ?? '',
                                      validate: (p0) {
                                        return AppValidationUtils.isEmailValid(
                                            p0 ?? '');
                                      },
                                      onChange: (p0) {
                                        context
                                            .read<PersonalInformationBloc>()
                                            .add(EmailChangeEvent(value: p0));
                                      },
                                    ),
                                    SizedBox(
                                      height: 40.h,
                                    ),
                                    CommonButtonSmall(
                                      title: tr('modify_and_save'),
                                      onTap: () {
                                        if (_key.currentState?.validate() ==
                                            true) {
                                          context
                                              .read<PersonalInformationBloc>()
                                              .add(OnSendEvent());
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
                          ),
                          Visibility(
                            visible: state.status == EditStatus.loading,
                            child: const LoadingView(),
                          )
                        ],
                      ),
                    ),
                  )
                : Container();
          },
        ));
  }
}
