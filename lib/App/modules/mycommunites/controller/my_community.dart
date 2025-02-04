import 'dart:developer';
import 'package:civitante/App/Models/my_community_model.dart';
import 'package:civitante/App/service/http_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyCommunityController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var isPosting = false.obs;

  RxString selectedStatus = "accepted".obs;

  RxString searchedValue = "".obs;

  RxList<MyCommunityModel> communities = <MyCommunityModel>[].obs;
  RxList<MyCommunityModel> filteredCommunities =
      <MyCommunityModel>[].obs; // New list for filtered communities

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

  ///[Invite Members]

  RxList<int> selectedIndexes = <int>[].obs;

  void toggleSelection(int index) {
    if (selectedIndexes.contains(index)) {
      selectedIndexes.remove(index);
    } else {
      selectedIndexes.add(index);
    }
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
