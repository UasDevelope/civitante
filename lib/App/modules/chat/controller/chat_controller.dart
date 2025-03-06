import 'dart:developer';

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
  var isLoadingOlder = false.obs; // For pagination loading state
  final showEmojiPicker = false.obs;
  var currentPage = 0.obs; // Track current page
  var hasMoreMessages = true.obs; // Flag for more messages availability

  @override
  void onInit() {
    super.onInit();
    _initializeChat();
    _setupScrollListener();
  }

  @override
  void onClose() {
    socket.disconnect();
    socket.dispose();
    scrollController.dispose();
    messageController.dispose();
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

  }

  void _setupScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels <= 50 &&
          !isLoadingOlder.value &&
          hasMoreMessages.value) {
        log("Click");
        _loadOlderMessages();
      }
    });
  }

  void _joinCommunity() {
    String userToken = PrefUtil.getString(PrefUtil.userId);
    String userId = ChatService.decodeToken(userToken);

    ChatService.joinCommunity(
      socket: socket,
      communityId: communityId,
      userId: userId,
      messages: messages,
      onMessagesUpdated: () {
        log("Joined community, messages loaded: ${messages.length}");
        _scrollToBottom();
        isLoading.value = false; // Set false only after messages are loaded
      },
    );
  }

  void sendMessage() {
    ChatService.sendMessage(
      socket: socket,
      communityId: communityId,
      messageController: messageController,
      onMessageSent: _scrollToBottom,
    );
    showEmojiPicker.value = false;
  }

  void toggleEmojiPicker() {
    showEmojiPicker.value = !showEmojiPicker.value;
    if (showEmojiPicker.value) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
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
    Future.delayed(const Duration(milliseconds: 300), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _loadOlderMessages() async {
    if (!hasMoreMessages.value) return;

    isLoadingOlder.value = true;
    String userToken = PrefUtil.getString(PrefUtil.userId);
    String userId = ChatService.decodeToken(userToken);

    final previousPosition = scrollController.position.pixels;

    ChatService.loadOlderMessages(
      socket: socket,
      communityId: communityId,
      page: currentPage.value + 1,
      messages: messages,
      userId: userId,
      onMessagesLoaded: () {
        currentPage.value++;
        // Maintain scroll position after loading
        Future.delayed(const Duration(milliseconds: 100), () {
          if (scrollController.hasClients) {
            scrollController.jumpTo(previousPosition + 50); // Adjust offset
          }
        });
        isLoadingOlder.value = false;
        // If fewer messages than expected, assume no more
        if (messages.length < currentPage.value * 20) { // Adjust page size
          hasMoreMessages.value = false;
        }
      },
    );
  }

  String _formatTime(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp).toLocal();
    int hour = dateTime.hour % 12;
    hour = hour == 0 ? 12 : hour;
    String period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return "$hour:${dateTime.minute.toString().padLeft(2, '0')} $period";
  }
}