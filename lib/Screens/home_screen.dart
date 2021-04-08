import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:madboxes/Auth/sign_in.dart';
import 'package:madboxes/Utils/theme.dart';
import 'package:rive/rive.dart';
import 'package:madboxes/Auth/authentication.dart';
import 'package:provider/src/consumer.dart';



class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({Key key,@required this.user}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Artboard _riveArtboard;
  RiveAnimationController _controller;
  bool _isSigningOut = false;
  double maxHeight;
  double maxWidth;
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
    maxHeight = MediaQuery.of(context).size.height;
    maxWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Consumer<ThemeNotifier>(
                  builder: (context, notifier, child) => IconButton(
                      icon: notifier.isDarkTheme
                          ? FaIcon(
                        FontAwesomeIcons.moon,
                        size: 20,
                        color: Colors.white,
                      )
                          : Icon(Icons.wb_sunny),
                      onPressed: () => {notifier.toggleTheme()})),
              Consumer<ThemeNotifier>(
                builder: (context, notifier, child) => IconButton(
                    icon: notifier.isDarkTheme
                        ? Icon(
                      Icons.exit_to_app_rounded,
                      size: 20,
                      color: Colors.white,
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
                    }),
              ),
            ],
              ),
            Container(
              color: Colors.black54,
              padding: EdgeInsets.only(top: 25,left: 20,right: 25),
              height: maxHeight/5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text("Karan Kunwar",style: TextStyle(color: Colors.blue,fontSize: 26,fontWeight: FontWeight.bold)),
                      Text("Software Developer",style: TextStyle(color: Colors.white,fontSize: 18)),
                      SizedBox(height: 20,),
                      Text("Stats",style: TextStyle(color: Colors.white,fontSize: 37,fontWeight: FontWeight.w900)),
                    ],
                  ),
                  CircleAvatar(
                    radius: 60,

                    backgroundImage: NetworkImage(widget.user.photoURL),),
                ],
              ),
            ),
            Container(
              color: Theme.of(context).primaryColor,
              height: maxHeight*4/5-100,
              child: Padding(
                padding: EdgeInsets.only(left: 10,right: 10,top: 10),
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      height: 150,
                      child: _riveArtboard == null
                          ? const SizedBox()
                          : Rive(
                        artboard: _riveArtboard,
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Container(
                              color: Colors.red,
                              width: maxWidth/2-20,
                              height: 140,
                            ),
                            SizedBox(height: 20,width: maxWidth/2-40,),
                            Container(
                              color: Colors.lightGreenAccent,
                              width: maxWidth/2-20,
                              height: 140,
                            ),
                          ],
                        ),
                        Container(
                          color: Colors.lightBlueAccent,
                          width: maxWidth/2-20,
                          height: 300,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



