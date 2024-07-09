const List<String> bengaliMonthNames = [
  "বৈশাখ",
  "জ্যৈষ্ঠ",
  "আষাঢ়",
  "শ্রাবণ",
  "ভাদ্র",
  "আশ্বিন",
  "কার্তিক",
  "অগ্রহায়ণ",
  "পৌষ",
  "মাঘ",
  "ফাল্গুন",
  "চৈত্র"
];

class BengaliDate {
  final int day;
  final String month;
  final int year;

  BengaliDate(this.day, this.month, this.year);

  @override
  String toString() {
    return "$day $month $year";
  }
}

BengaliDate gregorianToBengali(DateTime date) {
  // This is a simplistic conversion logic for demonstration.
  // Bengali date conversion is complex and requires accurate algorithms or libraries.
  int year = date.year - 593; // Rough conversion
  int monthIndex = (date.month + 8) % 12; // Adjust month
  int day = date.day;

  return BengaliDate(day, bengaliMonthNames[monthIndex], year);
}