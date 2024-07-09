import 'dart:convert';

import 'package:astro_app/Appointment/getBookingSchedule.dart';
import 'package:astro_app/components/buttons.dart';
import 'package:astro_app/components/customTextField.dart';
import 'package:astro_app/components/util.dart';
import 'package:astro_app/services/apiServices.dart';
import 'package:astro_app/services/servicesManeger.dart';
import 'package:astro_app/theme/style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class CreateAppointmentScreen extends StatefulWidget {
  int? appointId;
  CreateAppointmentScreen({super.key, this.appointId});

  @override
  _CreateAppointmentScreenState createState() =>
      _CreateAppointmentScreenState();
}

class _CreateAppointmentScreenState extends State<CreateAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _dobController = TextEditingController();
  final _pobController = TextEditingController();
  final _tobController = TextEditingController();
  final _refNameController = TextEditingController();
  final _guardianNameController = TextEditingController();
  final _pinController = TextEditingController();
  final _refAddressController = TextEditingController();
  final _areaController = TextEditingController();
  final _cityController = TextEditingController();

  File? _selectedFile;
  final picker = ImagePicker();
  bool isLoading = false;
  List<String> states = [];
  List<String> districts = [];
  String? selectedState;
  String? selectedDistrict;
  Map<String, List<String>> stateDistrictMap = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStateAndDistrict();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectFile() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _selectedFile = File(pickedFile.path);
      } else {
        print('No file selected.');
      }
    });
  }

  void _saveAndGoToDashboard() {
    if (_formKey.currentState!.validate()) {}
  }

  getStateAndDistrict() async {
    setState(() {
      isLoading = true;
    });
    String url = APIData.getStateAndDistrict;
    print(url);

    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${ServiceManager.tokenID}',
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      if (data['status']) {
        setState(() {
          for (var stateInfo in data['data']['states']) {
            String state = stateInfo['state'];
            List<String> districts = List<String>.from(stateInfo['districts']);
            states.add(state);
            stateDistrictMap[state] = districts;
          }
        });
      }

      setState(() {
        isLoading = false;
      });
    }
    return 'Success';
  }

  void onStateSelected(String? state) {
    setState(() {
      selectedState = state;
      districts = stateDistrictMap[state] ?? [];
      selectedDistrict = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.appointId == null ? 'New Appointment' : "Edit Appointment"),
      ),
      body: isLoading == true
          ? Center(
              child: LoadingIcon(),
            )
          : Container(
              height: MediaQuery.of(context).size.height,
              decoration: kBackgroundDesign(context),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Please fill the details here to book the Appointment",
                          textAlign: TextAlign.center,
                          style: kWhiteHeaderStyle(),
                        ),
                        KTextField(
                          title: 'Name',
                          controller: _nameController,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        KTextField(
                          title: 'Guardian Name',
                          controller: _guardianNameController,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        KTextField(
                          title: 'Email',
                          controller: _emailController,
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
                        SizedBox(
                          height: 10,
                        ),
                        KTextField(
                          title: 'Phone',
                          controller: _phoneController,
                          textInputType: TextInputType.number,
                          validation: (value) {},
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        KTextField(
                          title: 'Date of Birth',
                          controller: _dobController,
                          //: TextInputType.emailAddress,
                          onClick: () => _selectDate(context),
                          validation: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your date of birth';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        KTextField(
                          title: 'Place of Birth',
                          controller: _pobController,
                          textInputType: TextInputType.emailAddress,
                          validation: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your place of birth';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                            height: dropdownTextFieldHeight(),
                            width: MediaQuery.of(context).size.width,
                            decoration: dropTextFieldDesign(context),
                            child: DropdownButtonHideUnderline(
                              child: ButtonTheme(
                                alignedDropdown: true,
                                child: DropdownButton<String>(
                                  borderRadius: BorderRadius.circular(10.0),
                                  value: selectedState != ''
                                      ? selectedState
                                      : null,
                                  hint: Text('Select State'),
                                  items: states.map((String state) {
                                    return DropdownMenuItem<String>(
                                      value: state,
                                      child: Text(state),
                                    );
                                  }).toList(),
                                  onChanged: onStateSelected,
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                            height: dropdownTextFieldHeight(),
                            width: MediaQuery.of(context).size.width,
                            decoration: dropTextFieldDesign(context),
                            child: DropdownButtonHideUnderline(
                              child: ButtonTheme(
                                alignedDropdown: true,
                                child: DropdownButton<String>(
                                  borderRadius: BorderRadius.circular(10.0),
                                  hint: Text('Select District'),
                                  value: selectedDistrict,
                                  onChanged: (String? district) {
                                    setState(() {
                                      selectedDistrict = district;
                                    });
                                  },
                                  items: districts.map((String district) {
                                    return DropdownMenuItem<String>(
                                      value: district,
                                      child: Text(district),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        KTextField(
                          title: 'Area',
                          controller: _areaController,
                          //   textInputType: TextInputType.number,
                          validation: (value) {},
                        ),
                        SizedBox(height: 10),
                        KTextField(
                          title: 'City',
                          controller: _cityController,
                          //  textInputType: TextInputType.number,
                          validation: (value) {},
                        ),
                        SizedBox(height: 10),
                        KTextField(
                          title: 'Pin',
                          controller: _pinController,
                          textInputType: TextInputType.number,
                          validation: (value) {},
                        ),
                        // DropdownButton<String>(
                        //   hint: Text('Select District'),
                        //   value: selectedDistrict,
                        //   onChanged: (String? district) {
                        //     setState(() {
                        //       selectedDistrict = district;
                        //     });
                        //   },
                        //   items: districts.map((String district) {
                        //     return DropdownMenuItem<String>(
                        //       value: district,
                        //       child: Text(district),
                        //     );
                        //   }).toList(),
                        //   dropdownColor: Colors.white,
                        //   style: TextStyle(color: Colors.black),
                        //   underline: Container(
                        //     height: 2,
                        //     color: Colors.black,
                        //   ),
                        // ),

                        SizedBox(
                          height: 10,
                        ),
                        KTextField(
                          title: 'Time of Birth',
                          controller: _tobController,
                          validation: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your time of birth';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            "Source of reference",
                            style: k16Style(),
                          ),
                        ),
                        KTextField(
                          title: 'Person Name',
                          controller: _refNameController,
                          validation: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your time of birth';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            "*You can upload any picture or document for reference",
                            style: k14BoldStyle(),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _selectFile,
                          child: const Text('Upload Document'),
                        ),
                        if (_selectedFile != null)
                          Text('File selected: ${_selectedFile!.path}'),
                        const SizedBox(height: 20),
                        isLoading == true
                            ? LoadingButton()
                            : ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    saveAppointment();
                                  }
                                },
                                child: const Text('Save & Pay'),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  saveAppointment() async {
    setState(() {
      isLoading = true;
    });
    String url = APIData.createAppointment;
    print(url);
    //await Future.delayed(Duration(seconds: 1));
    var res = await http.post(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${ServiceManager.tokenID}',
    }, body: {
      'client_name': _nameController.text,
      'client_phone': _phoneController.text,
      'client_email': _emailController.text,
      'guardian': _guardianNameController.text,
      'dob': _dobController.text,
      'tob': _tobController.text,
      'pob': _pobController.text,
      'state': selectedState,
      'district': selectedDistrict,
      'pin': _pinController.text,
      'reference_person': _refNameController.text,
      'reference_address': _refAddressController.text,
      'city': _cityController.text,
      'area': _areaController.text
    });
    print(res.statusCode);
    if (res.statusCode == 200) {
      print(res.body);

      setState(() {
        isLoading = false;
      });
      Map<String, dynamic> decodedResponse = json.decode(res.body);
      print(decodedResponse['info_id']);
      print("dfd");

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => BookingSchedule(infoId: decodedResponse['info_id'].toString(),)));
    }
    setState(() {
      isLoading = false;
    });
    return 'Success';
  }
}
