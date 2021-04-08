import 'dart:typed_data';

import 'package:flutter/cupertino.dart';

class AppModel {
  String title;
  String package;
  Uint8List icon;
  bool selected;

  AppModel({this.title, this.package, this.icon, @required this.selected});
}
