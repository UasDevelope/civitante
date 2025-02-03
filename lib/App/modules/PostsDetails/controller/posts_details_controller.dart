import 'dart:developer';

import 'package:civitante/App/service/http_service.dart';
import 'package:civitante/App/utilse/pref.dart';
import 'package:civitante/App/utilse/toast_util.dart';
import 'package:civitante/App/utilse/widgets.dart';
import 'package:flutter/material.dart';

class PostsDetailsController extends GetxController {
  final TextEditingController commentController = TextEditingController();
  Future<void> addComments(String postId) async {
    String userId = PrefUtil.getString(PrefUtil.userId);
    try {
      var data = {"userId": userId, "text": commentController.text};
      log('Requested data is $data');
      final response =
          await HttpService.post("/addCommentToPost/$postId", data);

      log("Response is $response");
      commentController.clear();
    } catch (e) {
      ToastUtil.showToast(message: "$e", backgroundColor: Colors.red);
    } finally {}
  }
}
