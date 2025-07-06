import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/note_model.dart';

class NoteRepository {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<List<Note>> fetchNotes() async {
    final uid = _auth.currentUser?.uid;
    final snapshot = await _firestore
        .collection('notes')
        .where('userId', isEqualTo: uid)
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => Note(id: doc.id, text: doc['text']))
        .toList();
  }

  Future<void> addNote(String text) async {
    final uid = _auth.currentUser?.uid;
    await _firestore.collection('notes').add({
      'text': text,
      'userId': uid,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateNote(String id, String text) async {
    await _firestore.collection('notes').doc(id).update({
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteNote(String id) async {
    await _firestore.collection('notes').doc(id).delete();
  }
}
