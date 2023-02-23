import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _errorText = '';
  String _countryCode = '+880';

  void _submit() async {
    final phone = _countryCode + _phoneController.text.trim();
    final usersRef = FirebaseFirestore.instance.collection('signup');
    final userDoc = await usersRef.doc(phone).get();
    if (!userDoc.exists) {
      setState(() {
        _errorText = 'Phone number not found';
      });
      return;
    }
    // Save user's login information in a collection called 'logins'
    // with the document ID set to the user's phone number
    final loginsRef = FirebaseFirestore.instance.collection('logins');
    final loginData = {
      'phone': phone,
      'timestamp': FieldValue.serverTimestamp(),
    };
    await loginsRef.doc(phone).set(loginData);
    // Give access to the home page
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 300,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Welcome! to the Login Section',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        CountryCodePicker(
                          onChanged: (code) {
                            setState(() {
                              _countryCode = code.toString();
                            });
                          },
                          initialSelection: 'BD',
                          favorite: ['+880'],
                          showCountryOnly: false,
                          showOnlyCountryWhenClosed: false,
                          alignLeft: false,
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: 'Phone',
                              hintText: 'Enter your phone number',
                              errorText: _errorText,
                            ),
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return 'Phone number is required';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _submit();
                        }
                      },
                      child: Text('Login'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.teal, // set the background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10), // set the radius border
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
