import 'notice_model.dart';
import '../service/calculator.dart';
import '../service/database.dart';
import 'package:flutter/material.dart';

class AddNoticeViewModel extends ChangeNotifier {
  Database _database = Database();
  String collectionPath = 'notices';

  Future<void> addNewNotice(
      {required String lessonName,
      required String noticeData,
      required DateTime publishDate,
      required String image}) async {
    /// Form alanındaki verileri ile önce bir duyuru objesi oluşturulması
    Notice newNotice = Notice(
        id: DateTime.now().toString(),
        lessonName: lessonName,
        noticeData: noticeData,
        publishDate: Calculator.datetimeToTimestamp(publishDate),
        image: image);

    /// bu duyuru bilgisini database servisi üzerinden Firestore'a yazacak
    await _database.setNoticeData(
        collectionPath: collectionPath, noticeAsMap: newNotice.toMap());
  }
}
