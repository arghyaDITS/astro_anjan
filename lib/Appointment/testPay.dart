// // ignore_for_file: must_be_immutable

// import 'dart:async';
// import 'dart:convert';
// import 'dart:math';
// import 'dart:typed_data';

// import 'package:crypto/crypto.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:http/http.dart';
// import 'package:intl/intl.dart';
// import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';

// import 'paymentscreen.dart';

// class Booking extends StatefulWidget {
//   String hotelId;
//   String roomtype;
//   String mealtype;
//   String roomId;
//   String dueAmount;
//   String hoteltype;
//   String roomName;

//   Booking(
//       {required this.hotelId,
//       required this.roomtype,
//       required this.mealtype,
//       required this.roomId,
//       required this.dueAmount,
//       required this.hoteltype,
//       required this.roomName
//       });

//   @override
//   State<Booking> createState() => _BookingState();
// }

// class _BookingState extends State<Booking> {
//   TextEditingController firstname = TextEditingController();
//   TextEditingController lastname = TextEditingController();
//   TextEditingController email = TextEditingController();
//   TextEditingController number = TextEditingController();
//   TextEditingController address = TextEditingController();
//   TextEditingController startdate = TextEditingController();
//   TextEditingController enddate = TextEditingController();
//   TextEditingController coupontext = TextEditingController();
//   final _formkey = GlobalKey<FormState>();
//   final booking = Get.put(BookingCont());
//   CalBookingpriceData price = CalBookingpriceData();
//   BookingData bookingdata = BookingData();
//     DateMange date= new DateMange();
//     CalBookingpriceM _calBookingpriceM=CalBookingpriceM();

//   // var coupon;
//   var error;

//   bool loader = true;

//   //PhonePe Params
//   String environment = "PRODUCTION";
//   String appId = "dd9895738c834d31a05dfb778f6e718a";
//   String merchantId = "M1JANB3EQPGU";
//   bool enableLogging = true;
//   String slatKey = "6416a218-710c-4af1-a348-c2b33ebacc1d";
//   String slatIndex = "1";
//   String callbackUrl =
//       "https://webhook.site/6145154b-a10b-451c-a19c-c63b368f8255";
//   String body = "";
//   String checksum = "";
//   Object? result;
//   String apiEndPoint = "/pg/v1/pay";
  

//   @override
//   void initState() {
  
//     phonePeInit();
//     Date();
//     print('------------------hotelId--------------${widget.hotelId}');
//     print('------------------roomtype--------------${widget.roomtype}');
//     print('------------------mealtype--------------${widget.mealtype}');
//     print('------------------roomId--------------${widget.roomId}');
//     print('------------------hoteltype--------------${widget.hoteltype}');

//     print("the amount "+widget.dueAmount);
//     startdate.text=DateMange.checkIndate;
//     enddate.text=DateMange.chekOutDate;
  
//     load();
//     super.initState();
//   }

//   DateTime? today;
//   String? cdate;
//   String? ydate;
//     String? cdate1;
//   String? ydate2;

 

//   Date() {
//     today = DateTime.now();
//     cdate = DateFormat("yyyy-MM-dd ").format(today!);
//     DateTime yesterday = today!.add(const Duration(days: 1));
//     ydate = DateFormat("yyyy-MM-dd ").format(yesterday);
//     print('$cdate');
//     print('$ydate');

//     print(bookingdata.bookingId.toString());
//   }

//   var _paymentResponse = 'Unknown';

//   startInstamojo({orderId, islive,bookingId}) async {


//     var rng = new Random();
//     var code = rng.nextInt(900000) + 100000;

//     final getUserId = GetUserDetail();
//     var userId = await getUserId.getUserData('id');
//     String transactionId = "${code}-${DateTime.now().millisecondsSinceEpoch.toString()}";
//     body = getChecksum(transactionId, userId).toString();
//     Timer(const Duration(seconds: 1), () async => await startPgTransaction(transactionId, orderId,bookingId));
//   }

