import 'package:final_project/taxi.dart';
import 'package:flutter/material.dart';
import 'package:final_project/login.dart';
import 'package:final_project/register.dart';

void main() => runApp(const MainPage());

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
          iconButton: IconButton(onPressed: () {}, icon: const Icon(Icons.home)),
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
        bottomNavigationBar: const BottomNavigator(),
        floatingActionButton: const BottomNavigatorButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class NavDrawer extends StatelessWidget {
  const NavDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const drawerHeader = UserAccountsDrawerHeader(
      accountName: Text('Name'),
      accountEmail: Text('Email'),
      currentAccountPicture: CircleAvatar(
        child: FlutterLogo(size: 42.0),
      ),
    );

    final drawerItems = ListView(
      children: [
        drawerHeader,
        ListTile(
          title: const Text('1'),
          leading: const Icon(Icons.favorite),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: const Text('2'),
          leading: const Icon(Icons.comment),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    );

    return Drawer(
      child: drawerItems,
    );
  }
}

class BottomNavigator extends StatelessWidget {
  const BottomNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.green,
      shape: const CircularNotchedRectangle(),
      notchMargin: 3.0,
      child: IconTheme(
        data: const IconThemeData(
          color: Colors.black,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              color: Colors.white,
              iconSize: 26,
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              color: Colors.white,
              iconSize: 26,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
    // return BottomNavigationBar(
    //   currentIndex: 0,
    //   fixedColor: Colors.black,
    //   backgroundColor: Colors.white,
    //   elevation: 0,
    //   items: const [
    //     BottomNavigationBarItem(
    //       icon: Icon(Icons.home),
    //       label: 'Home',
    //     ),
    //     BottomNavigationBarItem(
    //       icon: Icon(Icons.car_rental),
    //       label: 'Messages',
    //     ),
    //     BottomNavigationBarItem(
    //       icon: Icon(Icons.person),
    //       label: 'Profile',
    //     )
    //   ],
    // );
  }
}

class BottomNavigatorButton extends StatelessWidget {
  const BottomNavigatorButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const TaxiPage()));
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
