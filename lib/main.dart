import 'dart:developer';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mine_pushkit/mine_pushkit.dart';
import 'package:omnyqr/bloc/authentication_bloc.dart';
import 'package:omnyqr/clients/device/device_api_client.dart';
import 'package:omnyqr/clients/message/message_api_client.dart';
import 'package:omnyqr/clients/search/search_api_client.dart';
import 'package:omnyqr/clients/user/user_api_client.dart';
import 'package:omnyqr/clients/utility/utility_api_client.dart';
import 'package:omnyqr/commons/constants/theme.dart';
import 'package:omnyqr/commons/widgets/common_scale_factor.dart';
import 'package:omnyqr/models/user.dart';
import 'package:omnyqr/repositories/auth/auth_repository.dart';
import 'package:omnyqr/repositories/device/device_repository.dart';
import 'package:omnyqr/repositories/message/message_repository.dart';
import 'package:omnyqr/repositories/preferences/preferences_repo.dart';
import 'package:omnyqr/repositories/search/search_repository.dart';
import 'package:omnyqr/repositories/user/user_repository.dart';
import 'package:omnyqr/repositories/utilities/notification_manager.dart';
import 'package:omnyqr/repositories/utilities/utility_repo.dart';
import 'package:omnyqr/services/signaling_service.dart';
import 'package:omnyqr/views/after_scan_section/association_section.dart';
import 'package:omnyqr/views/after_scan_section/utility_section.dart';
import 'package:omnyqr/views/association_create/association_create_page.dart';
import 'package:omnyqr/views/association_overview/association_overview.dart';
import 'package:omnyqr/views/association_search/association_page.dart';
import 'package:omnyqr/views/availability/availability_page.dart';
import 'package:omnyqr/views/call_deviation/call_deviation.dart';
import 'package:omnyqr/views/create_utils_list/create_utils.dart';
import 'package:omnyqr/views/message_section/message_page.dart';
import 'package:omnyqr/views/personal_area/subviews/in_app_purchase/in_app_purchase_page.dart';
import 'package:omnyqr/views/personal_area/subviews/personal_information/personal_information_page.dart';
import 'package:omnyqr/views/tab_message/subviews/message_details.dart';
import 'package:omnyqr/views/tab_qr/views/qr_page.dart';
import 'package:omnyqr/views/user_login/login_view.dart';
import 'package:omnyqr/views/onBoarding_page/on_boarding_page.dart';
import 'package:omnyqr/views/main_container/bloc/container_bloc.dart';
import 'package:omnyqr/views/password_reset/password_reset.dart';
import 'package:omnyqr/views/personal_area/personal_area.dart';
import 'package:omnyqr/views/users_search/user_search.dart';
import 'package:omnyqr/views/utility_overview/utility_overview.dart';
import 'package:uuid/uuid.dart';
import 'clients/auth/auth_api_client.dart';
import 'commons/constants/omny_routes.dart';
import 'views/create_edit_qr/create_edit_qr.dart';
import 'views/main_container/bloc/container_event.dart';
import 'views/personal_area/subviews/change_password/change_password.dart';
import 'views/user_registration/registration_view.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html;






final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

@pragma("vm:entry-point")
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  Map<String, dynamic> data = {
    "source": "External",
    "data": message.data,
  };
  NotificationManager.instance.sendNotification(data);
  PreferencesRepo preferencesRepo = PreferencesRepo();
  User? user = await preferencesRepo.getUser();

  String newId = const Uuid().v4();

  if (user != null) {
    if (message.data['type'] == "CALL") {
     // const String websocketUrl = "http://162.19.244.59:8080";
      const websocketUrl = "https://wrtc.smlwebdesign.it";
      print(websocketUrl);
      //"http://192.168.1.106:8080";

      // generate callerID of local user
      final String selfCallerID = user.id ?? '';

      SignallingService.instance.init(
          websocketUrl: websocketUrl,
          selfCallerID: selfCallerID,
          callKit: 'false');

      FlutterCallkitIncoming.onEvent.listen((event) {
        if (event != null) {
          switch (event.event) {
            case Event.actionCallDecline:
              _onCallDeclinedFromCallKit(user, event);
              break;
            case Event.actionCallTimeout:
              _onCallDeclinedFromCallKit(user, event);
              break;
            default:
              break;
          }
        }
      });
      SignallingService.instance.socket!.on("closeNotification", (data) async {
        if (!kIsWeb && Platform.isAndroid) {
          FlutterCallkitIncoming.endCall(newId);
          FlutterCallkitIncoming.endAllCalls();
          showCallkitIncoming(
              newId,
              message.data['type'],
              message.data['sender'],
              message.data['receiver'],
              message.data['senderName'],
              message.data["utilityName"],
              1,
              true);
        }
      });
    }
  }

  await _checkIncomingCallAndroid(message, newId);
}

