import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/task.dart';

class TaskService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get uid => _auth.currentUser!.uid;

  CollectionReference get _userDoc =>
      _db.collection('users').doc(uid).collection(_type);

  late String _type;

  TaskService(String type) {
    _type = type; // dailyTasks / monthlyTasks / yearlyTasks
  }

  Stream<List<Task>> getTasks() {
    return _userDoc.orderBy('createdAt').snapshots().map(
      (snapshot) {
        return snapshot.docs
            .map((doc) => Task.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList();
      },
    );
  }

  Future<void> addTask(String title) async {
    await _userDoc.add({
      'title': title,
      'isDone': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateTask(String id, bool isDone) async {
    await _userDoc.doc(id).update({'isDone': isDone});
  }

  Future<void> deleteTask(String id) async {
    await _userDoc.doc(id).delete();
  }
}
