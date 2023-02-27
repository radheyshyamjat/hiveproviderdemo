import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:providerhive/database/models/post_info_model.dart';

/// Table Name
const String postList = "post_list";

class PostConstant {
  Future<void> storePostList(PostInfo postInfo) async {
    var postBox = Hive.box<PostInfo>(postList);
    var filteredPost = postBox.values.where((post) => post.id == postInfo.id);
    print("Come inot filter $postInfo");
    if (filteredPost.isEmpty) {
      postBox.add(postInfo);
    }
  }

  Future<void> deleteLastPost() async {
    var postBox = Hive.box<PostInfo>(postList);
    if (postBox.values.isNotEmpty) {
      postBox.values.last.delete();
    }
  }

  Future<void> getPostData() async {
    final response =
        await http.get(Uri.parse("https://jsonplaceholder.typicode.com/posts"));
    var responseData = json.decode(response.body);
    for (var singlePost in responseData) {
      storePostList(PostInfo(
          id: singlePost['id'],
          userId: singlePost['userId'],
          title: singlePost['title'],
          body: singlePost['body']
      ));
    }
  }
}
