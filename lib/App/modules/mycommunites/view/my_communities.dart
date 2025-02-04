import 'package:flutter/material.dart';

import '../../../utilse/widgets.dart';
import '../../AddCommunity/view/addCommunity.dart';
import '../../home/widgets/home_search.dart';
import '../../home/widgets/tab_bar.dart';
import '../controller/my_community.dart';
import '../widgets/addCommunityButton.dart';
import '../widgets/tab_bar.dart';

class MyCommunitiesScreen extends StatelessWidget {
  MyCommunitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = LocateController.myCommunities;
    controller.fetchCommunities();
    return Scaffold(
        backgroundColor: Colors.white, // Change the background color
        appBar: HomeAppbar(
          title: "Communities",
          rightIcon: controller.isPosting.value == true
              ? AppImages.notification
              : AppImages.notification,
          onRightIconPressed: () {},
        ),
        drawer: CustomDrawer(),
        body: Obx(() => SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: controller.isPosting.value == true ? 20 : 20,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: HomeSerchField(
                        hintText: "Search here...", // Custom hint text
                        onChanged: (value) {
                          controller.changeSearchValue(value);
                        },
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: AddCommunityButton(
                          onPressed: () {
                            Get.to(AddCommunityScreen());
                            print("Add Community");
                          },
                        ),
                      ),
                    ),
                    Container(
                        height: Get.height / 1.7, child: MyCommunitiesTabBar()),
                  ],
                ),
              ),
            )));
  }
}
