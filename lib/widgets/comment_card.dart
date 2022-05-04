import 'package:app/models/user.dart';
import 'package:app/providers/user_provider.dart';
import 'package:app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({ Key? key, required this.snap }) : super(key: key);
  @override
  State<CommentCard> createState() => _CommentCardState();

  
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              widget.snap.data()['profilePic']
            ),
            radius: 18,
          ),
          SizedBox(width: 10,),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10)
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.snap.data()['name'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                    ),
                  ), 
                  SizedBox(height: 4,),
                  Text(
                    widget.snap.data()['text']
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        DateFormat.yMMMd().format(
                          widget.snap.data()['datePublished'].toDate(),
                        ),
                        style: const TextStyle(
                            fontSize: 12, 
                            fontWeight: FontWeight.w400,
                            color: blueColor
                          ),
                      ),
                    )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}