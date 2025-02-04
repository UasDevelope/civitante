import 'package:civitante/App/modules/loading/custom_loading_dialogue.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class ImageUtils {
  /// Compress the image before uploading
  static Future<XFile?> compressImage(XFile originalImage) async {
    final directory = path.dirname(originalImage.path);
    final fileName = 'compressed_${path.basename(originalImage.path)}.jpg';
    final compressedPath = path.join(directory, fileName);

    final compressedImage = await FlutterImageCompress.compressAndGetFile(
      originalImage.path,
      compressedPath,
      minWidth: 320,
      minHeight: 240,
      quality: 50,
    );

    if (compressedImage != null) {
      final originalSize = await File(originalImage.path).length();
      final compressedSize = await File(compressedImage.path).length();

      print('Original Image Size: ${originalSize ~/ 1024} KB');
      print('Compressed Image Size: ${compressedSize ~/ 1024} KB');

      return XFile(compressedImage.path);
    } else {
      // Compression failed, handle the error
      return null;
    }
  }

  /// Pick and update image path
  static Future<void> pickAndUpdateImage(RxString pathToUpdate) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final XFile? compressImage = await ImageUtils.compressImage(image);
      CustomLoadingDialog.showCustomLoadingDialog("Uploading image....");
      String imageUrl =
          await uploadImageToFirebase(File(compressImage?.path ?? image.path));
      pathToUpdate.value = imageUrl;
      CustomLoadingDialog.closeLoadingDialog();
    } else {
      // Show an error message if no image was selected
      print("Please pick an image");
    }
  }

  /// Upload the image to Firebase Storage and return the URL
  static Future<String> uploadImageToFirebase(File image) async {
    try {
      // Get the Firebase Storage instance
      final storageRef = FirebaseStorage.instance.ref();

      // Generate a unique file name
      final fileName = 'public_images/${path.basename(image.path)}';

      // Create a reference to the file's location in Firebase Storage
      final imageRef = storageRef.child(fileName);

      // Upload the file to Firebase Storage
      final uploadTask = imageRef.putFile(image);

      // Wait for the upload to complete
      final taskSnapshot = await uploadTask;

      // Get the download URL
      final downloadUrl = await taskSnapshot.ref.getDownloadURL();
      log("Image uploaded successfully! URL: $downloadUrl");
      return downloadUrl;
    } catch (e) {
      log("Error uploading image: $e");
      return "";
    }
  }

  /// Compress and Upload the image to Firebase Storage
  static Future<String> compressAndUploadImage(String imagePath) async {
    try {
      final compressedImageFile = await compressImage(XFile(imagePath));
      if (compressedImageFile != null) {
        final imageUrl =
            await uploadImageToFirebase(File(compressedImageFile.path));
        return imageUrl; // Return the uploaded image URL
      } else {
        log("Image compression failed.");
        return "";
      }
    } catch (e) {
      log("Error during compression and upload: $e");
      return "";
    }
  }
}
