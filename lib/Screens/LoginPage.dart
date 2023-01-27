import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:vtroom/Screens/OTPScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vtroom/Screens/HomePage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String dialCodeDigits = "+880";
  TextEditingController _controller = TextEditingController();

  void saveDataToFirestore(String phone, String codeDigits) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final CollectionReference usersCollection = firestore.collection('users');

    try {
      await usersCollection.add({
        'phone': phone,
        'codeDigits': codeDigits,
      });
      print("Data added successfully to Firestore");
    } catch (e) {
      print("Error adding data to Firestore: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Image.asset("assets/images/login.png"),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: const Center(
                child: Text(
                  "Welcome to the Login Section",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            SizedBox(
              width: 400,
              height: 60,
              child: CountryCodePicker(
                onChanged: (country) {
                  setState(() {
                    dialCodeDigits = country.dialCode!;
                  });
                },
                initialSelection: "BD",
                showCountryOnly: false,
                showOnlyCountryWhenClosed: false,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10, right: 10, left: 10),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Phone Number",
                  labelStyle: TextStyle(color: Colors.teal),
                  prefix: Padding(
                    padding: EdgeInsets.all(4),
                    child: Text(dialCodeDigits),
                  ),
                ),
                maxLength: 11,
                keyboardType: TextInputType.number,
                controller: _controller,
              ),
            ),
            Container(
              margin: EdgeInsets.all(15),
              width: double.infinity,
              child: MaterialButton(
                onPressed: () async {

                  final FirebaseFirestore firestore =
                      FirebaseFirestore.instance;
                  final CollectionReference usersCollection =
                      firestore.collection('users');
                  final QuerySnapshot snapshot = await usersCollection
                      .where("phone", isEqualTo: _controller.text)
                      .get();
                  if (snapshot.docs.length == 0) {
                    saveDataToFirestore(_controller.text, dialCodeDigits);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (c) => OTPControllerScreen(
                              phone: _controller.text,
                              codeDigits: dialCodeDigits,
                            )));
                  } else {
                    // Phone number found in Firestore
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (c) => HomeScreen()));
                  }
                },

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.black12),
                ),
                color: Colors.teal,
                child: const Text(
                  'Next',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
