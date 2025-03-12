import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omnyqr/views/main_container/bloc/container_bloc.dart';
import 'package:omnyqr/views/main_container/bloc/container_event.dart';
import 'package:omnyqr/views/user_login/login_view.dart';
import 'package:omnyqr/views/main_container/view/main_container.dart';
import '../../bloc/authentication_bloc.dart';
import '../../models/associations.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      AuthState? authState =
          context.select((AuthenticationBloc bloc) => bloc.state.state);

      List<Association>? associationsList =
          context.select((ContainerBloc bloc) => bloc.state.associations);
      if (authState == AuthState.anonimous) {
        return LoginPage();
      } else if (authState == AuthState.logged) {
        // this controll is used for reloading utilities in case someone log in with different account

        if (associationsList == null) {
       
          context.read<ContainerBloc>().add(LoadUtilsEvent());
        }
        return const MainContainerPage();
      } else if (authState == AuthState.initialising) {
        return Container();
      } else {
        return Container();
      }
    });
  }
}
