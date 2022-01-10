import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/manager.dart';
import 'package:final_project/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:final_project/taxi.dart';
import 'package:final_project/login.dart';
import 'package:final_project/register.dart';
import 'package:provider/provider.dart';
import 'authentication.dart';
import 'driver.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainPage());
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  final _key = GlobalKey<BottomNavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Authentication>(
          create: (_) => Authentication(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<Authentication>().authStateChanges,
          initialData: null,
        ),
      ],
      child: MaterialApp(
        title: 'Main',
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.white,
          fontFamily: 'Time News Roman',
          textTheme: const TextTheme(
            headline1: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
            headline6: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            bodyText2: TextStyle(fontSize: 16.0, fontFamily: 'Hind'),
          ),
        ),
        home: Scaffold(
          appBar: MainAppBar(
            title: '最新消息',
            iconButton: IconButton(
                onPressed: () {
                  setState(() {});
                  _key.currentState?.setState(() {});
                },
                icon: const Icon(Icons.update)),
          ),
          body: ListView(
            children: const [
              BodyCard('some information'),
              BodyCard('some information'),
              BodyCard('some information'),
              BodyCard('some information'),
              BodyCard('some information'),
              BodyCard('some information'),
              BodyCard('some information'),
              BodyCard('some information'),
              BodyCard('some information'),
              BodyCard('some information'),
              BodyCard('some information'),
              BodyCard('some information'),
            ],
          ),
          bottomNavigationBar: BottomNavigator(key: _key),
          floatingActionButton: const BottomNavigatorButton(),
          floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class NavigatorList extends StatelessWidget {
  const NavigatorList({Key? key}) : super(key: key);

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
    final user = FirebaseAuth.instance.currentUser;
    final data = snapshot.data;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          child: user != null && int.parse(data!['permission']) >= 2
              ? IconButton(
                  icon: const Icon(Icons.manage_accounts),
                  color: Colors.white,
                  iconSize: 26,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ManagerPage()));
                  },
                )
              : null,
        ),
        SizedBox(
          child: user != null && int.parse(data!['permission']).isOdd
              ? IconButton(
                  icon: const Icon(Icons.list_alt),
                  color: Colors.white,
                  iconSize: 26,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const DriverPage()));
                  },
                )
              : null,
        ),
        IconButton(
          icon: const Icon(Icons.settings),
          color: Colors.white,
          iconSize: 26,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => user == null ? const LoginPage() : const ProfilePage()));
          },
        ),
      ],
    );
  }
}

class BottomNavigator extends StatefulWidget {
  const BottomNavigator({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => BottomNavigatorState();
}

class BottomNavigatorState extends State<BottomNavigator> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const BottomAppBar(
      color: Colors.green,
      shape: CircularNotchedRectangle(),
      notchMargin: 3.0,
      child: IconTheme(
        data: IconThemeData(
          color: Colors.black,
        ),
        child: NavigatorList(),
      ),
    );
  }
}

class BottomNavigatorButton extends StatelessWidget {
  const BottomNavigatorButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        if (FirebaseAuth.instance.currentUser != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const TaxiPage()));
        }
      },
      tooltip: '叫車',
      child: const Icon(
        Icons.directions_car,
        size: 26,
      ),
      backgroundColor: const Color.fromARGB(255, 66, 66, 66),
    );
  }
}

class BodyCard extends StatelessWidget {
  const BodyCard(this.data, {Key? key}) : super(key: key);

  final String data;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: InkWell(
          splashColor: Colors.red,
          onTap: () {},
          child: SizedBox(
            width: 300,
            height: 120,
            child: Center(
              child: Text(data, style: const TextStyle(fontSize: 20)),
            ),
          ),
        ),
      ),
      heightFactor: 1.5,
    );
  }
}

class MainAppBar extends StatelessWidget with PreferredSizeWidget {
  const MainAppBar({Key? key, required this.title, required this.iconButton}) : super(key: key);

  final String title;
  final IconButton? iconButton;
  final _style = const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      foregroundColor: Colors.black,
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(title, style: _style),
      centerTitle: false,
      leading: iconButton ?? const Icon(null),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
