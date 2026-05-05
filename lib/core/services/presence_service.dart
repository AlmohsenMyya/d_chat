import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PresenceService with WidgetsBindingObserver {
  final FirebaseDatabase _database = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: "https://d-chat-84fd0-default-rtdb.firebaseio.com/",
  );
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _currentUid;

  StreamSubscription? _connectionSub;
  StreamSubscription? _presenceSub;

  void configurePresence(String uid) async {
    _currentUid = uid;

    final presenceRef = _database.ref('status/$uid');
    final userRef = _firestore.collection('users').doc(uid);

    WidgetsBinding.instance.addObserver(this);

    // 🔌 مراقبة الاتصال
    _connectionSub =
        _database.ref('.info/connected').onValue.listen((event) async {
          final connected = event.snapshot.value;
          final isConnected = connected as bool? ?? false;

          if (!isConnected) return;

          try {
            // ❗ onDisconnect
            await presenceRef.onDisconnect().set({
              'state': 'offline',
              'last_changed': ServerValue.timestamp,
            });

            // ✳️ set online
            await presenceRef.set({
              'state': 'online',
              'last_changed': ServerValue.timestamp,
            });
          } catch (e) {
            debugPrint("Presence RTDB Error: $e");
          }
        });

    // 🔁 bridge من RTDB إلى Firestore
    _presenceSub = presenceRef.onValue.listen((event) {
      final raw = event.snapshot.value;
      if (raw == null || raw is! Map) return;

      final data = Map<String, dynamic>.from(raw);
      final isOnline = data['state'] == 'online';
      final lastChanged = data['last_changed'];

      try {
        userRef.update({
          'isOnline': isOnline,
          'lastSeen': lastChanged != null
              ? Timestamp.fromMillisecondsSinceEpoch(lastChanged)
              : FieldValue.serverTimestamp(),
        });
      } catch (e) {
        debugPrint("Presence Firestore update error: $e");
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_currentUid == null) return;

    final presenceRef = _database.ref('status/$_currentUid');

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      setOffline(_currentUid!);
    } else if (state == AppLifecycleState.resumed) {
      _database.ref('status/$_currentUid').set({
        'state': 'online',
        'last_changed': ServerValue.timestamp,
      });
    }
  }

  Future<void> setOffline(String uid) async {
    await _database.ref('status/$uid').set({
      'state': 'offline',
      'last_changed': ServerValue.timestamp,
    });
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _connectionSub?.cancel();
    _presenceSub?.cancel();
  }
}