Future<void> _checkIncomingCallAndroid(
    RemoteMessage message, String newId) async {
  PreferencesRepo preferencesRepo = PreferencesRepo();
  User? user = await preferencesRepo.getUser();

  if (user != null) {
    if (message.data['type'] == "CALL") {
      final String creationTime = message.data['creationTime'] as String;
      DateTime data = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ")
          .parse(creationTime, true)
          .toLocal();
      Duration difference = DateTime.now().difference(data);

      if (difference.inSeconds < 50) {
        await showCallkitIncoming(
            newId,
            message.data['type'],
            message.data['sender'],
            message.data['receiver'],
            message.data['senderName'],
            message.data["utilityName"],
            30000,
            true);
      } else {}
    }
  }
}

void _onCallDeclinedFromCallKit(User user, CallEvent event) {
  SignallingService.instance.socket!.emit('RejectCall', {
    "callerId": event.body['extra']['sender'],
    "calleeId": event.body['extra']['receiver'],
  });
  FlutterCallkitIncoming.endAllCalls();
}

Future<void> showCallkitIncoming(
    String uuid,
    String msg,
    String sender,
    String receiver,
    String name,
    String utilityName,
    int? duration,
    bool? show,
    ) async {
  String nameCaller = "";
  if (utilityName.isEmpty) {
    nameCaller = name;
  } else {
    nameCaller = "$name - $utilityName";


  }

  final params = CallKitParams(
    id: uuid,
    nameCaller: nameCaller,
    appName: 'OmnyQr',
    type: 0,
    duration: duration ?? 30000,
    textAccept: 'Accetta',
    textDecline: 'Rifiuta',
    missedCallNotification: NotificationParams(
      showNotification: show ?? true,
      isShowCallback: false,
      subtitle: 'Missed call',
    ),
    extra: <String, dynamic>{
      'type': msg,
      'sender': sender,
      'receiver': receiver
    },
    headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
    android: const AndroidParams(
      isCustomNotification: false,
      isShowLogo: true,
      ringtonePath: 'system_ringtone_default',
      backgroundColor: '#961132',
      // backgroundUrl: 'assets/test.png',
      actionColor: '#4CAF50',
    ),
    ios: const IOSParams(
      iconName: 'CallKitLogo',
      handleType: '',
      supportsVideo: true,
      maximumCallGroups: 2,
      maximumCallsPerCallGroup: 1,
      audioSessionMode: 'default',
      audioSessionActive: true,
      audioSessionPreferredSampleRate: 44100.0,
      audioSessionPreferredIOBufferDuration: 0.005,
      supportsDTMF: true,
      supportsHolding: true,
      supportsGrouping: false,
      supportsUngrouping: false,
      ringtonePath: 'system_ringtone_default',
    ),
  );
  await FlutterCallkitIncoming.showCallkitIncoming(params);
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  Intl.defaultLocale = 'it';
  //TODO:Remove for release.
  // if (kDebugMode) {
  //   print("Debug");
  //   HttpOverrides.global = MYHttpOvverrides();
  // }
  /*
  Load env file
  */
  await dotenv.load(fileName: ".env");
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCaEmQSIxoBxyDzi1gpxbyBNor3AsP36vY",
          authDomain: "omnyqr-a19ef.firebaseapp.com",
          projectId: "omnyqr-a19ef",
          storageBucket: "omnyqr-a19ef.firebasestorage.app",
          messagingSenderId: "628443235801",
          appId: "1:628443235801:web:c7aecf58668455135ac5c8"
      ),
    );
  } else {
    await Firebase.initializeApp();
  }


  /**
   * Init Firebase
   */

  // remove system device orientation
  if (!kIsWeb && Platform.isIOS) {
    MinePushkit.instance.didReciveIncomingClosedCallNotification = ((event) {
      final String? ssUrl = dotenv.env["SS_URL"];
      String websocketUrl = ssUrl ?? '';
      // generate callerID of local user
      final String selfCallerID = event['receiver'];
      SignallingService.instance.init(
          websocketUrl: websocketUrl,
          selfCallerID: selfCallerID,
          callKit: 'true');
      SignallingService.instance.socket!.emit('RejectCall', {
        "callerId": event['sender'],
        "calleeId": event['receiver'],
      });
    });

    MinePushkit.instance.didCallWithPushNotification = (((payload) {
      SignallingService.instance.socket!.on("closeCallKit", (data) {
        MinePushkit.instance.closeCall();
      });

      final String creationTime = payload['creationTime'] as String;
      DateTime data = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ")
          .parse(creationTime, true)
          .toLocal();

      Duration difference = DateTime.now().difference(data);

      if (difference.inSeconds > 50) {
        MinePushkit.instance.closeCall();
      }

      //  MinePushkit.instance.setAudioSession();
      if (MinePushkit.instance.didReciveIncomingPushNotification == null) {}
    }));

    MinePushkit.instance.didReciveIncomingToken = ((token) async {
      await DeviceRepository(DeviceApiClient(PreferencesRepo()))
          .registerFcmToken(
        '',
        token,
      );
    });
  }

  await Firebase.initializeApp();
  if (kIsWeb) {
    await FirebaseMessaging.instance.deleteToken(); // Elimina token precedente

    final newToken = await FirebaseMessaging.instance.getToken(); // Richiedi nuovo

    final userAgent = html.window.navigator.userAgent;
    final now = DateTime.now().toIso8601String();

    if (newToken != null) {
      print("♻️ Nuovo token Web generato: $newToken");
      print("🧠 UserAgent: $userAgent");
      print("⏱️ Data: $now");

      await DeviceRepository(DeviceApiClient(PreferencesRepo()))
          .registerFcmToken(newToken, '');
    } else {
      print("⚠️ Token FCM Web nullo");
    }
  }

  FirebaseMessaging.instance.onTokenRefresh.listen(
        (event) async {
      await DeviceRepository(DeviceApiClient(PreferencesRepo()))
          .registerFcmToken(
        event,
        '',
      );
    },
  );

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  // remove system device orientation

  await Firebase.initializeApp();

  FirebaseMessaging.onMessage.listen((event) {
    String newId = const Uuid().v4();
    inspect('object');
    SignallingService.instance.socket!.on("closeNotification", (data) async {
      inspect('object');
      if (!kIsWeb && Platform.isAndroid) {
        FlutterCallkitIncoming.endCall(newId);
        FlutterCallkitIncoming.endAllCalls();
        showCallkitIncoming(
            newId,
            event.data['type'],
            event.data['sender'],
            event.data['receiver'],
            event.data['senderName'],
            event.data["utilityName"],
            1,
            true);
      }
    });
    _checkIncomingCallAndroid(event, newId);
    Map<String, dynamic> data = {
      "source": "Internal",
      "data": event.data,
    };
    NotificationManager.instance.sendNotification(data);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    Map<String, dynamic> data = {
      "source": "External",
      "data": event.data,
    };
    NotificationManager.instance.sendNotification(data);
  });

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  // ignore: unused_local_variable
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  // ignore: unused_local_variable
  final notificationSettings =
  await FirebaseMessaging.instance.requestPermission(
    provisional: true,
  );

