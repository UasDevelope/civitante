import 'package:civitante/App/shared/color.dart';
import 'package:civitante/App/utilse/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../controller/controller_locate.dart';
import '../controller/wallet_controller.dart';

class BuyPointsScreen extends StatelessWidget {
  final TextEditingController _amountController = TextEditingController();

  BuyPointsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = LocateController.walletController;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text('Buy Points with USD'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Predefined Amounts:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Obx(() => LoadingOverlay(
                  isLoading: controller.isloading.value,
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 3,
                    children: controller.predefinedAmounts.map((amount) {
                      return ElevatedButton(
                        onPressed: () =>
                            controller.selectPredefinedAmount(amount['usd']),
                        child: Text(
                          '\$${amount['usd'].toStringAsFixed(2)} = ${amount['points'].toStringAsFixed(0)} pts',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.appColor),
                        ),
                      );
                    }).toList(),
                  ),
                )),
            const SizedBox(height: 20),
            const Text(
              'Custom Amount:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Obx(() {
              final points =
                  controller.selectedAmount.value * controller.conversionRate;
              _amountController.text =
                  controller.selectedAmount.value.toString();
              return Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _amountController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      textInputAction: TextInputAction.done,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d{0,2}')),
                      ],
                      decoration: const InputDecoration(
                        prefixText: '\$ ',
                        border: OutlineInputBorder(),
                        hintText: 'Enter amount',
                      ),
                      onChanged: controller.updateCustomAmount,
                      onSubmitted: (_) => FocusScope.of(context).unfocus(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '= ${points.toStringAsFixed(0)} pts',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              );
            }),
            const SizedBox(height: 10),
            const Text(
              'Conversion Rate: 1 USD = 10 points',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            Obx(() => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      controller.buyPoints();

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: controller.selectedAmount.value > 0
                          ? AppColors.appColor
                          : AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'Buy Points',
                      style: TextStyle(fontSize: 18, color: AppColors.white),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
