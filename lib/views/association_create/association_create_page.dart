import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:omnyqr/commons/constants/omny_colors.dart';
import 'package:omnyqr/commons/constants/omny_images.dart';
import 'package:omnyqr/commons/constants/omny_typography.dart';
import 'package:omnyqr/commons/dialog/association_create_dialog.dart';
import 'package:omnyqr/commons/utils/validation_utils.dart';
import 'package:omnyqr/commons/widgets/common_form_field.dart';
import 'package:omnyqr/commons/widgets/common_google_search.dart';
import 'package:omnyqr/commons/widgets/common_page_header.dart';
import 'package:omnyqr/repositories/utilities/utility_repo.dart';
import 'package:omnyqr/views/association_create/bloc/association_create_bloc.dart';
import '../../commons/widgets/common_app_small.dart';
import '../../commons/widgets/common_create_pages_body.dart';
import '../../commons/widgets/loader/loading_view.dart';

class AssociationCreatePage extends StatefulWidget {
  const AssociationCreatePage({super.key});
  static final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  State<AssociationCreatePage> createState() => _AssociationCreatePageState();
}

class _AssociationCreatePageState extends State<AssociationCreatePage> {
  static final TextEditingController aController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    String? params = ModalRoute.of(context)!.settings.arguments as String?;
    return BlocProvider(
      create: (context) =>
          AssociationCreateBloc(context.read<UtilityRepository>())
            ..add(AssociationCreateInitEvent(value: params)),
      child: BlocConsumer<AssociationCreateBloc, AssociationCreateState>(
        listener: (context, state) async {
          AssociationCreateDialog.callDialog(state.status, context);
        },
        builder: (context, state) {
          return Stack(
            children: [
              CommonCreatePageBody(
                child: Form(
                  key: AssociationCreatePage._key,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20.h,
                      ),
                      CommonHeader(
                        icon: AppImages.tab2,
                        title: state.title ?? '',
                        color: AppColors.commonBlack,
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      CommonFormField(
                        title: state.labelTitle,
                        validate: (p0) {
                          return AppValidationUtils.isNameValid(p0 ?? '');
                        },
                        onChange: (p0) {
                          context
                              .read<AssociationCreateBloc>()
                              .add(NameChangeEvent(value: p0));
                        },
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tr('address_info'),
                            style: AppTypografy.common13,
                          ),
                          SizedBox(height: 5.h),
                          TextFormField(
                              onTap: () async {
                                FocusManager.instance.primaryFocus?.unfocus();
                                var result = await showModalBottomSheet(
                                    isScrollControlled: true,
                                    context: context,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15.r),
                                            topRight: Radius.circular(15.r))),
                                    backgroundColor: Colors.white,
                                    builder: (context) {
                                      return SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.8,
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                            Text(
                                              tr('insert_address'),
                                              style: AppTypografy.common16,
                                            ),
                                            SizedBox(
                                              height: 5.h,
                                            ),
                                            Text(
                                              tr('insert_address_number'),
                                              style: AppTypografy.common11,
                                            ),
                                            SizedBox(
                                              height: 25.h,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 10.w, right: 10.w),
                                              child: Center(
                                                  child: _searchPlace(context)),
                                            ),
                                          ],
                                        ),
                                      );
                                    });

                                if (result != null) {
                                  Prediction ok = result;

                                  // ignore: use_build_context_synchronously
                                  context.read<AssociationCreateBloc>().add(
                                      AddressChangeEvent(
                                          value: ok.description,
                                          lat: ok.lat,
                                          long: ok.lng));

                                  aController.text = ok.description ?? '';
                                }
                              },
                              controller: aController,
                              validator: (value) {
                                return AppValidationUtils.isNotEmpty(
                                    value ?? '');
                              },
                              textCapitalization: TextCapitalization.none,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              maxLines: 1,
                              readOnly: true,
                              textAlign: TextAlign.start,
                              obscureText: false,
                              cursorColor: AppColors.formBorderColor,
                              decoration: InputDecoration(
                                  fillColor: AppColors.formFieldColor,
                                  filled: true,
                                  focusColor: AppColors.formBorderColor,
                                  errorBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColors.mainBlue)),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3.r),
                                    borderSide: const BorderSide(
                                        color: AppColors.transparent),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3.r),
                                    borderSide: const BorderSide(
                                        color: AppColors.transparent),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3.r),
                                    borderSide: const BorderSide(
                                        color: AppColors.transparent),
                                  ),
                                  hintText: tr('address_info'),
                                  hintStyle: AppTypografy.formHint,
                                  labelStyle: const TextStyle(
                                      color: AppColors.formBorderColor),
                                  suffixIconColor: AppColors.formHintColor)),
                          SizedBox(
                            height: 20.h,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      CommonButtonSmall(
                        title: tr('create'),
                        onTap: () {
                          if (AssociationCreatePage._key.currentState
                                  ?.validate() ==
                              true) {
                            context
                                .read<AssociationCreateBloc>()
                                .add(FormSendEvent());
                          } else {}
                        },
                      )
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
          );
        },
      ),
    );
  }

  Widget _searchPlace(BuildContext context) {
    return const GoogleSearch();
  }

  @override
  void dispose() {
    aController.clear();

    super.dispose();
  }
}
