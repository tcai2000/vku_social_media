import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';


class Post {
  final String uid;
  final String username;
  final String description;
  final String postId;
  final datePublished;
  final String postUrl;
  final String profImage;
  final likes;
  const Post({
    required this.uid,
    required this.username,
    required this.datePublished,
    required this.description,
    required this.likes,
    required this.postId,
    required this.postUrl,
    required this.profImage
  });

  Map<String, dynamic> toJson() => {
    "username": username,
    "uid": uid,
    "postUrl": postUrl,
    "datePublished": datePublished,
    "description": description,
    "likes": likes,
    "postId": postId,
    "profImage": profImage,

  };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
      uid: snapshot["uid"], 
      postUrl: snapshot["photoUrl"], 
      username: snapshot["username"], 
      likes: snapshot["likes"],
      postId: snapshot["postId"],
      profImage: snapshot["profImage"],
      description: snapshot["description"],
      datePublished: snapshot["datePublished"]
    );
  }
}