//   startPgTransaction(transactionId, orderId,int bookingId) {
//     try {
//       print("booking validation body");
//       print("bookingId "+bookingId.toString());
//       print("transaction "+transactionId);
//       print("transaction "+orderId);

//       var response = PhonePePaymentSdk.startTransaction(
//           body, callbackUrl, checksum,"",);
//       response
//           .then((val) => {
//                 setState(() {
//                   if (val != null) {
//                     print("REPONSE---$val");
//                     String status = val['status'].toString();
//                     String error = val['error'].toString();
//                           if (status == 'SUCCESS') {
//                             result = "Flow Completed - Status: Success!";
//                             BookingValApi()
//                                 .bookingvalidationApi(
//                                     // payment_id: transactionId,
//                                     // payment_status: "PAYMENT_SUCCESS",
//                                     // statusCode: "200",
//                                     // orderId: orderid,
//                                     booking_id: bookingId.toString(),
//                                     paymet_status: "PAYMENT_SUCCESS",
//                                     paymet_id: transactionId,
//                                     order_id: orderId,
                                   
//                                     context: context)
//                                 .then((value) {
//                               Get.off(() => Mybooking());
//                             });
//                           } else {
//                             BookingValApi()
//                                 .bookingvalidationApi(
//                                 // payment_id: transactionId,
//                                 // payment_status: "Failed",
//                                 // statusCode: "400",
//                                 // orderId: orderid,
//                                   booking_id: bookingId.toString(),
//                                   paymet_status: "Failed",
//                                   paymet_id: transactionId,
//                                   order_id: orderId,
//                                   context: context
//                                   )
//                                 .then((value) {
//                               Get.off(() => {});
//                             });

//                             result =
//                                 "Flow Completed - Status: $status and Error: $error";
//                           }
//                   } else {
//                     BookingValApi()
//                         .bookingvalidationApi(
//                         booking_id: bookingId.toString(),
//                         paymet_status: "Failed",
//                         paymet_id: transactionId,
//                         order_id: orderId,
//                         context: context)
//                         .then((value) {
//                       Get.off(() =>{});
//                     });

//                     result = "Flow Incomplete";
//                   }
//                 })
//               })
//           .catchError((error) {
//         handleError(error);
//         return <dynamic>{};
//       });
//     } catch (error) {
//       handleError(error);
//     }
//   }

//   String getChecksum(transactionId, userId)  {

//     final reqData =  {
//       "merchantId": merchantId,
//       "merchantTransactionId": "najara_${DateTime.now().millisecondsSinceEpoch.toString()}",
//       "merchantUserId": userId,
//       "amount": (price?.price ?? 1) * 100,
//       "mobileNumber": number.text,
//       "callbackUrl": callbackUrl,
//       "paymentInstrument": {
//         "type": "PAY_PAGE",
//         //   "type": "UPI_INTENT",
//         // "targetApp": "com.phonepe.app"
//       },
//       "deviceContext": {
//         "deviceOS": "ANDROID"
//       }
//     };
//     // final reqData = {
//     //   "merchantId": merchantId,
//     //   "merchantTransactionId":transactionId,
//     //   "merchantUserId": "90223250",
//     //   "amount": 100,
//     //   "mobileNumber": "9999999999",
//     //   "callbackUrl": callbackUrl,
//     //   "paymentInstrument": {
//     //     "type": "PAY_PAGE",
//     //     //   "type": "UPI_INTENT",
//     //     // "targetApp": "com.phonepe.app"
//     //   },
//     //   "deviceContext": {"deviceOS": "ANDROID"}
//     // };
//     String base64Body = base64.encode(utf8.encode(json.encode(reqData)));
//     checksum =
//         "${sha256.convert(utf8.encode(base64Body + apiEndPoint + slatKey)).toString()}###$slatIndex";
//     return base64Body;
//   }

