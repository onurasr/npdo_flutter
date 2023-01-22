import 'dart:convert';

import 'package:npdo_flutter/helper/helper_function.dart';
import 'package:npdo_flutter/widgets/admin_drawer_widget.dart';
import '../model/notice_model.dart';
import '../model/notices_view_model.dart';
import '../pages/update_notice_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import '../service/auth_service.dart';
import 'add_notice_view.dart';

class AdminNoticesView extends StatefulWidget {
  @override
  _AdminNoticesViewState createState() => _AdminNoticesViewState();
}

class _AdminNoticesViewState extends State<AdminNoticesView> {
  String userName = "";
  String email = "";
  AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  gettingUserData() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunctions.getUserNameFromSF().then((val) {
      setState(() {
        userName = val!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return ChangeNotifierProvider<NoticesViewModel>(
      create: (_) => NoticesViewModel(),
      builder: (context, child) => Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
            title: Text(
          'Duyuru Listesi',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 27,
          ),
        )),
        drawer: AdminDrawerWidget(
          userName: userName,
          email: email,
          authService: authService,
          secim: true,
        ),
        body: Stack(
          children: [
            Column(children: [
              StreamBuilder<List<Notice>>(
                stream: Provider.of<NoticesViewModel>(context, listen: false)
                    .getNoticeList(),
                builder: (context, asyncSnapshot) {
                  if (asyncSnapshot.hasError) {
                    print(asyncSnapshot.error);
                    return Center(
                        child: Text(
                            'Bir Hata Oluştu, daha sonra tekrar deneyiniz'));
                  } else {
                    if (!asyncSnapshot.hasData) {
                      return CircularProgressIndicator();
                    } else {
                      List<Notice> duyuruList = asyncSnapshot.data!;
                      return BuildListView(
                          duyuruList: duyuruList); //, key: null,
                    }
                  }
                },
              ),
              Divider(),
            ]),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddNoticeView()));
            },
            child: Icon(Icons.note_add)),
      ),
    );
  }
}

class BuildListView extends StatefulWidget {
  const BuildListView({
    super.key,
    required this.duyuruList,
  });

  final List<Notice> duyuruList;

  @override
  _BuildListViewState createState() => _BuildListViewState();
}

class _BuildListViewState extends State<BuildListView> {
  bool isFiltering = false;
  late List<Notice> filteredList;

  @override
  Widget build(BuildContext context) {
    var fullList = widget.duyuruList;
    return Flexible(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: TextField(
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Arama: Ders Adı',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0))),
              onChanged: (query) {
                if (query.isNotEmpty) {
                  isFiltering = true;

                  setState(() {
                    filteredList = fullList
                        .where((notice) => notice.lessonName
                            .toLowerCase()
                            .contains(query.toLowerCase()))
                        .toList();
                  });
                } else {
                  WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
                  setState(() {
                    isFiltering = false;
                  });
                }
              },
            ),
          ),
          Flexible(
            child: ListView.builder(
                itemCount: isFiltering ? filteredList.length : fullList.length,
                itemBuilder: (context, index) {
                  var list = isFiltering ? filteredList : fullList;
                  return Slidable(
                    child: Card(
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(list[index].noticeData),
                            subtitle: Text(list[index].lessonName),
                          ),
                          Image.memory(
                            base64Decode(list[index].image),
                            height: 300,
                          )
                        ],
                      ),
                    ),
                    startActionPane: ActionPane(
                      motion: const ScrollMotion(),

                      // A pane can dismiss the Slidable.
                      dismissible: DismissiblePane(onDismissed: () {}),
                      children: [
                        SlidableAction(
                          onPressed: (BuildContext context) async {
                            await Provider.of<NoticesViewModel>(context,
                                    listen: false)
                                .deleteNotice(list[index]);
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Sil',
                        ),
                        SlidableAction(
                          onPressed: (BuildContext context) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        UpdateNoticeView(notice: list[index])));
                          },
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: 'Güncelle',
                        ),
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
