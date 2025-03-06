import 'package:civitante/App/modules/loading/custom_loading_dialogue.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class ImageUtils {
  /// Compress the image before uploading
  static Future<XFile?> compressImage(XFile originalImage) async {
    try {
      final directory = await getTemporaryDirectory();
      final fileName = 'compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final compressedPath = path.join(directory.path, fileName);

      // Get original image dimensions (you may need an image package like 'image')
      // For simplicity, we'll assume avoiding upscaling for now
      final compressedImage = await FlutterImageCompress.compressAndGetFile(
        originalImage.path,
        compressedPath,
        quality: 85, // Adjust quality as needed
        // Remove minWidth and minHeight to avoid upscaling, or set dynamically
      );

      if (compressedImage != null) {
        final originalSize = await File(originalImage.path).length();
        final compressedSize = await File(compressedImage.path).length();

        log('📷 Original Image Size: ${originalSize ~/ 1024} KB');
        log('📦 Compressed Image Size: ${compressedSize ~/ 1024} KB');

        if (compressedSize > 5 * 1024 * 1024) {
          log("⚠️ Compressed image is still too large! Reducing quality...");
          return await FlutterImageCompress.compressAndGetFile(
            originalImage.path,
            compressedPath,
            quality: 50, // Lower quality further if needed
          ).then((file) => file != null ? XFile(file.path) : null);
        }

        return XFile(compressedImage.path);
      } else {
        log("❌ Image compression failed.");
        return null;
      }
    } catch (e) {
      log("🚨 Compression Error: $e");
      return null;
    }
  }
  /// Pick and upload image
  static Future<void> pickAndUpdateImage(RxString pathToUpdate) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      CustomLoadingDialog.showCustomLoadingDialog("Uploading image...");
      log("Image path is ${image.path}");
      final XFile? compressedImage = await compressImage(image);
      final File fileToUpload = File(compressedImage?.path ?? image.path);

      final String imageUrl = await uploadImageToFirebase(fileToUpload);

      pathToUpdate.value = imageUrl;
      CustomLoadingDialog.closeLoadingDialog();
    } else {
      log("⚠️ No image selected.");
    }
  }

  /// Upload image to Firebase Storage
  static Future<String> uploadImageToFirebase(File image) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final fileName = 'public_images/${DateTime.now().millisecondsSinceEpoch}_${path.basename(image.path)}';
      log("file name is $fileName");
      final imageRef = storageRef.child(fileName);

      final metadata = SettableMetadata(contentType: "image/jpeg");
      log("Uploading with metadata: $metadata");

      final uploadTask = imageRef.putFile(image, metadata);
      await uploadTask.whenComplete(() => log("✅ Upload task completed"));

      // Check upload status explicitly
      final taskSnapshot = await uploadTask;
      log("Upload state: ${taskSnapshot.state}"); // Should be TaskState.success
      log("Bytes transferred: ${taskSnapshot.bytesTransferred}/${taskSnapshot.totalBytes}");

      // Attempt to get the download URL
      final downloadUrl = await taskSnapshot.ref.getDownloadURL();
      log("🚀 Image uploaded successfully! URL: $downloadUrl");
      return downloadUrl;
    } catch (e) {
      log("❌ Error uploading image: $e");
      log("Error type: ${e.runtimeType}");
      if (e is FirebaseException) {
        log("Code: ${e.code}, Message: ${e.message}");
      }
      return "";
    }
  }  /// Compress and Upload Image
  static Future<String> compressAndUploadImage(String imagePath) async {
    try {
      final compressedImageFile = await compressImage(XFile(imagePath));
      if (compressedImageFile != null) {
        return await uploadImageToFirebase(File(compressedImageFile.path));
      } else {
        log("❌ Image compression failed.");
        return "";
      }
    } catch (e) {
      log("🚨 Compression & Upload Error: $e");
      return "";
    }
  }
}
