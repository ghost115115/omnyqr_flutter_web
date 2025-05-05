// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:omnyqr/commons/constants/omny_dotted_container.dart';
import 'package:omnyqr/commons/constants/omny_images.dart';
import 'package:omnyqr/commons/constants/omny_qr_type.dart';
import 'package:omnyqr/commons/constants/omny_routes.dart';
import 'package:omnyqr/commons/constants/omny_typography.dart';
import 'package:omnyqr/commons/dialog/delete_utility_dialog.dart';
import 'package:omnyqr/commons/utils/link_utils.dart';
import 'package:omnyqr/commons/widgets/common_app_dialog.dart';
import 'package:omnyqr/commons/widgets/common_dialog_button.dart';
import 'package:omnyqr/commons/widgets/common_page_header.dart';
import 'package:omnyqr/commons/widgets/loader/loading_view.dart';
import 'package:omnyqr/repositories/utilities/utility_repo.dart';
import 'package:omnyqr/views/create_edit_qr/bloc/create_edit_qr_bloc.dart';
import 'package:omnyqr/views/main_container/bloc/container_bloc.dart';
import 'package:omnyqr/views/main_container/bloc/container_event.dart';
import 'package:omnyqr/views/utility_overview/bloc/overview_page_bloc.dart';
import 'package:widgets_to_image/widgets_to_image.dart';
import '../../commons/constants/omny_colors.dart';
import '../../commons/widgets/common_app_button_withicon.dart';
import '../../commons/widgets/common_overview_form_field.dart';
import '../../models/association_wrapper.dart';

class UtilityOverViewPage extends StatefulWidget {
  const UtilityOverViewPage({super.key});

  @override
  State<UtilityOverViewPage> createState() => _UtilityOverViewPageState();
}

class _UtilityOverViewPageState extends State<UtilityOverViewPage> {
  Uint8List? bytes;
 // bool _hasReloaded = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      AssociationWrapper? params =
      ModalRoute.of(context)!.settings.arguments as AssociationWrapper?;