//   void phonePeInit() {
//     PhonePePaymentSdk.init(environment, appId, merchantId, enableLogging)
//         .then((val) => {
//               setState(() {
//                 result = 'PhonePe SDK Initialized - $val';
//               })
//             })
//         .catchError((error) {
//       handleError(error);
//       print(error.toString());

//       return <dynamic>{};
//     });
//   }

//   void handleError(error) {
//     setState(() {
//       CommonToast(context: context, title:error.toString(), alignCenter: true);

//       result = error;
//     });
//   }

//   load() {
//     Searchprice().isLoading.value = true;
//     Searchprice()
//         .searchpriceApi(
//       hotel_id: widget.hotelId,
//       room_type: widget.roomtype,
//       total_no_adults: 1.toString(),
//       total_no_children: 0.toString(),
//       meal_type: widget.mealtype,
//       context: context,
//       total_no_rooms: 1.toString(),
//       // starttime: cdate!,
//       // endtime: cdate!,
//       starttime: DateMange.checkIndate,
//       endtime: DateMange.chekOutDate,
//       couponCode: '',
//     )
//         .then((value) {
//       setState(() {
//         error = value.error!;
       
//         print('----------error--------------$error');
//         print(error.runtimeType.toString());
//         price = value.data!;
//         print("hotel id"+ widget.hotelId);
//         print("room type"+ widget.roomtype);

//         print("meal tyype"+ value.data!.price.toString());
//         print("rupee"+ widget.mealtype);
//         print("date"+ cdate!);
//         print("endDate"+ cdate!);
//          print("the due amoun is" + price.dueAmount.toString());
//         print("The price is" );
//         loader = false;
//       });
//       setState(() {
        
//       });
//     });
//   }

//   // _searchpriceCont.isLoading.val=false;
//   int dropdownvalue1 = 01;
//   int dropdownvalue2 = 01;
//   int dropdownvalue3 = 00;
//   int dropdownvalue4 = 00;
//   var items = [
//     00,
//     01,
//     02,
//     03,
//     04,
//     05,
//     06,
//     07,
//     08,
//     09,
//     10,
//     11,
//     12,
//     13,
//     14,
//   ];
//   var adultitems = [
//     01,
//     02,
//     03,
//     04,
//     05,
//     06,
//     07,
//     08,
//     09,
//     10,
//     11,
//     12,
//     13,
//     14,
//     15,
//     16,
//     17,
//     18,
//     19,
//     20,
//     21
//   ];
//   var roomitems = [
//     00,
//     01,
//     02,
//     03,
//     04,
//     05,
//     06,
//     07,
//     08,
//     09,
//     10,
//     11,
//     12,
//     13,
//     14,
//     15,
//     16,
//     17,
//     18,
//     19,
//     20,
//     21
//   ];

