import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String name;
  final String imageUrl;
  final String price;

  Product({required this.name, required this.imageUrl, required this.price});
}

class MenSunglassesPage extends StatefulWidget {
  const MenSunglassesPage({Key? key}) : super(key: key);

  @override
  _MenSunglassesPage createState() => _MenSunglassesPage();
}

class _MenSunglassesPage extends State<MenSunglassesPage> {
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  void _fetchProducts() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('Men').get();

    setState(() {
      _products = snapshot.docs
          .map((doc) => Product(
                name: doc.data()['name'],
                imageUrl: doc.data()['imageUrl'],
                price: doc.data()['price'],
              ))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Men\'s Sunglasses'),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: _products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,

            ///childAspectRatio: 0.75
          ),
          itemBuilder: (BuildContext context, int index) {
            final Product product = _products[index];
            return SizedBox(
              height: 200,
              child: Card(
                color: Colors.grey[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 1.5,
                          // adjust aspect ratio to make image smaller
                          child: Image.network(
                            product.imageUrl,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 3.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                          product.name,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      const SizedBox(height: 3.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                          product.price,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),

                      ///const Spacer(),
                      const SizedBox(height: 2.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MaterialButton(
                            color: Colors.teal[200],
                            onPressed: () {
                              // TODO: Implement add to cart functionality.
                            },
                            child: const Text('Add to Cart'),
                          ),
                          MaterialButton(
                            color: Colors.teal[200],
                            onPressed: () {
                              // TODO: Implement try on functionality.
                            },
                            child: const Text('Try On'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
