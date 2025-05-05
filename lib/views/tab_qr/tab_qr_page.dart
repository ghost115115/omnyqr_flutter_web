import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:omnyqr/commons/constants/omny_images.dart';
import 'package:omnyqr/commons/constants/omny_routes.dart';
import 'package:omnyqr/commons/dialog/qr_scan_dialog.dart';
import 'package:omnyqr/commons/utils/validation_utils.dart';
import 'package:omnyqr/commons/widgets/common_app_button.dart';
import 'package:omnyqr/commons/widgets/common_app_button_withicon.dart';
import 'package:omnyqr/commons/widgets/common_page_header.dart';
import 'package:omnyqr/commons/widgets/common_rounded_container_big.dart';
import 'package:omnyqr/commons/widgets/loader/loading_view.dart';
import 'package:omnyqr/extensions/string_extension.dart';
import 'package:omnyqr/repositories/message/message_repository.dart';
import 'package:omnyqr/repositories/utilities/utility_repo.dart';
import 'package:omnyqr/views/tab_qr/bloc/qr_tab_bloc.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../commons/constants/omny_typography.dart';
import '../../commons/widgets/common_form_field.dart';

class QrPage extends StatelessWidget {
  static final GlobalKey<FormState> _key = GlobalKey<FormState>();
  const QrPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QrTabBloc(
          context.read<UtilityRepository>(), context.read<MessageRepository>())
        ..add(InitEvent()),
      child: BlocConsumer<QrTabBloc, QrTabState>(
        listener: (context, state) {
          QrScanDialog.callDialog(state.status, context);

          if (state.status == QrScanStatus.success) {
            if (state.association?.isRealAssociation == true) {
              Navigator.of(context).pushNamed(Routes.associationSection,
                  arguments: state.association);
              context.read<QrTabBloc>().add(ResetDialogEvent());
            } else {
              if (state.association?.utilities?[0].type == "price") {
                Future.delayed(Duration.zero, () async {
                  await launchUrlString(verifyAndCorrectUrl(
                      state.association?.utilities?[0].utilityLink ?? ''));
                });
                context.read<QrTabBloc>().add(ResetDialogEvent());
              } else {
                Navigator.of(context).pushNamed(Routes.utilitySection,
                    arguments: state.association?.utilities?[0]);
                context.read<QrTabBloc>().add(ResetDialogEvent());
              }
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 30.w, right: 30.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20.h,
                      ),
                      CommonHeader(
                        icon: AppImages.tab1,
                        title: tr('qr_header'),
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      RoundBorderContainerBig(
                          child: Center(
                        child: ScrollConfiguration(
                          behavior: const ScrollBehavior()
                              .copyWith(overscroll: false),
                          child: SingleChildScrollView(
                              child: Column(

                                      mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                SizedBox(
                                  height: 10.h,
                                ),
                                InkWell(
                                  onTap: () async {
                                    QrTabBloc bloc = context.read<QrTabBloc>();
                                    var result =
                                        await Navigator.of(context).pushNamed(
                                      Routes.qrScannerPage,
                                    );

                                    if (result != null &&
                                        state.isLoading != true) {
                                      bloc.add(GetAssociation(
                                          isFromScan: true,
                                          id: result.toString()));
                                    }
                                  },
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        AppImages.scanImage,
                                        height: 100.h,
                                        width: 100.h,
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      CommonInconButton(
                                        radius: 0.0,
                                        title: tr('scan'),

                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 30.h,
                                ),
                                Center(
                                  child: Text(
                                    tr('other'),
                                    style: AppTypografy.common20,
                                  ),
                                ),
                                SizedBox(
                                  height: 30.h,
                                ),
                                Form(
                                  key: _key,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 20.w, right: 20.w, bottom: 20.h),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                        color: Colors.transparent,
                                        width: 3,
                                      )),
                                      child: CommonFormField(
                                        isScan: true,
                                        bottomPadding: 0,
                                        maxLine: 1,
                                        hint: tr('insert_id'),
                                        capitalization: true,
                                        txtAlign: TextAlign.center,
                                        onChange: (p0) {
                                          context.read<QrTabBloc>().add(
                                              AssociationChangeEvent(
                                                  id: p0.toCapitalized()));
                                        },
                                        validate: (p0) {
                                          return AppValidationUtils
                                              .isAssociationIdValid(p0 ?? '');
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                CommonButton(
                                  givenWidth: 200.w,
                                  txtSize: 16,
                                  radius: 0.0,
                                  title: tr('send'),
                                  onTap: () {
                                    if (_key.currentState?.validate() == true) {
                                      context.read<QrTabBloc>().add(
                                          GetAssociation(
                                              isFromScan: false,
                                              id: state.associationId));
                                    } else {}
                                  },
                                ),
                                SizedBox(
                                  height: 20.h,
                                )
                              ])),
                        ),
                      )),
                      SizedBox(
                        height: 25.h,
                      ),
                    ],
                  ),
                ),
                Visibility(
                    visible: state.isLoading == true,
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

String verifyAndCorrectUrl(String url) {
  RegExp regex = RegExp(r'^https?://');

  if (url.startsWith("/files/")) {
    url = "https://api.omnyqr.com/omny-backend$url";
  } else if (!regex.hasMatch(url)) {
    url = 'https://$url';
  }

  return url;
}
