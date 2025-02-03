import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class RandomizedShimmerPost extends StatelessWidget {
  const RandomizedShimmerPost({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 10,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[350]!, // Darker base for visibility
          highlightColor: Colors.grey[100]!, // Light highlight for effect
          child: Card(
            color: Colors.grey[50], // Light grey for subtle contrast
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                          radius: 26, backgroundColor: Colors.grey[400]!),
                      SizedBox(width: 10),
                      Container(
                          height: 16, width: 100, color: Colors.grey[400]!),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(height: 200, color: Colors.grey[400]!),
                  SizedBox(height: 10),
                  Container(
                      height: 16,
                      width: double.infinity,
                      color: Colors.grey[400]!),
                  SizedBox(height: 5),
                  Container(height: 16, width: 150, color: Colors.grey[400]!),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
