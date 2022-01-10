import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:final_project/main.dart';

void main() => runApp(const ProfilePage());

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Profile();
  }
}

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  static const _style = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  final user = FirebaseAuth.instance.currentUser;

  Future<DocumentSnapshot> getDocument() async => FirebaseFirestore.instance.collection('data').doc(user?.uid).get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        title: '個人資料',
        iconButton: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: const ProfileList(),
      ),
      bottomNavigationBar: const BottomNavigator(),
      floatingActionButton: const BottomNavigatorButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
    );
  }
}

class ProfileList extends StatelessWidget {
  const ProfileList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('data').doc(user?.uid).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (!snapshot.hasData) return const Text('There is no data');
          return getExpenseItems(context, snapshot);
        });
  }

  getExpenseItems(BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
    const _style = TextStyle(fontSize: 18);
    final data = snapshot.data;
    return Center(
      child: Column(
        children: [
          const SizedBox(
            height: 150,
          ),
          Text('名字: ' + data!['name'], style: _style),
          Text('身份證: ' + data['id'], style: _style),
          Text('電話: ' + data['phone'], style: _style),
          Text('地址: ' + data['address'], style: _style),
          Text('信箱: ' + data['email'], style: _style),
          const SizedBox(
            height: 150,
          ),
          ElevatedButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pop(context);
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                '登出',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
