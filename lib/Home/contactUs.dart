import 'dart:convert';

import 'package:astro_app/Home/home.dart';
import 'package:astro_app/components/buttons.dart';
import 'package:astro_app/services/apiServices.dart';
import 'package:astro_app/services/servicesManeger.dart';
import 'package:astro_app/theme/style.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ContactUsScreen extends StatefulWidget {
  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameCon = TextEditingController();

  final TextEditingController emailCon = TextEditingController();

  final TextEditingController phoneCon = TextEditingController();

  final TextEditingController msgCon = TextEditingController();
  String _name = '';
  String _email = '';
  String _phone = '';
  String _message = '';
  bool isLoading = false;
  sendrequest() async {
    isLoading = true;
    String url = APIData.contactUs;
    print(url);

    var res = await http.post(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${ServiceManager.tokenID}',
    }, body: {
      'name': nameCon.text,
      'email': emailCon.text,
      'phone': phoneCon.text,
      'message': msgCon.text
    });
    print(res.statusCode);
    print(res.body);
    if (res.statusCode == 200) {
      print(res.body);
       Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            builder: (context) => Home()), (route) => false);

    //  var data = jsonDecode(res.body);
    }
    isLoading = false;
    return 'Success';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us'),
        backgroundColor: const Color.fromARGB(255, 177, 142, 236),
      ),
      body: Container(
        decoration: kBackgroundDesign(context),
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'We would love to hear from you!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                _buildContactForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: nameCon,
            decoration: InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
            onSaved: (value) => _name = value ?? '',
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: emailCon,
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
            onSaved: (value) => _email = value ?? '',
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: phoneCon,
            decoration: InputDecoration(
              labelText: 'Phone',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.phone),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              return null;
            },
            onSaved: (value) => _phone = value ?? '',
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: msgCon,
            decoration: InputDecoration(
              labelText: 'Message',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.message),
            ),
            maxLines: 5,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your message';
              }
              return null;
            },
            onSaved: (value) => _message = value ?? '',
          ),
          SizedBox(height: 80),
        isLoading==true?LoadingButton():  KButton(
              title: "Submit",
              onClick: () {
                if (_formKey.currentState?.validate() ?? false) {
                  _formKey.currentState?.save();
                  sendrequest();
                  // Handle form submission logic
                  print('Name: $_name');
                  print('Email: $_email');
                  print('Phone: $_phone');
                  print('Message: $_message');
                }
              }),
        ],
      ),
    );
  }
}
