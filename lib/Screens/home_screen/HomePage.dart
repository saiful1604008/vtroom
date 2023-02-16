import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vtroom/Screens/LoginPage.dart';
import 'package:vtroom/Screens/NavigationDrawerScreen.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:vtroom/Screens/Glass/men.dart';

class Category {
  final String title;
  final String image;

  Category({required this.title, required this.image});
}

class Banner {
  final String url;

  Banner({required this.url});
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

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
                width: size.width,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Banners')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return PageView.builder(
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot banner = snapshot.data!.docs[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(banner["url"]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
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
                  children: [for (int i = 0; i < 2; i++) indicator(size, true)],
                ),
              ),

              // .....categories.....
              categoriesTitle(size, "All Categories", () {}),

              SizedBox(
                height: size.height / 2,
                width: size.width,
                child: FutureBuilder<List<Category>>(
                  future: fetchCategoriesFromFirestore(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Category>> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return GridView.builder(
                      itemCount: snapshot.data!.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: size.width / (size.height / 3),
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        Category category = snapshot.data![index];
                        return GestureDetector(
                          onTap: () {
                            switch (index) {
                              case 0:
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MenSunglassesPage(),
                                  ),
                                );
                                break;
                              case 1:
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                );
                                break;
                              case 2:
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                );
                                break;
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.teal[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: EdgeInsets.all(8),
                            child: Center(
                              child: Text(
                                category.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              SizedBox(
                height: size.height / 25,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Banner>> fetchBannersFromFirestore() async {
    List<Banner> banner = [];
    var firestore = FirebaseFirestore.instance;
    var query = firestore.collection("Banners");
    var snapshot = await query.get();
    snapshot.docs.forEach((document) {
      banner.add(Banner(
        url: document.data()["url"],
      ));
    });
    return banner;
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
