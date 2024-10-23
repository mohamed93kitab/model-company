

import '../app_config.dart';
import 'package:http/http.dart' as http;

import '../models/news_response.dart';
class NewsRepository {

  Future<NewsResponse> getLatestNews({user_id = 0}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/news");
    final response =
    await http.get(url);
    // print("${AppConfig.BASE_URL}/categories?parent_id=${parent_id}");
     print(response.body.toString());
    return newsResponseFromJson(response.body);
  }
  Future<NewsResponse> likeNews({user_id = 0, news_id = 0}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/likes/like-unlike?user_id=$user_id&news_id=$news_id");
    final response =
    await http.post(url);
    // print("${AppConfig.BASE_URL}/categories?parent_id=${parent_id}");
     print(response.body.toString());
    return newsResponseFromJson(response.body);
  }

}