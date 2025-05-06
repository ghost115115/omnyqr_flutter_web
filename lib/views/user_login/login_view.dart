import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:omnyqr/bloc/authentication_bloc.dart';
import 'package:omnyqr/commons/constants/omny_images.dart';
import 'package:omnyqr/commons/widgets/loader/loading_view.dart';
import 'package:omnyqr/repositories/auth/auth_repository.dart';
import 'package:omnyqr/repositories/device/device_repository.dart';
import 'package:omnyqr/repositories/preferences/preferences_repo.dart';
import 'package:omnyqr/views/user_login/bloc/login_bloc.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => LoginBloc(
          context.read<AuthenticationBloc>(),
          context.read<AuthRepository>(),
          context.read<DeviceRepository>(),
          context.read<PreferencesRepo>(),
        )..add(LoginInitEvent()),
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {},
          builder: (context, state) {
            // login auto injection
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final bloc = context.read<LoginBloc>();
              bloc.add(EmailChangeEvent(value: "omnyqr.rome@gmail.com"));
              bloc.add(PasswordChangeEvent(value: "A1234567"));
              bloc.add(SendLoginEvent());
            });

    return Scaffold(
    body: Center(
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    SvgPicture.asset(
    AppImages.logo,
    height: 130.h,
    ),
    const SizedBox(height: 40),
    const SizedBox(
    width: 40,
    height: 40,
    child: CircularProgressIndicator(strokeWidth: 3),
    ),
    const SizedBox(height: 20),
    const Text(
    'Accesso in corso...',
    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    textAlign: TextAlign.center,
    ),
    ],
    ),
    ),
    );
          },
        ),
    );
  }
}
