import 'package:civitante/App/utilse/widgets.dart';

class BottomNaveController extends GetxController {
  RxInt currentIndex = RxInt(0);
  RxBool showloading = RxBool(false);
  final RxList<Widget> _pages = [
    HomeScreen(),
    ExplorerScreen(),
    PostScreen(),
    WalletScreen(),
    ProfileScreen(),
  ].obs;
  RxList<Widget> get pages => _pages;
  Future<void> changeIndex(int index) async {
    showloading.value = true;
    // Timer(Duration(seconds: 3), () {
    print("Index Changed====>from${[currentIndex]}----to----${[index]}");
    currentIndex.value = index;
    showloading.value = false;
    // });
  }
}
