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
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    controller.fetchUserStats(userId: userId);

    return RefreshIndicator(
      onRefresh: () => controller.fetchUserStats(),
      backgroundColor: AppColors.appColor,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'KPIs & Stats',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isTablet ? 24 : 20,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Obx(() => controller.isLoading.value
            ? KpisShimmer()
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(isTablet ? 24.0 : 16.0),
                  child: Column(
                    children: controller.metrics
                        .map((metric) =>
                            buildMetricSection(metric, controller, isTablet))
                        .toList(),
                  ),
                ),
              )),
      ),
    );
  }
}

Widget buildMetricSection(
    String metric, KPISController controller, bool isTablet) {
  return Obx(() => Container(
        margin: EdgeInsets.only(bottom: isTablet ? 12.0 : 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => controller.toggleSection(metric),
              child: Container(
                padding: EdgeInsets.all(isTablet ? 20 : 16),
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
                        fontSize: isTablet ? 22 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      controller.expandedSections[metric]!
                          ? Icons.expand_less
                          : Icons.expand_more,
                      color: Colors.white,
                      size: isTablet ? 30 : 24,
                    ),
                  ],
                ),
              ),
            ),
            if (controller.expandedSections[metric]!) ...[
              Padding(
                padding: EdgeInsets.all(isTablet ? 20.0 : 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildGraph(metric, controller, isTablet),
                    SizedBox(height: isTablet ? 20 : 16),
                    _buildStatsTable(metric, controller, isTablet),
                  ],
                ),
              ),
            ],
          ],
        ),
      ));
}

Widget _buildGraph(String metric, KPISController controller, bool isTablet) {
  final List<FlSpot> spots = controller.graphData[metric]?.map((entry) {
        int index = controller.graphData[metric]!.indexOf(entry);
        return FlSpot(index.toDouble(), entry['value'].toDouble());
      }).toList() ??
      [];

  return Container(
    height: isTablet ? Get.height * 0.35 : Get.height * 0.3,
    width: Get.width * 0.9,
    padding: EdgeInsets.all(isTablet ? Get.width * 0.05 : Get.width * 0.04),
    margin: EdgeInsets.symmetric(horizontal: Get.width * 0.02),
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
              reservedSize: isTablet ? 50 : 40,
              interval: 1,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index >= 0 &&
                    index < controller.graphData[metric]!.length) {
                  final timestamp =
                      controller.graphData[metric]![index]['timestamp'];
                  return Padding(
                    padding: EdgeInsets.only(top: isTablet ? 12 : 8),
                    child: Text(
                      timestamp,
                      style: TextStyle(
                        fontSize:
                            isTablet ? Get.width * 0.035 : Get.width * 0.03,
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
              reservedSize: isTablet ? 50 : 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(
                    fontSize: isTablet ? Get.width * 0.035 : Get.width * 0.03,
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
                radius: isTablet ? Get.width * 0.015 : Get.width * 0.01,
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
            tooltipPadding:
                EdgeInsets.all(isTablet ? Get.width * 0.025 : Get.width * 0.02),
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  '${spot.y}',
                  TextStyle(
                    color: AppColors.white,
                    fontSize: isTablet ? Get.width * 0.04 : Get.width * 0.035,
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

Widget _buildStatsTable(
    String metric, KPISController controller, bool isTablet) {
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
      vertical: isTablet ? Get.height * 0.025 : Get.height * 0.02,
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
                _buildCell('Metric',
                    width: isTablet ? Get.width * 0.3 : Get.width * 0.25,
                    isHeader: true,
                    isTablet: isTablet),
                ...labels.map((label) => _buildCell(label,
                    width: isTablet ? Get.width * 0.25 : Get.width * 0.2,
                    isHeader: true,
                    isTablet: isTablet)),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCell(metric,
                  width: isTablet ? Get.width * 0.3 : Get.width * 0.25,
                  isTablet: isTablet),
              ...labels.map((label) => _buildCell(
                    data[label.toLowerCase()]?.toStringAsFixed(1) ?? "0",
                    width: isTablet ? Get.width * 0.25 : Get.width * 0.2,
                    isTablet: isTablet,
                  )),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _buildCell(String text,
    {required double width, bool isHeader = false, required bool isTablet}) {
  return Container(
    width: width,
    padding: EdgeInsets.all(isTablet ? Get.width * 0.025 : Get.width * 0.02),
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
      height: isTablet ? Get.height * 0.05 : Get.height * 0.04,
      child: Text(
        text,
        style: TextStyle(
          fontSize: isTablet ? Get.width * 0.04 : Get.width * 0.035,
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
