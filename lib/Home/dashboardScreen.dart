import 'package:astro_app/Appointment/appoinments.dart';
import 'package:astro_app/Appointment/createAppointment.dart';
import 'package:astro_app/Home/bangLaCalender/testBanglaCalender.dart';
import 'package:astro_app/Home/Our%20Services/services.dart';
import 'package:astro_app/dummyPayments/dummyPayment.dart';
import 'package:astro_app/Home/achievements.dart';
import 'package:astro_app/Home/banglaCalender.dart';
import 'package:astro_app/Home/bookAppointment.dart';
import 'package:astro_app/Home/chembers.dart';
import 'package:astro_app/Home/rashiFal.dart';
import 'package:astro_app/theme/style.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/animation.dart';

class AstrologyDashboardScreen extends StatefulWidget {
  @override
  State<AstrologyDashboardScreen> createState() =>
      _AstrologyDashboardScreenState();
}

class _AstrologyDashboardScreenState extends State<AstrologyDashboardScreen>
    with SingleTickerProviderStateMixin {
  final List<String> carouselImages = [
    'https://anjanshastri.com/wp-content/uploads/2023/02/Dr.-Anjan-Shastri-2.png',
    'https://anjanshastri.com/wp-content/uploads/2024/06/2-website-banner.jpg',
    'https://anjanshastri.com/wp-content/uploads/2023/02/Untitled-design-1.png',
    'https://anjanshastri.com/wp-content/uploads/2022/03/anjansastri-website.png',
    'https://anjanshastri.com/wp-content/uploads/2021/03/anjandabanner1_93.png'
  ];

  final List<DashboardItem> dashboardItems = [
    DashboardItem('Calendar', FontAwesomeIcons.calendar,
        const Color.fromARGB(255, 246, 227, 250), CalendarScreen()),
    DashboardItem('Rashifal', FontAwesomeIcons.star,
        Color.fromARGB(255, 213, 164, 223), RashiGridScreen()),
    DashboardItem('Appointments', FontAwesomeIcons.calendarCheck,
        Color.fromARGB(255, 213, 164, 223), Appoinments()),
    DashboardItem('Book Appointments', FontAwesomeIcons.calendarPlus,
        const Color.fromARGB(255, 246, 227, 250), CreateAppointmentScreen()),
    DashboardItem('Chembers', FontAwesomeIcons.house,
        const Color.fromARGB(255, 246, 227, 250), LocationsScreen()),
    DashboardItem('Achivements', FontAwesomeIcons.award,
        const Color.fromARGB(255, 213, 164, 223), CertificateScreen()),
    DashboardItem('Services', FontAwesomeIcons.servicestack,
        const Color.fromARGB(255, 213, 164, 223), ServiceScreen()),

    // Add more items as needed
  ];
  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: kBackgroundDesign(context),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              AppointmentBookingSection(animation: _animation),
              SizedBox(
                height: 10,
              ),
              _buildCarousel(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildGridView(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarousel() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 150.0,
        autoPlay: true,
        enlargeCenterPage: true,
        enableInfiniteScroll: true,
        viewportFraction: 0.8,
      ),
      items: carouselImages.map((imageUrl) {
        return Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                // Handle image tap
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailScreen(imageUrl)),
                );
              },
              child: Container(
                height: 450,
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.4,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: dashboardItems.length,
      itemBuilder: (context, index) {
        return _buildGridItem(context, dashboardItems[index]);
      },
    );
  }
  Widget _buildGridItem2(BuildContext context, DashboardItem item) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => item.route));
    },
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [item.color.withOpacity(0.7), item.color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: item.color.withOpacity(0.5),
            blurRadius: 10.0,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Icon(
              item.icon,
              size: 100.0,
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                child: FaIcon(item.icon, size: 50.0, color: Colors.white),
              ),
              const SizedBox(height: 10.0),
              Text(
                item.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}


  Widget _buildGridItem(context, DashboardItem item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => item.route));
      },
      child: Container(
        decoration: BoxDecoration(
          color: item.color,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(item.icon, size: 50.0, color: Colors.white),
            const SizedBox(height: 10.0),
            Text(
              item.title,
              style: const TextStyle(
                fontSize: 18.0,
                color: Color.fromARGB(255, 64, 0, 75),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardItem {
  final String title;
  final IconData icon;
  final Color color;
  final Widget route;

  DashboardItem(this.title, this.icon, this.color, this.route);
}

class DetailScreen extends StatelessWidget {
  final String imageUrl;

  DetailScreen(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          //  title: const Text('Detail Screen'),
          ),
      body: Center(
        child: Image.network(imageUrl),
      ),
    );
  }
}
