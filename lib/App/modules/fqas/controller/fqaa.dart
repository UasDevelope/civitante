// controllers/faq_controller.dart
import 'package:get/get.dart';

import '../model/fqa.dart';

class FAQController extends GetxController {
  // List of FAQs
  final faqs = <FAQModel>[
    FAQModel("Lorem ipsum dolor sit amet consectetur. Nibh faucibus mi pretium id sed enim?"),
    FAQModel("What experience is preferred for candidates applying for this role?"),
    FAQModel("Lorem ipsum dolor sit amet consectetur. Nibh faucibus mi pretium id sed enim?"),
    FAQModel("Lorem ipsum dolor sit amet consectetur. Nibh faucibus mi pretium id sed enim?"),
  ].obs;
}
