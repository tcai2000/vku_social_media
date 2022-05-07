import 'package:app/models/user.dart';
import 'package:app/providers/user_provider.dart';
import 'package:app/resources/auth_methods.dart';
import 'package:app/resources/firestore_methods.dart';
import 'package:app/utils/colors.dart';
import 'package:app/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  String uid;
  ProfileScreen({ Key? key, required this.uid }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  bool isLoading = false;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isFollower = false;
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var snap = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.uid)
        .get();
      var postSnap = await FirebaseFirestore.instance
        .collection("posts")
        .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
      postLen = postSnap.docs.length;
      userData = snap.data()!;
      followers = snap.data()!["followers"].length;
      following = snap.data()!["following"].length;
      isFollowing = snap
      .data()!["followers"]
      .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
      
    } catch (e) {
      showSnackBar(context, e.toString());
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserProvider>(context).getUser;
    return isLoading 
    ? Center(
        child: CircularProgressIndicator(),
    )
    : Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Column(
              
              children: [
                Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.25,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            userData["photoUrl"]
                          ),
                          fit: BoxFit.cover
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 50,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                            userData["photoUrl"]
                          ),
                          radius: 46,
                        ),
                      )
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  userData["username"],

                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  // userData["email"],
                  userData["email"],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          buildStatColumn(postLen, "Posts"),
                          // buildStatColumn(230, "Photos"),
                          buildStatColumn(followers, "Followers"),
                          buildStatColumn(following, "Following")
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FirebaseAuth.instance.currentUser!.uid == widget.uid 
                          ? FollowButton(
                            backgroundColor: Colors.white,
                            borderColor: Colors.grey,
                            text: "Edit Profile",
                            function: () {},
                            textColor: Colors.black,
                          )
                          : isFollowing 
                            ? FollowButton(function: 
                                () async {
                                  await FirsestoreMethods().followUser(
                                    FirebaseAuth.instance.currentUser!.uid, 
                                    userData["uid"]
                                  );
                                  // Create Follow Request notification
                                  setState(() {
                                    isFollowing = false;
                                    followers--;
                                  });
                                }, 
                                backgroundColor:  Colors.white, 
                                borderColor: blueColor,
                                text: "UnFollow", 
                                textColor: blueColor
                              )
                            : FollowButton(function: 
                                () async {
                                  await FirsestoreMethods().followUser(
                                    FirebaseAuth.instance.currentUser!.uid, 
                                    userData["uid"]
                                  );
                                  setState(() {
                                    isFollowing = true;
                                    followers++;
                                  });
                                  await FirsestoreMethods().followReqnotif(
                                    userData["uid"], 
                                    user.photoUrl, 
                                    "stared following you", 
                                    user.username, 
                                    user.uid
                                  );
                                  
                                }, 
                                backgroundColor: blueColor, 
                                borderColor: blueColor, 
                                text: "Follow", 
                                textColor: Colors.white
                              )
                          
                          // SizedBox(width: 10,),
                          // Container(
                          //   padding: EdgeInsets.all(4),
                          //   decoration: BoxDecoration(
                          //     border: Border.all(color: Colors.grey, width: 1),
                          //     borderRadius: BorderRadius.circular(4)
                          //   ),
                          //   child: Icon(
                          //     Icons.settings,
                          //     color: Colors.grey,
                          //   ),
                          // )
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Photos",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      FutureBuilder(
                        future: FirebaseFirestore.instance
                          .collection("posts")
                          .where('uid', isEqualTo: widget.uid)
                          .get(),
                        builder: (context, snapshot) {
                          if(snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return GridView.builder(
                            shrinkWrap: true,
                            itemCount: (snapshot.data! as dynamic).docs.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 1.5,
                              childAspectRatio: 1,
                            ),
                            itemBuilder: (context, index) {
                              DocumentSnapshot snap =
                                  (snapshot.data! as dynamic).docs[index];

                              return Container(
                                child: Image(
                                  image: NetworkImage(snap['postUrl']),
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          );
                        },
                      ),
                      RaisedButton(onPressed: () async {
                        await AuthMethods().singOut();
                        
                      }
                      )
                    ],
                  ),
                ),
                
              ],
            ),
          ],
        ),
      ),
    );
  }

  Column buildStatColumn(int? num, String label) {
    return Column(
      children: [
        Text(
          num.toString(),
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 16
          ),
        ),
        SizedBox(height: 4,),
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14
          ),
        )
      ],
    );
  }
}

