import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:final_project/main.dart';
import 'package:intl/intl.dart';

void main() => runApp(const DriverPage());

class DriverPage extends StatelessWidget {
  const DriverPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Driver();
  }
}

class Driver extends StatefulWidget {
  const Driver({Key? key}) : super(key: key);

  @override
  State<Driver> createState() => DriverState();
}

class DriverState extends State<Driver> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: MainAppBar(
          title: '預約界面',
          iconButton: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back))),
      body: user == null
          ? null
          : Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 540,
                    child: ExpenseList(),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, null);
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        '確定',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: const BottomNavigator(),
    );
  }
}

class ExpenseList extends StatelessWidget {
  const ExpenseList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('order').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return const Text('There is no data');
          return ListView(children: getExpenseItems(snapshot));
        });
  }

  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    const _style = TextStyle(fontSize: 18);
    final user = FirebaseAuth.instance.currentUser;
    return snapshot.data?.docs.map((doc) {
        return doc['driver'] == user?.uid ? ListTile(
          title: Text(doc['address'] + ' -----> ' + doc['location'], style: _style),
          subtitle: Text(DateFormat('yyyy/MM/dd HH:mm').format(DateTime.parse(doc['datetime']))),
          trailing: Text(doc['comment'], style: _style),
        ) : const ListTile();
    }).toList();
  }
}
