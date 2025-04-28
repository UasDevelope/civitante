import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:civitante/App/modules/loading/custom_loading_dialogue.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'constant.dart';

class ImageUtils {
  /// Compress the image before uploading
  static Future<XFile?> compressImage(XFile originalImage) async {
    try {
      final directory = await getTemporaryDirectory();
      final fileName =
          'compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';
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
      final fileName =
          'public_images/${DateTime.now().millisecondsSinceEpoch}_${path.basename(image.path)}';
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
  }

  /// Compress and Upload Image
  /// Returns an empty string if the upload fails.
  static Future<String> uploadVideoToFirebase(File video) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final fileName =
          'public_videos/${DateTime.now().millisecondsSinceEpoch}_${path.basename(video.path)}';
      log("Video file name is $fileName");
      final videoRef = storageRef.child(fileName);

      // Determine content type based on file extension
      String contentType;
      String extension = path.extension(video.path).toLowerCase();
      switch (extension) {
        case '.mp4':
          contentType = 'video/mp4';
          break;
        case '.mov':
          contentType = 'video/quicktime';
          break;
        case '.avi':
          contentType = 'video/x-msvideo';
          break;
        case '.mkv':
          contentType = 'video/x-matroska';
          break;
        case '.webm':
          contentType = 'video/webm';
          break;
        default:
          contentType = 'video/mp4'; // Fallback to MP4
          log("⚠️ Unknown video extension '$extension', using fallback contentType: $contentType");
      }

      // Set metadata with content type and additional information
      final metadata = SettableMetadata(
        contentType: contentType,
        customMetadata: {
          'uploaded_by':
              AppConstant().userID ?? 'unknown', // Replace with actual user ID
          'upload_timestamp': DateTime.now().toIso8601String(),
          'platform': Platform.isAndroid ? 'Android' : 'iOS', // Detect platform
          'file_size': video.lengthSync().toString(), // File size in bytes
        },
      );
      log("Uploading with metadata: $metadata");

      // Upload the video file
      final uploadTask = videoRef.putFile(video, metadata);
      final taskSnapshot = await uploadTask;
      log("✅ Video upload task completed");
      log("Upload state: ${taskSnapshot.state}"); // Should be TaskState.success
      log("Bytes transferred: ${taskSnapshot.bytesTransferred}/${taskSnapshot.totalBytes}");

      // Get the download URL
      final downloadUrl = await taskSnapshot.ref.getDownloadURL();
      log("🚀 Video uploaded successfully! URL: $downloadUrl");
      return downloadUrl;
    } catch (e) {
      log("❌ Error uploading video: $e");
      log("Error type: ${e.runtimeType}");
      if (e is FirebaseException) {
        log("Code: ${e.code}, Message: ${e.message}");
      }
      return "";
    }
  }

  // Upload to Cloudinary (for both image and video)
  static Future<String> uploadToCloudinary(String filePath, String folderName,
      {bool isVideo = false}) async {
    try {
      const cloudName = 'dh61apvbf';
      const uploadPreset = 'wbznzo2g';

      final uri = Uri.parse(
          'https://api.cloudinary.com/v1_1/$cloudName/${isVideo ? 'video' : 'image'}/upload');
      final request = http.MultipartRequest('POST', uri)
        ..fields['upload_preset'] = uploadPreset
        ..fields['folder'] = folderName
        ..files.add(
          http.MultipartFile(
            'file',
            File(filePath).openRead(),
            await File(filePath).length(),
            filename: isVideo ? 'video.mp4' : 'image.jpg',
          ),
        );

      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final decodedData = json.decode(responseData);
        log('Upload successful: ${decodedData['secure_url']}');
        return decodedData['secure_url'];
      } else {
        log('Failed to upload ${isVideo ? 'video' : 'image'}: ${response.statusCode}');
        throw Exception('Failed to upload ${isVideo ? 'video' : 'image'}');
      }
    } catch (error) {
      log('Error uploading ${isVideo ? 'video' : 'image'}: $error');
      rethrow;
    }
  }

  static Future<String> uploadVideoToCloudinary(File video) async {
    try {
      final uploadPreset = "Here_now";
      final cloudName = "dqv0rpgrw";
      log("Cloud name is $cloudName and upload preset is $uploadPreset");

      // Determine content type based on file extension
      String extension = path.extension(video.path).toLowerCase();
      String resourceType;
      String filename;
      switch (extension) {
        case '.mp4':
          resourceType = 'video';
          filename = 'video.mp4';
          break;
        case '.mov':
          resourceType = 'video';
          filename = 'video.mov';
          break;
        case '.avi':
          resourceType = 'video';
          filename = 'video.avi';
          break;
        case '.mkv':
          resourceType = 'video';
          filename = 'video.mkv';
          break;
        case '.webm':
          resourceType = 'video';
          filename = 'video.webm';
          break;
        default:
          resourceType = 'video';
          filename = 'video.mp4'; // Fallback
          log("⚠️ Unknown video extension '$extension', using fallback filename: $filename");
      }

      // Prepare metadata (context in Cloudinary)
      final context = {
        'uploaded_by': AppConstant().userID ?? 'unknown',
        'upload_timestamp': DateTime.now().toIso8601String(),
        'platform': Platform.isAndroid ? 'Android' : 'iOS',
        'file_size': video.lengthSync().toString(),
      };

      final uri = Uri.parse(
          'https://api.cloudinary.com/v1_1/$cloudName/$resourceType/upload');
      final request = http.MultipartRequest('POST', uri)
        ..fields['upload_preset'] = uploadPreset
        ..fields['folder'] = 'HereNow/Videos'
        ..fields['context'] = context.entries
            .map((e) => '${e.key}=${e.value}')
            .join('|') // Cloudinary context format: key1=value1|key2=value2
        ..files.add(
          http.MultipartFile(
            'file',
            video.openRead(),
            await video.length(),
            filename: filename,
          ),
        );

      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final decodedData = json.decode(responseData);
        log("🚀 Video uploaded successfully! URL: ${decodedData['secure_url']}");
        return decodedData['secure_url'];
      } else {
        log("❌ Failed to upload video: ${response.statusCode}");
        throw Exception('Failed to upload video: ${response.statusCode}');
      }
    } catch (e) {
      log("❌ Error uploading video: $e");
      log("Error type: ${e.runtimeType}");
      return "";
    }
  }

  // Upload thumbnail and video, combine URLs
  static Future<String> uploadMediaWithThumbnail(
      String thumbnailPath, String? videoPath, String folderName) async {
    try {
      // Upload thumbnail
      final thumbnailUrl =
          await uploadToCloudinary(thumbnailPath, folderName, isVideo: false);

      // If no video, return only thumbnail URL
      if (videoPath == null || videoPath.isEmpty) {
        return thumbnailUrl;
      }

      // Upload video
      final videoUrl =
          await uploadToCloudinary(videoPath, folderName, isVideo: true);

      // Combine URLs
      return '$videoUrl&thumbnail=$thumbnailUrl';
    } catch (e) {
      return "";
    }
  }

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