//   @override
//   Widget build(BuildContext context) {
//       return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: const Icon(
//             Icons.arrow_back_sharp,
//             color: Colors.black,
//           ),
//         ),
//         centerTitle: true,
//         title: Text(
//           'BOOKING',
//           style: TextStyles.font22Blue500,
//         ),
//       ),
//       body: Form(
//         key: _formkey,
//         child: SingleChildScrollView(
//           child: Padding(
//               padding: const EdgeInsets.all(28.0),
//               child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(
//                       height: 40,
//                       child: TextFormField(
//                           style: TextStyles.font16B,
//                           controller: firstname,
//                           validator: (mailvalid) {
//                             if (mailvalid!.isEmpty) {
//                               return "Please enter name";
//                             } else {
//                               return null;
//                             }
//                           },
//                           textInputAction: TextInputAction.next,
//                           enableInteractiveSelection: false,
//                           decoration: InputDecoration(
//                               hintText: 'First Name',
//                               hintStyle: TextStyles.hint_text,
//                               enabledBorder: UnderlineInputBorder(
//                                 borderSide: (BorderSide(
//                                     color: Colors.black.withOpacity(0.2),
//                                     width: 2)),
//                               ))),
//                     ),
//                     const SizedBox(
//                       height: 18,
//                     ),
//                     SizedBox(
//                       height: 40,
//                       child: TextFormField(
//                           controller: lastname,
//                           style: TextStyles.font16B,
//                           validator: (mailvalid) {
//                             if (mailvalid!.isEmpty) {
//                               return "Please enter last name";
//                             } else {
//                               return null;
//                             }
//                           },
//                           textInputAction: TextInputAction.next,
//                           enableInteractiveSelection: false,
//                           decoration: InputDecoration(
//                               hintText: 'Last Name',
//                               hintStyle: TextStyles.hint_text,
//                               enabledBorder: UnderlineInputBorder(
//                                 borderSide: (BorderSide(
//                                     color: Colors.black.withOpacity(0.2),
//                                     width: 2)),
//                               ))),
//                     ),
//                     const SizedBox(
//                       height: 18,
//                     ),
//                     SizedBox(
//                       height: 40,
//                       child: TextFormField(
//                           controller: email,
//                           style: TextStyles.font16B,
//                           validator: (mailvalid) {
//                             String pattern =
//                                 r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
//                             RegExp regExp = RegExp(pattern);
//                             if (mailvalid!.isEmpty) {
//                               return "Please enter your valid email address";
//                             } else if (!(regExp.hasMatch(mailvalid))) {
//                               return "Email must be end from @gmail.com";
//                             } else {
//                               return null;
//                             }
//                           },
//                           textInputAction: TextInputAction.next,
//                           enableInteractiveSelection: false,
//                           decoration: InputDecoration(
//                               hintText: 'Email ID',
//                               hintStyle: TextStyles.hint_text,
//                               enabledBorder: UnderlineInputBorder(
//                                 borderSide: (BorderSide(
//                                     color: Colors.black.withOpacity(0.2),
//                                     width: 2)),
//                               ))),
//                     ),
//                     const SizedBox(
//                       height: 18,
//                     ),
//                     SizedBox(
//                       height: 40,
//                       child: TextFormField(
//                           controller: number,
//                           style: TextStyles.font16B,
//                           validator: (value) {
//                             String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
//                             RegExp regExp = RegExp(patttern);
//                             if (value!.isEmpty) {
//                               return 'Please enter mobile number';
//                             } else if (value.toString().split('').first ==
//                                     '1' ||
//                                 value.toString().split('').first == '2' ||
//                                 value.toString().split('').first == '3' ||
//                                 value.toString().split('').first == '4' ||
//                                 value.toString().split('').first == '5') {
//                               return 'Please enter valid mobile number';
//                             } else if (!regExp.hasMatch(value)) {
//                               return 'Please enter valid mobile number';
//                             }
//                             return null;
//                           },
//                           textInputAction: TextInputAction.next,
//                           inputFormatters: [
//                             FilteringTextInputFormatter.digitsOnly,
//                             LengthLimitingTextInputFormatter(10)
//                           ],
//                           keyboardType: TextInputType.number,
//                           enableInteractiveSelection: false,
//                           decoration: InputDecoration(
//                               hintText: 'Contact Number',
//                               hintStyle: TextStyles.hint_text,
//                               enabledBorder: UnderlineInputBorder(
//                                 borderSide: (BorderSide(
//                                     color: Colors.black.withOpacity(0.2),
//                                     width: 2)),
//                               ))),
//                     ),
//                     const SizedBox(
//                       height: 18,
//                     ),
//                     SizedBox(
//                       height: 40,
//                       child: TextFormField(
//                           controller: address,
//                           style: TextStyles.font16B,
//                           validator: (mailvalid) {
//                             if (mailvalid!.isEmpty) {
//                               return "Please enter address";
//                             } else {
//                               return null;
//                             }
//                           },
//                           textInputAction: TextInputAction.next,
//                           enableInteractiveSelection: false,
//                           decoration: InputDecoration(
//                               hintText: 'Address',
//                               hintStyle: TextStyles.hint_text,
//                               enabledBorder: UnderlineInputBorder(
//                                 borderSide: (BorderSide(
//                                     color: Colors.black.withOpacity(0.2),
//                                     width: 2)),
//                               ))),
//                     ),
//                     const SizedBox(
//                       height: 30,
//                     ),
//                     Text(
//                       'Date & Time',
//                       style: TextStyles.font16B,
//                     ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     Container(
                   
