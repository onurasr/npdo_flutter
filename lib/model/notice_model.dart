import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Notice {
  final String id;
  final String lessonName;
  final String noticeData;
  final String image;
  final Timestamp publishDate;

  Notice({
    required this.id,
    required this.lessonName,
    required this.noticeData,
    required this.image,
    required this.publishDate,
  });

  /// objeden map oluşturan

  Map<String, dynamic> toMap() => {
        'id': id,
        'lessonName': lessonName,
        'noticeData': noticeData,
        'publishDate': publishDate,
        'image': image,
      };

  /// mapTen obje oluşturan yapıcı

  factory Notice.fromMap(map) => Notice(
        id: map['id'],
        lessonName: map['lessonName'],
        noticeData: map['noticeData'],
        image: map['image'] ?? "",
        publishDate: map['publishDate'],
      );
}
