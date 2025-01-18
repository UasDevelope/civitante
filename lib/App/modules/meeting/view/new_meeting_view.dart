import 'package:civitante/App/modules/home/widgets/homeAppbar.dart';
import 'package:civitante/App/shared/app_text.dart';
import 'package:civitante/App/shared/color.dart';
import 'package:civitante/App/shared/image.dart';
import 'package:civitante/App/shared/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/app_textform_field.dart';
import '../../../shared/validators.dart';
import '../controller/meeting_controller.dart';
import '../widget/meeting_widgets.dart';

class NewMeetingView extends StatelessWidget {
  final MeetingController controller = Get.put(MeetingController());
  final TextEditingController agendaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: HomeAppbar(title: AppStrings.New_Meeting),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
                text: AppStrings.MEETING_AGENDA,
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: AppColors.appColor),
            SizedBox(
              height: 10,
            ),
            customTextFormField(
              maxLines: 3,
              validatore: (value) {
                return Validators.locationValidator(value!);
              },
              width: Get.width / 2,
              borderRadius: 15,
              hintText: AppStrings.Enter_meeting_agenda,
              borderColor: AppColors.textFieldHintColor,
              controller: TextEditingController(),
            ),
            SizedBox(height: 20),
            AppText(
                text: AppStrings.TIMING,
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: AppColors.appColor),
            SizedBox(height: 8),
            Obx(() => InfoTile(
                  icon: AppImages.calender,
                  title: "Start Date & Time",
                  value: controller.selectedStartDate.value.isEmpty
                      ? "Select Date & Time"
                      : controller.selectedStartDate.value,
                  onTap: () {
                    // Open DateTime Picker
                    controller.updateStartDate("12 Sep' 23, 10:10AM");
                  },
                )),
            Obx(() => InfoTile(
                  icon: AppImages.clock,
                  title: "Duration",
                  value: controller.duration.value.isEmpty
                      ? "Set Duration"
                      : controller.duration.value,
                  onTap: () {
                    // Open Duration Picker
                    controller.updateDuration("1 hour 15 min");
                  },
                )),
            Obx(() => InfoTile(
                  icon: AppImages.calender,
                  title: "End Date & Time",
                  value: controller.selectedEndDate.value.isEmpty
                      ? "Select Date & Time"
                      : controller.selectedEndDate.value,
                  onTap: () {
                    // Open DateTime Picker
                    controller.updateEndDate("12 Sep' 23, 10:10AM");
                  },
                )),
            SizedBox(height: 20),
            AppText(
                text: AppStrings.INVITES_MEMBERS,
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: AppColors.appColor),
            SizedBox(height: 8),
            ListTile(
              trailing: Icon(Icons.chevron_right),
              leading: Image.asset(
                AppImages.add,
                height: 25,
              ),
              title: AppText(text: AppStrings.Add_Members),
              onTap: () {
                // Add members logic
              },
            ),
            SizedBox(height: 20),
            AppText(
                text: AppStrings.MEETING_LINK,
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: AppColors.appColor),
            SizedBox(height: 8),
            InkWell(
              onTap: () {},
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "http://sample.info/?insect=firem...",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  Image.asset(AppImages.copy, height: 25)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
