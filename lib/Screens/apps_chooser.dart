import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:googleapis/run/v1.dart';
import 'package:madboxes/Auth/sign_in_button.dart';
import 'package:madboxes/Models/AppModel.dart';
import 'package:madboxes/Models/database.dart';

List installedApps = [];

class appsChooser extends StatefulWidget {
  @override
  _appsChooserState createState() => _appsChooserState();
}

class _appsChooserState extends State<appsChooser> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //return Scaffold(appBar: AppBar(title: Text("HELLO")));
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose your distractions"),
      ),
      body: (ListView.builder(
        itemCount: installedApps.length,
        itemBuilder: (context, int i) => Column(
          children: [
            new CheckboxListTile(
              activeColor: Colors.pink[300],
              dense: true,
              title: new Text(
                installedApps[i].title,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5),
              ),
              subtitle: new Text(installedApps[i].package),
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
      )),
    );
  }
}
