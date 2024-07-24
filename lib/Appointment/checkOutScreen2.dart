import 'package:astro_app/Appointment/payPage.dart';
import 'package:astro_app/components/buttons.dart';
import 'package:astro_app/components/util.dart';
import 'package:astro_app/services/apiServices.dart';
import 'package:astro_app/services/servicesManeger.dart';
import 'package:astro_app/theme/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';

class CheckoutScreen2 extends StatefulWidget {
  String? amount = '100';
  String? appoId = '10';
  CheckoutScreen2({super.key, this.amount, this.appoId});

  @override
  _CheckoutScreen2State createState() => _CheckoutScreen2State();
}

class _CheckoutScreen2State extends State<CheckoutScreen2> {
  final TextEditingController _couponController = TextEditingController();
    double _discount = 0.0;
  bool isLoading = false;
  int a=10;
String environment="SANDBOX";
    String appId="";
    String merchantId="PGTESTPAYUAT86";
    bool enableLogging=true;
    String checksum="";
    String saltkey="96434309-7796-489d-8924-ab56988a6076";
    String saltindex="1";
    String callbackUrl="https://webhook.site/b5fc8951-42a3-4857-be8a-fdd60dd7a79e";
    String body="";
    Object? result;
    String apiEndPoint="/pg/v1/pay";

     getCheksum(){
     final requesBody= {
        "merchantId": merchantId,
        "merchantTransactionId": "transaction_123",
        "merchantUserId": "90223250",
        "amount": 1000,
        "mobileNumber": "9999999999",
        "callbackUrl": "https://webhook.site/callback-url",
        "paymentInstrument": {
          "type": "PAY_PAGE",
         
        },
       
};

String base64body=base64.encode(utf8.encode(json.encode(requesBody)));
checksum='${sha256.convert(utf8.encode(base64body+apiEndPoint+saltkey)).toString()}###${saltindex}';
return base64body;

    }

  void _applyCoupon() {
    setState(() {
      // Apply coupon logic here, for example:
      if (_couponController.text == 'DISCOUNT10') {
        // _discount = widget.amount! * 0.1; // 10% discount
      } else {
        _discount = 0.0;
      }
    });
  }

  @override
  void initState() {
    phonePayInit();
    body=getCheksum().toString();
    super.initState();
  }
  void phonePayInit(){
    	PhonePePaymentSdk.init(environment, appId, merchantId, enableLogging)
        .then((val) => {
              setState(() {
                result = 'PhonePe SDK Initialized - $val';
              })
            })
        .catchError((error) {
      handleError(error);
      return <dynamic>{};
    });
  }

  void starTrunction()async{
  await  PhonePePaymentSdk.startTransaction(body, callbackUrl, checksum, "")
        .then((response) => {
              setState(() {
                if (response != null) {
                  String status = response['status'].toString();
                  String error = response['error'].toString();
                  if (status == 'SUCCESS') {
                    print('Flow complete');
                    
                  } else {
                 print("flow was not complete");  
                }
                } else {
                  // "Flow Incomplete";
                }
              })
            })
        .catchError((error) {
      // handleError(error)
      return <dynamic>{};
    });
  }
  void handleError(error) {
    setState(() {
      result={
        'error':error
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    String? finalAmount = (widget.amount); // - _discount) + gstAmount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout', style: TextStyle(fontSize: 24)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Appointment Id: ${widget.appoId}',
                style: TextStyle(fontSize: 18)),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Amount', style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 4),
                    Text('\$${widget.amount}',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    const Divider(height: 32),
                    const Text('Discount', style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 4),
                    Text('\$${_discount.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    const Divider(height: 32),
                    const Text('Final Amount', style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 4),
                    Text('\$$finalAmount',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _couponController,
              decoration: InputDecoration(
                labelText: 'Enter Coupon Code',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon:
                    const Icon(Icons.local_offer, color: Colors.deepPurple),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _applyCoupon,
              icon:
                  const Icon(FontAwesomeIcons.checkCircle, color: Colors.white),
              label: const Text('Apply Coupon',
                  style: TextStyle(fontSize: 18, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                showModalBottomSheet(
                    shape: bottomSheetRoundedDesign(),
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(builder:
                          (BuildContext context, StateSetter setState) {
                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15.0, vertical: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Payment Method',
                                          style: kHeaderStyle()),
                                      IconButton(
                                        onPressed: () => Navigator.pop(context),
                                        icon: Icon(Icons.close),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    LoginButton(
                                      title: 'Cash On Delivery',
                                      //  image: 'images/cash.png',
                                      onClick: () {
                                        // checkout(
                                        //   context: context,
                                        //   paymentType: 'Cash On Delivery',
                                        //   paymentStatus: 'Unpaid',
                                        //   paymentId: '',
                                        // );
                                      },
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    LoginButton(
                                      title: 'Online Payment',
                                      // image: 'images/online.png',
                                      onClick: () {
                                         starTrunction();
                                        // Navigator.pushAndRemoveUntil(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (context) =>
                                        //             const PhonePay()),
                                        //     (route) => false);
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 40.0),
                              ],
                            ),
                          ),
                        );
                      });
                    });
              },
              icon:
                  const Icon(FontAwesomeIcons.creditCard, color: Colors.white),
              label: const Text('Pay with PhonePe',
                  style: TextStyle(fontSize: 18, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
      //-------------------
    );
  }

  Future<String> checkout({
    context,
    required String paymentType,
    required String paymentStatus,
    required String paymentId,
  }) async {
    String url = '${APIData.baseURL}api/checkout';
    var res = await http.post(Uri.parse(url), body: {
      'user_id': ServiceManager.userID,
      'payment_method': paymentType,
      'shipping_id': ServiceManager.addressID,
    });
    if (res.statusCode == 200) {
      print(res.body);
      // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
      //     builder: (context) => OrderSuccessfully()), (route) => false);
    } else {
      // toastMessage(message: 'Something went wrong', colors: Colors.red);
      toastMessage(message: 'Error ${res.statusCode}', colors: Colors.red);
      print(res.body);
    }
    return 'Success';
  }
  }
