import 'package:firebase_auth_project/pages/addinfo.dart';
import 'package:firebase_auth_project/pages/adminexecutionstatus.dart';
import 'package:firebase_auth_project/pages/adminhistory.dart';
import 'package:firebase_auth_project/pages/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_project/pages/googleform.dart';
import 'package:firebase_auth_project/pages/history.dart';
import 'package:firebase_auth_project/pages/report.dart';
import 'package:flutter/material.dart';

enum DrawerSections {
  dashboard,
  repair,
  repair_history,
  status,
  estimate,
  addinfo,
}

class AdminHomePage extends StatefulWidget {
  AdminHomePage({Key? key}) : super(key: key);

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final User? user = Auth().currentUser;
  DrawerSections currentPage = DrawerSections.dashboard;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _title() {
    return Row(
      children: [
        Icon(Icons.build, color: Colors.white), // Add the wrench icon here
        SizedBox(width: 10), // Add some space between the icon and text
        Text(
          'Repair Admininterface',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _userUid() {
    return Padding(
      padding: EdgeInsets.only(left: 20.0),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[200],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_outline,
              color: Colors.black,
              size: 28,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                user?.email ?? 'User email',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _signOutButton() {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "Confirm Sign Out",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.red,
                ),
              ),
              content: Text(
                "Are you sure you want to sign out?",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              actions: [
                TextButton(
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                ElevatedButton(
                  child: Text(
                    "Sign Out",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  onPressed: () {
                    signOut();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.logout,
            color: Colors.white,
          ),
          SizedBox(width: 10),
          Text(
            'Sign Out',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Change the background color
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900], // Change the app bar color
        title: _title(),
      ),
      drawer: Drawer(
        child: MyDrawerList(),
      ),

      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: <Widget>[
            Container(
              height: 300,
              child: Image.asset("assets/images/logo.png"),
            ),
            SizedBox(height: 20), // Add some space between the logo and text
            _userUid(),
            SizedBox(height: 20), // Add some space between the text and button
            _signOutButton(),
          ],
        ),
      ),
    );
  }

  Widget MyDrawerList() {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.only(
          top: 15,
        ),
        children: [
          menuItem(
            1,
            "Dashboard",
            Icons.dashboard_outlined,
            currentPage == DrawerSections.dashboard ? true : false,
            () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminHomePage(),
                  ));
            },
          ),
          menuItem(
            2,
            "ประวัติการซ่อม",
            Icons.history_outlined,
            currentPage == DrawerSections.repair_history ? true : false,
            () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminHistoryPage(),
                  ));
            },
          ),
          menuItem(
            3,
            "สถานะการดำเนินการซ่อม",
            Icons.view_list_rounded,
            currentPage == DrawerSections.status ? true : false,
            () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminExecutionStatusPage(),
                  ));
            },
          ),
        ],
      ),
    );
  }

  Widget menuItem(int id, String title, IconData icon, bool selected,
      [Function()? onTap]) {
    return ListTile(
      leading: Icon(
        icon,
        color: selected ? Colors.blue : Colors.black,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: selected ? Colors.blue : Colors.black,
        ),
      ),
      selected: selected,
      onTap: onTap,
    );
  }
}
