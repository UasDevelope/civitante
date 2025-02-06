import 'package:civitante/App/utilse/pref.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../../service/chat_service.dart';

class ChatController extends GetxController {
  final String communityId;
  ChatController({required this.communityId});

  late IO.Socket socket;
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  var messages = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeChat();
  }

  @override
  void onClose() {
    socket.disconnect();
    socket.dispose();
    super.onClose();
  }

  Future<void> _initializeChat() async {
    isLoading.value = true;
    socket = await ChatService.connectSocket();

    socket.onConnect((_) {
      print("Connected to socket!");
      _joinCommunity();
    });

    socket.on("receiveMessage", (data) {
      _handleReceivedMessage(data);
    });

    socket.onDisconnect((_) => print("Disconnected from socket"));
    socket.onError((error) => print("Socket error: $error"));

    isLoading.value = false;
  }

  void _joinCommunity() {
    String userToken = PrefUtil.getString(PrefUtil.userId);
    String userId = ChatService.decodeToken(userToken);

    ChatService.joinCommunity(
      socket: socket,
      communityId: communityId,
      userId: userId,
      messages: messages,
      onMessagesUpdated: _scrollToBottom,
    );
  }

  void sendMessage() {
    ChatService.sendMessage(
      socket: socket,
      communityId: communityId,
      messageController: messageController,
      onMessageSent: _scrollToBottom,
    );
  }

  void _handleReceivedMessage(Map<String, dynamic> data) {
    String userToken = PrefUtil.getString(PrefUtil.userId);
    String userId = ChatService.decodeToken(userToken);

    messages.add({
      "_id": data["_id"],
      "text": data["message"],
      "isMe": data["sender"]["id"] == userId,
      "time": _formatTime(data["createdAt"]),
      "sender": data["sender"]["name"],
      "profileImage": data["sender"]["profileImage"],
    });

    _scrollToBottom();
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
    return "\${dateTime.hour}:\${dateTime.minute.toString().padLeft(2, '0')} \${dateTime.hour >= 12 ? 'PM' : 'AM'}";
  }
}
