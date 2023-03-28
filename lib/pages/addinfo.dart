import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_project/pages/executionstatus.dart';
import 'package:firebase_auth_project/pages/googleform.dart';
import 'package:firebase_auth_project/pages/history.dart';
import 'package:firebase_auth_project/pages/home_page.dart';
import 'package:firebase_auth_project/pages/report.dart';
import 'package:flutter/material.dart';

import 'login_register_page.dart';

enum DrawerSections {
  dashboard,
  repair,
  repair_history,
  status,
  estimate,
  addinfo,
}

class AddInfoPage extends StatefulWidget {
  @override
  _AddInfoPageState createState() => _AddInfoPageState();
}

bool _submitEnabled = true;

class _AddInfoPageState extends State<AddInfoPage> {
  DrawerSections currentPage = DrawerSections.dashboard;
  final User? user = FirebaseAuth.instance.currentUser;
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('info');
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController telController = TextEditingController();
  final TextEditingController roomController = TextEditingController();

  String prefixValue = ''; // default prefix value
  List<String> prefixes = ['Mr.', 'Mrs.', 'Ms.'];

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
          title: Text('เพิ่มข้อมูลส่วนตัว'),
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
            child: _entryInfo(),
          ),
        ),
      );
    }
  }

  Widget _entryInfo() {
    return FutureBuilder<DocumentSnapshot>(
        future: usersCollection.doc(user!.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.exists) {
            // User has already added information, show a message
            return Text('You have already submitted your information.');
          } else {
            // User has not yet added information, show the form
            return Form(
              key: _formKey,
              child: Column(children: [
                Row(
                  children: prefixes.map((prefix) {
                    return Row(
                      children: [
                        Radio(
                          value: prefix,
                          groupValue: prefixValue,
                          onChanged: (value) {
                            setState(() {
                              prefixValue = value!;
                            });
                          },
                        ),
                        Text(prefix),
                      ],
                    );
                  }).toList(),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.person, color: Colors.grey[500]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name.';
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
                Builder(
                  builder: (context) => ElevatedButton(
                    onPressed: _submitEnabled
                        ? () {
                            if (_formKey.currentState!.validate()) {
                              // Check if the user has already added information
                              usersCollection
                                  .doc(user!.uid)
                                  .get()
                                  .then((snapshot) {
                                if (snapshot.exists) {
                                  // User has already added information, show a message
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'You have already submitted your information.'),
                                    ),
                                  );
                                } else {
                                  // User has not yet added information, submit the form
                                  if (_formKey.currentState!.validate()) {
                                    // Show a dialog box with a loading indicator while submitting data
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title:
                                              Text('Submitting Information...'),
                                          content: CircularProgressIndicator(),
                                        );
                                      },
                                    );
                                    // Submit data to Firebase and handle the result
                                    FirebaseFirestore.instance
                                        .collection('info')
                                        .add({
                                      'email': user?.email ??
                                          'Unknown user', // add user's email or use a default value if user is null
                                      'prefix': prefixValue,
                                      'name': nameController.text,
                                      'telephone': telController.text,
                                      'room': roomController.text,
                                    }).then((value) {
                                      Navigator.pop(
                                          context); // close the dialog box
                                      setState(() {
                                        _submitEnabled = false;
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Information submitted successfully'),
                                          backgroundColor: Colors.green,
                                          duration: Duration(seconds: 4),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                                      Navigator.pop(
                                          context); // close the dialog box
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Failed to submit information'),
                                        ),
                                      );
                                      print("ADD" + error.toString());
                                    });
                                  }
                                }
                              });
                            }
                          }
                        : null,
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
                        SizedBox(
                            width: 8), // add some space between icon and text
                        Text('Submit'),
                      ],
                    ),
                  ),
                ),
              ]),
            );
          }
        });
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
            "Addข้อมูลส่วนตัว",
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
