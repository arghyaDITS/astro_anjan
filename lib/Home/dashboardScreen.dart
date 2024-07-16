import 'package:astro_app/Home/banglaCalender.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AstrologyDashboardScreen extends StatelessWidget {
  final List<String> carouselImages = [
    'https:\/\/thecityofjoy.in\/anjan\/public\/gallery\/gallery_image-1721045483.jpeg',
    'https:\/\/thecityofjoy.in\/anjan\/public\/gallery\/gallery_image-1721045492.jpeg',
    'https:\/\/thecityofjoy.in\/anjan\/public\/gallery\/gallery_image-1721047023.jpeg',
  ];

  final List<DashboardItem> dashboardItems = [
    DashboardItem('Calendar', FontAwesomeIcons.calendar, const Color.fromARGB(255, 146, 204, 252),BanglaCalendarSection()),
    DashboardItem('Daily Horoscope', FontAwesomeIcons.star, Color.fromARGB(255, 255, 243, 139),BanglaCalendarSection),
    DashboardItem('Appointments', FontAwesomeIcons.calendarCheck, Color.fromARGB(255, 255, 138, 236),BanglaCalendarSection),
    DashboardItem('Book Appointments', FontAwesomeIcons.calendarPlus, const Color.fromARGB(255, 255, 203, 125),BanglaCalendarSection),
    DashboardItem('Get My Birth Chart', FontAwesomeIcons.chartBar, const Color.fromARGB(255, 209, 151, 219),BanglaCalendarSection),
    // Add more items as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Astrology Dashboard'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildCarousel(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildGridView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarousel() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200.0,
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
                  MaterialPageRoute(builder: (context) => DetailScreen(imageUrl)),
                );
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
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
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: dashboardItems.length,
      itemBuilder: (context, index) {
        return _buildGridItem(context,dashboardItems[index],BanglaCalendarSection());
      },
    );
  }

  Widget _buildGridItem(context,DashboardItem item,route) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>route));
        // Handle card tap
        // Navigate to corresponding screen
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
            SizedBox(height: 10.0),
            Text(
              item.title,
              style: TextStyle(
                fontSize: 18.0,
                color: const Color.fromARGB(255, 64, 0, 75),
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
  final route;

  DashboardItem(this.title, this.icon, this.color, this.route);
}

class DetailScreen extends StatelessWidget {
  final String imageUrl;

  DetailScreen(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Screen'),
      ),
      body: Center(
        child: Image.network(imageUrl),
      ),
    );
  }
}
