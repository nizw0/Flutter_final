import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:final_project/main.dart';
import 'package:intl/intl.dart';

void main() => runApp(const ManagerPage());

class ManagerPage extends StatelessWidget {
  const ManagerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Manager();
  }
}

class Manager extends StatefulWidget {
  const Manager({Key? key}) : super(key: key);

  @override
  State<Manager> createState() => ManagerState();
}

class ManagerState extends State<Manager> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: MainAppBar(
          title: '派送界面',
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
                      Navigator.pop(context);
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
      floatingActionButton: const BottomNavigatorButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
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
    return snapshot.data?.docs
        .map((doc) => ListTile(
              title: Text(
                  doc['address'] +
                      ' / ' +
                      doc['passenger'].toString().substring(0, 5) +
                      '\n' +
                      doc['location'] +
                      ' / ' +
                      doc['driver'].toString().substring(0, 5),
                  style: _style),
              subtitle: Text(DateFormat('yyyy/MM/dd HH:mm').format(DateTime.parse(doc['datetime']))),
              trailing: Text(doc['comment'], style: _style),
            ))
        .toList();
  }
}