//                       height: 40,
//                       child: Row(
//                         children: [
//                          Expanded(
                             
//                           child: Container(
//                             height: double.infinity,
//                              decoration: BoxDecoration(
//                              color: const Color(0xFF004AAD),
//                              borderRadius: BorderRadius.circular(5)
//                            ),
//                             child: Center(child: Text("CheckIn",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
                            
//                           )),

//                           Expanded(
//                             flex: 2,
                            
//                             child: Padding(
//                               padding: const EdgeInsets.only(left:8.0),
//                               child: TextFormField(
                               
//                                 textAlign: TextAlign.center,
//                                   controller: startdate,
//                                   style: TextStyles.font16B,
//                                   validator: (mailvalid) {
//                                     if (mailvalid!.isEmpty) {
//                                       return "Please enter date";
//                                     } else {
//                                       return null;
//                                     }
//                                   },
//                                   readOnly: true,
//                                   onTap: () async {
//                                     DateTime? pickedTime = await showDatePicker(
//                                         context: context,
//                                         initialDate: DateTime.now(),
//                                         firstDate: DateTime.now(),
//                                         lastDate: DateTime(2101));
//                                     if (pickedTime != null) {
//                                       String formattedDate =
//                                           DateFormat('yyyy-MM-dd').format(pickedTime);
//                                       setState(() {
//                                         //startdate.text = formattedDate;
//                                         startdate.text=DateMange.checkIndate;
//                                        DateMange.checkIndate=formattedDate;
//                                         Searchprice()
//                                             .searchpriceApi(
//                                           hotel_id: widget.hotelId,
//                                           room_type: widget.roomtype,
//                                           total_no_adults: dropdownvalue2.toString(),
//                                           total_no_children: dropdownvalue3.toString(),
//                                           meal_type: widget.mealtype,
//                                           context: context,
//                                           total_no_rooms: dropdownvalue1.toString(),
//                                           // starttime: startdate.text,
//                                           // endtime: enddate.text,
//                                           starttime: DateMange.checkIndate,
//                                           endtime: DateMange.chekOutDate,
//                                           couponCode: '',
//                                         )
//                                             .then((value) {
//                                           setState(() {
//                                             price = value.data!;
//                                             loader = false;
//                                           });
//                                         });
//                                       });
//                                     } else {
//                                       print("Time is not selected");
//                                     }
//                                   },
//                                   decoration: InputDecoration(

//                                       hintText: DateMange.checkIndate.toString(),
//                                       hintStyle: TextStyles.hint_text,
//                                       enabledBorder: UnderlineInputBorder(
//                                         borderSide: (BorderSide(
//                                             color: Colors.black.withOpacity(0.2),
//                                             width: 2)),
//                                       ))),
//                             ),
//                           ),
                        
                        
//                         ],
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 18,
//                     ),
//                     Container(
//                       height: 40,
//                       child: Row(
//                         children: [
//                            Expanded(
                             
//                           child: Container(
//                             height: double.infinity,
                           
//                            decoration: BoxDecoration(
//                              color: const Color(0xFF004AAD),
//                              borderRadius: BorderRadius.circular(5)
//                            ),
//                             child: Center(child: Tex