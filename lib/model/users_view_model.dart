import 'package:cloud_firestore/cloud_firestore.dart';
import 'users_model.dart';
import '../service/database.dart';
import 'package:flutter/material.dart';

class UsersViewModel extends ChangeNotifier {
  String _collectionPath = 'users';

  Database _database = Database();

  Stream<List<Users>> getUsersList() {
    /// stream<QuerySnapshot> --> Stream<List<DocumentSnapshot>>
    Stream<List<DocumentSnapshot>> streamListDocument = _database
        .getUsersListFromApi(_collectionPath)
        .map((querySnapshot) => querySnapshot.docs);

    ///Stream<List<DocumentSnapshot>> --> Stream<List<Users>>
    Stream<List<Users>> streamListUsers = streamListDocument.map(
        (listOfDocSnap) => listOfDocSnap
            .map((docSnap) => Users.fromMap(docSnap.data()))
            .toList());

    return streamListUsers;
  }

  Future<void> deleteUsers(Users users) async {
    await _database.deleteUsers(referecePath: _collectionPath, uid: users.uid);
  }
}
