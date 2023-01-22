import 'dart:convert';
import 'dart:io';

import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';
import '../model/notice_model.dart';
import '../service/calculator.dart';
import '../model/update_notice_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateNoticeView extends StatefulWidget {
  final Notice notice;

  const UpdateNoticeView({required this.notice});

  @override
  _UpdateNoticeViewState createState() => _UpdateNoticeViewState();
}

class _UpdateNoticeViewState extends State<UpdateNoticeView> {
  TextEditingController lessonCtr = TextEditingController();
  TextEditingController noticedtCtr = TextEditingController();
  TextEditingController publishCtr = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _selectedDate;

  final ImagePicker _pickerImage = ImagePicker();
  dynamic _pickImage;
  var profileImage;

  Widget imagePlace() {
    double height = MediaQuery.of(context).size.height;
    if (profileImage != null) {
      return Container(
        child: Image.memory(base64Decode(profileImage!), height: 200),
      );
    } else {
      if (_pickImage != null) {
        return Container(
          child: Image.network(_pickImage),
          height: 200,
        );
      } else
        return Container(
          child: Image.network(_pickImage),
          height: 200,
        );
    }
  }

  @override
  void initState() {
    lessonCtr.text = widget.notice.lessonName;
    noticedtCtr.text = widget.notice.noticeData;
    publishCtr.text = Calculator.dateTimeToString(
        Calculator.datetimeFromTimestamp(widget.notice.publishDate));
    profileImage = widget.notice.image;
    super.initState();
  }

  @override
  void dispose() {
    lessonCtr.dispose();
    noticedtCtr.dispose();
    publishCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UpdateNoticeViewModel>(
      create: (_) => UpdateNoticeViewModel(),
      builder: (context, _) => Scaffold(
        appBar: AppBar(title: Text('Duyuru Bilgisi Güncelle')),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(15),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                      controller: lessonCtr,
                      decoration: InputDecoration(
                          hintText: 'Ders Adı', icon: Icon(Icons.abc)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ders Adı Boş Olamaz';
                        } else {
                          return null;
                        }
                      }),
                  TextFormField(
                      controller: noticedtCtr,
                      decoration: InputDecoration(
                          hintText: 'Not Açıklaması', icon: Icon(Icons.edit)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Not Bilgisi  Boş Olamaz';
                        } else {
                          return null;
                        }
                      }),
                  TextFormField(
                      onTap: () async {
                        _selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(-1000),
                            lastDate: DateTime.now());

                        publishCtr.text =
                            Calculator.dateTimeToString(_selectedDate);
                      },
                      controller: publishCtr,
                      decoration: InputDecoration(
                          hintText: 'Eklenme Tarihi',
                          icon: Icon(Icons.date_range)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lütfen Tarih Seçiniz';
                        } else {
                          return null;
                        }
                      }),
                  SizedBox(height: 25),
                  Center(
                    child: imagePlace(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                          onTap: () => _onImageButtonPressed(ImageSource.camera,
                              context: context),
                          child: Icon(
                            Icons.camera_alt,
                            size: 30,
                            color: Colors.blue,
                          )),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                          onTap: () => _onImageButtonPressed(
                              ImageSource.gallery,
                              context: context),
                          child: Icon(
                            Icons.image,
                            size: 30,
                            color: Colors.blue,
                          ))
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    child: Text('Güncelle'),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        /// kulanıcı bilgileri ile addNotice metodu çağırılacak,
                        await context
                            .read<UpdateNoticeViewModel>()
                            .updateNotice(
                                lessonName: lessonCtr.text,
                                noticedtName: noticedtCtr.text,
                                publishDate: _selectedDate ??
                                    Calculator.datetimeFromTimestamp(
                                        widget.notice.publishDate),
                                image: profileImage,
                                notice: widget.notice);

                        /// navigator.pop
                        Navigator.pop(context);
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onImageButtonPressed(ImageSource source,
      {required BuildContext context}) async {
    try {
      final pickedFile = await _pickerImage.pickImage(source: source);
      File compressedFile =
          await FlutterNativeImage.compressImage(pickedFile!.path, quality: 20);
      var file = await compressedFile.readAsBytes();
      setState(() {
        profileImage = base64Encode(file);
        print("dosyaya geldim: $profileImage");
        if (profileImage != null) {}
      });
    } catch (e) {
      setState(() {
        _pickImage = e;
        print("Image Error: " + _pickImage);
      });
    }
  }
}
