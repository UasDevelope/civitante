import 'package:civitante/App/utilse/widgets.dart';
import 'package:permission_handler/permission_handler.dart';

class PostController extends GetxController {
  RxString selectedLanguage = 'English'.obs;
  RxList<String> languages = ['English', 'Spanish', 'French', 'German'].obs;
  RxString selectCatagory = "General".obs;
  RxList<String> categories =
      ['General', 'Tech', 'Lifestyle', 'Business', 'Health'].obs;
  final TextEditingController tagController = TextEditingController();
  RxList<String> tags = [""].obs;
  var images = <String>[].obs; // Observable list of image paths

  // Method to check and request permission
  Future<void> _checkPermissions() async {
    final status = await Permission.photos.request();
    if (status.isGranted) {
      await pickImage();
    } else {
      // Show a dialog or notification to inform the user about permission denial
      print("Permission Denied");
    }
  }

  // Method to pick images
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      images.add(pickedFile.path); // Add the picked image path to the list
    }
  }

  // Method to trigger permission check and image pick
  Future<void> pickImageWithPermission() async {
    await _checkPermissions();
  }
}
