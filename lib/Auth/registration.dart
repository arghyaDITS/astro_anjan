import 'dart:convert';
import 'package:astro_app/Auth/login.dart';
import 'package:astro_app/Home/home.dart';
import 'package:astro_app/components/buttons.dart';
import 'package:astro_app/components/customTextField.dart';
import 'package:astro_app/components/util.dart';
import 'package:astro_app/profile/terms.dart';
import 'package:astro_app/services/apiServices.dart';
import 'package:astro_app/services/servicesManeger.dart';
import 'package:astro_app/theme/colors.dart';
import 'package:astro_app/theme/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  bool agreeWithTerms = false;
  bool isLoading = false;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
   bool passwordsMatch = true;
  bool startEditing = false;

  @override
  void initState() {
    super.initState();
    name.text="ap2";
    email.text="ap2@gmail.com";
    mobile.text="9876543212";
    password.text="12345678";
    confirmPassword.text="12345678";

    // getToken();
  }

  // String firebaseFCMToken = '';
  // void getToken() async {
  //   firebaseFCMToken = (await FirebaseMessaging.instance.getToken())!;
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kBackgroundDesign(context),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text('Sign Up'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                 Padding(
                   padding: const EdgeInsets.only(left: 20.0,right: 20.0),
                   child: Image.asset('images/logo.jpg', height: 150,),
                 ),
                Column(
                  children: [
                    KTextField(
                      title: 'Name',
                      controller: name,
                    ),
                    KTextField(
                      title: 'Email',
                      controller: email,
                      textInputType: TextInputType.emailAddress,
                       validation: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    KTextField(
                      title: 'Mobile',
                      controller: mobile,
                      textLimit: 10,
                      textInputType: TextInputType.number,
                     
                    ),
                    KTextField(
                      title: 'Password',
                      controller: password,
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
                      controller: confirmPassword,
                      obscureText: obscureConfirmPassword,
                       onChanged: (value) {
                        setState(() {
                          startEditing = true;

                          passwordsMatch =
                              password.text != confirmPassword.text;
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
                  ],
                ),
                kSpace(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CupertinoSwitch(
                        value: agreeWithTerms,
                        onChanged: (value) {
                          setState(() {
                            agreeWithTerms = value;
                          });
                        },
                      ),
                      SizedBox(width: 5.0),
                      Expanded(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .color),
                            children: <TextSpan>[
                              TextSpan(text: 'I agree with '),
                              TextSpan(
                                text: 'Term & condition',
                                style: linkTextStyle(context),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                   Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AboutUsScreen()));
                                  },
                              ),
                              TextSpan(text: ' and '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: linkTextStyle(context),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                   Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AboutUsScreen()));
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                if (agreeWithTerms != true && isLoading != true)
                  KButton(
                    color: kMainColor.withOpacity(0.1),
                    title: 'Sign Up',
                    onClick: () {},
                  ),
                if (agreeWithTerms != false && isLoading != true)
                  KButton(
                    title: "Sign Up",
                    onClick: () {
                      if (_formKey.currentState!.validate()) {
                        if (password.text == confirmPassword.text) {
                          setState(() {
                            isLoading = true;
                          });
                          registerUser(context);
                        } else {
                          toastMessage(message: "Password doesn't match");
                        }
                      }
                    },
                  ),
                if (isLoading != false) LoadingButton(),
                kSpace(),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodySmall!.color),
                    children: <TextSpan>[
                      TextSpan(text: 'Already a registered user ? '),
                      TextSpan(
                        text: 'Sign In',
                        style: linkTextStyle(context),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()));
                          },
                      ),
                    ],
                  ),
                ),
                kBottomSpace(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void registerUser(context) async {
    String url = APIData.registration;
    print(url);
    var res = await http.post(Uri.parse(url), headers: {
      'Accept': 'application/json',
    }, body: {
      'name': name.text,
      'email': email.text,
      'phone': mobile.text,
      'password': password.text,
      'password_confirmation':confirmPassword.text
    });
    var data = jsonDecode(res.body);
    print(res.statusCode);
    print(res.body);
    if (res.statusCode == 200) {
      //   try{
      ServiceManager().setUser('${data['userInfo']['id']}');
      ServiceManager().setToken('${data['token']}');
      ServiceManager.userID = '${data['userInfo']['id'].toString()}';
      ServiceManager.tokenID = '${data['token']}';
      print(ServiceManager.userID);
      print(ServiceManager.userName);
      toastMessage(message: 'User registered and logged in successfully');
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Login()),
          (route) => false);
      //  } catch (e){
      setState(() {
        isLoading = false;
      });
      //  toastMessage(message: '$e');
      // }
    } else if (res.statusCode == 422) {
     
      setState(() {
        isLoading = false;
      });
      // toastMessage(message: '${data['message']}');
      toastMessage(message: '${data['errors']['email'][0]}');
    }
    else
    {
      setState(() {
        isLoading = false;
      });
      // toastMessage(message: '${data['message']}');
      toastMessage(message: '${data['errors']['email'][0]}');

    }
  }
}
