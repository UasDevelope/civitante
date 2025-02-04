import 'package:flutter/material.dart';

import '../../../utilse/widgets.dart';

class BucketScreen extends StatelessWidget {
  const BucketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
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
            text: AppStrings.Bucket,
            fontWeight: FontWeight.w500,
            color: AppColors.appColor,
            fontSize: 14),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 10,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  // return GridItem(imageUrl: AppImages.rectangle);
                  return Text('Ahmad');
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
