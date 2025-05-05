import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


Route<dynamic> customPageRoute(Widget page, {Object? arguments}) {
  return PageRouteBuilder(
    settings: RouteSettings(arguments: arguments),
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, animation, __, child) {
      if (!kIsWeb && Platform.isIOS) {
        // Animazione tipica Cupertino per iOS
        return CupertinoPageTransition(
          primaryRouteAnimation: animation,
          secondaryRouteAnimation: __,
          linearTransition: true,
          child: child,
        );
      } else {
        // Animazione tipica Material per Android
        return FadeTransition(opacity: animation, child: child);
      }
    },
  );
}
