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
  bool _isLoading = false;
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
      setState(() {
        _isLoading = true;
      });
      String res = await FirsestoreMethods().uploadPost(
        _desriptionControllder.text, 
        _file!, 
        uid, 
        username, 
        profImage
      );
      if(res == "success") {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(context, "Posted");
        clearImage();
      }else {
        setState(() {
          _isLoading = false;
        });
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
            _isLoading ? LinearProgressIndicator() : Container(),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.username,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: blueColor
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
                  ],
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
                InkWell(
                child: Container(
                  child: !_isLoading
                      ? const Text(
                          'Log in',
                          style: TextStyle(
                            color: mobileBackgroundColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                          ),
                        )
                      : const CircularProgressIndicator(
                          color: mobileBackgroundColor,
                        ),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    color: blueColor,
                  ),
                ),
                onTap: (){},
              ),
              ],
            )
          ],
        )
      ),
    );
  }
}