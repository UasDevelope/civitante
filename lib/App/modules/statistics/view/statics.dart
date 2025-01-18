import 'package:civitante/App/modules/statistics/view/porineanred.dart';
import 'package:civitante/App/utilse/widgets.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../shared/app_text.dart';
import '../../../shared/color.dart';
import '../../../shared/strings.dart';

class StatisticsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
        title: AppText(
            text: "Statistics",
            fontWeight: FontWeight.w500,
            color: AppColors.appColor,
            fontSize: 14),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row with Export and Dropdown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.black),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.upload, color: Colors.black),
                      SizedBox(width: 5),
                      Text("Export", style: TextStyle(color: Colors.black)),
                    ],
                  ),
                ),
                DropdownButton<String>(
                  value: "Weekly",
                  items: ["Daily", "Weekly", "Monthly"]
                      .map((e) => DropdownMenuItem(
                            child: Text(e),
                            value: e,
                          ))
                      .toList(),
                  onChanged: (value) {},
                )
              ],
            ),
            SizedBox(height: 16),
            // Statistics Cards
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2.3,
              physics: NeverScrollableScrollPhysics(),
              children: [
                _buildStatCard("Posts", "430", "10.2%", Colors.blue),
                _buildStatCard(
                    "Avg Interactions Per Post", "430", "10.2%", Colors.pink),
                _buildStatCard("Engagement", "874", "10.2%", Colors.green),
                _buildStatCard(
                    "Followers Growth", "7430", "10.2%", Colors.purple),
              ],
            ),
            SizedBox(height: 16),
            // Points Earned Chart
            Text(
              "Points Earned",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            SizedBox(height: 10),
            Container(
              height: 400,
              child: PointsEarnedGraph(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, String percentage, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
              text: title,
              color: AppColors.Slate_gray,
              fontWeight: FontWeight.w400,
              fontSize: 10),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                  text: value,
                  color: AppColors.appColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 12),
              Row(
                children: [
                  Icon(Icons.arrow_upward, color: color, size: 16),
                  AppText(text: percentage,fontWeight:FontWeight.w600,color:color,fontSize:10),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: Colors.grey)),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
