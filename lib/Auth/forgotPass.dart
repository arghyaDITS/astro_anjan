import 'dart:convert';

import 'package:astro_app/Auth/resetPassword.dart';
import 'package:astro_app/components/buttons.dart';
import 'package:astro_app/components/customTextField.dart';
import 'package:astro_app/services/apiServices.dart';
import 'package:astro_app/services/servicesManeger.dart';
import 'package:astro_app/theme/style.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ForgetPasswordScreen extends StatefulWidget {
  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController otpController = TextEditingController();
  bool isLoading = false;
  bool isOtp = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailController.text = "soumenpaul4g@gmail.com";

    // checkDeviceType();
  }

  sendresetLink() async {
    setState(() {
      isLoading = true;
    });
    String url = APIData.sendForgotPassOtp;
    print(url);

    var res = await http.post(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${ServiceManager.tokenID}',
    }, body: {
      'email': emailController.text
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
          content: Text("Otp sent to your email and will be valid upto 10 mins"),
        ),
      );
    }
    return 'Success';
  }

  verifyOtp() async {
    setState(() {
      isLoading = true;
    });
    String url = APIData.verifyOtpForgotPass;
    print(url);

    var res = await http.post(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${ServiceManager.tokenID}',
    }, body: {
      'email': emailController.text,
      'otp': otpController.text
    });
    print(res.statusCode);
    if (res.statusCode == 200) {
      //  print(res.body);

      var data = jsonDecode(res.body);
      print(data.toString());
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Otp Verified"),
        ),
      );
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ResetPasswordScreen(
                    email: emailController.text,
                  )));
    }
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
                title: 'Email',
                controller: emailController,
                textInputType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20.0),
              isOtp
                  ? KTextField(
                      title: 'Otp',
                      controller: otpController,
                      textInputType: TextInputType.number,
                    )
                  : Container(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: KButton(
                  onClick: () => isOtp ? verifyOtp() : sendresetLink(),
                  title: isOtp ? 'Verify' : 'Send Otp',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
