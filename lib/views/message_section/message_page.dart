import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:omnyqr/commons/constants/omny_typography.dart';
import 'package:omnyqr/commons/dialog/send_message_dialog.dart';
import 'package:omnyqr/commons/utils/validation_utils.dart';
import 'package:omnyqr/commons/widgets/common_app_bar.dart';
import 'package:omnyqr/commons/widgets/common_app_small.dart';
import 'package:omnyqr/commons/widgets/common_form_field.dart';
import 'package:omnyqr/repositories/message/message_repository.dart';
import 'package:omnyqr/views/message_section/bloc/send_message_bloc.dart';

class SendMessagePage extends StatelessWidget {
  const SendMessagePage({super.key});
  static final GlobalKey<FormState> _key2 = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    String? params = ModalRoute.of(context)!.settings.arguments as String?;

    return BlocProvider(
      create: (context) => SendMessageBloc(context.read<MessageRepository>())..add(SendMessageInitEvemt(id: params)),
      child: BlocConsumer<SendMessageBloc, SendMessageState>(
        listener: (context, state) {
                    SendMessageDialog.callDialog(state.status, context);
        },
        builder: (context, state) {
          return Scaffold(
            appBar: const CommonAppBar(),
            body: ScrollConfiguration(
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
                          tr('message'),
                          style: AppTypografy.commonBlack16
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        CommonFormField(
                          maxLine: 10,
                          hint: tr('write_here'),
                          validate: (p0) {
                            return AppValidationUtils.isNotEmpty(p0 ?? '');
                          },
                          onChange: (p0) {
                            context
                                .read<SendMessageBloc>()
                                .add(MessageChangeEvent(value: p0));
                          },
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: CommonButtonSmall(
                            givenWidth: 100.w,
                            title: tr('send'),
                            onTap: () {
                              if (_key2.currentState?.validate() == true) {
                                context
                                    .read<SendMessageBloc>()
                                    .add(SendFormEvent());
                              } else {}
                            },
                          ),
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
