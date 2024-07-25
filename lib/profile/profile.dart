import 'dart:convert';
import 'package:astro_app/Auth/login.dart';
import 'package:astro_app/profile/contactUs.dart';
import 'package:astro_app/profile/terms.dart';
import 'package:astro_app/components/buttons.dart';
import 'package:astro_app/components/util.dart';
import 'package:astro_app/profile/galary.dart';
import 'package:astro_app/profile/gallery.dart';
import 'package:astro_app/profile/notifications.dart';
import 'package:astro_app/services/servicesManeger.dart';
import 'package:astro_app/theme/colors.dart';
import 'package:astro_app/theme/style.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

import 'editProfile.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  Future<String?> logoutBuilder(BuildContext context,
      {required Function() onClickYes}) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        title: Text('Logout', style: kHeaderStyle()),
        content: const Text('Are you sure you want to logout?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: onClickYes,
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  Widget buildProfileContent() {
    return SingleChildScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          const SizedBox(height: kToolbarHeight),
          Column(
            children: [
              Stack(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 90),
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: blurCurveDecor(context),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Row(),
                            Text("${ServiceManager.userName}",
                                style: kHeaderStyle()),
                          ],
                        ),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor !=
                            Colors.black
                        ? kMainColor
                        : kDarkColor,
                    child: ServiceManager.profileURL == ''
                        ? const CircleAvatar(
                            radius: 45,
                            backgroundImage:
                                AssetImage('images/img_blank_profile.png'),
                          )
                        : CircleAvatar(
                            radius: 45,
                            backgroundImage:
                                NetworkImage(ServiceManager.profileURL),
                          ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Container(
            decoration: blurCurveDecor(context),
            child: Column(
              children: [
                profileButton(Icons.edit_outlined, 'Edit Profile', () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditProfile()));
                }),
              ],
            ),
          ),
          kSpace(),
          Container(
            decoration: blurCurveDecor(context),
            child: Column(
              children: [
                profileButton(Icons.call_outlined, 'Contact Us', () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ContactUsScreen()));
                }),
                profileButton(Icons.album, 'Gallery', () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ImageGalleryScreen()));
                }),
                 profileButton(Icons.notifications, 'My Notification', () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationListScreen()));
                }),
                profileButton(Icons.info_outlined, 'About Us', () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AboutUsScreen()));
                }),
                profileButton(Icons.receipt_long_outlined, 'Terms and Condition',
                    () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AboutUsScreen()));
                }),
                profileButton(Icons.receipt_long_outlined, 'Privacy Policy', () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AboutUsScreen()));
                }),
              ],
            ),
          ),
          kSpace(),
          KButton(
            title: 'Logout',
            onClick: () {
              logoutBuilder(context, onClickYes: () {
                try {
                  Navigator.pop(context);
                  setState(() {
                    isLoading = true;
                  });
                  ServiceManager().removeAll();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const Login()),
                      (route) => false);
                } catch (e) {
                  setState(() {
                    isLoading = false;
                  });
                }
              });
            },
          ),
        ],
      ),
    );
  }

  Widget buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const SizedBox(height: kToolbarHeight),
            Container(
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              height: 150,
            ),
            Container(
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              height: 150,
            ),
            Container(
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              height: 150,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kBackgroundDesign(context),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: isLoading
            ? Center(child: buildShimmer())
            : buildProfileContent(),
      ),
    );
  }
}
