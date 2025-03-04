import 'package:civitante/App/modules/kpi/controller/kpis_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/app_text.dart';
import '../../../shared/color.dart';
import '../../previewUserProfile/widget/status_row.dart';

class KpisScreen extends StatelessWidget {
  KpisScreen({super.key});
  final KPISController controller = Get.put(KPISController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: AppText(text: "KPIs & Stats",fontWeight: FontWeight.w600),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // // Points Balance Card
                  // _buildPointsCard(),
                  // const SizedBox(height: 16),
                  //
                  // // Action Buttons
                  // _buildActionButtons(context),
                  // const SizedBox(height: 24),

                  // Transaction History
                  StatsRow(),
                  SizedBox(height: 16,),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
