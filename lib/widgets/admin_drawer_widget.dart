import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:npdo_flutter/pages/add_admin_page.dart';
import 'package:npdo_flutter/pages/admin_home_page.dart';
import 'package:npdo_flutter/pages/admin_notice_view.dart';
import 'package:npdo_flutter/pages/admin_profile_page.dart';
import 'package:npdo_flutter/pages/login_page.dart';
import 'package:npdo_flutter/pages/users_list_page.dart';
import 'package:npdo_flutter/service/auth_service.dart';
import 'package:npdo_flutter/widgets/widgets.dart';

class AdminDrawerWidget extends StatelessWidget {
  const AdminDrawerWidget({
    Key? key,
    required this.userName,
    required this.email,
    required this.secim,
    required this.authService,
  }) : super(key: key);

  final String userName;
  final String email;
  final bool secim;
  final AuthService authService;

  @override
  Widget build(BuildContext context) {
    String groupId = "";
    return Drawer(
        child: ListView(
      padding: const EdgeInsets.symmetric(vertical: 50),
      children: <Widget>[
        Icon(
          Icons.account_circle,
          size: 150,
          color: Colors.grey[700],
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          userName,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 30,
        ),
        const Divider(
          height: 2,
        ),
        ListTile(
          onTap: () {
            nextScreen(context, const AdminHomePage());
          },
          selected: secim,
          selectedColor: Theme.of(context).primaryColor,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          leading: const Icon(Icons.group),
          title: const Text(
            "Gruplar",
            style: TextStyle(color: Colors.black),
          ),
        ),
        ListTile(
          onTap: () {
            nextScreenReplace(context, AdminNoticesView());
          },
          selected: secim,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          leading: const Icon(Icons.announcement),
          title: const Text(
            "Duyurular",
            style: TextStyle(color: Colors.black),
          ),
        ),
        ListTile(
          onTap: () {
            nextScreenReplace(context, UsersListPage());
          },
          selected: secim,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          leading: const Icon(Icons.list),
          title: const Text(
            "Öğrenci Listesi",
            style: TextStyle(color: Colors.black),
          ),
        ),
        ListTile(
          onTap: () {
            nextScreenReplace(context, AddAdminPage());
          },
          selected: secim,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          leading: const Icon(Icons.person_add),
          title: const Text(
            "Admin Ekle",
            style: TextStyle(color: Colors.black),
          ),
        ),
        ListTile(
          onTap: () {
            nextScreenReplace(
                context,
                AdminProfilePage(
                  userName: userName,
                  email: email,
                ));
          },
          selected: secim,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          leading: const Icon(Icons.person),
          title: const Text(
            "Profil",
            style: TextStyle(color: Colors.black),
          ),
        ),
        Divider(),
        ListTile(
          onTap: () async {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Çıkış Yap"),
                    content:
                        const Text("Çıkış Yapmak İstediğinize Emin Misiniz?"),
                    actions: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.cancel,
                          color: Colors.red,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          await authService.signOut();
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                              (route) => false);
                        },
                        icon: const Icon(
                          Icons.done,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  );
                });
          },
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          leading: const Icon(Icons.exit_to_app),
          title: const Text(
            "Çıkış Yap!",
            style: TextStyle(color: Colors.black),
          ),
        )
      ],
    ));
  }
}
