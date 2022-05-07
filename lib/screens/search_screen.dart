import 'package:app/screens/profile_screen.dart';
import 'package:app/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({ Key? key }) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;
  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [ 
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20)
                ),
                child: TextFormField(
                  controller: searchController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search',
                    suffixIcon: IconButton(
                      onPressed: searchController.clear, 
                      icon: Icon(Icons.close)
                    ),
                    
                    border: InputBorder. none,           
                  ),
                  onFieldSubmitted: (String _) {
                    setState(() {
                      isShowUsers = true;
                    });
                  },
                )
              ),
              SizedBox(height: 20,),
              Expanded(
                child: isShowUsers 
                ? FutureBuilder(
                  future: FirebaseFirestore.instance.collection("users")
                    .where("username", isGreaterThanOrEqualTo: searchController.text)
                    .get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return ListView.builder(
                      itemCount: (snapshot.data as dynamic).docs.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: ((context) {
                                  return ProfileScreen(
                                    uid: (snapshot.data as dynamic).docs[index]['uid'] 
                                  );
                                }
                              )
                            ));
                          },
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                (snapshot.data as dynamic).docs[index]['photoUrl']
                              ),
                            ),
                            title: Text(
                              (snapshot.data as dynamic).docs[index]["username"]
                            ),
                          ),
                        );
                      },
                    );
                  },
                )
                : Container()
                // : FutureBuilder(
                //   future: FirebaseFirestore.instance.collection("posts")
                //   .get(),
                //   builder: (context, snapshot) {
                //     if (!snapshot.hasData) {
                //       return Center(
                //         child: const CircularProgressIndicator()
                //       );
                //     }
                //     return StaggeredGridView.countBuilder(
                //       crossAxisCount: 3, 
                //       itemCount: (snapshot.data! as dynamic).docs.length,
                //       itemBuilder: (context, index) => Image.network(
                //         (snapshot.data! as dynamic).docs[index]["postUrl"],
                //         fit: BoxFit.cover,
                //       ), 
                //       staggeredTileBuilder: (index) => StaggeredTile.count(
                //         (index % 7 == 0) ? 2 : 1, 
                //         (index % 7 == 0)? 2 : 1
                //       )  ,
                //       mainAxisSpacing: 8,
                //       crossAxisSpacing: 8,
                //     );
                //   }
                // )
              ),
            ],
          ),
        ),
      ),
    );
  }
}