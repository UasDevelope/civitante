import 'package:get/get.dart';

class MeetingController extends GetxController {
  RxString selectedStartDate = ''.obs;
  RxString selectedEndDate = ''.obs;
  RxString duration = ''.obs;
  RxString meetingAgenda = ''.obs;

  void updateStartDate(String value) {
    selectedStartDate.value = value;
  }

  void updateEndDate(String value) {
    selectedEndDate.value = value;
  }

  void updateDuration(String value) {
    duration.value = value;
  }

  void updateMeetingAgenda(String value) {
    meetingAgenda.value = value;
  }
}
