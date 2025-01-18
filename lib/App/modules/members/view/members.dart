import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../shared/color.dart';
import '../../../shared/image.dart';
import '../../../shared/strings.dart';
import '../../home/widgets/homeAppbar.dart';
import '../model/memberModel.dart';
import '../widget/memberCard.dart';

class Members extends StatelessWidget {
  Members({super.key});
  final List<Member> members = [
    Member(
        name: "Sara Mathew",
        points: 200,
        imageUrl: "https://via.placeholder.com/150"),
    Member(
        name: "Claude Pfeffer",
        points: 200,
        imageUrl: "https://via.placeholder.com/150"),
    Member(
        name: "Orville Kautzer",
        points: 200,
        imageUrl: "https://via.placeholder.com/150"),
    // Add more members here
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: HomeAppbar(title: AppStrings.Members),
      body: ListView.builder(
        itemCount: members.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return MemberCard(member: members[index]);
        },
      ),
    );
  }
}
