import 'package:device_apps/device_apps.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:madboxes/Models/AppModel.dart';
import 'package:madboxes/Models/database.dart';
import 'package:madboxes/Screens/apps_chooser.dart';

import 'authentication.dart';

class GoogleSignInButton extends StatefulWidget {
  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

String UID;

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: _isSigningIn
          ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          : OutlinedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
              onPressed: () async {
                setState(() {
                  _isSigningIn = true;
                });
                List _apps = await DeviceApps.getInstalledApplications(
                    onlyAppsWithLaunchIntent: true,
                    includeAppIcons: true,
                    includeSystemApps: false);
                for (var app in _apps) {
                  var item = AppModel(
                    title: app.appName,
                    package: app.packageName,
                    icon: app.icon,
                    selected: false,
                  );
                  installedApps.add(item);
                }
                User user = await Authentication.signInWithGoogle(context: context);

                setState(() {
                  _isSigningIn = false;
                });
                if (user != null) {
                  var curUser = <String, dynamic>{
                    'email': user.email,
                    'photoURL': user.photoURL,
                    'name': user.displayName,
                  };
                  MadDatabase.addUser(curUser, user.uid);
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => appsChooser(
                        user: user,
                      ),
                    ),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(
                      image: AssetImage("assets/google_logo.png"),
                      height: 35.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'Sign in with Google',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
