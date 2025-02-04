import 'package:civitante/App/utilse/widgets.dart';
import 'package:flutter/material.dart';
import '../../home/widgets/homeAppbar.dart';
import '../../home/widgets/home_search.dart';

class InviteMember extends StatelessWidget {
  const InviteMember({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = LocateController.myCommunities;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: HomeAppbar(
        title: "Add Member",
        onRightIconPressed: () {},
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            spacing: Get.height * 0.02,
            children: [
              HomeSerchField(
                hintText: "Search here...", // Custom hint text
                onChanged: (value) {},
              ),
              ListView.separated(
                itemCount: 4,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemBuilder: (itemBuilder, index) {
                  return Obx(() {
                    final isSelected =
                        controller.selectedIndexes.contains(index);
                    return GestureDetector(
                      onTap: () {
                        controller
                            .toggleSelection(index); // Toggle selection on tap
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.greyShade),
                          color: isSelected
                              ? AppColors.light_gray
                              : Colors.white60, // Change color if selected
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              // Group Image
                              CircleAvatar(
                                radius: 25,
                                backgroundImage: NetworkImage("imageUrl"),
                              ),
                              const SizedBox(width: 16),
                              // Group Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "groupName",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '100 pts',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Icon
                              Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    color: AppColors.greyShade,
                                    border:
                                        Border.all(color: AppColors.greyShade),
                                    shape: BoxShape.circle),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  });
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: Get.height * 0.02,
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
