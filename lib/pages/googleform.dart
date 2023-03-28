import 'package:firebase_auth_project/pages/addinfo.dart';
import 'package:firebase_auth_project/pages/executionstatus.dart';
import 'package:firebase_auth_project/pages/history.dart';
import 'package:firebase_auth_project/pages/home_page.dart';
import 'package:firebase_auth_project/pages/report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

enum DrawerSections {
  dashboard,
  repair,
  repair_history,
  status,
  estimate,
  addinfo,
}

class FormPage extends StatefulWidget {
  const FormPage({required Key key}) : super(key: key);

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  late InAppWebViewController controller;
  DrawerSections currentPage = DrawerSections.dashboard;
  String url =
      "https://docs.google.com/forms/d/e/1FAIpQLSdqUP8tkk3YKe89sGu7EEuIAmdhgjIUYhM4oEvwuOkEzYkHSQ/viewform?pli=1";
  double progress = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text(
          "แบบประเมินความพึงพอใจ",
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: Drawer(
        child: MyDrawerList(),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.grey[200],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: InAppWebView(
                    initialUrlRequest: URLRequest(url: Uri.parse(url)),
                    initialOptions: InAppWebViewGroupOptions(
                        crossPlatform:
                            InAppWebViewOptions(javaScriptEnabled: true)),
                    onWebViewCreated: (controller) =>
                        this.controller = controller,
                    onLoadStart: (controller, url) {
                      setState(() {
                        this.url = url.toString();
                      });
                    },
                    onLoadStop: (controller, url) {
                      setState(() {
                        this.url = url.toString();
                      });
                    },
                    onProgressChanged: (controller, progress) {
                      setState(() {
                        this.progress = progress / 100;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
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