// For apple platforms, ensure the APNS token is available before making any FCM plugin API calls
  final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
  if (apnsToken != null) {
    // APNS token is available, make FCM plugin API requests...
  }

  /**
   *   var fbToken = await FirebaseMessaging.instance.getToken();
      print(fbToken);
   */

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  if (!kIsWeb) {
    HttpOverrides.global = MyHttpOverrides();
  }
  runApp(
    EasyLocalization(
      path: 'assets/translations',
      supportedLocales: const <Locale>[
        Locale('it'),
        Locale('fr'),
        Locale('en'),
        Locale('de'),
        Locale('ru'),
        Locale('es'),
        Locale('ja'),
        Locale('uk'),
      ],
      fallbackLocale: const Locale('it'),
      useFallbackTranslations: true,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    //Check call when open app from terminated
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      if (!kIsWeb && Platform.isIOS) {}
    }
  }

  @override
  void dispose() async {
    NotificationManager.instance.dispose();
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => AuthRepository(AuthApiClient())),
        RepositoryProvider(
            create: (_) =>
                UtilityRepository(UtilityApiClient(PreferencesRepo()))),
        RepositoryProvider(create: (_) => PreferencesRepo()),
        RepositoryProvider(
            create: (_) => UserRepository(UserApiClient(PreferencesRepo()))),
        RepositoryProvider(
            create: (_) =>
                MessageRepository(MessageApiClient(PreferencesRepo()))),
        RepositoryProvider(
            create: (_) =>
                SearchRepository(SearchApiClient(PreferencesRepo()))),
        RepositoryProvider(
            create: (_) => DeviceRepository(DeviceApiClient(PreferencesRepo())))
      ],
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: ScreenUtilInit(
          builder: (context, widget) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => AuthenticationBloc(
                    context.read<PreferencesRepo>(),
                    context.read<UserRepository>())
                  ..add(AuthenticationInitEvent()),
              ),
              BlocProvider(
                create: (context) => ContainerBloc(
                    context.read<MessageRepository>(),
                    context.read<AuthenticationBloc>(),
                    context.read<PreferencesRepo>(),
                    context.read<UtilityRepository>(),
                    context.read<UserRepository>())
                  ..add(ContainerInit()),
              ),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              // useInheritedMediaQuery: true,
              localizationsDelegates: context.localizationDelegates,
              navigatorObservers: [routeObserver],


              supportedLocales: context.supportedLocales,
              locale: context.locale,
              navigatorKey: navigatorKey,
              initialRoute: Routes.main,
              theme: appTheme,
              routes: {
                Routes.main: (_) => const OnBoardingPage(),
                Routes.anonimous: (_) => LoginPage(),
                Routes.personalArea: (_) => const PersonalAreaPage(),
                Routes.passwordReset: (_) => const PasswordResetPage(),
                Routes.register: (_) => const RegistrationPage(),
                Routes.msgDetails: (_) => const MessageDetails(),
                Routes.createUtils: (_) => const CreateUtilsPage(),
                Routes.personalInformation: (_) =>
                const PersonalInformationPage(),
                Routes.changePassword: (_) => const ChangePasswordPage(),
                Routes.createEditQr: (_) => const CreateEditQrPage(),
                Routes.utilityOverView: (_) => const UtilityOverViewPage(),
                Routes.associationOverView: (_) =>
                const AssociationOverviewPage(),
                Routes.userSearch: (_) => const UserSearchPage(),
                Routes.association: (_) => const AssociationPage(),
                Routes.createAssociation: (_) => const AssociationCreatePage(),
                Routes.availabilities: (_) => const AvailabilitiesPage(),
                Routes.qrScannerPage: (_) => const QrScannerPage(),
                Routes.associationSection: (_) =>
                const AssociationSectionPage(),
                Routes.utilitySection: (_) => const UtilitySectionPage(),
                Routes.messagePage: (_) => const SendMessagePage(),
                Routes.inAppPurchase: (_) => const InAppPurchasePage(),
                Routes.callDeviation: (_) => const CallDeviation(),
              },
              builder: (context, child) {
                return ScaleFactorWidget(
                  child: child!,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
