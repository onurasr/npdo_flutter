import 'notice_model.dart';
import '../service/calculator.dart';
import '../service/database.dart';
import 'package:flutter/material.dart';

class UpdateNoticeViewModel extends ChangeNotifier {
  Database _database = Database();
  String collectionPath = 'notices';

  Future<void> updateNotice(
      {required String lessonName,
      required String noticedtName,
      required DateTime publishDate,
      required Notice notice,
      required String image}) async {
    /// Form alanındaki verileri ile önce bir duyuru objesi oluşturulması
    Notice newNotice = Notice(
        id: notice.id,
        lessonName: lessonName,
        noticeData: noticedtName,
        image: image,
        publishDate: Calculator.datetimeToTimestamp(publishDate));

    /// bu kitap bilgisini database servisi üzerinden Firestore'a yazacak
    await _database.setNoticeData(
        collectionPath: collectionPath, noticeAsMap: newNotice.toMap());
  }
}
