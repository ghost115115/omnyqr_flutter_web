import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omnyqr/repositories/utilities/notification_manager.dart';
import 'package:omnyqr/views/main_container/bloc/container_event.dart';
import 'package:omnyqr/views/tab_message/message_page.dart';
import 'package:omnyqr/views/tab_qr/tab_qr_page.dart';
import '../../tab_utilities/utilities_page.dart';
import '../bloc/container_bloc.dart';
import '../bloc/container_state.dart';

class ContainerContent extends StatefulWidget {
  const ContainerContent({super.key});

  @override
  State<ContainerContent> createState() => _ContainerContentState();
}

class _ContainerContentState extends State<ContainerContent> {
  final PageController pageController = PageController();

  bool loaded = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.instance.getInitialMessage().then((value) {
      if (value != null) {
        context
            .read<ContainerBloc>()
            .add(const BottomBarSelectionChange(selectedIndex: 2));
      }
    });
    NotificationManager.instance.addListener(
      (data) {
        Map<String, dynamic> message = data['data'] as Map<String, dynamic>;
        if (message["type"] == "INVITATION") {
          if (data['source'] == "External") {
            if (pageController.page != 2) {
              context
                  .read<ContainerBloc>()
                  .add(const BottomBarSelectionChange(selectedIndex: 2));
            }
          }
          context.read<ContainerBloc>().add((const RefreshThreadsEvent()));
        }
      },
    );
    return BlocListener<ContainerBloc, ContainerState>(
      listener: (context, state) {
        pageController.jumpToPage(state.bottomBarSelected);
      },
      child: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [QrPage(), UtilitiesPage(), MessagePage()],
      ),
    );
  }
}
