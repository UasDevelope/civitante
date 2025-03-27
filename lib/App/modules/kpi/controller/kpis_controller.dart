import 'dart:developer';

import 'package:civitante/App/service/http_service.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class KPISController extends GetxController {
  var expandedSections = <String, bool>{}.obs;
  var selectedTimeframes = <String, String>{}.obs;
  var statsData = <String, Map<dynamic, dynamic>>{}
      .obs; // Changed to dynamic to handle mixed types
  var graphData = <String, List<Map<String, dynamic>>>{}.obs;
  RxBool isLoading = false.obs;
  final List<String> metrics = [
    'Posts',
    'Followers',
    'Likes',
    'Comments',
    'Points Spent',
    'Following',
    'Parties', // Represents CommunityStats.joined
  ];

  final List<String> timeframes = [
    'Daily',
    'Weekly',
    'Monthly',
    'YTD',
    'Annually',
    'All Time',
  ];

  // Helper function to extend graph data to 7 days with MM-dd format
  List<Map<String, dynamic>> extendToSevenDays(
      List<Map<String, dynamic>> data, String valueKey) {
    final DateFormat formatter = DateFormat('MM-dd');

    if (data.isEmpty) {
      // If no data, return 7 days with 0 values starting from today
      DateTime today = DateTime.now();
      return List.generate(7, (index) {
        DateTime date = today.subtract(Duration(days: 6 - index));
        return {
          'timestamp': formatter.format(date),
          'value': 0,
        };
      });
    }

    // Parse the timestamps (assuming original data has yyyy-MM-dd format)
    List<Map<String, dynamic>> sortedData = List.from(data).map((entry) {
      DateTime date = DateTime.parse(entry['timestamp']); // Parse full date
      return {
        'timestamp': formatter.format(date), // Convert to MM-dd
        'value': entry['value'],
      };
    }).toList();

    sortedData.sort((a, b) => DateTime.parse('2025-${a['timestamp']}')
        .compareTo(DateTime.parse('2025-${b['timestamp']}')));

    DateTime earliestDate =
        DateTime.parse('2025-${sortedData.first['timestamp']}');
    DateTime latestDate =
        DateTime.parse('2025-${sortedData.last['timestamp']}');
    List<Map<String, dynamic>> extendedData = [];

    // Add existing data
    extendedData.addAll(sortedData);

    // Calculate how many days we need to add to reach 7
    int daysToAdd = 7 - sortedData.length;
    if (daysToAdd > 0) {
      DateTime nextDate = latestDate.add(Duration(days: 1));
      for (int i = 0; i < daysToAdd; i++) {
        DateTime newDate = nextDate.add(Duration(days: i));
        extendedData.add({
          'timestamp': formatter.format(newDate),
          'value': 0,
        });
      }
    }

    // Ensure we only take the first 7 days if more than 7 exist
    return extendedData.length > 7 ? extendedData.sublist(0, 7) : extendedData;
  }

  Future<void> fetchUserStats({String userId = ""}) async {
    try {
      isLoading.value = true;
      String endpoint = "/getStats";
      if (userId.isNotEmpty) {
        endpoint += "/$userId";
      }
      log("End point is $endpoint");

      final response = await HttpService.get(endpoint);
      log("KPIS response is $response");

      final stats = response['statsData'];
      final graph = response['graphData'];

      statsData['Posts'] = stats['Posts'].map((key, value) =>
          MapEntry(key.toLowerCase(), double.tryParse(value.toString()) ?? 0));

      statsData['Followers'] = stats['Followers'].map((key, value) =>
          MapEntry(key.toLowerCase(), double.tryParse(value.toString()) ?? 0));

      statsData['Following'] = stats['Following'].map((key, value) =>
          MapEntry(key.toLowerCase(), double.tryParse(value.toString()) ?? 0));

      statsData['Likes'] = stats['Likes'].map((key, value) => MapEntry(
          key.toLowerCase(),
          value == "NaN" ? 0 : double.tryParse(value.toString()) ?? 0));

      statsData['Comments'] = stats['Comments'].map((key, value) => MapEntry(
          key.toLowerCase(),
          value == "NaN" ? 0 : double.tryParse(value.toString()) ?? 0));

      statsData['Points Spent'] = stats['PointsSpent'].map((key, value) =>
          MapEntry(
              key.toLowerCase(),
              value is int
                  ? value.toDouble()
                  : double.tryParse(value.toString()) ?? 0));

      statsData['Parties'] = stats['CommunityStats']['joined']
          .map((key, value) => MapEntry(key.toLowerCase(), value.toDouble()));

      // Extend graph data to 7 days with MM-dd format
      graphData['Posts'] = extendToSevenDays(
          List<Map<String, dynamic>>.from(graph['Posts']), 'value');
      graphData['Followers'] = extendToSevenDays(
          List<Map<String, dynamic>>.from(graph['Followers']), 'value');
      graphData['Following'] = extendToSevenDays(
          List<Map<String, dynamic>>.from(graph['Following']), 'value');
      graphData['Points Spent'] = extendToSevenDays(
          List<Map<String, dynamic>>.from(graph['PointsSpent']), 'value');

      graphData['Parties'] = extendToSevenDays(
        (graph['CommunityStats'] as List)
            .map<Map<String, dynamic>>((entry) => {
                  'timestamp': entry['timestamp'],
                  'value': entry['joined'],
                })
            .toList(),
        'value',
      );

      graphData['Likes'] = extendToSevenDays(
          [], 'value'); // No data provided, so start with empty
      graphData['Comments'] = extendToSevenDays(
          [], 'value'); // No data provided, so start with empty
    } catch (e) {
      print("The error is $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchUserStats();
    for (var metric in metrics) {
      expandedSections[metric] = false;
      selectedTimeframes[metric] = 'Weekly';
      statsData[metric] ??= {
        'daily': 0.0,
        'weekly': 0.0,
        'monthly': 0.0,
        'ytd': 0.0,
        'annually': 0.0,
        'all_time': 0.0,
      };
      graphData[metric] ??= [];
    }
  }

  void toggleSection(String metric) {
    expandedSections[metric] = !expandedSections[metric]!;
  }

  void changeTimeframe(String metric, String timeframe) {
    selectedTimeframes[metric] = timeframe;
  }
}
