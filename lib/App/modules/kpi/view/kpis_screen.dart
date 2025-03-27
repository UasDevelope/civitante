import 'package:civitante/App/modules/kpi/controller/kpis_controller.dart';
import 'package:civitante/App/modules/shimmer/kpis_shimmer.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../utilse/widgets.dart';

class KpisScreen extends StatelessWidget {
  final String userId;
  KpisScreen({this.userId = ""});
  final KPISController controller = Get.find<KPISController>();
  @override
  Widget build(BuildContext context) {
    controller.fetchUserStats(userId: userId);
    return RefreshIndicator(
      onRefresh: () {
        return controller.fetchUserStats();
      },
      backgroundColor: AppColors.appColor,
      child: Scaffold(
        appBar: AppBar(
          title: Text('KPIs & Stats',
              style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Obx(() => controller.isLoading.value
            ? KpisShimmer()
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: controller.metrics
                        .map((metric) => buildMetricSection(metric, controller))
                        .toList(),
                  ),
                ),
              )),
      ),
    );
  }
}

Widget buildMetricSection(String metric, KPISController controller) {
  return Obx(() => Container(
        margin: EdgeInsets.only(bottom: customMargin()),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withValues(alpha: 0.2), blurRadius: 10),
          ],
        ),
        child: Column(
          children: [
            // Section Header
            GestureDetector(
              onTap: () => controller.toggleSection(metric),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.appColor, AppColors.textFieldHintColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      metric,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      controller.expandedSections[metric]!
                          ? Icons.expand_less
                          : Icons.expand_more,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
            // Expanded Content
            if (controller.expandedSections[metric]!) ...[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Timeframe Selector
                    // DropdownButton<String>(
                    //   value: controller.selectedTimeframes[metric],
                    //   items: controller.timeframes.map((timeframe) {
                    //     return DropdownMenuItem(
                    //       value: timeframe,
                    //       child: Text(timeframe),
                    //     );
                    //   }).toList(),
                    //   onChanged: (value) =>
                    //       controller.changeTimeframe(metric, value!),
                    //   underline: SizedBox(),
                    //   isExpanded: true,
                    //   style: TextStyle(color: Colors.black, fontSize: 14),
                    // ),
                    // SizedBox(height: 16),
                    // Graph
                    _buildGraph(metric, controller),
                    SizedBox(height: 16),
                    // Stats Table
                    _buildStatsTable(metric, controller),
                  ],
                ),
              ),
            ],
          ],
        ),
      ));
}

Widget _buildGraph(String metric, KPISController controller) {
  final List<FlSpot> spots = controller.graphData[metric]?.map((entry) {
        int index = controller.graphData[metric]!.indexOf(entry);
        return FlSpot(index.toDouble(), entry['value'].toDouble());
      }).toList() ??
      [];

  return Container(
    // Use GetX for responsive dimensions
    height: Get.height * 0.3, // 30% of screen height
    width: Get.width * 0.9, // 90% of screen width
    padding: EdgeInsets.all(Get.width * 0.04), // 4% of screen width as padding
    margin: EdgeInsets.symmetric(horizontal: Get.width * 0.02), // 2% margin
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: AppColors.light_gray.withOpacity(0.2),
          blurRadius: 8,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 10,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: AppColors.greyShade.withOpacity(0.3),
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: AppColors.greyShade.withOpacity(0.3),
              strokeWidth: 1,
            );
          },
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: AppColors.greyShade.withOpacity(0.5),
            width: 1,
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: 1,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index >= 0 &&
                    index < controller.graphData[metric]!.length) {
                  final timestamp =
                      controller.graphData[metric]![index]['timestamp'];
                  return Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      timestamp,
                      style: TextStyle(
                        fontSize: Get.width * 0.03, // Responsive font size
                        color: AppColors.Slate_gray,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return SizedBox.shrink();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(
                    fontSize: Get.width * 0.03, // Responsive font size
                    color: AppColors.Slate_gray,
                  ),
                );
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles()),
          rightTitles: AxisTitles(sideTitles: SideTitles()),
        ),
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            curveSmoothness: 0.35,
            spots: spots,
            barWidth: 2,
            color: AppColors.blue,
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  AppColors.blue.withOpacity(0.3),
                  AppColors.blue.withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) =>
                  FlDotCirclePainter(
                radius: Get.width * 0.01, // Responsive dot size
                color: AppColors.blue,
                strokeWidth: 2,
                strokeColor: AppColors.white,
              ),
            ),
          ),
        ],
        minX: 0,
        maxX: spots.length > 0 ? (spots.length - 1).toDouble() : 0,
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            tooltipPadding: EdgeInsets.all(Get.width * 0.02),
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  '${spot.y}',
                  TextStyle(
                    color: AppColors.white,
                    fontSize: Get.width * 0.035,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    ),
  );
}

Widget _buildStatsTable(String metric, KPISController controller) {
  final data = controller.statsData[metric] ?? {};
  final List<String> labels = [
    'Daily',
    'Weekly',
    'Monthly',
    'YTD',
    'Annually',
    'All Time'
  ];

  return Container(
    width: Get.width * 0.95,
    margin: EdgeInsets.symmetric(
      vertical: Get.height * 0.02,
      horizontal: Get.width * 0.02,
    ),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: AppColors.light_gray.withOpacity(0.2),
          blurRadius: 8,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Container(
            decoration: BoxDecoration(
              color: AppColors.greyShade.withOpacity(0.3),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildCell('Metric', width: Get.width * 0.25, isHeader: true),
                ...labels.map((label) =>
                    _buildCell(label, width: Get.width * 0.2, isHeader: true)),
              ],
            ),
          ),
          // Data Row
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCell(metric, width: Get.width * 0.25),
              ...labels.map((label) => _buildCell(
                    data[label.toLowerCase()]?.toStringAsFixed(1) ?? "0",
                    width: Get.width * 0.2,
                  )),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _buildCell(String text, {required double width, bool isHeader = false}) {
  return Container(
    width: width,
    padding: EdgeInsets.all(Get.width * 0.02),
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: AppColors.greyShade.withOpacity(0.5),
          width: 1,
        ),
        right: BorderSide(
          color: AppColors.greyShade.withOpacity(0.5),
          width: 1,
        ),
      ),
    ),
    child: SizedBox(
      height: Get.height * 0.04,
      child: Text(
        text,
        style: TextStyle(
          fontSize: Get.width * 0.035,
          color: isHeader ? AppColors.Slate_gray : AppColors.blue,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.w500,
        ),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    ),
  );
}

double customMargin() {
  return 8.0;
}
