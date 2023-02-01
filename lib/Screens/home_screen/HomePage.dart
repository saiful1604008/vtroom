import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vtroom/Screens/LoginPage.dart';
import 'package:vtroom/Screens/NavigationDrawerScreen.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';

class Category {
  final String title;
  final String image;

  Category({required this.title, required this.image});
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final Size size = Get.size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: Text('Home'),
      ),
      drawer: NavigationDrawer(),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // banner
              SizedBox(
                height: size.height / 3.5,
                width: size.width ,
                child: PageView.builder(
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/images/sunglass.PNG',
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // ............indicator.........

              SizedBox(
                height: size.height / 22,
                width: size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < 4; i++) indicator(size, false)
                  ],
                ),
              ),

              // .....categories.....
              categoriesTitle(size, "All Categories", () {}),

              listViewBuilder(size),

              SizedBox(
                height: size.height / 25,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Category>> fetchCategoriesFromFirestore() async {
    List<Category> categories = [];
    var firestore = FirebaseFirestore.instance;
    var query = firestore.collection("Categories");
    var snapshot = await query.get();
    snapshot.docs.forEach((document) {
      categories.add(Category(
          image: document.data()["image"], title: document.data()["title"]));
    });
    return categories;
  }

  Widget listViewBuilder(Size size) {
    return FutureBuilder(
      future: fetchCategoriesFromFirestore(),
      builder: (context, AsyncSnapshot<List<Category>> snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        return Container(
          height: size.height / 4,
          width: size.width,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data?.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      height: size.height / 5,
                      width: size.width / 3.5,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(snapshot.data![index].image),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height / 500),
                    Text(
                      snapshot.data![index].title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget categoriesTitle(Size size, String title, Function function) {
    return SizedBox(
      height: size.height / 15,
      width: size.width / 1.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextButton(
            onPressed: () => function(),
            child: const Text(
              "View More",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget indicator(Size size, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        height: isSelected ? size.height / 80 : size.height / 100,
        width: isSelected ? size.height / 80 : size.height / 100,
        decoration:
            const BoxDecoration(shape: BoxShape.circle, color: Colors.black),
      ),
    );
  }
}
