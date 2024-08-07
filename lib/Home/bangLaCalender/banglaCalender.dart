// import 'package:astro_app/Home/bangLaCalender/utils/bangla_calender.dart';
// import 'package:astro_app/Home/bangLaCalender/utils/utils.dart';
// import 'package:flutter/material.dart';

// class BnglaCalanderPage extends StatefulWidget {
//   const BnglaCalanderPage({super.key});

//   @override
//   State<BnglaCalanderPage> createState() => _BnglaCalanderPageState();
// }

// class _BnglaCalanderPageState extends State<BnglaCalanderPage> {
//   final int year = 2024;
//   int monthIndex = 3;

//   var _tdate = Bongabdo.now();
//   DateTime now = DateTime.now();

//   @override
//   void initState() {
//     // getTotalMonth();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final String targetMonth = banglaMonths[monthIndex];
//     final List<Map<String, String>> bengaliMonthDates =
//         getAllBengaliMonthDates(2024, targetMonth);
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Calander'),
//         backgroundColor: Colors.blue,
//       ),
//       body: Container(
//         height: MediaQuery.of(context).size.height - kToolbarHeight,
//         child: Column(
//           children: [
//             Container(
//               height: 100,
//               width: double.infinity,
//               color: const Color.fromARGB(255, 86, 106, 122),
//               child: Center(
//                 child: Row(
//                   children: [
//                     IconButton(
//                         onPressed: () {
//                           setState(() {
//                             if (monthIndex >= 1) {
//                               monthIndex--;
//                             }
//                           });
//                         },
//                         icon: const Icon(
//                           Icons.arrow_back_ios,
//                           color: Colors.white,
//                         )),
//                     Expanded(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             "${banglaMonths[monthIndex] + "-" + _tdate.bYear}বঙ্গাব্দ",
//                             style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                           Text(
//                             "${now.day}-${now.month}-${now.year}",
//                             style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                         ],
//                       ),
//                     ),
//                     IconButton(
//                         onPressed: () {
//                           setState(() {
//                             if (monthIndex < 12) {
//                               monthIndex++;
//                             } else {
//                               null;
//                             }
//                           });
//                         },
//                         icon: const Icon(
//                           Icons.arrow_forward_ios,
//                           color: Colors.white,
//                         )),
//                   ],
//                 ),
//               ),
//             ),
//             Container(
//               color: const Color.fromARGB(255, 86, 106, 122),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: banglaWeekDays.values
//                     .map((weekday) => Expanded(
//                           child: Text(
//                             weekday,
//                             textAlign: TextAlign.center,
//                             style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                         ))
//                     .toList(),
//               ),
//             ),
//             Expanded(
//               child: GridView.builder(
//                 padding: const EdgeInsets.all(8.0),
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 7, // 7 columns for the days of the week
//                   crossAxisSpacing: 0.0,
//                   mainAxisSpacing: 0.0,
//                 ),
//                 itemCount: bengaliMonthDates.length,
//                 itemBuilder: (context, index) {
//                   final dateMap = bengaliMonthDates[index];
//                   final englishDate = dateMap.keys.first;
//                   final bengaliDate = dateMap.values.first;
//                   print(englishDate);
//                   print(bengaliDate);

//                   String date = bengaliDate.substring(0, 2).replaceAll(',', '');

//                   String keyword = 'রোজ ';
//                   int startIndex = bengaliDate.indexOf(keyword);
//                   String? dayName;

//                   if (startIndex != -1) {
//                     // Extract day name after "রোজ "
//                     dayName = bengaliDate
//                         .substring(startIndex + keyword.length)
//                         .trim();
//                     print(dayName); // Output: বৃহস্পতিবার
//                   } else {
//                     print('Day name not found');
//                   }

