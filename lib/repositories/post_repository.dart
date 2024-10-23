

import '../app_config.dart';
import 'package:http/http.dart' as http;

import '../models/news_response.dart';
import '../models/post_response.dart';
class PostRepository {

  Future<PostResponse> getMyPosts({user_id = 0}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/posts?user_id=$user_id");
    final response =
    await http.get(url);
    // print("${AppConfig.BASE_URL}/categories?parent_id=${parent_id}");
    print(response.body.toString());
    return postsResponseFromJson(response.body);
  }

  Future<PostResponse> getLatestPost({user_id = 0}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/posts/dashboard");
    final response =
    await http.get(url);
    // print("${AppConfig.BASE_URL}/categories?parent_id=${parent_id}");
    print(response.body.toString());
    return postsResponseFromJson(response.body);
  }
  Future<PostResponse> likePost({user_id = 0, post_id = 0}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/likes/like-unlike?user_id=$user_id&post_id=$post_id");
    final response =
    await http.post(url);
    // print("${AppConfig.BASE_URL}/categories?parent_id=${parent_id}");
    print(response.body.toString());
    return postsResponseFromJson(response.body);
  }
}