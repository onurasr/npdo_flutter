import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:npdo_flutter/service/database.dart';
import 'package:npdo_flutter/widgets/widgets.dart';

popUpDialog() {
  String userName = "";
  bool _isLoading = false;
  String groupName = "";

  barrierDismissible:
  false;
  builder:
  (context) {
    return StatefulBuilder(builder: ((context, setState) {
      return AlertDialog(
        title: const Text(
          "Grup Oluştur!",
          textAlign: TextAlign.left,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _isLoading == true
                ? Center(
                    child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor),
                  )
                : TextField(
                    onChanged: (val) {
                      setState(() {
                        groupName = val;
                      });
                    },
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(20)),
                        errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(20)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(20))),
                  ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor),
            child: const Text("İPTAL"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (groupName != "") {
                setState(() {
                  _isLoading = true;
                });
                Database(uid: FirebaseAuth.instance.currentUser!.uid)
                    .createGroup(userName,
                        FirebaseAuth.instance.currentUser!.uid, groupName)
                    .whenComplete(() {
                  _isLoading = false;
                });
                Navigator.of(context).pop();
                showSnackbar(
                    context, Colors.green, "Grup başarıyla oluşturuldu.");
              }
            },
            style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor),
            child: const Text("OLUŞTUR"),
          )
        ],
      );
    }));
  };
}
