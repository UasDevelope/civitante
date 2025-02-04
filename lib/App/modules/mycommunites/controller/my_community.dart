import 'dart:developer';
import 'package:civitante/App/Models/my_community_model.dart';
import 'package:civitante/App/modules/loading/custom_loading_dialogue.dart';
import 'package:civitante/App/service/http_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Models/member_model.dart';

class MyCommunityController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var isPosting = false.obs;

  RxString selectedStatus = "accepted".obs;

  RxString searchedValue = "".obs;

  RxList<MyCommunityModel> communities = <MyCommunityModel>[].obs;

  RxList<MyCommunityModel> filteredCommunities = <MyCommunityModel>[].obs;

  late TabController tabController;

  RxBool communityLoading = false.obs;

  void changeSearchValue(String newValue) {
    searchedValue.value = newValue;
    filterCommunities(); // Filter communities when search value changes
  }

  void filterCommunities() {
    if (searchedValue.value.isEmpty) {
      filteredCommunities.value = communities; // Show all if search is empty
    } else {
      filteredCommunities.value = communities.where((community) {
        return community.name
            .toLowerCase()
            .contains(searchedValue.value.toLowerCase());
      }).toList();
    }
  }

  Future<void> fetchCommunities() async {
    try {
      communityLoading.value = true;
      communities.clear();
      final response = await HttpService.get(
          "/getUserCommunities?status=${selectedStatus.value}");
      if (response is List) {
        communities.value = response
            .map((data) =>
                MyCommunityModel.fromJson(data as Map<String, dynamic>))
            .toList();
        filterCommunities(); // Apply filter after fetching data
      } else {
        log("Unexpected response format: $response");
      }
      log("Response for singleCommunity is $response");
    } catch (e) {
      log("Error during fetching community $e");
    } finally {
      communityLoading.value = false;
    }
  }

  ///[Edit Community]

  ///[Invite Members]

  RxList<String> selectedIndexes = <String>[].obs;

  RxString userSearch = "".obs;

  RxBool isUserLoading = false.obs;
  var nonMembers = <NonMemberUser>[].obs;

  ///[userSearch]
  void onChangeUserSearch(String value) {
    userSearch.value = value;
  }

  ///toggle selection by using toggle selection [selectedIndexes]
  void toggleSelection(String id) {
    if (selectedIndexes.contains(id)) {
      selectedIndexes.remove(id);
    } else {
      selectedIndexes.add(id);
    }
  }

  List<NonMemberUser> get filteredUsers {
    if (userSearch.value.isEmpty) {
      return nonMembers;
    }
    return nonMembers
        .where((user) =>
            user.name.toLowerCase().contains(userSearch.value.toLowerCase()))
        .toList();
  }

  Future<void> fetchAllUsers(String communityId) async {
    try {
      isUserLoading.value = true;
      final response = await HttpService.get("/getNonMembers/$communityId");
      if (response != null && response['nonMembers'] != null) {
        nonMembers.value = (response['nonMembers'] as List<dynamic>)
            .map((data) => NonMemberUser.fromJson(data as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      log("Error during fetching all use $e");
    } finally {
      isUserLoading.value = false;
    }
  }

  /// add or remove community by using  [selectedIndexes]

  Future<void> addOrRemoveFromCommunity(String communityId,
      {String actionType = "add"}) async {
    try {
      CustomLoadingDialog.showCustomLoadingDialog(
          actionType == "add" ? "Inviting user...." : "Removing user....");
      final response = await HttpService.post("/addOrRemoveUser/$communityId",
          {"memberIds": selectedIndexes, "action": actionType});
      log("Response for add and remove community is $response");
      CustomLoadingDialog.closeLoadingDialog();
    } catch (e) {
      CustomLoadingDialog.closeLoadingDialog();
      log("Error for community is $e");
    } finally {}
  }

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        switch (tabController.index) {
          case 0:
            selectedStatus.value = "accepted";
            break;
          case 1:
            selectedStatus.value = "pending";
            break;
          case 2:
            selectedStatus.value = "rejected";
            break;
        }
        log("Selected status is ${selectedStatus.value}");
        fetchCommunities();
      }
    });
    fetchCommunities();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
