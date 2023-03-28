import 'package:firebase_auth_project/pages/adminhome.dart';
import 'package:firebase_auth_project/pages/auth.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'login_register_page.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key, required String title}) : super(key: key);

  @override
  _WidgetTreeState createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.email == 'nuttapon254426@gmail.com') {
            return AdminHomePage();
          } else {
            return HomePage();
          }
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
