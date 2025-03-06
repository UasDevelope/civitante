import 'dart:developer';

import 'package:civitante/App/utilse/pref.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatService {
  static Future<IO.Socket> connectSocket() async {
    String userToken = PrefUtil.getString(PrefUtil.userId);
    debugPrint("Connecting to socket with token: $userToken");

    IO.Socket socket = IO.io("https://civitante.onrender.com/", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
      "auth": {"token": userToken},
    });

    socket.connect();
    return socket;
  }

  static String decodeToken(String userToken) {
    if (userToken.isNotEmpty) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(userToken);
      return decodedToken["id"];
    }
    return "";
  }

  static void joinCommunity({
    required IO.Socket socket,
    required String communityId,
    required String userId,
    required RxList<Map<String, dynamic>> messages,
    required VoidCallback onMessagesUpdated,
  }) {
    debugPrint("Joining community: $communityId");
    socket.emit("joinCommunityChat", {"communityId": communityId});

    socket.on("joinedCommunity", (data) {
      messages.clear();
      if (data["recentMessage"] != null) {
        for (var msg in data["recentMessage"]) {
          messages.add({
            "_id": msg["_id"],
            "text": msg["message"],
            "isMe": msg["sender"]["_id"] == userId,
            "time": _formatTime(msg["createdAt"]),
            "sender": msg["sender"]["name"],
            "profileImage": msg["sender"]["profileImage"],
          });
        }
      }
      onMessagesUpdated();
    });
  }

  static void sendMessage({
    required IO.Socket socket,
    required String communityId,
    required TextEditingController messageController,
    required VoidCallback onMessageSent,
  }) {
    if (messageController.text.trim().isNotEmpty) {
      debugPrint("Sending message: ${messageController.text.trim()}");
      socket.emit("sendMessage", {
        "communityId": communityId,
        "message": messageController.text.trim(),
      });
      messageController.clear();
      onMessageSent();
    }
  }

  /// Requests older messages from the server for pagination
  static void loadOlderMessages({
    required IO.Socket socket,
    required String communityId,
    required int page,
    required RxList<Map<String, dynamic>> messages,
    required String userId,
    required VoidCallback onMessagesLoaded,
  }) {
    debugPrint("Loading older messages for page: $page");
    socket.emit("loadOlderMessages", {"communityId": communityId, "page": page});

    socket.on("olderMessages", (data) {
      if (data["messages"] != null && data["messages"].isNotEmpty) {
        final List<Map<String, dynamic>> newMessages = [];
        for (var msg in data["messages"]) {
          final message = {
            "_id": msg["_id"],
            "text": msg["message"],
            "isMe": msg["sender"]["_id"] == userId,
            "time": _formatTime(msg["createdAt"]),
            "sender": msg["sender"]["name"],
            "profileImage": msg["sender"]["profileImage"],
          };
          // Avoid duplicates
          if (!messages.any((m) => m["_id"] == msg["_id"])) {
            newMessages.add(message);
          }
        }
        log("Older messages are $newMessages");
        messages.insertAll(0, newMessages);
        onMessagesLoaded();
      } else {
        debugPrint("No more older messages available");
      }
    });
  }

  static String _formatTime(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp).toLocal();
    int hour = dateTime.hour % 12;
    hour = hour == 0 ? 12 : hour;
    String period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return "$hour:${dateTime.minute.toString().padLeft(2, '0')} $period";
  }
}