      context.read<OverviewPageBloc>().add(
        OverviewPageInitEvent(
          association: params?.association,
          index: params?.index,
          isReal: params?.isReal,
        ),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    AssociationWrapper? params =
        ModalRoute.of(context)!.settings.arguments as AssociationWrapper?;
    return BlocProvider(
      create: (context) => OverviewPageBloc(context.read<UtilityRepository>())
        ..add(OverviewPageInitEvent(
            association: params?.association,
            index: params?.index,
            isReal: params?.isReal)),
      child: BlocConsumer<OverviewPageBloc, OverviewPageState>(
        listener: (context, state) {
          DeleteDialog.callDialog(state.status, context);

          if (state.status == DeleteStatus.showQr) {
            showDialog(
                context: context,
                builder: (context) {
                  WidgetsToImageController controller =
                      WidgetsToImageController();
                  return Dialog(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          WidgetsToImage(
                            controller: controller,
                            child: Container(
                              color: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.all(8.h),
                                child: Container(
                                  color: AppColors.commonWhite,
                                  child: Column(
                                    children: [
                                      Container(
                                          width: double.maxFinite,
                                          decoration: BoxDecoration(
                                              color: AppColors.commonWhite,
                                              border: Border.all(
                                                color: AppColors.mainBlue,
                                                width: 3,
                                              )),
                                          child: Padding(
                                            padding: EdgeInsets.all(8.h),
                                            child: Text(
                                              tr('omny_virtual_device'),
                                              style: AppTypografy.common16,
                                            ),
                                          )),
                                      Image.memory(base64Decode(
                                          state.qrUrl?.split(",")[1] ?? '')),
                                      Padding(
                                        padding: EdgeInsets.all(8.h),
                                        child: Container(
                                            width: double.maxFinite,
                                            decoration: BoxDecoration(
                                                color: AppColors.commonWhite,
                                                border: Border.all(
                                                  color: AppColors.mainBlue,
                                                  width: 3,
                                                )),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  top: 5.h,
                                                  left: 5.w,
                                                  right: 5.w,
                                                  bottom: 5.h),
                                              child: Text(
                                                "${tr('id')}: ${params?.association?.uid}",
                                                style: AppTypografy.common16,
                                              ),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 20.w,
                                right: 20.w,
                                bottom: 10.h,
                                top: 10.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width: 110.w,
                                  child: CommonDialogButton(
                                    title: tr('download'),
                                    onTap: () async {
                                      final bytes = await controller.capture();
                                      setState(() {
                                        this.bytes = bytes;
                                      });
                                      var result =
                                          await ImageGallerySaver.saveImage(
                                              bytes ?? Uint8List(0),
                                              quality: 60,
                                              name: "qr");

                                      if (result['isSuccess']) {
                                        final snackBar = SnackBar(
                                          content: Text(tr('qr_saved')),
                                          action: SnackBarAction(
                                            label: tr('ok'),
                                            onPressed: () {
                                              // Some code to undo the change.
                                            },
                                          ),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      }
                                    },
                                    txtColor: AppColors.commonWhite,
                                    backgroundColor: AppColors.commonGreen,
                                  ),
                                ),
                                SizedBox(
                                  width: 110.w,
                                  child: CommonDialogButton(
                                    title: tr('close'),
                                    onTap: () async {
                                      Navigator.pop(context);
                                    },
                                    txtColor: AppColors.commonWhite,
                                    backgroundColor: AppColors.commonGreen,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).then((value) async {
              context.read<OverviewPageBloc>().add(ResetDialog());
            });
          }
        },
        builder: (context, state) {
          print('[UI] rebuild switch: isActive = ${state.isActive}');

          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: AppColors.transparent,
              centerTitle: true,
              actions: [
                SizedBox(
                  width: 25.w,
                ),
                InkWell(
                    enableFeedback: false,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    onTap: () {
                      print('[DEBUG] Navigazione verso la schermata dello switch');
                      context.read<ContainerBloc>().add(RefreshUtilities());

                      Navigator.pop(context, true);
                    },
                    child: SvgPicture.asset(
                      AppImages.backIcon,
                    )),
                SizedBox(
                  width: 5.w,
                ),
                const Spacer(
                  flex: 2,
                ),
                Center(
                  child: Text(tr('appbar_title'),
                      style: AppTypografy.mainContainerAppBarTitle),
                ),
                Spacer(
                  flex: params?.association?.amIOwner == true ? 2 : 3,
                ),
                Visibility(
                  visible: params?.association?.amIOwner == true ||
                      params?.association?.isRealAssociation == true,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(Routes.createEditQr, arguments: params);
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    child: SvgPicture.asset(
                      AppImages.edit,
                    ),
                  ),
                ),
                SizedBox(
                  width: 30.w,
                ),
              ],
            ),
            body: Stack(
              children: [
                ScrollConfiguration(
                  behavior: const ScrollBehavior().copyWith(overscroll: false),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(left: 25.w, right: 25.w),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20.h,
                          ),
                          CommonHeader(
                            icon: AppImages.bell,
                            color: AppColors.commonBlack,
                            title: state.subTitle,
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            state.title?.toUpperCase() ?? '',
                            style: AppTypografy.common11,
                          ),
                          SizedBox(
                            height: 40.h,
                          ),
                          CommonInconButton(
                            height: 40.h,
                            title: tr("open_qr"),
                            brColor: AppColors.mainBlue,
                            txtColor: AppColors.mainBlue,
                            icon: AppImages.logo,
                            onTap: () {
                              context.read<OverviewPageBloc>().add(GetQrEvemt(
                                  associationId:
                                      params?.association?.uid ?? ''));
                            },
                          ),
                          SizedBox(
                            height: 40.h,
                          ),
                          Visibility(
                            visible: params?.association?.amIOwner == true ||
                                params?.association?.isRealAssociation == true,
                            child: Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return CommonDialog(
                                              isBtn1Enabled: false,
                                              btn2Label: tr('ok'),
                                              title: tr('on_description'),
                                              onTap2: () {
                                                Navigator.pop(context);
                                              },
                                            );
                                          });
                                    },
                                    icon: const Icon(Icons.info_outline)),
                                Text(
                                  tr('on'),
                                  style: AppTypografy.commonBlack16W700,
                                ),
                                const Spacer(),
                                Switch(
                                  value: state.isActive ?? false,
                                  activeColor: AppColors.mainBlue,
                                  activeTrackColor: AppColors.commonGreen,
                                  inactiveThumbColor: AppColors.mainBlue,
                                  onChanged: (value) {
                                    context.read<OverviewPageBloc>().add(
                                          OnOffUtility(
                                              associationId:
                                                  params?.association?.id ?? '',
                                              utilityId: params
                                                      ?.association
                                                      ?.utilities?[
                                                          params.index ?? 0]
                                                      .id ??
                                                  ''),
                                        );
                                  },
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: getQrType(params?.association?.associationType ??'') ==QrType.mine ||
                                     getQrType(params?.association?.associationType ??'') ==QrType.business ||
                                     getQrType(params?.association?.associationType ??'') ==QrType.lost ||
                                getQrType(params?.association?.associationType ??'') ==QrType.assistance||
                                getQrType(params?.association?.associationType ??'') ==QrType.going||
                                getQrType(params?.association?.associationType ??'') ==QrType.emergency,
                            child: Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return CommonDialog(
                                              isBtn1Enabled: false,
                                              btn2Label: tr('ok'),
                                              title: tr('private_description'),
                                              onTap2: () {
                                                Navigator.pop(context);
                                              },
                                            );
                                          });
                                    },
                                    icon: const Icon(Icons.info_outline)),
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
                                    context.read<OverviewPageBloc>().add(
                                          PublicPrivateUtility(
                                            associationId:
                                                params?.association?.id ?? '',
                                            utilityId: params
                                                    ?.association
                                                    ?.utilities?[
                                                        params.index ?? 0]
                                                    .id ??
                                                '',
                                            value: value,
                                          ),
                                        );
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 25.h,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Pulsante "Set"
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {

                                      Navigator.of(context).pushNamed(
                                          Routes.availabilities,
                                          arguments: state.utility);

                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue[900],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                    ),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.access_time, color: Colors.white),
                                        SizedBox(width: 8),
                                        Text(
                                          'Set',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Icon(Icons.double_arrow_rounded, color: Colors.white),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),

                                // Pulsante "Salva"
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      print('[DEBUG] Navigazione verso la schermata del tasto salva');
                                      context.read<ContainerBloc>().add(RefreshUtilities());
                                      Navigator.pop(context, true);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue[900],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                    ),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Salva',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Icon(Icons.double_arrow_rounded, color: Colors.white),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(
                            height: 25.h,
                          ),
                          Visibility(
                            visible: state.showName ?? false,
                            child: CommonOverViewFormField(
                              title: tr('registry'),
                              text: state.utility?.details,
                            ),
                          ),
                          Visibility(
                            visible: state.showIntercom ?? false,
                            child: CommonOverViewFormField(
                              title: state.intercomNameLabel ??
                                  tr('intercon_name'),
                              text: state.utility?.intercomName,
                            ),
                          ),
                          Visibility(
                            visible: state.showAddress ?? false,
                            child: CommonOverViewFormField(
                              title: tr('address_only'),
                              text: state.utility?.address,
                            ),
                          ),
                          Visibility(
                            visible: state.showDate ?? false,
                            child: CommonOverViewFormField(
                              title: tr('start_date'),
                              text: state.utility?.startDate != null
                                  ? formatter(state.utility?.startDate ?? '')
                                  : '',
                            ),
                          ),
                          Visibility(
                            visible: state.showDate ?? false,
                            child: CommonOverViewFormField(
                              title: tr('end_date'),
                              text: state.utility?.endDate != null
                                  ? formatter(state.utility?.endDate ?? '')
                                  : '',
                            ),
                          ),
                          Visibility(
                            visible: state.showUrl ?? false,
                            child: CommonOverViewFormField(
                              title: tr('url'),
                              text: verifyUrl(state.utility?.utilityLink ?? ''),
                            ),
                          ),
                          Visibility(
                            visible: state.showfile ?? false,
                            child: DottedContainer(
                              title: tr('download_document'),
                              onTap: () {},
                            ),
                          ),
                          Visibility(
                            visible: state.showMember ?? false,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(tr('members'))),
                          ),
                          Visibility(
                            visible: state.showMember ?? false,
                            child: SizedBox(
                              height: 5.h,
                            ),
                          ),
                          Visibility(
                            visible: state.showMember ?? false,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.utility?.referents?.length ?? 0,
                              itemBuilder: (context, index) {
                                if (state.utility?.referents?[index].status ==
                                    'accepted') {
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 5.h),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: AppColors.commonWhite,
                                        border: Border.all(
                                          color: AppColors.containerSmall,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(3.r)),
                                      ),
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 20.w,
                                                top: 20.h,
                                                bottom: 20.h,
                                                right: 20.w),
                                            child: Text(
                                              "${state.utility?.referents?[index].name ?? ''} ${state.utility?.referents?[index].surname ?? ''}",
                                              style: AppTypografy.common18,
                                            ),
                                          )),
                                    ),
                                  );
                                }
                                return Container();
                              },
                            ),
                          ),
                          Visibility(
                            visible: (state.showMember ?? false) &&
                                (state.utility?.backupReferent != null) &&
                                (state.utility?.backupReferent?.status ==
                                    'accepted'),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(tr('user_deviation'))),
                          ),
                          Visibility(
                            visible: (state.showMember ?? false) &&
                                (state.utility?.backupReferent != null) &&
                                (state.utility?.backupReferent?.status ==
                                    'accepted'),
                            child: SizedBox(
                              height: 5.h,
                            ),
                          ),
                          Visibility(
                            visible: (state.showMember ?? false) &&
                                (state.utility?.backupReferent != null) &&
                                (state.utility?.backupReferent?.status ==
                                    'accepted'),
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 5.h),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppColors.commonWhite,
                                  border: Border.all(
                                    color: AppColors.containerSmall,
                                    width: 2,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3.r)),
                                ),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 20.w,
                                          top: 20.h,
                                          bottom: 20.h,
                                          right: 20.w),
                                      child: Text(
                                        "${state.utility?.backupReferent?.name ?? ''} ${state.utility?.backupReferent?.surname ?? ''}",
                                        style: AppTypografy.common18,
                                      ),
                                    )),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          /**
                           * 
                           * 
                           * 
                           * 
                           * 
                           * 
                           * 
                           * 
                           * 
                           * 
                           * 
                           * 
                           * 
                           * 
                           * 
                           */
                          Visibility(
                            visible: state.showCondominium ?? false,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 20.h),
                              child: Divider(
                                thickness: 1.5.h,
                              ),
                            ),
                          ),
                          Visibility(
                            visible: state.showCondominium ?? false,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 20.h),
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
                                      value: true,
                                      onChanged: (bool? value) {},
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    child: Text(
                                      state.groupCheckBoxLabel ?? '',
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
                          ),
                          Visibility(
                            visible: state.showCondominium ?? false,
                            child: CommonOverViewFormField(
                              title: tr('utilities_business'),
                              text: state.associationName,
                            ),
                          ),
                          Visibility(
                            visible: params?.association?.amIOwner == true,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  bottom: 30.h,
                                  top: 10.h,
                                  left: 100.w,
                                  right: 100.w),
                              child: Divider(
                                thickness: 1.5.h,
                              ),
                            ),
                          ),


                    Visibility(
                    visible: params?.association?.amIOwner == true,
                      child: CommonInconButton(
                        height: 40.h,
                        title: tr("delete_utility_title"),
                        brColor: AppColors.lightGrey,
                        txtColor: AppColors.lightGrey,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) {
                              String confirmationText = ""; // 🔁 RESET ogni apertura del dialog

                              return BlocProvider.value(
                                value: context.read<OverviewPageBloc>(),
                                child: StatefulBuilder(
                                  builder: (context, setState) {


                                    return CommonDialog(
                                      title: tr('delete_utility'),
                                      btn2Label: tr('no'),
                                      btn1Label: tr('yes'),
                                      isBtn1Enabled: confirmationText.toLowerCase() == 'delete',
                                      onTap2: () {
                                        Navigator.pop(context);
                                      },
                                      onTap1: () {
                                        context.read<OverviewPageBloc>().add(
                                          DeleteUtilityEvent(
                                            utilityId: params?.association?.utilities?[params.index ?? 0].id,
                                            associationId: params?.association?.id,
                                          ),
                                        );
                                        Navigator.pop(context);
                                      },
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            tr("type_delete_to_confirm"),
                                            style: AppTypografy.common14,
                                          ),
                                          const SizedBox(height: 12),
                                          TextField(
                                            onChanged: (value) {
                                              setState(() {
                                                confirmationText = value;
                                              });
                                            },
                                            decoration: const InputDecoration(
                                              hintText: "delete",
                                              border: OutlineInputBorder(),
                                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),

                    /* Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                            child: SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  print('[DEBUG] Navigazione verso la schermata del tasto salva');
                                  context.read<ContainerBloc>().add(RefreshUtilities());
                                  Navigator.pop(context, true);

                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue[900],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                child: const Text(
                                  'Save',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),*/




                          Padding(
                            padding: EdgeInsets.only(top: 10.h),
                            child: Visibility(
                              visible: params?.association?.amIOwner == false,
                              child: CommonInconButton(
                                height: 40.h,
                                title: tr("leave_user"),
                                brColor: AppColors.lightGrey,
                                txtColor: AppColors.lightGrey,
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (_) {
                                        return BlocProvider.value(
                                          value:
                                              context.read<OverviewPageBloc>(),
                                          child: CommonDialog(
                                            btn2Label: tr('no'),
                                            btn1Label: tr('yes'),
                                            isBtn1Enabled: true,
                                            title: tr('leave_utility'),
                                            onTap2: () {
                                              Navigator.pop(context);
                                            },
                                            onTap1: () {
                                              context
                                                  .read<OverviewPageBloc>()
                                                  .add(
                                                    DeleteUserEvent(
                                                        utilityId: params
                                                            ?.association
                                                            ?.utilities?[
                                                                params.index ??
                                                                    0]
                                                            .id,
                                                        associationId: params
                                                            ?.association?.id),
                                                  );
                                              Navigator.pop(context);
                                            },
                                          ),
                                        );
                                      });
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 100.h,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: state.isLoading ?? false,
                  child: const LoadingView(),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

String formatter(String date) {
  String inputString = date;
  DateTime dateTime = DateTime.parse(inputString);

  String formattedDate = DateFormat('dd/MM/yyyy - HH:mm').format(dateTime);

  return formattedDate;
}
