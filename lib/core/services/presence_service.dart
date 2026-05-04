import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class PresenceService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void configurePresence(String uid) {
    // Reference to the user's presence in Realtime Database
    final presenceRef = _database.ref('status/$uid');
    // Reference to the user's document in Firestore
    final userFirestoreRef = _firestore.collection('users').doc(uid);

    // .info/connected is a special location that returns true when connected and false when disconnected
    _database.ref('.info/connected').onValue.listen((event) async {
      final connected = event.snapshot.value as bool? ?? false;
      
      if (connected) {
        // When connected, set Realtime DB status to true and configure onDisconnect
        await presenceRef.set(true);
        
        // When the client disconnects (app kill, crash, network loss), 
        // Realtime DB will automatically set this to false on the server side.
        presenceRef.onDisconnect().set(false);

        // Update Firestore to Online
        await userFirestoreRef.update({
          'isOnline': true,
          'lastSeen': FieldValue.serverTimestamp(),
        });

        // Optional: We can also sync the Firestore offline status via a Cloud Function 
        // listening to RTDB, but for this prototype, we'll use a local onDisconnect
        // trick if possible, or just rely on the fact that RTDB is the source of truth.
        // For D-chat, we'll stick to updating Firestore directly.
      }
    });

    // Listen to changes in RTDB to update Firestore (The Bridge)
    presenceRef.onValue.listen((event) {
      final isOnline = event.snapshot.value as bool? ?? false;
      userFirestoreRef.update({
        'isOnline': isOnline,
        'lastSeen': FieldValue.serverTimestamp(),
      });
    });
  }

  Future<void> setOffline(String uid) async {
    await _database.ref('status/$uid').set(false);
    await _firestore.collection('users').doc(uid).update({
      'isOnline': false,
      'lastSeen': FieldValue.serverTimestamp(),
    });
  }
}
