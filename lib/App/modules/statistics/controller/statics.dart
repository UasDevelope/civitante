import 'package:get/get.dart';
import 'package:intl/intl.dart';

class StatisticsController extends GetxController {
  var daysAndDates = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _generateDaysAndDates();
  }

  // Generate days and dates for the current week dynamically (Monday to Sunday)
  void _generateDaysAndDates() {
    DateTime today = DateTime.now();
    int daysToMonday = today.weekday - DateTime.monday;
    DateTime startOfWeek = today.subtract(Duration(days: daysToMonday));

    daysAndDates.value = List.generate(7, (index) {
      DateTime date = startOfWeek.add(Duration(days: index));
      return {
        "day": DateFormat('EEE').format(date), // Day (e.g., Mon)
        "date": DateFormat('dd').format(date), // Date (e.g., 10)
      };
    });
  }
}
