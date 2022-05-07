import 'package:app/utils/colors.dart';
import 'package:app/widgets/followrep_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({ Key? key }) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> 
  with SingleTickerProviderStateMixin
{
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        toolbarHeight: 80,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Notification",
          style: TextStyle(
            color: Colors.black
          ),
        ),
        leading: IconButton(
          onPressed: (){},
          icon: Icon(Icons.arrow_back_ios
        ),
      ),  
    ),
    body: SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 38,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(
                  4.0,
                ),
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: blueColor,
                ),
                tabs: [
                  Tab(text: "Follow Request",),
                  Tab(text: "Activity",)
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "Follow Request"
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              child: Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(user!.uid)
                      .collection("follow_requests")
                      .snapshots(),
                      builder:  (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: LinearProgressIndicator(color: blueColor,),
                          );
                        }
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            return FollowReqCard(
                              snap: snapshot.data!.docs[index].data(),
                              isFollowingReq: true,
                            );
                          }
                        );
                      }
                    ),
                    Text("Activity")
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ),
    );
  }
}
