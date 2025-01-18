import 'package:flutter/material.dart';

// class ProgressBannerCard extends StatelessWidget {
//   final String title;
//   final String subtitle;
//   final double progress; // Progress value between 0.0 to 1.0
//   final int earnedPoints;
//
//   const ProgressBannerCard({
//     Key? key,
//     required this.title,
//     required this.subtitle,
//     required this.progress,
//     required this.earnedPoints,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 5, // Elevation for the card
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15), // Rounded corners
//       ),
//       child: Padding(
//         padding: EdgeInsets.all(16), // Inner padding
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 8),
//             Text(
//               "Like 15 videos",
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey[700],
//               ),
//             ),
//             SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   '75/300',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//                 Text(
//                   '${(progress * 100).toInt()}%', // Show percentage
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF327BA6), // Slider color
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 8),
//             Row(
//               children: [
//                 Expanded(
//                   child: Container(
//
//                     child: LinearProgressIndicator(
//                       value: progress, // Value between 0.0 and 1.0
//                       backgroundColor: Colors.grey[300], // Background slider color
//                       color: Color(0xFF327BA6), // Active slider color
//                       minHeight: 8, // Slider height
//                     ),
//                   ),
//                 ),
//                 Text(
//                   '12 pts',
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.green[700],
//                   ),
//                 ),
//               ],
//             ),
//
//           ],
//         ),
//       ),
//     );
//   }
// }
