import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:madboxes/Auth/authentication.dart';
import 'package:madboxes/Auth/sign_in.dart';
import 'package:madboxes/Utils/theme.dart';
import 'package:provider/src/consumer.dart';
import 'package:rive/rive.dart';

import 'apps_chooser.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({Key key, @required this.user}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Artboard _riveArtboard;
  RiveAnimationController _controller;
  bool _isSigningOut = false;
  double maxHeight;
  double maxWidth;

  static const MethodChannel platform =
      MethodChannel('samples.flutter.io/foregroundApp');

  String _currentForegroundApp = 'Unknown';

  DateTime lastNotificationTime;
  List<String> distractingApps;

  void getData() {}

  Future<void> _getCurrentForegroundApp() async {
    String currentForegroundApp;

    try {
      currentForegroundApp =
          await platform.invokeMethod('getCurrentForegroundApp');
    } on PlatformException catch (e) {
      currentForegroundApp = "Failed to get: '${e.message}'.";
    }

    _currentForegroundApp = currentForegroundApp;
    print(_currentForegroundApp);
  }

  @override
  void initState() {
    super.initState();
    rootBundle.load('assets/phone_drop.riv').then(
      (data) async {
        final file = RiveFile.import(data);
        final artboard = file.mainArtboard;
        artboard.addController(_controller = SimpleAnimation('phone_loop'
            ''));
        setState(() => _riveArtboard = artboard);
      },
    );
    // Timer.periodic(Duration(seconds: 10), (Timer t) => _getCurrentForegroundApp());
  }

}
