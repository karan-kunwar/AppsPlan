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

  static const MethodChannel platform = MethodChannel('samples.flutter.io/foregroundApp');

  String _currentForegroundApp = 'Unknown';
  DateTime lastNotificationTime;
  List<String> distractingApps;
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
    rootBundle.load('assets/buggy.riv').then(
      (data) async {
        final file = RiveFile.import(data);
        final artboard = file.mainArtboard;
        artboard.addController(_controller = SimpleAnimation('idle'));
        setState(() => _riveArtboard = artboard);
      },
    );
    Timer.periodic(Duration(seconds: 5), (Timer t) => _getCurrentForegroundApp());
  }

  @override
  Widget build(BuildContext context) {
    Route _routeToSignInScreen() {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => SignInScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(-1.0, 0.0);
          var end = Offset.zero;
          var curve = Curves.ease;

          var tween =
          Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      );
    }
    var scaffoldKey = GlobalKey<ScaffoldState>();
    maxHeight = MediaQuery.of(context).size.height;
    maxWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(
        child: Container(
          color: Theme.of(context).primaryColor,
          child: ListView(
            children: [
              Consumer<ThemeNotifier>(
                  builder: (context, notifier, child) => IconButton(
                      icon: notifier.isDarkTheme
                          ? FaIcon(
                        FontAwesomeIcons.moon,
                        size: 20,
                        color: notifier.isDarkTheme? Colors.white:Colors.black54,
                      )
                          : Icon(Icons.wb_sunny),
                      onPressed: () => {notifier.toggleTheme()})),
              Consumer<ThemeNotifier>(
                builder: (context, notifier, child) => IconButton(
                    icon: notifier.isDarkTheme
                        ? Icon(
                      Icons.exit_to_app_rounded,
                      size: 20,
                      color: notifier.isDarkTheme? Colors.white:Colors.black54,
                    )
                        : Icon(Icons.exit_to_app_rounded),
                    onPressed: () async {
                      setState(() {
                        _isSigningOut = true;
                      });
                      await Authentication.signOut(context: context);
                      setState(() {
                        _isSigningOut = false;
                      });
                      Navigator.of(context)
                          .pushReplacement(_routeToSignInScreen());
                    },
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  color: Colors.black54,
                  padding: EdgeInsets.only(top: 25, left: 20, right: 25),
                  height: maxHeight / 4,
                  child: Column(
                      children: [
                        SizedBox(height:40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 20,),
                                Text(widget.user.displayName,style: GoogleFonts.montserrat(color: Colors.blue, fontSize: 18,fontWeight: FontWeight.bold)),
                                Text("Software Developer",style: TextStyle(color: Colors.white,fontSize: 14)),
                                SizedBox(height: 20,),
                                Text("Welcome",style: GoogleFonts.montserrat(color: Colors.grey, fontSize: 34,fontWeight: FontWeight.bold) ),
                              ],),
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(widget.user.photoURL),
                            ),
                          ],
                        ),
                      ]
                  ),
                ),
                Container(
                  color: Theme.of(context).primaryColor,
                  height: maxHeight * 4 / 5-60,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, top:0),
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),

                          height: 250,
                          child: _riveArtboard == null
                              ? const SizedBox()
                              : Rive(
                            artboard: _riveArtboard,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Container(
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                            (Set<MaterialState> states) {
                                          if (states.contains(MaterialState.pressed))
                                            return Colors.green;
                                          return Colors.red; // Use the component's default.
                                        },
                                      ),
                                    ),
                                    onPressed: () {

                                    },
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children:[
                                        Text("Set",style: GoogleFonts.montserrat(color: Colors.white, fontSize: 42,fontWeight: FontWeight.w700),),
                                        Text("Schedule",style: GoogleFonts.montserrat(color: Colors.white60, fontSize: 30,fontWeight: FontWeight.w700)),
                                      ],
                                    ),
                                  ),
                                  width: maxWidth/2-15,
                                  height: 150,
                                ),
                                SizedBox(height: 10,width: maxWidth/2-30,),
                                Container(
                                  width: maxWidth/2-15,
                                  height: 150,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                            (Set<MaterialState> states) {
                                          if (states.contains(MaterialState.pressed))
                                            return Colors.pink;
                                          return Colors.yellowAccent; // Use the component's default.
                                        },
                                      ),
                                    ),
                                    onPressed: () {

                                    },
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children:[
                                        Text("Modify",style: GoogleFonts.montserrat(color: Colors.red, fontSize: 36,fontWeight: FontWeight.w700),),
                                        Text("Schedule",style: GoogleFonts.montserrat(color: Colors.black45, fontSize: 30,fontWeight: FontWeight.w700)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: maxWidth/2-15,
                              height: 310,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                      if (states.contains(MaterialState.pressed))
                                        return Colors.orangeAccent;
                                      return Colors.blue; // Use the component's default.
                                    },
                                  ),
                                ),
                                onPressed: () {

                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children:[
                                    Text("02hr",style: GoogleFonts.montserrat(color: Colors.white, fontSize: 54,fontWeight: FontWeight.w700),),
                                    Text("26min",style: GoogleFonts.montserrat(color: Colors.white24, fontSize: 40,fontWeight: FontWeight.w700)),
                                    Text("chill\ntime",style: GoogleFonts.montserrat(color: Colors.black45, fontSize: 22,fontWeight: FontWeight.w700)),
                                    Text("remaining",style: GoogleFonts.montserrat(color: Colors.black45, fontSize: 15))
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Container(
                          height: 150,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed))
                                    return Colors.lightBlueAccent;
                                  return Colors.orange; // Use the component's default.
                                },
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => appsChooser(
                                    user: widget.user,
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:[
                                Text("Edit",style: GoogleFonts.montserrat(color: Colors.white, fontSize: 42,fontWeight: FontWeight.w700),),
                                Text("your Preferences",style: GoogleFonts.montserrat(color: Colors.white60, fontSize: 30,fontWeight: FontWeight.w700)),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 50,),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 10,
            top: 20,
            child: IconButton(
              icon: Icon(Icons.menu,color: Colors.white,),
              onPressed: () => scaffoldKey.currentState.openDrawer(),
            ),
          ),
        ],
      ),
    );
  }
}
