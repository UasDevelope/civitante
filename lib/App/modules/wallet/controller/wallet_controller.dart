import 'package:get/get.dart';

class WalletController extends GetxController {
  // Observables for toggling "See All"
  RxBool showMoreHistory = false.obs;
  RxBool showMorePostsHistory = false.obs;

  // Sample data for history and posts history
  var historyData = [
    {'title': 'Withdraw', 'points': "503.12", 'date': "12 July, 2024", 'currency': "2.05 BTC"},
    {'title': 'Deposit', 'points': "1200.00", 'date': "10 July, 2024", 'currency': "1.50 ETH"},
    {'title': 'Bonus', 'points': "300.00", 'date': "9 July, 2024", 'currency': "0.75 BTC"},
  ].obs;

  var postsHistoryData = [
    {'title': 'Posts', 'points': "850.90", 'date': "5 July, 2024", 'currency': "3.25 BTC"},
    {'title': 'Ad Clicks', 'points': "210.00", 'date': "2 July, 2024", 'currency': "0.50 BTC"},
    {'title': 'Shares', 'points': "450.00", 'date': "1 July, 2024", 'currency': "1.25 BTC"},
  ].obs;

  // Toggle "See All" for history and posts
  void toggleHistory() {
    showMoreHistory.value = !showMoreHistory.value;
  }

  void togglePostsHistory() {
    showMorePostsHistory.value = !showMorePostsHistory.value;
  }
}
