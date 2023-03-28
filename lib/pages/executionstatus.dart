import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_project/pages/addinfo.dart';
import 'package:firebase_auth_project/pages/googleform.dart';
import 'package:firebase_auth_project/pages/history.dart';
import 'package:firebase_auth_project/pages/home_page.dart';
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

class ExecutionPage extends StatefulWidget {
  const ExecutionPage({Key? key}) : super(key: key);

  @override
  State<ExecutionPage> createState() => _ExecutionPageState();
}

class _ExecutionPageState extends State<ExecutionPage> {
  DrawerSections currentPage = DrawerSections.dashboard;
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 226, 224, 224),
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text(
          "สถานะการดำเนินการซ่อม",
          style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold),
        ),
      ),
      drawer: Drawer(
        child: MyDrawerList(),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("report")
            .where("email", isEqualTo: user!.email)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: Icon(
                          Icons.assignment,
                          size: 40,
                          color: Colors.blue,
                        ),
                        title: Text(
                          snapshot.data!.docs[index]["topic"],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: 'Roboto',
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.room,
                                  size: 20,
                                  color: Colors.grey[500],
                                ),
                                SizedBox(width: 8),
                                Text(
                                  snapshot.data!.docs[index]["room"],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[500],
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              snapshot.data!.docs[index]["reportinfo"],
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontFamily: 'Roboto',
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              snapshot.data!.docs[index]["status"],
                              style: (snapshot.data!.docs[index]["status"] ==
                                      "approved")
                                  ? TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 19,
                                    )
                                  : TextStyle(
                                      fontSize: 19,
                                      color: Color.fromARGB(255, 248, 1, 1),
                                      fontFamily: 'Roboto',
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
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
