import 'package:civitante/App/modules/profile/widget/statusCard.dart';
import 'package:civitante/App/modules/statistics/view/statics.dart';
import 'package:flutter/material.dart';

import '../../../utilse/widgets.dart';

class StatsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: StatsContainer(
              title: "Posts",
              value: "430",
              percentage: "10.2%",
              percentageColor: Colors.blue, voidCallback: () {
                Get.to(StatisticsScreen());
            },
            ),
          ),
          Expanded(
            child: StatsContainer(
              title: "Engagement",
              value: "874",
              percentage: "10.2%",
              percentageColor: Colors.blue, voidCallback: () {  },
            ),
          ),
          Expanded(
            child: StatsContainer(
              title: "Followers Growth",
              value: "7430",
              percentage: "10.2%",
              percentageColor: Colors.blue, voidCallback: () {  },
            ),
          ),
        ],
      ),
    );
  }
}
