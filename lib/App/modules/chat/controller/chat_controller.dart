import 'package:civitante/App/utilse/pref.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatController extends GetxController {
  final String communityId;
  ChatController({required this.communityId});

  late IO.Socket socket;
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  var messages = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs; // Track loading state

  @override
  void onInit() {
    super.onInit();
    connectSocket();
  }

  @override
  void onClose() {
    print("Disconnecting socket...");
    socket.disconnect();
    socket.dispose();
    super.onClose();
  }

  String decodeToken(String userToken) {
    if (userToken.isNotEmpty) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(userToken);
      return decodedToken["id"];
    } else {
      return "";
    }
  }

  Future<void> connectSocket() async {
    isLoading.value = true;
    String userToken = PrefUtil.getString(PrefUtil.userId);
    String userId = decodeToken(userToken);

    print("Connecting to socket with token: $userToken"); // Debug log

    socket = IO.io("https://civitante.onrender.com/", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
      "auth": {
        "token": userToken,
      },
    });

    socket.connect();

    socket.onConnect((_) {
      print("Connected to socket!"); // Debug log
      joinCommunity(userId);
    });

    socket.on("disconnect", (data) {
      print("Data from server is $data");
    });

    socket.on("receiveMessage", (data) {
      print("Received message: ${data}"); // Debug log
      messages.add({
        "_id": data["_id"],
        "text": data["message"],
        "isMe": data["sender"]["id"] == userId,
        "time": _formatTime(data["createdAt"]),
        "sender": data["sender"]["name"],
        "profileImage": data["sender"]["profileImage"],
      });

      _scrollToBottom();
    });

    socket.onDisconnect((_) {
      print("Disconnected from socket"); // Debug log
    });

    socket.onError((error) {
      print("Socket error: $error"); // Debug log
    });

    isLoading.value = false; // Stop loading after connection
  }

  void joinCommunity(String userId) {
    print("Joining community: $communityId"); // Debug log
    isLoading.value = true; // Start loading while fetching messages

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
      _scrollToBottom();
      isLoading.value = false; // Stop loading after fetching messages
    });
  }

  void sendMessage() {
    if (messageController.text.trim().isNotEmpty) {
      print("Sending message: ${messageController.text.trim()}"); // Debug log
      socket.emit("sendMessage", {
        "communityId": communityId,
        "message": messageController.text.trim(),
      });

      messageController.clear();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 300), () {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  String _formatTime(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp).toLocal();
    return "${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour >= 12 ? 'PM' : 'AM'}";
  }
}
