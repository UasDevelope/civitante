import 'dart:developer';

import 'package:civitante/App/modules/loading/custom_loading_dialogue.dart';
import 'package:civitante/App/service/http_service.dart';
import 'package:civitante/App/utilse/widgets.dart';
import 'package:flutter/material.dart';

import '../../../Models/my_community_model.dart';

class AllCommunityController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var isPosting = false.obs;

  RxBool isCommunityLoading = false.obs;

  RxString searchedValue = "".obs;

  RxString selectedTab = "new".obs;
  RxInt selectedTabIndex = 0.obs;

  RxList<MyCommunityModel> communities = <MyCommunityModel>[].obs;

  RxList<MyCommunityModel> filteredCommunities = <MyCommunityModel>[].obs;

  late TabController tabController;

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


  Future<void> fetchAllCommunities() async {
    try {
      isCommunityLoading.value = true;
      final response =
          await HttpService.get("/getCommunities?filter=${selectedTab.value}");
      log("Response for all community is $response");
      communities.value = (response["communities"] as List<dynamic>)
          .map(
              (data) => MyCommunityModel.fromJson(data as Map<String, dynamic>))
          .toList();
      filterCommunities();
    } catch (e) {
      log("Error is $e");
    } finally {
      isCommunityLoading.value = false;
    }
  }
  Future<void> joinCommunity(String communityId) async {
    try {
      CustomLoadingDialog.showCustomLoadingDialog("loadingText");
      final response =
          await HttpService.post("/joinCommunity/$communityId",{});
      log("Response is $response");
fetchAllCommunities();
    } catch (e) {
log("Error is $e");
    } finally {
CustomLoadingDialog.closeLoadingDialog();
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchAllCommunities();

    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        print("Index is ${tabController.index}");
        switch (tabController.index) {
          case 0:
            selectedTab.value = "new";
            selectedTabIndex.value = 0;
            break;
          case 1:
            selectedTab.value = "top";
            selectedTabIndex.value = 1;
            break;
          case 2:
            selectedTab.value = "joined";
            selectedTabIndex.value = 2;
            break;
        }
        log("Selected status is ${selectedTab.value}");
        log("Selected Index is ${selectedTabIndex.value}");
        fetchAllCommunities();
      }
    });
  }
}
