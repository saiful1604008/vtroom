import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CartProduct {
  final String name;
  final String imageUrl;
  final String price;

  CartProduct({required this.name, required this.imageUrl, required this.price});
}

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartProduct> _cartProducts = [];

  @override
  void initState() {
    super.initState();

    // Fetch cart products from Firestore and populate _cartProducts list
    FirebaseFirestore.instance
        .collection('cart')
        .get()
        .then((QuerySnapshot snapshot) {
      List<CartProduct> cartProducts = [];

      snapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;

        CartProduct cartProduct = CartProduct(
          name: data['name'],
          imageUrl: data['imageUrl'],
          price: data['price'],
        );

        cartProducts.add(cartProduct);
      });

      setState(() {
        _cartProducts = cartProducts;
      });
    });
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: _cartProducts.isNotEmpty
            ? ListView.builder(
          itemCount: _cartProducts.length,
          itemBuilder: (BuildContext context, int index) {
            final CartProduct cartProduct = _cartProducts[index];
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
                            cartProduct.imageUrl,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 3.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                          cartProduct.name,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      const SizedBox(height: 3.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                          cartProduct.price,
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
                              setState(() {
                                _cartProducts.removeAt(index);
                              });

                              // Show snackbar to inform user that product was removed
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Product removed from cart'),
                                duration: const Duration(seconds: 2),
                                action: SnackBarAction(
                                  label: 'Undo',
                                  onPressed: () {
                                    setState(() {
                                      _cartProducts.insert(index, cartProduct);
                                    });
                                  },
                                ),
                              ));
                            },
                            child: const Text('Remove'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        )
            : const Center(
          child: Text('No items in cart'),
        ),
      ),
    );
  }
}
