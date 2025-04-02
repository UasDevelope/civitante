import 'dart:developer';

import 'package:civitante/App/Models/my_community_model.dart';
import 'package:civitante/App/modules/loading/custom_loading_dialogue.dart';
import 'package:civitante/App/service/http_service.dart';
import 'package:civitante/App/shared/color.dart';
import 'package:civitante/App/utilse/toast_util.dart';
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

  RxString nonMemberUserSearch = "".obs;

  RxBool isNonMemberUserLoading = false.obs;
  var nonMembers = <NonMemberUser>[].obs;

  Future<void> removeMemberFromCommunity(
      String communityId, String userId) async {
    try {
      CustomLoadingDialog.showCustomLoadingDialog("Removing member...");
      String endPoint = "/leaveCommunity/$communityId";

      final response = await HttpService.post(endPoint, {
        "userId": userId,
      });

      log("Response of deleting member from community: $response");

      // Check if response is a Map and contains an error
      if (response is Map<String, dynamic> && response.containsKey('message')) {
        ToastUtil.showToast(
          message: response["message"],
          backgroundColor: response.containsKey("error")
              ? AppColors.red_color
              : AppColors.green,
        );
      } else {
        ToastUtil.showToast(
          message: "Unexpected response format",
          backgroundColor: AppColors.red_color,
        );
      }

      fetchMemberUsers(communityId);
    } catch (e) {
      log("Error removing member: $e");
      ToastUtil.showToast(
          message: "Failed to remove member: $e",
          backgroundColor: AppColors.red_color);
    } finally {
      CustomLoadingDialog.closeLoadingDialog();
    }
  }

  ///[nonMemberUserSearch]
  void onChangeNonMemberUserSearch(String value) {
    nonMemberUserSearch.value = value;
  }

  ///toggle selection by using toggle selection [selectedIndexes]
  void toggleSelection(String id) {
    if (selectedIndexes.contains(id)) {
      selectedIndexes.remove(id);
    } else {
      selectedIndexes.add(id);
    }
  }

  List<NonMemberUser> get filteredNonMemberUsers {
    if (nonMemberUserSearch.value.isEmpty) {
      return nonMembers;
    }
    return nonMembers
        .where((user) => user.name
            .toLowerCase()
            .contains(nonMemberUserSearch.value.toLowerCase()))
        .toList();
  }

  Future<void> fetchAllUsers(String communityId) async {
    try {
      isNonMemberUserLoading.value = true;
      final response = await HttpService.get("/getNonMembers/$communityId");
      if (response != null && response['nonMembers'] != null) {
        nonMembers.value = (response['nonMembers'] as List<dynamic>)
            .map((data) => NonMemberUser.fromJson(data as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      log("Error during fetching all use $e");
    } finally {
      isNonMemberUserLoading.value = false;
    }
  }

  /// Its Time to process the member in the community

  RxString memberUserSearch = "".obs;

  RxBool isMemberUserLoading = false.obs;
  var members = <NonMemberUser>[].obs;

  ///[nonMemberUserSearch]
  void onChangeMemberUserSearch(String value) {
    memberUserSearch.value = value;
  }

  List<NonMemberUser> get filteredMemberUsers {
    if (memberUserSearch.value.isEmpty) {
      return members;
    }
    return members
        .where((user) => user.name
            .toLowerCase()
            .contains(memberUserSearch.value.toLowerCase()))
        .toList();
  }

  Future<void> fetchMemberUsers(String communityId) async {
    try {
      isMemberUserLoading.value = true;
      final response = await HttpService.get("/getMembers/$communityId");
      log("response for member is $response");

      if (response != null && response['members'] != null) {
        members.value = (response['members'] as List<dynamic>)
            .map((data) => NonMemberUser.fromJson(data as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      log("Error during fetching all use $e");
    } finally {
      isMemberUserLoading.value = false;
    }
  }

  /// add or remove community by using  [selectedIndexes]

  Future<void> addOrRemoveFromCommunity(String communityId,
      {String actionType = "add", required List<String> selectedIndex}) async {
    try {
      CustomLoadingDialog.showCustomLoadingDialog(
          actionType == "add" ? "Inviting user...." : "Removing user....");
      log("Selected index is $selectedIndex");
      final response =
          await HttpService.post("/inviteToCommunity/$communityId", {
        "userIds": selectedIndex,
      });
      log("Response for add and remove community is $response");
      fetchCommunities();
      CustomLoadingDialog.closeLoadingDialog();
      Get.back();
      Get.back();
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
