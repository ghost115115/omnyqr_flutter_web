// ignore_for_file: must_be_immutable, unrelated_type_equality_checks

import 'dart:async';
//import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:mine_pushkit/mine_pushkit.dart';
import 'package:omnyqr/commons/constants/omny_account_type.dart';
import 'package:omnyqr/commons/constants/omny_colors.dart';
import 'package:omnyqr/commons/constants/omny_images.dart';
import 'package:omnyqr/commons/constants/omny_typography.dart';
import 'package:omnyqr/repositories/preferences/preferences_repo.dart';
import 'package:omnyqr/services/audio_check.dart';
import 'package:omnyqr/services/signaling_service.dart';
import 'package:omnyqr/views/main_container/bloc/container_bloc.dart';
import 'package:omnyqr/views/main_container/bloc/container_event.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


class CallScreen extends StatefulWidget {
  final String? callerId, calleeId, name, surname;
  dynamic offer;
  bool isCaller;
  final String nameToCallee;

  CallScreen({
    super.key,
    this.offer,
    required this.name,
    required this.surname,
    required this.callerId,
    required this.calleeId,
    required this.isCaller,
    required this.nameToCallee,
  });

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> with WidgetsBindingObserver {
  // socket instance

  final socket = SignallingService.instance.socket;

  // videoRenderer for localPeer
  final _localRTCVideoRenderer = RTCVideoRenderer();

  // videoRenderer for remotePeer
  final _remoteRTCVideoRenderer = RTCVideoRenderer();

  // mediaStream for localPeer
  MediaStream? _localStream;

  // RTC peer connection
  RTCPeerConnection? _rtcPeerConnection;

  // list of rtcCandidates to be sent over signalling
  List<RTCIceCandidate> rtcIceCadidates = [];
  PreferencesRepo preferencesRepo = PreferencesRepo();
  // media status
  bool isAudioOn = true, isVideoOn = true, isFrontCameraSelected = true;
  bool refused = false;
  bool isBusy = false;
  bool acceptedCall = false;
  bool speaker = true;
  bool firstSetSpeaker = false;
  bool isConnecting = true;
  Timer? _timer;
  int _secondsElapsed = 0;
  bool isRemoteAudioOn = false;
  bool isRemoteVideoOn = false;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {}

  @override
  void initState() {
    // initializing renderers

    /*if (!kIsWeb && Platform.isAndroid) {
    //  checkSpeaker();
    }*/

    WakelockPlus.enable();
    // setup Peer Connection
    if (widget.isCaller) {
      _localRTCVideoRenderer.initialize();
      _remoteRTCVideoRenderer.initialize();
      _setupPeerConnectionCaller();
    }

    WidgetsBinding.instance.addObserver(this);
    if (mounted) {
      SignallingService.instance.socket!.emit("callResumed");
    }

    SignallingService.instance.socket!.on("callBackground", (data) async {
      String response = data['response'] as String;
      if (response == 'true') {
        if (mounted) {
          _acceptCall();
        }
      }
    });

    SignallingService.instance.socket!.on("callEnded", (data) async {
      Navigator.of(context).pop();
    });

    SignallingService.instance.socket!.on("callRejected", (data) async {
      setState(() => refused = true);
      await Future.delayed(Duration(seconds: 5));
      Navigator.pop(context, 'rejected');
    });

    SignallingService.instance.socket!.on("busy", (data) async {
      setState(() => isBusy = true);

      await Future.delayed(Duration(seconds: 5));
      Navigator.pop(context, 'rejected');
    });

   /* SignallingService.instance.socket!.on("SendNotification", (data) async {
      context.read<ContainerBloc>().add(SendNotificationEvent(
            id: widget.calleeId,
            type: 'CALL',
            name: widget.nameToCallee,
          ));
    });*/
    SignallingService.instance.socket!.on("SendNotification", (data) async {
      print('📤 Inviando notifica con calleeId: ${widget.calleeId}, type: CALL');

      final calleeId = widget.calleeId ?? '';

      if (calleeId.isNotEmpty) {
        context.read<ContainerBloc>().add(SendNotificationEvent(
          id: calleeId,
          type: 'CALL',
          name: widget.nameToCallee,
        ));
      } else {
        print('❌ [Web] calleeId mancante: notifica non inviata');
      }
    });

    SignallingService.instance.socket!.on("setVideoAndMic", (data) {
      setState(
        () {
          isRemoteAudioOn = data['isAudioOn'];
          isRemoteVideoOn = data['isVideoOn'];
        },
      );
    });

    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  _setupPeerConnectionCaller() async {
    // create peer connection

    _rtcPeerConnection = await createPeerConnection({
      ..._iceServers,
      ...{'sdpSemantics': sdpSemantics}
    }, _config);

    // listen for remotePeer mediaTrack event
    _rtcPeerConnection!.onTrack = (event) {
      _remoteRTCVideoRenderer.srcObject = event.streams[0];

      setState(() {});
    };

    // get localStream

    _localStream = await navigator.mediaDevices.getUserMedia({
      'audio': isAudioOn,
      'video': false,
    });

  //  _localStream!.getAudioTracks()[0].enableSpeakerphone(true);

    // add mediaTrack to peerConnection
    _localStream!.getTracks().forEach((track) {
      _rtcPeerConnection!.addTrack(track, _localStream!);
    });
    // set source for local video renderer
    _localRTCVideoRenderer.srcObject = _localStream;
    setState(() {});
    // for Incoming call
    if (widget.offer != null) {
      // listen for Remote IceCandidate

      socket!.on("IceCandidate", (data) {
        String candidate = data["iceCandidate"]["candidate"];
        String sdpMid = data["iceCandidate"]["id"];
        int sdpMLineIndex = data["iceCandidate"]["label"];

        // add iceCandidate

        _rtcPeerConnection!
            .addCandidate(RTCIceCandidate(
          candidate,
          sdpMid,
          sdpMLineIndex,
        ))
            .onError((error, stackTrace) {
          debugPrint("Error PeerConnectionCaller $error $data");
        });
      });

      // set SDP offer as remoteDescription for peerConnection
      await _rtcPeerConnection!.setRemoteDescription(
        RTCSessionDescription(widget.offer["sdp"], widget.offer["type"]),
      );

      // create SDP answer
      RTCSessionDescription answer = await _rtcPeerConnection!.createAnswer();

      // set SDP answer as localDescription for peerConnection
      _rtcPeerConnection!.setLocalDescription(answer);

      // send SDP answer to remote peer over signalling
      socket!.emit("answerCall", {
        "callerId": widget.callerId,
        "sdpAnswer": answer.toMap(),
      });
    }
    // for Outgoing Call
    else {
      // listen for local iceCandidate and add it to the list of IceCandidate
      _rtcPeerConnection!.onIceCandidate =
          (RTCIceCandidate candidate) => rtcIceCadidates.add(candidate);

      // when call is accepted by remote peer
      socket!.on("callAnswered", (data) async {
        // set SDP answer as remoteDescription for peerConnection
        await _rtcPeerConnection!.setRemoteDescription(
          RTCSessionDescription(
            data["sdpAnswer"]["sdp"],
            data["sdpAnswer"]["type"],
          ),
        );

        // send iceCandidate generated to remote peer over signalling
        for (RTCIceCandidate candidate in rtcIceCadidates) {
          socket!.emit("IceCandidate", {
            "calleeId": widget.calleeId,
            "iceCandidate": {
              "id": candidate.sdpMid,
              "label": candidate.sdpMLineIndex,
              "candidate": candidate.candidate
            }
          });
        }
      });

      // create SDP Offer
      RTCSessionDescription offer = await _rtcPeerConnection!.createOffer();

      // set SDP offer as localDescription for peerConnection
      await _rtcPeerConnection!.setLocalDescription(offer);
      var userInfo = {
        "name": widget.name,
        "surname": widget.surname,
      };

      socket!.emit('startCall', {
        "calleeId": widget.calleeId,
        "sdpOffer": offer.toMap(),
        "callerInfo": userInfo,
      });
      // make a call to remote peer over signalling
      socket!.emit('makeCall', {
        "calleeId": widget.calleeId,
        "sdpOffer": offer.toMap(),
        "callerInfo": userInfo,
      });
    }
  }

  final Map<String, dynamic> _iceServers = {
    'iceServers': [
      {
        'urls': [
          'stun:stun1.l.google.com:19302',
        ]
      },
      {
        'url': 'turn:turn.omnyqr.com:3478',
        'username': 'omnyturn',
        'credential': 'omnyturn'
      }
    ],
  };
  String get sdpSemantics => 'unified-plan';

  final Map<String, dynamic> _config = {
    'mandatory': {},
    'optional': [
      {'DtlsSrtpKeyAgreement': true},
    ]
  };
  _setupPeerConnectionCallee() async {
    // create peer connection
    _rtcPeerConnection = await createPeerConnection({
      ..._iceServers,
      ...{'sdpSemantics': sdpSemantics}
    }, _config);

    // listen for remotePeer mediaTrack event
    _rtcPeerConnection!.onTrack = (event) {
      _remoteRTCVideoRenderer.srcObject = event.streams[0];

      setState(() {});
    };

    // get localStream
    _localStream = await navigator.mediaDevices.getUserMedia({
      'audio': isAudioOn,
      'video': false,
    });
    //_localStream!.getAudioTracks()[0].enableSpeakerphone(true);

    // add mediaTrack to peerConnection
    _localStream!.getTracks().forEach((track) {
      _rtcPeerConnection!.addTrack(track, _localStream!);
    });

    // set source for local video renderer
    _localRTCVideoRenderer.srcObject = _localStream;
    setState(() {});

    // listen for Remote IceCandidate
    socket!.on("IceCandidate", (data) {
      String candidate = data["iceCandidate"]["candidate"];
      String sdpMid = data["iceCandidate"]["id"];
      int sdpMLineIndex = data["iceCandidate"]["label"];

      // add iceCandidate

      _rtcPeerConnection!
          .addCandidate(RTCIceCandidate(
        candidate,
        sdpMid,
        sdpMLineIndex,
      ))
          .onError((error, stackTrace) {
        debugPrint("Error PeerConnectionCallee $error $data");
      });
    });

    // set SDP offer as remoteDescription for peerConnection
    await _rtcPeerConnection!.setRemoteDescription(
      RTCSessionDescription(widget.offer["sdp"], widget.offer["type"]),
    );

    // create SDP answer
    RTCSessionDescription answer = await _rtcPeerConnection!.createAnswer();

    // set SDP answer as localDescription for peerConnection
    _rtcPeerConnection!.setLocalDescription(answer);

    // send SDP answer to remote peer over signalling
    socket!.emit("answerCall", {
      "callerId": widget.callerId,
      "sdpAnswer": answer.toMap(),
    });
  }

  _acceptCall() {
    _localRTCVideoRenderer.initialize();
    _remoteRTCVideoRenderer.initialize();
    _setupPeerConnectionCallee();
    acceptedCall = true;
  }

  _leaveCall() {
    Navigator.of(context).pop();

    if (widget.isCaller == true && isConnecting == true) {
      SignallingService.instance.socket!.emit("closeNotification", {
        "calleeId": widget.calleeId,
      });
    }
  }

  _toggleMic() {
    // change status
    isAudioOn = !isAudioOn;
    // enable or disable audio track
    _localStream?.getAudioTracks().forEach((track) {
      track.enabled = isAudioOn;
    });

    SignallingService.instance.socket!.emit('setVideoAndMic', {
      "isAudioOn": isAudioOn,
      "isVideoOn": isVideoOn,
      "remoteId": widget.isCaller == true ? widget.calleeId : widget.callerId
    });
    setState(() {});
  }

  _toogleSpeaker() {
    speaker = !speaker;
    if (!speaker) {
      MinePushkit.instance.resetAudioSession();
    } else {
      MinePushkit.instance.setAudioSession();
    }
    setState(() {
      firstSetSpeaker = true;
    });
  }

  _toggleSpeakerAndroid() async {
    if (speaker == false) {
    //  _localStream!.getAudioTracks()[0].enableSpeakerphone(true);
      setState(() {
        speaker = true;
      });
    } else {
     // _localStream!.getAudioTracks()[0].enableSpeakerphone(false);
      setState(() {
        speaker = false;
      });
    }
  }

  _toggleCamera() {
    // change status

    // change status
    isVideoOn = !isVideoOn;

    // enable or disable video track
    _localStream?.getVideoTracks().forEach((track) {
      track.enabled = isVideoOn;
    });

    SignallingService.instance.socket!.emit('setVideoAndMic', {
      "isAudioOn": isAudioOn,
      "isVideoOn": isVideoOn,
      "remoteId": widget.isCaller == true ? widget.calleeId : widget.callerId
    });

    // enable or disable video track
    _localStream?.getVideoTracks().forEach((track) {
      track.enabled = isVideoOn;
    });
    setState(() {});
  }

  _switchCamera() {
    // change status
    isFrontCameraSelected = !isFrontCameraSelected;

    // switch camera
    _localStream?.getVideoTracks().forEach((track) {
      // ignore: deprecated_member_use
      track.switchCamera();
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    AccountType? accountType =
        context.select((ContainerBloc bloc) => bloc.state.accountType);

    _rtcPeerConnection?.onConnectionState = (newState) {
      if (newState.name == 'RTCPeerConnectionStateConnected') {
        setState(() {
          isConnecting = false;
        });
        _startTimer();
        if (accountType == AccountType.free) {
          setState(() {
            isVideoOn = false;
          });
        } else {
          setState(() {
            isVideoOn = true;
          });
        }
        SignallingService.instance.socket!.emit('setVideoAndMic', {
          "isAudioOn": isAudioOn,
          "isVideoOn": isVideoOn,
          "remoteId":
              widget.isCaller == true ? widget.calleeId : widget.callerId
        });
      }
    };


   /* _localRTCVideoRenderer.errorListener((value) {
      debugPrint("localRTCVideoRenderer $value");
    });

    _remoteRTCVideoRenderer.errorListener((value) {
      debugPrint("remoteRTCVideoRenderer $value");
    });*/

    return Scaffold(
      backgroundColor: AppColors.commonWhite,
      body: SafeArea(
        child: widget.isCaller
            ? _activeCallView(accountType)
            : acceptedCall
                ? _activeCallView(accountType)
                : _recivedCallView(accountType),
      ),
    );
  }

  @override
  void dispose() {
    if (widget.isCaller == false && acceptedCall == false) {
      SignallingService.instance.socket!.emit('RejectCall', {
        //"calleeId": widget.calleeId,
        "callerId": widget.callerId,
      });
    } else if ((widget.isCaller == true &&
            (isBusy == false && refused == false)) ||
        (widget.isCaller == false && acceptedCall == true)) {
      SignallingService.instance.socket!.emit('endCall', {
        "calleeId": widget.calleeId,
        "callerId": widget.callerId,
      });
    }

    SignallingService.instance.socket!.emit("closeCall", {
      "calleeId": widget.calleeId,
    });

    _localRTCVideoRenderer.dispose();
    _remoteRTCVideoRenderer.dispose();
    _localStream?.dispose();
    _rtcPeerConnection?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    WakelockPlus.disable();
    super.dispose();
  }

  Widget _recivedCallView(AccountType? type) {
    _acceptCall();

    return Container();
  }

  Widget _activeCallView(AccountType? type) {
   /* if (!kIsWeb && Platform.isIOS) {
      Future.delayed(const Duration(seconds: 1), () {
        if (!firstSetSpeaker) {
          MinePushkit.instance.setAudioSession();
          firstSetSpeaker = true;
        }
      });
    }*/
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Stack(children: [
              isBusy
                  ? Center(
                      child: Text(
                        tr('user_busy'),
                        style: AppTypografy.common16,
                      ),
                    )
                  : refused
                      ? Center(
                          child: Text(
                            tr('call_refused_action'),
                            style: AppTypografy.common16,
                          ),
                        )
                      : type != AccountType.free
                          ? showVideoCallFrame()
                          : isConnecting == true
                              ? Center(
                                  child: Text(
                                  tr('call_init'),
                                  style: AppTypografy.common16,
                                ))
                              : callTimer(),
              Visibility(
                visible: type != AccountType.free,
                child: Positioned(
                  right: 20,
                  bottom: 20,
                  child: SizedBox(
                    height: 150.h,
                    width: 120.w,
                    child: RTCVideoView(
                      _localRTCVideoRenderer,
                      mirror: isFrontCameraSelected,
                      objectFit:
                          RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                    ),
                  ),
                ),
              )
            ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(isAudioOn ? Icons.mic : Icons.mic_off),
                  onPressed: _toggleMic,
                  iconSize: 30.h,
                ),
                /*Platform.isIOS
                    ? IconButton(
                        onPressed: _toogleSpeaker,
                        icon: SvgPicture.asset(
                          speaker ? AppImages.volumeUp : AppImages.volumeMute,
                        ),
                        iconSize: 30.h,
                      )
                    : IconButton(
                        onPressed: _toggleSpeakerAndroid,
                        icon: SvgPicture.asset(
                          speaker ? AppImages.volumeUp : AppImages.volumeMute,
                        ),
                        iconSize: 30.h,
                      ),*/
                IconButton(
                  icon: const Icon(Icons.call_end),
                  iconSize: 30.h,
                  onPressed: _leaveCall,
                ),
                Visibility(
                  visible: type != AccountType.free,
                  child: IconButton(
                    icon: const Icon(Icons.cameraswitch),
                    onPressed: _switchCamera,
                    iconSize: 30.h,
                  ),
                ),
                Visibility(
                  visible: type != AccountType.free,
                  child: IconButton(
                    icon: Icon(isVideoOn ? Icons.videocam : Icons.videocam_off),
                    onPressed: _toggleCamera,
                    iconSize: 30.h,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /*checkSpeaker() async {
    bool val = speaker = await AudioCheck.areSpeakersActive;
    setState(
      () {
        speaker = val;
      },
    );
  }*/

  void _startTimer() {
    if (mounted) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _secondsElapsed++;
        });
      });
    }
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = remainingSeconds.toString().padLeft(2, '0');
    return '$minutesStr:$secondsStr';
  }

  Widget showVideoCallFrame() {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return SizedBox(
      height: h,
      width: w,
      child: isRemoteVideoOn
          ? SizedBox(
              height: h * 0.85,
              width: w,
              child: Stack(
                children: [
                  RTCVideoView(
                    _remoteRTCVideoRenderer,
                    objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                    placeholderBuilder: (context) {
                      return SizedBox(
                          width: double.maxFinite,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CircularProgressIndicator(
                                color: AppColors.mainBlue,
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              Text(
                                tr('await_connection'),
                                style: AppTypografy.common16,
                              ),
                            ],
                          ));
                    },
                  ),
                  videoCallTimer(),
                ],
              ),
            )
          : Container(
              width: w,
              height: h * 0.85,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: isConnecting == true
                  ? Center(
                      child: Text(
                      tr('call_init'),
                      style: AppTypografy.common16,
                    ))
                  : callTimer(),
            ),
    );
  }

  videoCallTimer() {
    return SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: Text(
                isConnecting ? tr('call_init') : tr('call_in_progress'),
                style: AppTypografy.common16,
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            Visibility(
              visible: isConnecting == false,
              child: Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: Text(
                  _formatTime(_secondsElapsed),
                  style: AppTypografy.common16,
                ),
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
          ],
        ));
  }

  callTimer() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          tr('call_in_progress'),
          style: AppTypografy.common16,
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          _formatTime(_secondsElapsed),
          style: AppTypografy.common16,
        )
      ],
    ));
  }
}
