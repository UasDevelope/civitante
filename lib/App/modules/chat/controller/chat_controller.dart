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

  @override
  void onInit() {
    super.onInit();
    connectSocket();
  }

  void decodeToken(String userToken) {
    if (userToken.isNotEmpty) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(userToken);
      print("decodedToken is $decodedToken");
    } else {
      print("Token is empty!");
    }
  }

  void connectSocket() {
    String userToken = PrefUtil.getString(PrefUtil.userId);
    decodeToken(userToken);
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
      joinCommunity();
    });

    socket.on("receiveMessage", (data) {
      print("Received message: ${data}"); // Debug log
      messages.add({
        "_id": data["_id"],
        "text": data["message"],
        "isMe":
            data["sender"]["id"] == userToken, // Compare with actual userToken
        "time": _formatTime(data["createdAt"]),
        "sender": data["sender"]["name"],
      });

      _scrollToBottom();
    });

    socket.onDisconnect((_) {
      print("Disconnected from socket"); // Debug log
    });

    socket.onError((error) {
      print("Socket error: $error"); // Debug log
    });
  }

  void joinCommunity() {
    print("Joining community: $communityId"); // Debug log
    socket.emit("joinCommunityChat", {"communityId": communityId});
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