//                   return InkWell(
//                     onTap: () {},
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: date == _tdate.bDay ? Colors.blue : null,
//                         border: Border.all(color: Colors.grey.shade300),
//                       ),
//                       child: Center(
//                         child: Flexible(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               // Text(englishDate, style: TextStyle(fontSize: 12)),
//                               Column(
//                                 children: [
//                                   Text(date,
//                                       style: const TextStyle(
//                                           color: Colors.black,
//                                           fontSize: 27,
//                                           fontWeight: FontWeight.bold)),
//                                   // Text(dayName!,
//                                   //     style: const TextStyle(
//                                   //       color: Colors.black,
//                                   //       fontSize: 4,
//                                   //     )),
//                                   Text(
//                                     englishDate.substring(8, 10),
//                                     style: const TextStyle(fontSize: 8),
//                                   )
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   getTotalMonth() {
//     int year = 2024; // Example year
//     // Example Bengali month (1 to 12)
//     String targetMonth = banglaMonths[3];
//     List<Map<String, String>> bengaliYearDates = getAllBengaliYearDates(year);

//     for (var dateMap in bengaliYearDates) {
//       dateMap.forEach((englishDate, bengaliDate) {
//         if (bengaliDate.contains(targetMonth)) {
//           print('$englishDate: $bengaliDate');
//         }
//       });
//     }
//   }

//   List<Map<String, String>> getAllBengaliYearDates(int year) {
//     List<Map<String, String>> dates = [];

//     // Iterate through each Gregorian month (1 to 12)
//     for (int gMonth = 1; gMonth <= 12; gMonth++) {
//       // Get the number of days in the Gregorian month
//       int daysInMonth = DateTime(year, gMonth + 1, 0).day;

//       for (int gDay = 1; gDay <= daysInMonth; gDay++) {
//         DateTime date = DateTime(year, gMonth, gDay);
//         Bongabdo bDate = Bongabdo.fromDate(date, "new");

//         dates.add({
//           date.toIso8601String().split('T')[0]: bDate.fullDate(),
//         });
//       }
//     }

//     return dates;
//   }

//   List<Map<String, String>> getAllBengaliMonthDates(
//       int year, String targetMonth) {
//     List<Map<String, String>> dates = [];

//     for (int gMonth = 1; gMonth <= 12; gMonth++) {
//       int daysInMonth = DateTime(year, gMonth + 1, 0).day;

//       for (int gDay = 1; gDay <= daysInMonth; gDay++) {
//         DateTime date = DateTime(year, gMonth, gDay);
//         Bongabdo bDate = Bongabdo.fromDate(date);

//         if (bDate.fullDate().contains(targetMonth)) {
//           dates.add({
//             date.toIso8601String().split('T')[0]: bDate.fullDate(),
//           });
//         }
//       }
//     }

//     return dates;
//   }
// }
import 'package:astro_app/Home/bangLaCalender/utils/bangla_calender.dart';
import 'package:astro_app/Home/bangLaCalender/utils/utils.dart';
import 'package:flutter/material.dart';

class BnglaCalanderPage extends StatefulWidget {
  const BnglaCalanderPage({super.key});

  @override
  State<BnglaCalanderPage> createState() => _BnglaCalanderPageState();
}

class _BnglaCalanderPageState extends State<BnglaCalanderPage> {
  final int year = 2024;
  int monthIndex = 1;

  var _tdate = Bongabdo.now();
  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String targetMonth = banglaMonths[monthIndex];
    final List<Map<String, String>> bengaliMonthDates =
        getAllBengaliMonthDates(2024, targetMonth);

    // Calculate the weekday of the first date
    final firstDate = bengaliMonthDates.isNotEmpty
        ? DateTime.parse(bengaliMonthDates.first.keys.first)
        : DateTime.now();
    final firstWeekday = firstDate.weekday;

    // Adjust the start index based on the first date's weekday
    final adjustedDates = List.generate(
      firstWeekday,
      (index) => {'empty': ''},
    )..addAll(bengaliMonthDates);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bengali Calendar'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height - kToolbarHeight,
        child: Column(
          children: [
            Container(
              height: 100,
              width: double.infinity,
              color: const Color.fromARGB(255, 86, 106, 122),
              child: Center(
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            if (monthIndex > 1) {
                              monthIndex--;
                            }
                          });
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        )),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${banglaMonths[monthIndex] + "-" + _tdate.bYear} বঙ্গাব্দ",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${now.day}-${now.month}-${now.year}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            if (monthIndex < 12) {
                              monthIndex++;
                            }
                          });
                        },
                        icon: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        )),
                  ],
                ),
              ),
            ),
            Container(
              color: const Color.fromARGB(255, 86, 106, 122),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: banglaWeekDays.values
                    .map((weekday) => Expanded(
                          child: Text(
                            weekday,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold),
                          ),
                        ))
                    .toList(),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7, // 7 columns for the days of the week
                  crossAxisSpacing: 0.0,
                  mainAxisSpacing: 0.0,
                ),
                itemCount: adjustedDates.length,
                itemBuilder: (context, index) {
                  if (adjustedDates[index].containsKey('empty')) {
                    return Container(); // Empty container for padding
                  }

                  final dateMap = adjustedDates[index];
                  final englishDate = dateMap.keys.first;
                  final bengaliDate = dateMap.values.first;
                  print(englishDate);
                  print(bengaliDate);

                  String date = bengaliDate.substring(0, 2).replaceAll(',', '');

                  String keyword = 'রোজ ';
                  int startIndex = bengaliDate.indexOf(keyword);
                  String? dayName;

                  if (startIndex != -1) {
                    // Extract day name after "রোজ "
                    dayName = bengaliDate
                        .substring(startIndex + keyword.length)
                        .trim();
                    print(dayName); // Output: বৃহস্পতিবার
                  } else {
                    print('Day name not found');
                    dayName = '';
                  }

                  return InkWell(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        color: date == _tdate.bDay ? Colors.blue : null,
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              date,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 27,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              dayName.substring(0, 1),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 8,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, String>> getAllBengaliYearDates(int year) {
    List<Map<String, String>> dates = [];

    // Iterate through each Gregorian month (1 to 12)
    for (int gMonth = 1; gMonth <= 12; gMonth++) {
      // Get the number of days in the Gregorian month
      int daysInMonth = DateTime(year, gMonth + 1, 0).day;

      for (int gDay = 1; gDay <= daysInMonth; gDay++) {
        DateTime date = DateTime(year, gMonth, gDay);
        Bongabdo bDate = Bongabdo.fromDate(date, "new");

        dates.add({
          date.toIso8601String().split('T')[0]: bDate.fullDate(),
        });
      }
    }

    return dates;
  }

  List<Map<String, String>> getAllBengaliMonthDates(
      int year, String targetMonth) {
    List<Map<String, String>> dates = [];

    for (int gMonth = 1; gMonth <= 12; gMonth++) {
      int daysInMonth = DateTime(year, gMonth + 1, 0).day;

      for (int gDay = 1; gDay <= daysInMonth; gDay++) {
        DateTime date = DateTime(year, gMonth, gDay);
        Bongabdo bDate = Bongabdo.fromDate(date);

        if (bDate.fullDate().contains(targetMonth)) {
          dates.add({
            date.toIso8601String().split('T')[0]: bDate.fullDate(),
          });
        }
      }
    }

    return dates;
  }
}
