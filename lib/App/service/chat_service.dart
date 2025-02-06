import 'package:civitante/App/utilse/pref.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

/// Chat Service to handle socket connection and messaging functionality
/// This service provides methods to connect to a chat server, join communities,
/// send messages, and receive real-time updates.
class ChatService {
  /// Connects to the socket server and returns an instance of [IO.Socket].
  /// Automatically handles authentication using JWT tokens.
  static Future<IO.Socket> connectSocket() async {
    String userToken = PrefUtil.getString(PrefUtil.userId);

    debugPrint("Connecting to socket with token: $userToken");

    IO.Socket socket =
        IO.io("https://civitante.onrender.com/", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
      "auth": {
        "token": userToken,
      },
    });

    socket.connect();
    return socket;
  }

  /// Decodes the JWT token and extracts the user ID.
  static String decodeToken(String userToken) {
    if (userToken.isNotEmpty) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(userToken);
      return decodedToken["id"];
    }
    return "";
  }

  /// Joins a community chat room and listens for messages.
  static void joinCommunity(
      {required IO.Socket socket,
      required String communityId,
      required String userId,
      required RxList<Map<String, dynamic>> messages,
      required VoidCallback onMessagesUpdated}) {
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
            "profileImage": msg["sender"]["profileImage"]
          });
        }
      }
      onMessagesUpdated();
    });
  }

  /// Sends a message to the chat server.
  static void sendMessage(
      {required IO.Socket socket,
      required String communityId,
      required TextEditingController messageController,
      required VoidCallback onMessageSent}) {
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

  /// Formats a timestamp into a human-readable time string (HH:MM AM/PM format).
  static String _formatTime(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp).toLocal();
    return "${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour >= 12 ? 'PM' : 'AM'}";
  }
}
