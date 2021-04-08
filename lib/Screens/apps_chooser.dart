import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:madboxes/Models/AppModel.dart';
import 'package:madboxes/Models/database.dart';

import 'home_screen.dart';

List installedApps = [];

class appsChooser extends StatefulWidget {
  final User user;
  const appsChooser({Key key, this.user}) : super(key: key);
  @override
  _appsChooserState createState() => _appsChooserState();
}

class _appsChooserState extends State<appsChooser> {
  @override
  void initState() {
    super.initState();

  }

  Future<void> upload() async {
    List<AppModel> _distractedApps = [];
    for (int i = 0; i < installedApps.length; i++) {
      if (installedApps[i].selected) {
        _distractedApps.add(installedApps[i]);
      }
    }
    for (int i = 0; i < min(_distractedApps.length, 100); i++)
      MadDatabase.addApp(_distractedApps[i], widget.user.uid);
  }

  @override
  Widget build(BuildContext context) {
    //return Scaffold(appBar: AppBar(title: Text("HELLO")));
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text("Choose your distractions"),
        actions: [
          IconButton(
              icon: Icon(Icons.navigate_next),
              onPressed: () {
                upload();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(
                      user: widget.user,
                    ),
                  ),
                );
              }),
        ],
      ),
      body: ListView.builder(
        itemCount: installedApps.length,
        itemBuilder: (context, int i) => Column(
          children: [
            new CheckboxListTile(
              activeColor: Colors.pink[300],
              checkColor: Colors.white,
              dense: true,
              title: new Text(installedApps[i].title,
                  style: Theme.of(context).primaryTextTheme.bodyText1),
              subtitle: new Text(
                installedApps[i].package,
                style: Theme.of(context).primaryTextTheme.bodyText2,
              ),
              value: installedApps[i].selected ?? false,
              secondary: Image.memory(installedApps[i].icon),
              onChanged: (bool value) {
                print('Label has been tapped.');
                setState(() {
                  installedApps[i].selected = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
