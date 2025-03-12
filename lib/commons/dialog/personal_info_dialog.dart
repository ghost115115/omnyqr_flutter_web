import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omnyqr/commons/widgets/common_app_dialog.dart';
import 'package:omnyqr/views/personal_area/subviews/personal_information/bloc/personal_information_bloc.dart';

class PersonalInfoDialog {
  EditStatus? status;
  BuildContext? context;

  PersonalInfoDialog({this.context, this.status});
  PersonalInfoDialog.callDialog(EditStatus? status, BuildContext context) {
    switch (status) {
      case EditStatus.error:
        showDialog(
            context: context,
            builder: (context) {
              return CommonDialog(
                btn2Label: tr('ok'),
                isBtn1Enabled: false,
                title: tr('generic_error'),
                onTap2: () {
                  Navigator.pop(context);
                },
              );
            });
        context.read<PersonalInformationBloc>().add(ResetDialogEvent());
        break;
      case EditStatus.success:
        showDialog(
            context: context,
            builder: (context) {
              return CommonDialog(
                isBtn1Enabled: false,
                btn2Label: tr('ok'),
                title: tr('profile_update_success'),
                onTap2: () {
                  Navigator.pop(context);
                },
              );
            }).then((value) => Navigator.pop(context));
        context.read<PersonalInformationBloc>().add(ResetDialogEvent());
        break;
      case EditStatus.networkError:
        showDialog(
            context: context,
            builder: (context) {
              return CommonDialog(
                isBtn1Enabled: false,
                btn2Label: tr('ok'),
                title: tr('network_error'),
                onTap2: () {
                  Navigator.pop(context);
                },
              );
            });
        context.read<PersonalInformationBloc>().add(ResetDialogEvent());
        break;

      default:
    }
  }
}
