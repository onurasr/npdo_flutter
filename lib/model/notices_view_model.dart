import 'package:cloud_firestore/cloud_firestore.dart';
import 'notice_model.dart';
import '../service/database.dart';
import 'package:flutter/material.dart';

class NoticesViewModel extends ChangeNotifier {
  /// noticeview'ın state bilgisini tutmak
  /// noticeview arayüzünün ihtiyacı olan metotları ve hesaplamalrı yapmak
  /// gerekli servislerle konuşmak
  String _collectionPath = 'notices';

  Database _database = Database();

  Stream<List<Notice>> getNoticeList() {
    /// stream<QuerySnapshot> --> Stream<List<DocumentSnapshot>>
    Stream<List<DocumentSnapshot>> streamListDocument = _database
        .getNoticeListFromApi(_collectionPath)
        .map((querySnapshot) => querySnapshot.docs);

    ///Stream<List<DocumentSnapshot>> --> Stream<List<Notice>>
    Stream<List<Notice>> streamListNotice = streamListDocument.map(
        (listOfDocSnap) => listOfDocSnap
            .map((docSnap) => Notice.fromMap(docSnap.data()))
            .toList());

    return streamListNotice;
  }

  Future<void> deleteNotice(Notice notice) async {
    await _database.deleteDocument(
        referecePath: _collectionPath, id: notice.id);
  }
}
