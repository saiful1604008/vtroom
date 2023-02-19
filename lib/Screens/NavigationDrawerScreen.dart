import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vtroom/Screens/LoginPage.dart';
import 'package:vtroom/Screens/CartList.dart';

class NavigationDrawer extends StatefulWidget {
  @override
  _NavigationDrawerState createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("Ecommerce"),
            accountEmail: Text("Contact Us"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
            ),
            decoration: BoxDecoration(
              color: Colors.teal,
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Home"),
            onTap: () {
              // Navigate to home screen
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text("Cart"),
            onTap: () {
              // Navigate to cart screen
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (c) => CartPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.reorder),
            title: Text("Orders"),
            onTap: () {
              // Navigate to orders screen
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Settings"),
            onTap: () {
              // Navigate to settings screen
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Logout"),
            onTap: () async {
              await _auth.signOut();
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (c) => LoginScreen()));
              // Navigate to home screen
            },
          ),
        ],
      ),
    );
  }
}
