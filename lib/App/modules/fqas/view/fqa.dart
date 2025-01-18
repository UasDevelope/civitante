import 'package:flutter/material.dart';

import '../../../utilse/widgets.dart';
import '../controller/fqaa.dart';

class FAQPage extends StatelessWidget {
  FAQPage({Key? key}) : super(key: key);

  final FAQController controller = Get.find<FAQController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: HomeAppbar(title: AppStrings.fqa),
      body: Obx(() => ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.faqs.length,
            itemBuilder: (context, index) {
              final faq = controller.faqs[index];
              return Container(
                margin: EdgeInsets.only(bottom: 16),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: AppText(
                    text: faq.question,
                    fontWeight: FontWeight.w400,
                    color: AppColors.Slate_gray,
                    fontSize: 13),
              );
            },
          )),
    );
  }
}
