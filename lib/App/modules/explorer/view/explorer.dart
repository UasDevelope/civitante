import 'package:civitante/App/modules/home/widgets/home_search.dart';
import 'package:flutter/material.dart';
import '../../../utilse/widgets.dart';

class ExplorerScreen extends StatelessWidget {
  ExplorerScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: HomeAppbar(
        title: AppStrings.Explore,
        // imagePath: AppImages.location, // Optional, can be null
        rightIcon: AppImages.notification,
        onRightIconPressed: () {},
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: HomeSerchField(
              onChanged: (vale) {

              },
            ),
          ),
        ],
      ),
      drawer: CustomDrawer(),
    );
  }
}
