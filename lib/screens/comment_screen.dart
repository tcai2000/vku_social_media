import 'package:app/models/user.dart';
import 'package:app/providers/user_provider.dart';
import 'package:app/resources/firestore_methods.dart';
import 'package:app/utils/colors.dart';
import 'package:app/widgets/comment_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  final snap;
  const CommentScreen({
      Key? key,
      required this.snap 
    }
    ) : super(key: key);
  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {

  TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // Get comments
  

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: (){},
          icon: Icon(
            Icons.arrow_back_ios,
            color: blueColor,
          ),
        ),
        title: Text(
          "${user.username} comments",
          style: TextStyle(
            color: blueColor
          ),
        ),
        actions: [
          IconButton(
            onPressed: (){
              Navigator.pop(context);
            }, 
            icon: Icon(
              Icons.close,
              color: blueColor,
            )
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Comments",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                  .collection("posts")
                  .doc(widget.snap["postId"])
                  .collection("comments")
                  .snapshots(),
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: blueColor,
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: (snapshot.data as dynamic).docs.length,
                      itemBuilder: ((context, index) {
                        return CommentCard(
                          snap: (snapshot.data! as dynamic).docs[index]
                        );
                      }),
                    );
                  }, 
                ),
              )
            ],
          ),
        )
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          // margin: EdgeInsets.only(
          //   bottom: MediaQuery.of(context).viewInsets.bottom
          // ),
          margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          // padding: EdgeInsets.only(left: 16, right: 8, bottom: 10),
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: primaryColor, width: 1),
            borderRadius: BorderRadius.circular(40)
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  user.photoUrl
                ),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Write a comment...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  FirsestoreMethods().postComment(
                    widget.snap["postId"], 
                    _commentController.text, 
                    user.uid, 
                    user.username, 
                    user.photoUrl
                  );
                  setState(() {
                    _commentController.text = "";
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Icon(
                    Icons.send,
                    color: blueColor,
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