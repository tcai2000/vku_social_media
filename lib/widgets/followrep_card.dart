
import 'package:app/resources/firestore_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';

class FollowReqCard extends StatelessWidget {
  final snap;
  bool isFollowingReq;
  FollowReqCard({
    Key? key,
    required this.snap ,
    required this.isFollowingReq
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(
            snap["profilePic"]
          ),
          radius: 20,
        ),
        SizedBox(width: 10,),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                snap["name"],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16
                ),
              ),
              Text(
                snap["text"],
                style: TextStyle(
                  fontSize: 14
                ),
              )
            ],
          ),
        ),
        isFollowingReq
        ? InkWell(
          onTap: () async {
            print(snap);
            await FirsestoreMethods().followUser(
              FirebaseAuth.instance.currentUser!.uid, 
              snap["uid"]
            );

            await FirsestoreMethods().deleteNotify(
              snap["notifyId"]
            );
            
            
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: darkBlueColor,
              borderRadius: BorderRadius.circular(4)
            ),
            child: Center(
              child: Text(
                "Follow back",
                style: TextStyle(
                  color: Colors.white
                ),
              ),
            ),
          ),
        )
        : Container()
      ],
    );
  }
}