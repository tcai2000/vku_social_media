import 'package:app/models/user.dart';
import 'package:app/providers/user_provider.dart';
import 'package:app/resources/firestore_methods.dart';
import 'package:app/screens/comment_screen.dart';
import 'package:app/utils/colors.dart';
import 'package:app/utils/utils.dart';
import 'package:app/widgets/like_animation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
  
}

class _PostCardState extends State<PostCard> {

  bool isLikeAnimating = false;
  int commentLength = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getComments();
  }

  void getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance.collection("posts").doc(widget.snap["postId"]).collection('comments').get();
      commentLength = snap.docs.length;
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    setState(() {
      
    });
  } 
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      color: mobileBackgroundColor,
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 14
      ),
      child: Column(
        children: [
          Container(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(
                    widget.snap["profImage"]
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 12
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.snap['username']}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  onPressed: (){
                    showDialog(
                      context: context, 
                      builder: (context) => Dialog(
                        child: ListView(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shrinkWrap: true,
                          children: [
                            'Delete'
                          ]
                          .map(
                            (e) => InkWell(
                              child: Container(
                                padding:
                                  const EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 16),
                                child: Text(e),
                              ),
                              onTap: () {
                                
                              }),
                          )
                          .toList()),
                        ),
                    );
                  }, 
                  icon: Icon(Icons.more_vert)
                )
              ],
            ),
          ),
          SizedBox(height: 28,),

          GestureDetector(
            onDoubleTap: () async {
              await FirsestoreMethods().likePost(
                widget.snap["postId"],
                user.uid,
                widget.snap['likes']
              );
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.35,  
                  width: double.infinity,                
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.network(
                      "${widget.snap["postUrl"]}",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating? 1 : 0,
                  child: LikeAnimation(
                    child: const Icon(
                      Icons.favorite, 
                      color: Colors.white,
                      size: 100,
                    ), 
                    isAnimating: isLikeAnimating,
                    duration: const Duration(
                      milliseconds: 400
                    ),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                  ),
                )
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: mobileBackgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40)
              )
            ),
            height: MediaQuery.of(context).size.width * 0.14,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                LikeAnimation(
                  isAnimating: widget.snap["likes"].contains(user.uid),
                  smallLike: true,
                  child: IconButton(
                    onPressed: () async {
                      await FirsestoreMethods().likePost(
                        widget.snap["postId"],
                        user.uid,
                        widget.snap['likes']
                      );
                    }, 
                    icon: widget.snap["likes"].contains(user.uid) ? Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ): Icon(Icons.favorite_border_outlined)
                  ),
                ),
                IconButton(
                  onPressed: (){
                    pushNewScreen(
                      context,
                      screen: CommentScreen(snap: widget.snap,),
                      withNavBar: false, // OPTIONAL VALUE. True by default.
                      pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                  }, 
                  icon: Icon(Icons.comment_outlined)
                ),
                IconButton(
                  onPressed: (){}, 
                  icon: Icon(Icons.send)
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      onPressed: (){}, 
                      icon: Icon(Icons.bookmark_border)
                    ),
                  ),
                ) 
              ],
            ),
          ),
          // Description and number of comment
          Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                    fontWeight: FontWeight.w800
                  ), 
                  child: Text(
                    "${widget.snap["likes"].length} likes",
                    style: Theme.of(context).textTheme.bodyText2,
                  )
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    top: 8
                  ),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color: primaryColor
                      ),
                      children: [
                        TextSpan(
                          text: widget.snap["username"],
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          )
                        ),
                        TextSpan(
                          text: widget.snap["description"], 
                        )
                      ]
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){},
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      "View all $commentLength comments",
                      style: TextStyle(
                        fontSize: 16,
                        color: secondaryColor
                      ),
                    ),
                  ),
                ),
                 Container(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      DateFormat.yMMMd().format(
                        widget.snap["datePublished"].toDate()
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        color: secondaryColor
                      ),
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}