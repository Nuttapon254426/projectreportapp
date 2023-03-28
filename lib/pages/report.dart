import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_project/pages/addinfo.dart';
import 'package:firebase_auth_project/pages/auth.dart';
import 'package:firebase_auth_project/pages/executionstatus.dart';
import 'package:firebase_auth_project/pages/googleform.dart';
import 'package:firebase_auth_project/pages/history.dart';
import 'package:firebase_auth_project/pages/home_page.dart';
import 'package:firebase_auth_project/pages/login_register_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum DrawerSections {
  dashboard,
  repair,
  repair_history,
  status,
  estimate,
  addinfo,
}

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  DrawerSections currentPage = DrawerSections.dashboard;
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('report');
  final _formKey = GlobalKey<FormState>();
  final TextEditingController topicController = TextEditingController();
  final TextEditingController reportinfoController = TextEditingController();
  final TextEditingController telController = TextEditingController();
  final TextEditingController roomController = TextEditingController();
  final GlobalKey<FormState> _formKeyValue = new GlobalKey<FormState>();
  final User? user = Auth().currentUser;
  final firestoreInstance = FirebaseFirestore.instance;
  final Stream<QuerySnapshot> _infoStream =
      FirebaseFirestore.instance.collection('report').snapshots();

  Stream<QuerySnapshot> getItemsStream() {
    return FirebaseFirestore.instance.collection('report').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      // User is not authenticated, redirect to login page
      return LoginPage();
    } else {
      // User is authenticated, show the AddInfoPage
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: Text('แจ้งซ่อม'),
        ),
        drawer: Drawer(
          child: MyDrawerList(),
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: _reportInfo(),
          ),
        ),
      );
    }
  }

  Widget _userUid() {
    return Padding(
      padding: EdgeInsets.only(left: 20.0),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color.fromARGB(255, 226, 224, 224)),
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

  Widget _reportInfo() {
    return ListView(
      children: <Widget>[
        Form(
          key: _formKey,
          child: Column(children: [
            SizedBox(height: 16),
            TextFormField(
              controller: topicController,
              decoration: InputDecoration(
                labelText: 'Topic',
                prefixIcon:
                    Icon(Icons.home_repair_service, color: Colors.grey[200]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your Repotr topic.';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: reportinfoController,
              decoration: InputDecoration(
                labelText: 'Info',
                prefixIcon: Icon(Icons.info, color: Colors.grey[500]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your Repotr Infomation.';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: roomController,
              decoration: InputDecoration(
                labelText: 'Room Number',
                prefixIcon: Icon(Icons.room),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your room number.';
                }
                if (value.length > 4) {
                  return 'Room number should be 4 characters or less.';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: telController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Telephone Number',
                prefixIcon: Icon(Icons.phone, color: Colors.grey[500]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your telephone number.';
                }
                if (!RegExp(r'^\+?[0-9]{10,12}$').hasMatch(value)) {
                  return 'Please enter a valid phone number.';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Show a dialog box with a loading indicator while submitting data
                    showDialog(
                      context: context,
                      barrierDismissible:
                          false, // prevent closing the dialog box by tapping outside it
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Submitting Information...'),
                          content: CircularProgressIndicator(),
                        );
                      },
                    );
                    // Submit data to Firebase and handle the result
                    FirebaseFirestore.instance.collection('report').add({
                      'email': user?.email ?? 'Unknown user',
                      'topic': topicController.text,
                      'reportinfo': reportinfoController.text,
                      'telephone': telController.text,
                      'room': roomController.text,
                      'status':
                          'unapproved', // add the status field with a default value of "unapproved"
                    }).then((value) {
                      Navigator.pop(context); // close the dialog box
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Information submitted successfully'),
                          backgroundColor: Colors.green,
                          duration: Duration(seconds: 4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          behavior: SnackBarBehavior.floating,
                          action: SnackBarAction(
                            label: 'Dismiss',
                            onPressed: () {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                            },
                            textColor: Colors.white,
                          ),
                        ),
                      );
                      print("ADD");
                    }).catchError((error) {
                      Navigator.pop(context); // close the dialog box
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to submit information'),
                        ),
                      );
                      print("ADD" + error.toString());
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // background color
                  textStyle: TextStyle(
                    color: Colors.white, // text color
                    fontWeight: FontWeight.bold, // text font weight
                    fontSize: 18, // text font size
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ), // button padding
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20), // button border radius
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check),
                    SizedBox(width: 8), // add some space between icon and text
                    Text('Submit'),
                  ],
                ),
              ),
            ),
          ]),
        )
      ],
    );
  }

  Widget MyDrawerList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey[50], // Use a custom color scheme
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              "Menu",
              style: TextStyle(
                fontFamily: "Montserrat",
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800], // Use a custom font and color
              ),
            ),
          ),
          SizedBox(height: 20.0),
          Divider(
            color: Colors.grey[500],
            thickness: 1.0,
            height: 1,
            indent: 20.0,
            endIndent: 20.0,
          ),
          SizedBox(height: 20.0),
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
                  builder: (context) => HomePage(),
                ),
              );
            },
          ),
          SizedBox(height: 10.0),
          menuItem(
            2,
            "แจ้งซ่อม",
            Icons.home_repair_service_outlined,
            currentPage == DrawerSections.repair ? true : false,
            () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReportPage(),
                ),
              );
            },
          ),
          SizedBox(height: 10.0),
          menuItem(
            3,
            "ประวัติการซ่อม",
            Icons.history_outlined,
            currentPage == DrawerSections.repair_history ? true : false,
            () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoryPage(),
                ),
              );
            },
          ),
          SizedBox(height: 10.0),
          menuItem(
            4,
            "สถานะการดำเนินการซ่อม",
            Icons.view_list_rounded,
            currentPage == DrawerSections.status ? true : false,
            () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExecutionPage(),
                ),
              );
            },
          ),
          SizedBox(height: 10.0),
          menuItem(
            5,
            "ประเมินการซ่อม",
            Icons.checklist_rtl,
            currentPage == DrawerSections.estimate ? true : false,
            () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FormPage(key: UniqueKey()),
                ),
              );
            },
          ),
          SizedBox(height: 10.0),
          menuItem(
            6,
            "เพิ่มข้อมูลส่วนตัว",
            Icons.person_2,
            currentPage == DrawerSections.addinfo ? true : false,
            () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddInfoPage(),
                ),
              );
            },
          ),
          SizedBox(height: 20.0),
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
