import 'dart:convert';

import 'package:astro_app/Auth/login.dart';
import 'package:astro_app/components/buttons.dart';
import 'package:astro_app/components/customTextField.dart';
import 'package:astro_app/components/util.dart';
import 'package:astro_app/services/apiServices.dart';
import 'package:astro_app/services/servicesManeger.dart';
import 'package:astro_app/theme/style.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ResetPasswordScreen extends StatefulWidget {
  String? email;
  ResetPasswordScreen({super.key, this.email});
  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController passController = TextEditingController();

  final TextEditingController conPassController = TextEditingController();
  bool isLoading = false;
  bool isOtp = false;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool passwordsMatch = true;
  bool startEditing = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  changePassword() async {
    setState(() {
      isLoading = true;
    });
    String url = APIData.chnagePassword;
    print(url);

    var res = await http.post(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${ServiceManager.tokenID}',
    }, body: {
      'email': widget.email,
      'new_password': passController.text,
      'confirm_password': conPassController.text
    });
    print(res.statusCode);
    if (res.statusCode == 200) {
      //  print(res.body);

      var data = jsonDecode(res.body);
      print(data.toString());
      setState(() {
        isLoading = false;
        isOtp = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password reset successfully!"),
        ),
      );
       Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Login()),
          (route) => false);
    }
    setState(() {
      isLoading=false;
    });
    return 'Success';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forget Password"),
      ),
      body: Container(
        decoration: kBackgroundDesign(context),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              KTextField(
                title: 'New Password',
                controller: passController,
                obscureText: obscurePassword,
                suffixButton: IconButton(
                  onPressed: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
                  icon: Icon(obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text('Password must be of 8 character',
                        style: k12Text()),
                  ),
                ],
              ),
              KTextField(
                title: 'Confirm Password',
                controller: conPassController,
                obscureText: obscureConfirmPassword,
                onChanged: (value) {
                  setState(() {
                    startEditing = true;

                    passwordsMatch =
                        passController.text != conPassController.text;
                  });
                },
                suffixButton: IconButton(
                  onPressed: () {
                    setState(() {
                      obscureConfirmPassword = !obscureConfirmPassword;
                    });
                  },
                  icon: Icon(obscureConfirmPassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined),
                ),
                errorText: passwordsMatch && startEditing
                    ? 'Passwords do not match'
                    : null,
              ),
              SizedBox(height: 5.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: isLoading==true?LoadingButton(): KButton(
                    onClick: () {
                      // if (_formKey.currentState!.validate()) {
                      if (passController.text == conPassController.text) {
                        setState(() {
                          isLoading = true;
                        });
                        changePassword();
                      } else {
                        toastMessage(message: "Password doesn't match");
                      }
                    },
                    title: 'Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
