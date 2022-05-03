import 'dart:typed_data';

import 'package:app/models/user.dart';
import 'package:app/providers/user_provider.dart';
import 'package:app/resources/firestore_methods.dart';
import 'package:app/utils/colors.dart';
import 'package:app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({ Key? key }) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file; 
  TextEditingController _desriptionControllder = TextEditingController();
  _selectImage(BuildContext context) async {
    return showDialog(
      context: context, 
      builder: (context) {
        return SimpleDialog(
          title: const Text("Create a post"),
          children: [
            SimpleDialogOption(
              padding: EdgeInsets.all(20),
              child: const Text("Take a photo"),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.camera);
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: EdgeInsets.all(20),
              child: const Text("Choose from gallery"),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.gallery);
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: EdgeInsets.all(20),
              child: const Text(
                "Cancel",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: blueColor,
                  fontWeight: FontWeight.bold
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      }
    );
  }
  
  // postimage

  void postImage(String uid, username, String profImage) async {
    try {
      String res = await FirsestoreMethods().uploadPost(
        _desriptionControllder.text, 
        _file!, 
        uid, 
        username, 
        profImage
      );
      if(res == "success") {
        showSnackBar(context, res);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
  //end post image

  void clearImage() {
    setState(() {
      _file = null;
    });
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _desriptionControllder.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return _file == null 
    ? Center(
      child: IconButton(
        icon: const Icon(
          Icons.upload,
          size: 50,
          color: blueColor,
        ),
        onPressed: () => _selectImage(context),
      ),
    ) 
    : Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: clearImage, 
          icon: Icon(
            Icons.arrow_back_ios,
            color: blueColor,
          ),
        ),
        title: const Text(
          "Post to",
          style: TextStyle(
            color: blueColor
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => postImage(
              user.uid, 
              user.username, 
              user.photoUrl
            ), 
            child: Text(
              "Post",
              style: TextStyle(
                color: primaryColor
              ),
            )
          )
        ],
      ),
      body: SafeArea(
        child: Column( 
          children: [
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    user.photoUrl
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: TextField(
                    controller: _desriptionControllder,
                    decoration: InputDecoration(
                      hintText: 'Write a caption...',
                      border: InputBorder.none
                    ),
                    maxLines: 8,
                  ),
                ),
                SizedBox(
                      height: 45.0,
                      width: 45.0,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            fit: BoxFit.fill,
                            alignment: FractionalOffset.topCenter,
                            image: MemoryImage(
                              _file!
                            ),
                          )),
                        ),
                      ),
                    ),
              ],
            )
          ],
        )
      ),
    );
  }
}