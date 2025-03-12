// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:omnyqr/commons/constants/omny_account_config.dart';
import 'package:omnyqr/commons/constants/omny_account_type.dart';
import 'package:omnyqr/commons/constants/omny_dotted_container.dart';
import 'package:omnyqr/commons/utils/validation_utils.dart';
import 'package:omnyqr/commons/widgets/common_app_dialog.dart';
import 'package:omnyqr/commons/widgets/common_app_small.dart';
import 'package:omnyqr/commons/widgets/common_create_pages_body.dart';
import 'package:omnyqr/commons/widgets/common_google_search.dart';
import 'package:omnyqr/models/associations.dart';
import 'package:omnyqr/models/user.dart';
import 'package:omnyqr/repositories/preferences/preferences_repo.dart';
import 'package:omnyqr/repositories/utilities/utility_repo.dart';
import 'package:omnyqr/views/create_edit_qr/bloc/create_edit_qr_bloc.dart';
import 'package:omnyqr/views/main_container/bloc/container_bloc.dart';
import '../../commons/constants/omny_colors.dart';
import '../../commons/constants/omny_images.dart';
import '../../commons/constants/omny_qr_type.dart';
import '../../commons/constants/omny_routes.dart';
import '../../commons/constants/omny_typography.dart';
import '../../commons/dialog/creation_dialog.dart';
import '../../commons/widgets/common_form_field.dart';
import '../../commons/widgets/common_page_header.dart';
import '../../commons/widgets/loader/loading_view.dart';
import '../../models/association_wrapper.dart';

class CreateEditQrPage extends StatefulWidget {
  const CreateEditQrPage({super.key});
  static final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  State<CreateEditQrPage> createState() => _CreateEditQrPageState();
}

class _CreateEditQrPageState extends State<CreateEditQrPage> {
  static final TextEditingController aController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AssociationWrapper? params =
        ModalRoute.of(context)!.settings.arguments as AssociationWrapper?;
    AccountType? accountType =
        context.select((ContainerBloc bloc) => bloc.state.accountType);

