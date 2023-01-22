import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String uid;
  final String fullName;
  final String email;

  Users({
    required this.uid,
    required this.fullName,
    required this.email,
  });

  /// objeden map oluşturan

  Map<String, dynamic> toMap() => {
        'ud': uid,
        'fullName': fullName,
        'email': email,
      };

  /// mapTen obje oluşturan yapıcı

  factory Users.fromMap(map) => Users(
        uid: map['uid'],
        fullName: map['fullName'],
        email: map['email'],
      );
}
