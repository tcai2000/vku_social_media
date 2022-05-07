import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  // post comment

  Future<String> postComment(String postId, String text, String uid, String name, String profilePic) async{
  
    try {
      if (text.isNotEmpty) {
        String commenId = const Uuid().v1();
        _firestore.collection("posts").doc(postId).collection("comments").doc(commenId).set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commenId,
          'datePublished': DateTime.now()
        });
      } else {
        print('Text is empty.');
      }   
    } catch (e) {
      print(e.toString());
    }
    return '';
  }

  // delete Post
  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) { 
      print(e.toString());
    }
  }


  // Followe User
  Future<void> followUser(
    String uid,
    String followId
  ) async {
    try {
      DocumentSnapshot snap =  await _firestore.collection("users").doc(uid).get();
      List following = (snap.data() as dynamic)["following"];

      if(following.contains(followId)) {
        await _firestore.collection("users").doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection("users").doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      }else {
        await _firestore.collection("users").doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection("users").doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }

    } catch (e) {
    }  

  } 

  // Create FollowRequest Notifi
  Future<void> followReqnotif(
    String uid, 
    String profilePic,
    String text,
    String name,
    String userId
    

  ) async {
    String notifyId = const Uuid().v1();
    try {
      await _firestore
        .collection("users")
        .doc(uid)
        .collection("follow_requests")
        .doc(notifyId)
        .set({
          'uid': userId,
          'profilePic': profilePic,
          'text': text,
          'name': name,
          'notifyId': notifyId,
          'datePushished': DateTime.now()
        }
      );
    } catch (e) {
      print(e.toString());
    }
  }

  // Delete Notify

  Future<void> deleteNotify(String notifyId) async {
    await _firestore 
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("follow_requests")
      .doc(notifyId)
      .delete();
  }
}