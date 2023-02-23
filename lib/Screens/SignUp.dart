import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:vtroom/Screens/OTPScreen.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _email;
  late String _selectedGender = 'Men';

  late String _phone;
  late String _countryCode = '+880';

  List<String> _genderOptions = ['Men', 'Women', 'Non binary'];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 300,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Signup',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Name',
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your name';
                      }
                      final nameRegExp = RegExp(r'^[A-Za-z ]+$');
                      if (!nameRegExp.hasMatch(value)) {
                        return 'Please enter a valid name';
                      }
                      return null;
                    },
                    onSaved: (value) => _name = value!,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      }
                      final emailRegExp =
                      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegExp.hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    onSaved: (value) => _email = value!,
                  ),

                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Gender',
                      prefixIcon: Icon(Icons.person),
                    ),
                    value: _selectedGender,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedGender = newValue!;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select your gender';
                      }
                      return null;
                    },
                    items: _genderOptions
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    })
                        .toList(),
                  ),


                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        'Phone',
                        style: TextStyle(fontSize: 16),
                      ),

                      SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            prefixIcon: CountryCodePicker(
                              onChanged: (CountryCode? code) {
                                setState(() {
                                  _countryCode = code!.dialCode!;
                                });
                              },
                              initialSelection: 'BD',
                              favorite: ['+880', 'BD'],
                              showCountryOnly: false,
                              alignLeft: false,
                              textStyle: TextStyle(
                                fontSize: 16,
                              ),

                            ),

                          ),
                          keyboardType: TextInputType.phone,


                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            final phoneRegExp = RegExp(r'^\d{10}$');
                            if (!phoneRegExp.hasMatch(value)) {
                              return 'Please enter a valid phone number';
                            }
                            return null;
                          },
                          onSaved: (value) => _phone = _countryCode+value!,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate() && _selectedGender != null) {
                        _formKey.currentState!.save();
                        // TODO: Store data in Firebase Firestore
                        // Create a reference to the signup collection and generate the document id


                        final CollectionReference<Map<String, dynamic>> signupCollection =
                        FirebaseFirestore.instance.collection('signup');
                        final String docId = _phone;

                        // Create a map of the data to be stored
                        final Map<String, dynamic> data = {
                          'Name': _name,
                          'Email': _email,
                          'Gender': _selectedGender,
                          'Phone': _phone,
                        };

                        // Store the data in Firestore
                        signupCollection.doc(docId).set(data);

                        print('Name: $_name');
                        print('Name: $_phone');
                        // Send OTP to phone number

                        final String phone = _phone;
                        final String codeDigits = _countryCode;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OTPControllerScreen(
                              phone: phone, // replace with the user's phone number
                              codeDigits: codeDigits, // replace with the country code, e.g. +91
                            ),
                          ),
                        );
                      }
                    },
                    child: Text('Submit'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.teal, // set the background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // set the radius border
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

        ),
      ),
    );
  }
}
