import 'dart:developer';
import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

List<dynamic> events;
var uuid = Uuid();

class Database {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> addUser(Map<String, dynamic> task, String user_id) async {
    await _db
        .collection('users')
        .doc(user_id)
        .set(task, SetOptions(merge: true));
  }

  static Future<List<dynamic>> getApps(String user_id) async {
    await _db.collection('users').doc(user_id).get().then((value) {
      {
        return value.data()['installedApps'];
      }
    });
  }
}
