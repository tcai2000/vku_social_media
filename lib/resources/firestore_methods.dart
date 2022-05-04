import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:app/models/post.dart';
import 'package:app/resources/storage_methods.dart';

class FirsestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profImage
  ) async {
    String res = "some error occurer";
    try {
      String photoUrl = await StorageMethod().uploadImageToStorage("posts", file, true);
      String postId = Uuid().v1();
      Post post = Post(
        uid: uid, 
        username: username, 
        datePublished: DateTime.now(), 
        description: description, 
        likes: [], 
        postId: postId, 
        postUrl: photoUrl, 
        profImage: profImage
      );

      _firestore.collection("posts").doc(postId).set(post.toJson());
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }


  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)){
        await _firestore.collection('posts').doc(postId).update(
          {
            'likes': FieldValue.arrayRemove([uid])
          }
        ); 
      } else {
        await _firestore.collection('posts').doc(postId).update(
          {
            'likes': FieldValue.arrayUnion([uid])
          }
        ); 
      }
    } catch (e) {
      print(e.toString());
    }
  }
}