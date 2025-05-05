// ignore_for_file: unused_element

import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mine_pushkit/mine_pushkit.dart';
import 'package:omnyqr/commons/constants/omny_colors.dart';
import 'package:omnyqr/commons/constants/omny_images.dart';
import 'package:omnyqr/commons/constants/omny_typography.dart';
import 'package:omnyqr/commons/dialog/utilities_page_dialog.dart';
import 'package:omnyqr/services/signaling_service.dart';
import 'package:omnyqr/views/call_screen/call_screen.dart';
import 'package:uuid/uuid.dart';
import '../../../commons/constants/omny_routes.dart';
import '../bloc/container_bloc.dart';
import '../bloc/container_state.dart';
import '../widgets/container_bottom_bar.dart';
import '../widgets/container_content.dart';

class MainContainerPage extends StatefulWidget {
  const MainContainerPage({super.key});

  @override
  State<MainContainerPage> createState() => _MainContainerPageState();
}

class _MainContainerPageState extends State<MainContainerPage>
    with WidgetsBindingObserver {
  bool? isAccepted;
  dynamic incomingSDPOffer;
  // ignore: prefer_typing_uninitialized_variables
  var idUserConversation;
  Uuid uuid = const Uuid();

  int sdpCheckCounter = 0;

  StreamSubscription<CallEvent?>? event;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    sdpCheckCounter = 0;

    isAccepted = false;
    // listen for incoming video call
    SignallingService.instance.socket!.on("callEnded", (data) async {
      setState(() => isAccepted = false);
    });
    SignallingService.instance.socket!.on("callRejected", (data) async {
      setState(() => isAccepted = false);
    });

    if (!kIsWeb && Platform.isIOS) {
      MinePushkit.instance.didReciveIncomingPushNotification = ((data) {
        //    MinePushkit.instance.setAudioSession();
        _checkAndNavigationCallingPage();
      });
    }
    debugPrint("Server Signaling ${SignallingService.instance.socket!.active}");

    SignallingService.instance.socket!.emit("CheckCall");

    SignallingService.instance.socket!.on("newCall", (data) {
      debugPrint("Signaling server noticing incoming call...");
      incomingSDPOffer = data;
      debugPrint("INCOMING SDP: ${incomingSDPOffer}");
      if (!kIsWeb && Platform.isIOS) {
        MinePushkit.instance.didReciveIncomingPushNotification = ((data) {
          //    MinePushkit.instance.setAudioSession();
          _checkAndNavigationCallingPage();
        });
      }
      // if (Platform.isAndroid) {
      //   _checkAndNavigationCallingPage();
      // }
    });

    /**
     * Se l'app è stata avviata da notifica di Callkit
     * verificare che effettivamente Callkit abbia una risposto ad una
     * chiamata, se è così aprire direttamente la pagina della chiamata.
     */

    if (!kIsWeb && Platform.isAndroid) {
      _checkAndNavigationCallingPage();
    }

    event = FlutterCallkitIncoming.onEvent.listen((event) async {
      switch (event!.event) {
        case Event.actionCallDecline:
          setState(() {
            isAccepted = true;
          });
          SignallingService.instance.socket!.emit('RejectCall', {
            "callerId": event.body['extra']['sender'],
            "calleeId": event.body['extra']['receiver'],
          });
          FlutterCallkitIncoming.endAllCalls();
          break;
        case Event.actionDidUpdateDevicePushTokenVoip:
          break;
        case Event.actionCallIncoming:
          break;
        case Event.actionCallStart:
          break;
        case Event.actionCallAccept:
          debugPrint("Callkit notifying fror incoming call...");
          _checkAndNavigationCallingPage();
          break;
        case Event.actionCallEnded:
          FlutterCallkitIncoming.endAllCalls();
          break;
        case Event.actionCallTimeout:
          setState(() {
            isAccepted = true;
          });

          SignallingService.instance.socket!.emit('RejectCall', {
            "callerId": event.body['extra']['sender'],
            "calleeId": event.body['extra']['receiver'],
          });
          FlutterCallkitIncoming.endAllCalls();
          break;
        case Event.actionCallCallback:
          break;
        case Event.actionCallToggleHold:
          break;
        case Event.actionCallToggleMute:
          break;
        case Event.actionCallToggleDmtf:
          break;
        case Event.actionCallToggleGroup:
          break;
        case Event.actionCallToggleAudioSession:
          break;
        case Event.actionCallCustom:
          break;
        default:
          FlutterCallkitIncoming.endAllCalls();
      }
    });
  }

  Future<void> _checkAndNavigationCallingPage() async {
    var currentCall = await getCurrentCall();
    debugPrint("${incomingSDPOffer}");
    debugPrint(
        "Checking for existing calls incomingSDPOffer ${incomingSDPOffer != null}; Call: ${currentCall != null}");
    if (currentCall != null && incomingSDPOffer != null) {
      debugPrint("Moving to Call Screen...");
      String? callerId = incomingSDPOffer["callerId"];
      dynamic? sdpOffer = incomingSDPOffer["sdpOffer"];
      String? callerName = incomingSDPOffer['callerInfo']['name'];
      String? callerSurname = incomingSDPOffer['callerInfo']['surname'];

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Material(
            child: CallScreen(
              callerId: callerId,
              calleeId: idUserConversation,
              offer: sdpOffer,
              isCaller: false,
              name: callerName,
              surname: callerSurname,
              nameToCallee: '',
            ),
          ),
        ),
      );
      if (!kIsWeb && Platform.isAndroid) {
        FlutterCallkitIncoming.endAllCalls();
      } else {
        await MinePushkit.instance.closeCall();
      }
      incomingSDPOffer = null;
    } else {
      if (sdpCheckCounter < 10) {
        // Call the function again after some time.
        Future.delayed(
            const Duration(milliseconds: 1000), _checkAndNavigationCallingPage);
        sdpCheckCounter += 1;
      } else {
        FlutterCallkitIncoming.endAllCalls();
        sdpCheckCounter = 0;
        incomingSDPOffer = null;
      }
    }
  }

  Future<dynamic> getCurrentCall() async {
    var calls = await FlutterCallkitIncoming.activeCalls();
    if (calls is List) {
      if (calls.isNotEmpty) {
        print('DATA: $calls');
        return calls[0];
      } else {
        return null;
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    idUserConversation =
        context.select((ContainerBloc bloc) => bloc.state.user?.id);
    return BlocConsumer<ContainerBloc, ContainerState>(
      listener: (context, state) {
        if (state.bottomBarSelected == 1 ||
            state.bottomBarSelected == 2 ||
            state.bottomBarSelected == 0 &&
                state.status == UtilityStatus.initFail) {
          UtilitiesPageDialog.callDialog(state.status, context);
        }
      },
      builder: (context, state) {
        return Stack(children: [
          Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: AppColors.transparent,
              centerTitle: true,
              actions: [
                SizedBox(
                  width: 30.w,
                ),
                SvgPicture.asset(
                  AppImages.logo,
                  height: 30.h,
                ),
                const Spacer(),
                Center(
                  child: Text(tr('appbar_title'),
                      style: AppTypografy.mainContainerAppBarTitle),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(Routes.personalArea);
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  child: SvgPicture.asset(
                    AppImages.account,
                  ),
                ),
                SizedBox(
                  width: 30.w,
                ),
              ],
            ),
            body: const Stack(
              children: [
                ContainerContent(),
              ],
            ),
            bottomNavigationBar: const ContainerBottomBar(),
          ),
        ]);
      },
    );
  }
}
