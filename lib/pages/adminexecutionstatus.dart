import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminExecutionStatusPage extends StatefulWidget {
  const AdminExecutionStatusPage({Key? key}) : super(key: key);

  @override
  State<AdminExecutionStatusPage> createState() =>
      _AdminExecutionStatusPageState();
}

class _AdminExecutionStatusPageState extends State<AdminExecutionStatusPage> {
  final user = FirebaseAuth.instance.currentUser;

  Future<void> _approveRepair(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection("report")
          .doc(docId)
          .update({"status": "approved"});
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Repair report approved successfully.")));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error approving repair.")));
      print("Error approving repair: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 226, 224, 224),
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text(
          "การดำเนินการซ่อมAdmin",
          style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("report")
            // .where("email", isEqualTo: user!.email)
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
                String docId = snapshot.data!.docs[index].id;
                String status = snapshot.data!.docs[index]["status"] ?? "";

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
                              style: TextStyle(
                                fontSize: 19,
                                color: Color.fromARGB(255, 248, 1, 1),
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ],
                        ),
                        trailing: status == "approved"
                            ? Text(
                                "Approved",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 19,
                                ),
                              )
                            : ElevatedButton(
                                onPressed: () {
                                  if (status == "approved") {
                                    // do nothing if already approved
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        title: Text("ยืนยันการซ่อม"),
                                        content: Text(
                                            "คุณต้องการยืนยันการซ่อมใช่หรือไม่?"),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text("ยกเลิก"),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              // approve the repair
                                              await _approveRepair(docId);
                                              Navigator.pop(context);
                                            },
                                            child: Text("ยืนยัน"),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                                child: Text("ยืนยันการซ่อม"),
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
}
