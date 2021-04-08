import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:madboxes/Models/AppModel.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class MadDatabase {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> addUser(Map<String, dynamic> task, String user_id) async {
    await _db
        .collection('users')
        .doc(user_id)
        .set(task, SetOptions(merge: true));
  }

  static Future<void> addApp(AppModel app, String user_id) async {
    await _db.collection('users').doc(user_id).update({
      'apps': FieldValue.arrayUnion([
        {
          'name': app.title,
          'package': app.package,
          //'description': app.icon,
        }
      ])
    });
  }

  static Future<List<dynamic>> getApps(String user_id) async {
    await _db.collection('users').doc(user_id).get().then((value) {
      {
        return value.data()['installedApps'];
      }
    });
  }
}