    return BlocProvider(
      create: (context) => CreateEditQrBloc(
          context.read<PreferencesRepo>(), context.read<UtilityRepository>())
        ..add(
          InitEvent(
            association: params?.association,
            index: params?.index,
            isEdit: params?.isEdit,
          ),
        ),
      child: BlocConsumer<CreateEditQrBloc, CreateEditQrState>(
        listener: (context, state) {
          CreationDialog.callDialog(state.status, context);
        },
        builder: (context, state) {
          aController.text = state.address ?? '';
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              CommonCreatePageBody(
                child: Form(
                  key: CreateEditQrPage._key,
                  child: Column(children: [
                    SizedBox(
                      height: 20.h,
                    ),
                    CommonHeader(
                      color: state.headerClr,
                      icon: AppImages.tab2,
                      title: state.title?.toUpperCase() ?? '',
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Text(
                      tr('add_utilities').toUpperCase(),
                      style: AppTypografy.common16.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.commonBlack),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),

                    // REGISTRY
                    Visibility(
                      visible: state.showRegistry ?? false,
                      child: CommonFormField(
                        hint: tr('registry'),
                        title: tr('registry'),
                        text: state.registry,
                        validate: (p0) {
                          return AppValidationUtils.isRegistryValid(p0 ?? '');
                        },
                        onChange: (p0) {
                          context
                              .read<CreateEditQrBloc>()
                              .add(RegistryChangeEvent(value: p0));
                        },
                      ),
                    ),
                    // INTERCOM NAME
                    Visibility(
                      visible: state.showName ?? false,
                      child: CommonFormField(
                        hint: state.nameHint,
                        title: state.name,
                        text: state.intercomName,
                        onChange: (p0) {
                          context
                              .read<CreateEditQrBloc>()
                              .add(IntercomNameChangeEvent(value: p0));
                        },
                        validate: (p0) {
                          return AppValidationUtils.isIntercomValid(p0 ?? '');
                        },
                      ),
                    ),
                    //  START DATE

                    Visibility(
                      visible: state.showDates,
                      child: CommonFormField(
                        title: tr('start_date'),
                        hint: state.startDate ?? tr('date_place_holder'),
                        readOnly: true,
                        useController: true,
                        text: state.startDate,
                        validate: (p0) {
                          return AppValidationUtils.isDetailValid(p0 ?? '');
                        },
                        icon: InkWell(
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: const ColorScheme.light(
                                        primary: AppColors.mainBlue,
                                        onPrimary: Colors.white,
                                        onSurface: Colors.black,
                                      ),
                                      textButtonTheme: TextButtonThemeData(
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.black45,
                                        ),
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                                initialDate: DateTime.now(), //get today's date
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2101));
                            if (pickedDate != null) {
                              // use_build_context_synchronously
                              var time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                                builder:
                                    (BuildContext? context, Widget? child) {
                                  return MediaQuery(
                                    data: MediaQuery.of(context!)
                                        .copyWith(alwaysUse24HourFormat: false),
                                    child: Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: const ColorScheme.light(
                                          primary: AppColors.mainBlue,
                                          onPrimary: Colors.white,
                                          onSurface: Colors.black,
                                        ),
                                        textButtonTheme: TextButtonThemeData(
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.black45,
                                          ),
                                        ),
                                      ),
                                      child: child!,
                                    ),
                                  );
                                },
                              );
                              context.read<CreateEditQrBloc>().add(
                                  StartDateChangeEvent(
                                      value: pickedDate, time: time));
                            }
                          },
                          child: const Icon(
                            Icons.calendar_today_rounded,
                            color: AppColors.mainBlue,
                          ),
                        ),
                      ),
                    ),
                    // END DATE
                    Visibility(
                      visible: state.showDates && state.startDate != null,
                      child: CommonFormField(
                        title: tr('end_date'),
                        hint: state.endDate ?? tr('date_place_holder'),
                        readOnly: true,
                        useController: true,
                        text: state.endDate,
                        onTap: () {},
                        validate: (p0) {
                          return AppValidationUtils.isEndDetailValid(
                              state.startDate ?? '', p0 ?? '');
                        },
                        icon: InkWell(
                          onTap: () async {
                            // Stringa rappresentante la data e l'ora
                            String dateStartString = state.startDate ?? '';

                            // Dividi la stringa per ottenere data e ora separatamente
                            List<String> parts = dateStartString.split(" - ");
                            String datePart = parts[0]; // Parte della data
                            String timePart = parts[1]; // Parte dell'ora

                            // Dividi la parte della data
                            List<String> dateParts = datePart.split("/");
                            int day = int.parse(dateParts[0]);
                            int month = int.parse(dateParts[1]);
                            int year = int.parse(dateParts[2]);

                            // Dividi la parte dell'ora
                            List<String> timeParts = timePart.split(":");
                            int hour = int.parse(timeParts[0]);
                            int minute = int.parse(timeParts[1]);

                            // Creazione dell'oggetto DateTime
                            DateTime startDateTime =
                                DateTime(year, month, day, hour, minute);

                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: const ColorScheme.light(
                                        primary: AppColors.mainBlue,
                                        onPrimary: Colors.white,
                                        onSurface: Colors.black,
                                      ),
                                      textButtonTheme: TextButtonThemeData(
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.black45,
                                        ),
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                                initialDate: startDateTime, //get today's date
                                firstDate:
                                    startDateTime, //DateTime.now() - not to allow to choose before today.
                                lastDate: DateTime(2200));
                            if (pickedDate != null) {
                              //  use_build_context_synchronously
                              var time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                                builder:
                                    (BuildContext? context, Widget? child) {
                                  return MediaQuery(
                                    data: MediaQuery.of(context!)
                                        .copyWith(alwaysUse24HourFormat: false),
                                    child: Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: const ColorScheme.light(
                                          primary: AppColors.mainBlue,
                                          onPrimary: Colors.white,
                                          onSurface: Colors.black,
                                        ),
                                        textButtonTheme: TextButtonThemeData(
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.black45,
                                          ),
                                        ),
                                      ),
                                      child: child!,
                                    ),
                                  );
                                },
                              );
                              context.read<CreateEditQrBloc>().add(
                                  EndDateChangeEvent(
                                      value: pickedDate, time: time));
                            }
                          },
                          child: const Icon(
                            Icons.calendar_today_rounded,
                            color: AppColors.mainBlue,
                          ),
                        ),
                      ),
                    ),
                    // INDIRIZZO

                    Visibility(
                      visible: state.showAddress ?? false,
                      child: Column(
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

                                  context.read<CreateEditQrBloc>().add(
                                      AddressChangeEvent(
                                          value: ok.description,
                                          lat: ok.lat,
                                          lng: ok.lng));

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
                    ),

                    Visibility(
                      visible: (getQrType(
                                      params?.association?.associationType ??
                                          '') ==
                                  QrType.mine ||
                              getQrType(params?.association?.associationType ??
                                      '') ==
                                  QrType.business) &&
                          params?.isEdit != true,
                      child: Row(
                        children: [
                          Text(
                            (state.privatePublicToggle ?? true)
                                ? tr('private_toggle')
                                : tr('public_toggle'),
                            style: AppTypografy.commonBlack16W700,
                          ),
                          const Spacer(),
                          Switch(
                            value: state.privatePublicToggle ?? true,
                            activeColor: AppColors.mainBlue,
                            activeTrackColor: AppColors.commonGreen,
                            inactiveThumbColor: AppColors.mainBlue,
                            onChanged: (value) {
                              context.read<CreateEditQrBloc>().add(
                                    PublicPrivateEvent(value),
                                  );
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 25.h,
                    ),
                    // REFERENTS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Visibility(
                          visible: true,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 5.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  state.residentName ?? '',
                                  style: AppTypografy.common13,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: state.showResident ?? false,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: CommonButtonSmall(
                              givenHeight: 30.h,
                              givenWidth:
                                  MediaQuery.of(context).size.width * 0.4,
                              title: tr('add'),
                              onTap: () async {
                                if ((state.referents?.length ?? 0) >=
                                    getAccountReferentsLimit(
                                        accountType ?? AccountType.free)) {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return CommonDialog(
                                          isBtn1Enabled: true,
                                          btn1Label: tr('ok'),
                                          btn2Label: tr('go_to_shop'),
                                          title: tr('referents_limit'),
                                          onTap2: () {
                                            Navigator.of(context).pushNamed(
                                              Routes.inAppPurchase,
                                            );
                                          },
                                          onTap1: () {
                                            Navigator.pop(context);
                                          },
                                        );
                                      });
                                } else {
                                  CreateEditQrBloc bloc =
                                      context.read<CreateEditQrBloc>();
                                  User? result =
                                      await Navigator.of(context).pushNamed(
                                    Routes.userSearch,
                                  ) as User?;
                                  if (result != null) {
                                    bloc.add(
                                        ReferentsChangeEvemt(value: result));
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Visibility(
                        visible: state.showResident ?? false,
                        child: SizedBox(
                          height: 20.h,
                        )),
                    // RESIDENTI
                    state.referents?.isEmpty == true || state.referents == null
                        ? Visibility(
                            visible: state.showResident ?? false,
                            child: CommonFormField(
                              readOnly: true,
                              hint: state.residentHint,

                              //remove this commet to make residents required
                              /*  validate: (p0) {
                                return AppValidationUtils.isNameValid(p0 ?? '');
                              },

                              */
                              bottomPadding: 5.h,
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.only(bottom: 5.h, top: 5.h),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.referents?.length ?? 0,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  context
                                      .read<CreateEditQrBloc>()
                                      .add(RemoveReferentEvent(id: index));
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 10.h),
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppColors.containerSmall),
                                          color: AppColors.commonWhite,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(3.r)),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 20.w,
                                              top: 12.h,
                                              bottom: 12.h,
                                              right: 20.w),
                                          child: Row(
                                            children: [
                                              Text(
                                                  "${state.referents?[index].name ?? ''} ${state.referents?[index].surname ?? ''}"),
                                              const Spacer(),
                                              const Icon(Icons.cancel)
                                            ],
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                          visible:
                                              state.referents?[index].status ==
                                                  'pending',
                                          child: Text(
                                            tr('verifing'),
                                            style: AppTypografy.common14
                                                .copyWith(
                                                    color: AppColors.mainBlue),
                                          )),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                    Visibility(
                      visible: state.showResident ?? false,
                      child: SizedBox(
                        height: 20.h,
                      ),
                    ),

                    //UTENTE SEGRETARIO (CHIAMATE DEVIATE)
                    Visibility(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Visibility(
                            visible: true,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 5.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    tr("user_deviation") ?? '',
                                    style: AppTypografy.common13,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: state.showResident ?? false,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: CommonButtonSmall(
                                givenHeight: 30.h,
                                givenWidth:
                                    MediaQuery.of(context).size.width * 0.4,
                                title: tr('add'),
                                onTap: () async {
                                  CreateEditQrBloc bloc =
                                      context.read<CreateEditQrBloc>();
                                  User? result =
                                      await Navigator.of(context).pushNamed(
                                    Routes.userSearch,
                                  ) as User?;
                                  if (result != null) {
                                    bloc.add(
                                        SecretaryChangeEvent(value: result));
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                        visible: state.showResident ?? false,
                        child: SizedBox(
                          height: 20.h,
                        )),
                    state.secretary?.id == null
                        ? Visibility(
                            visible: state.showResident ?? false,
                            child: CommonFormField(
                              readOnly: true,
                              hint: tr("no_user_deviation"),

                              //remove this commet to make residents required
                              /*  validate: (p0) {
                                return AppValidationUtils.isNameValid(p0 ?? '');
                              },

                              */
                              bottomPadding: 5.h,
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              context
                                  .read<CreateEditQrBloc>()
                                  .add(SecretaryDeleteEvent());
                            },
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 10.h),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppColors.containerSmall),
                                      color: AppColors.commonWhite,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(3.r)),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 20.w,
                                          top: 12.h,
                                          bottom: 12.h,
                                          right: 20.w),
                                      child: Row(
                                        children: [
                                          Text(
                                              "${state.secretary?.name ?? ''} ${state.secretary?.surname ?? ''}"),
                                          const Spacer(),
                                          const Icon(Icons.cancel)
                                        ],
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                      visible:
                                          state.secretary?.status == 'pending',
                                      child: Text(
                                        tr('verifing'),
                                        style: AppTypografy.common14.copyWith(
                                            color: AppColors.mainBlue),
                                      )),
                                ],
                              ),
                            ),
                          ),

                    Visibility(
                        visible: state.showResident ?? false,
                        child: SizedBox(
                          height: 20.h,
                        )),

                    Visibility(
                      visible: state.showCheckBox ?? false,
                      child: Padding(
                        padding: EdgeInsets.only(top: 20.h, bottom: 20.h),
                        child: Divider(
                          thickness: 1.5.h,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: state.showCheckBox ?? false,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Transform.scale(
                            scale: 1.5,
                            child: Checkbox(
                              activeColor: AppColors.formFieldColor,
                              checkColor: AppColors.mainBlue,
                              // The parameter 'IS CHECKED' is used to identify whether it's a true association or not
                              value: state.isChecked,
                              onChanged: (bool? value) {
                                context
                                    .read<CreateEditQrBloc>()
                                    .add(ToggleShowCheckBoxEvent());
                              },
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Text(
                              state.checkBoxLabel ?? '',
                              style: AppTypografy.common16.copyWith(
                                  fontWeight: FontWeight.w300,
                                  color: AppColors.commonGrey),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: state.showGroup,
                      child: SizedBox(
                        height: 15.h,
                      ),
                    ),

                    // ASSOCIATION
                    state.associationName?.isEmpty == true ||
                            state.associationName == null
                        ? Visibility(
                            visible: state.showGroup,
                            child: CommonFormField(
                              hint: state.groupHint,
                              title: state.groupName,
                              bottomPadding: 5.h,
                              readOnly: true,
                              text: state.associationName,
                              validate: (p0) {
                                return AppValidationUtils.isNameValid(p0 ?? '');
                              },
                            ),
                          )
                        : Visibility(
                            visible: state.showGroup,
                            child: GestureDetector(
                              onTap: () {
                                context.read<CreateEditQrBloc>().add(
                                    const AssociationChangeEvent(value: null));
                              },
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 10.h),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppColors.containerSmall),
                                    color: AppColors.commonWhite,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3.r)),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 20.w,
                                        top: 12.h,
                                        bottom: 12.h,
                                        right: 20.w),
                                    child: Row(
                                      children: [
                                        Text(state.associationName ?? ''),
                                        const Spacer(),
                                        const Icon(Icons.cancel)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                    Visibility(
                      visible: state.showGroup,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: CommonButtonSmall(
                          givenHeight: 40.h,
                          givenWidth: MediaQuery.of(context).size.width * 0.7,
                          title: state.groupButtonLabel,
                          onTap: () async {
                            CreateEditQrBloc bloc =
                                context.read<CreateEditQrBloc>();
                            Association? result = await Navigator.of(context)
                                .pushNamed(Routes.association,
                                    arguments: params?.association
                                        ?.associationType) as Association?;
                            if (result != null) {
                              bloc.add(AssociationChangeEvent(
                                  value: result.name,
                                  associationId: result.id));
                            }
                          },
                        ),
                      ),
                    ),
                    Visibility(
                        visible: state.showSwitch,
                        child: Row(
                          children: [
                            Text(
                              tr('add_url_file'),
                              style: AppTypografy.commonBlack16
                                  .copyWith(fontWeight: FontWeight.w700),
                            ),
                            const Spacer(),
                            Switch(
                              value: state.toggleSwitch,
                              activeColor: AppColors.mainBlue,
                              activeTrackColor: AppColors.commonGreen,
                              inactiveThumbColor: AppColors.mainBlue,
                              onChanged: (value) {
                                context
                                    .read<CreateEditQrBloc>()
                                    .add(ToggleShowSwitchEvent());
                              },
                            ),
                          ],
                        )),
                    Visibility(
                        visible: state.showSwitch,
                        child: SizedBox(
                          height: 35.h,
                        )),
                    Visibility(
                      visible: state.showLink,
                      child: CommonFormField(
                        hint: tr('link'),
                        title: tr('link'),
                        text: state.url,
                        validate: (p0) {
                          return AppValidationUtils.isUrlValid(p0 ?? '');
                        },
                        onChange: (p0) {
                          context
                              .read<CreateEditQrBloc>()
                              .add(UrlChangeEvent(value: p0));
                        },
                        bottomPadding: 5.h,
                      ),
                    ),
                    Visibility(
                        visible: state.showFile,
                        child: DottedContainer(
                          onTap: () {
                            context
                                .read<CreateEditQrBloc>()
                                .add(PickDocument());
                          },
                        )),
                    SizedBox(
                      height: 50.h,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                  ]),
                ),
              ),
              Material(
                color: Colors.white,
                child: Padding(
                  padding:
                      EdgeInsets.only(bottom: 20.h, left: 30.w, right: 30.w),
                  child: CommonButtonSmall(
                    title: tr('save_and_add'),
                    onTap: () {
                      if (CreateEditQrPage._key.currentState?.validate() ==
                          true) {
                        context.read<CreateEditQrBloc>().add(SendFormEvent());
                      } else {}
                    },
                  ),
                ),
              ),
              Visibility(
                //
                visible: state.isLoading ?? true,
                child: const Center(
                  child: LoadingView(),
                ),
              )
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
