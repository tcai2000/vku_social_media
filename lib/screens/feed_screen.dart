import 'package:app/screens/home_screen.dart';
import 'package:app/utils/colors.dart';
import 'package:app/widgets/post_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        elevation: 0,
        title: Image.asset(
          "assets/images/logo.png",
          height: 38,
          width: 38,
        ),
        actions: [
          IconButton(
            onPressed: (){
              // pushNewScreen(
              //   context, 
              //   screen: HomeScreen(),
              //   withNavBar: false, // OPTIONAL VALUE. True by default.
              //   pageTransitionAnimation: PageTransitionAnimation.cupertino
              // );
            }, 
            icon: const Icon(
              Icons.messenger_outline,
              color: primaryColor,
            )
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("posts").snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: ((context, index) => Container(
              child: PostCard(
                snap: snapshot.data!.docs[index].data()
              ),
            )),
          );
        },
      ),
    );
  }
}