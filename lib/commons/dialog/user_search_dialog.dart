import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omnyqr/views/users_search/bloc/user_search_bloc.dart';
import '../widgets/common_app_dialog.dart';

class UserSearchDialog {
  UserSearchStatus? status;
  BuildContext? context;

  UserSearchDialog({this.context, this.status});
  UserSearchDialog.callDialog(
    UserSearchStatus? status,
    BuildContext context,
  ) {
    switch (status) {
      case UserSearchStatus.error:
        showDialog(
                context: context,
                builder: (context) {
                  return CommonDialog(
                    isBtn1Enabled: false,
                    btn2Label: tr('ok'),
                    title: tr('generic_error'),
                    onTap2: () {
                      Navigator.pop(context);
                    },
                  );
                })
            .then((value) =>
                context.read<UserSearchBloc>().add(ResetSearchStatus()));

        break;
      case UserSearchStatus.networkError:
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
                })
            .then((value) =>
                context.read<UserSearchBloc>().add(ResetSearchStatus()));

        break;
      default:
    }
  }
}

 