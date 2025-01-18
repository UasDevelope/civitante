import 'package:flutter/material.dart';

import '../../../shared/image.dart';
import '../model/memberModel.dart';

class MemberCard extends StatelessWidget {
  final Member member;

  MemberCard({required this.member});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(member.imageUrl),
          ),
          title: Text(
            member.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "${member.points} pts",
            style: const TextStyle(color: Colors.grey),
          ),
          trailing: IconButton(
            icon: Image.asset(
              AppImages.user,
              // height: 20,
            ),
            onPressed: () {
              // Add chat action here
            },
          ),
        ),
      ),
    );
  }
}
