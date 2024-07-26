import 'dart:convert';

import 'package:astro_app/Auth/forgotPass.dart';
import 'package:astro_app/Auth/registration.dart';
import 'package:astro_app/Home/home.dart';
import 'package:astro_app/components/buttons.dart';
import 'package:astro_app/components/customTextField.dart';
import 'package:astro_app/components/util.dart';
import 'package:astro_app/profile/terms.dart';
import 'package:astro_app/services/apiServices.dart';
import 'package:astro_app/services/servicesManeger.dart';
import 'package:astro_app/theme/style.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isObscure = true;
  bool isLoading = false;
  String message = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    email.text = "soumen@gmail.com";
    password.text = "654321";
    // checkDeviceType();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kBackgroundDesign(context),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.purple[50],
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.purple[100],
          title: const Text('Login'),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                Image.asset(
                  'images/logo.jpg',
                  height: 100,
                  width: 100,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                      textAlign: TextAlign.center,
                      style: kHeaderStyle(color: Colors.blueGrey),
                      "Please enter your valid email address, we don't share it with anyone without your consent"),
                ),
                const SizedBox(height: 40),
                KTextField(
                  title: 'Email',
                  controller: email,
                  textInputType: TextInputType.emailAddress,
                ),
                KTextField(
                  title: 'Password',
                  controller: password,
                  obscureText: isObscure,
                  suffixButton: IconButton(
                    onPressed: () {
                      setState(() {
                        isObscure = !isObscure;
                      });
                    },
                    icon: Icon(!isObscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: TextButton(
                        child: Text(
                          "Forgotten Password?",
                          style: linkTextStyle(context),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForgetPasswordScreen(),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodySmall!.color),
                          children: <TextSpan>[
                            const TextSpan(text: 'By continuing you agree to '),
                            TextSpan(
                              text: 'Terms of Use',
                              style: linkTextStyle(context),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AboutUsScreen()));
                                },
                            ),
                            const TextSpan(text: ' & '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: linkTextStyle(context),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AboutUsScreen()));
                                },
                            ),
                          ])),
                ),
                SizedBox(
                  height: 10,
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(color: Colors.black54),
                    children: <TextSpan>[
                      TextSpan(text: 'Not a registered user ? '),
                      TextSpan(
                        text: 'Sign up',
                        style: linkTextStyle(context),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Registration()));
                          },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 70,
                )
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: isLoading != true
            ? KButton(
                title: 'Login',
                onClick: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      isLoading = true;
                    });

                    loginUser(context);
                  }
                },
              )
            : LoadingButton(),
      ),
    );
  }

  Future<String> loginUser(context) async {
    setState(() {
      isLoading = true;
    });
    String url = APIData.login;
    print(url.toString());
    var res = await http.post(Uri.parse(url), body: {
      'email': email.text,
      'password': password.text,
    });
    if (res.statusCode == 200) {
      print("______________________________________");
      print(res.body);
      print("______________________________________");
      var data = jsonDecode(res.body);
      try {
        print('${data['userInfo']['id']}');
        ServiceManager().setUser('${data['userInfo']['id']}');
        ServiceManager().setToken('${data['auth_token']}');
        ServiceManager.userID = '${data['userInfo']['id']}';
        ServiceManager.tokenID = '${data['auth_token']}';
        toastMessage(message: 'Logged In');
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => Home()), (route) => false);
      } catch (e) {
        toastMessage(message: e.toString());
        setState(() {
          isLoading = false;
        });
        toastMessage(message: 'Something went wrong');
      }
    } else {
      setState(() {
        isLoading = false;
      });
      toastMessage(message: 'Invalid email or password');
    }
    setState(() {
      isLoading = false;
    });
    return 'Success';
  }
}
