import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../shared/color.dart';

class MyCommunityShimmer extends StatelessWidget {
  const MyCommunityShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      padding: const EdgeInsets.all(8.0),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Card(
              color: AppColors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    // Shimmer for the avatar
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.grey.shade300,
                    ),
                    const SizedBox(width: 16),
                    // Shimmer for text
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 16,
                            width: double.infinity,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 4),
                          Container(
                            height: 12,
                            width: 100,
                            color: Colors.grey.shade300,
                          ),
                        ],
                      ),
                    ),
                    // Shimmer for icon
                    const Icon(Icons.person, color: Colors.grey),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
