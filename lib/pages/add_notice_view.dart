import 'dart:convert';
import 'dart:io';

import 'package:flutter_native_image/flutter_native_image.dart';
import '../service/calculator.dart';
import '../model/add_notice_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class AddNoticeView extends StatefulWidget {
  @override
  _AddNoticeViewState createState() => _AddNoticeViewState();
}

class _AddNoticeViewState extends State<AddNoticeView> {
  TextEditingController lessonCtr = TextEditingController();
  TextEditingController noticedtCtr = TextEditingController();
  TextEditingController publishCtr = TextEditingController();
  TextEditingController imagesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _selectedDate;

  final ImagePicker _pickerImage = ImagePicker();
  dynamic _pickImage;
  var profileImage;

  Widget imagePlace() {
    double height = MediaQuery.of(context).size.height;
    if (profileImage != null) {
      return Container(
          child: Image.memory(base64Decode(profileImage)), height: 200);
    } else {
      if (_pickImage != null) {
        return Container(
          child: Image.network(_pickImage),
          height: 200,
        );
      } else
        return Container(
          child: Image.asset("assets/npdo_logo.png"),
          height: 200,
        );
    }
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
    return ChangeNotifierProvider<AddNoticeViewModel>(
      create: (_) => AddNoticeViewModel(),
      builder: (context, _) => Scaffold(
        appBar: AppBar(title: Text('Yeni Duyuru Ekle')),
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
                          return 'Not Bilgisi Boş Olamaz';
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
                  SizedBox(height: 25),
                  ElevatedButton(
                    child: Text('Kaydet'),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        /// kulanıcı bilgileri ile addNewNotice metodu çağırılacak,
                        await context.read<AddNoticeViewModel>().addNewNotice(
                            lessonName: lessonCtr.text,
                            noticeData: noticedtCtr.text,
                            publishDate: _selectedDate,
                            image: profileImage);

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
