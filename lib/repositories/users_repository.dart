

import 'package:bab_algharb/components/shared_value_helper.dart';
import 'package:http/http.dart' as http;

import '../app_config.dart';
import '../models/finished_counter.dart';
import '../models/news_response.dart';
import '../models/user_response.dart';
class UserRepository {

  Future<UserResponse> getSearchFriends({user_id}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/friends/search?user_id="+user_id.toString());
    final response =
    await http.get(url);
    // print("${AppConfig.BASE_URL}/categories?parent_id=${parent_id}");
   // print(response.body.toString());
    return usersResponseFromJson(response.body);
  }
  Future<UserResponse> getSearchedFriends({user_id, keyword}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/friends/search?username=${keyword}&user_id="+user_id.toString());
    final response =
    await http.get(url);
    // print("${AppConfig.BASE_URL}/categories?parent_id=${parent_id}");
   // print(response.body.toString());
    return usersResponseFromJson(response.body);
  }
  Future<UserResponse> getSearchUsers({search}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/users?search="+search.toString());
    final response =
    await http.get(url);
    // print("${AppConfig.BASE_URL}/categories?parent_id=${parent_id}");
    print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"+response.body.toString());
    return usersResponseFromJson(response.body);
  }

  Future<UserResponse> getRequests({user_id}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/friends/requests?follower_id="+user_id.toString());
    final response =
    await http.get(url);
    // print("${AppConfig.BASE_URL}/categories?parent_id=${parent_id}");
   // print(response.body.toString());
    return usersResponseFromJson(response.body);
  }

  Future<UserResponse> getFriends({user_id, keyword}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/friends/my-friends?username=${keyword}&user_id="+user_id.toString());
    final response =
    await http.get(url);
    // print("${AppConfig.BASE_URL}/categories?parent_id=${parent_id}");
   // print(response.body.toString());
    return usersResponseFromJson(response.body);
  }
  Future<UserResponse> geTeam({user_id}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/auth/team?user_id="+user_id.toString());
    final response =
    await http.get(url);
    // print("${AppConfig.BASE_URL}/categories?parent_id=${parent_id}");
   // print(response.body.toString());
    return usersResponseFromJson(response.body);
  }

  Future<FinishedCounterResponse> sendFriendRequest({following_id, follower_id}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/friends/send-request?following_id="+following_id.toString()+"&follower_id="+follower_id.toString());
    final response =
    await http.get(url);
    // print("${AppConfig.BASE_URL}/categories?parent_id=${parent_id}");
    print(response.body.toString());
    return finishedCounterResponseFromJson(response.body);
  }

  Future<FinishedCounterResponse> acceptRequest({id, approval}) async {
    print("${id}");
    print("${user_id.$}");
    Uri url = Uri.parse("${AppConfig.BASE_URL}/friends/accept?id=${id}&approval=${approval}");
    final response =
    await http.get(url);
    // print("${AppConfig.BASE_URL}/categories?parent_id=${parent_id}");
    print(response.body.toString());
    return finishedCounterResponseFromJson(response.body);
  }
  Future<FinishedCounterResponse> removeRequest({id}) async {
    print("${id}");
    print("${user_id.$}");
    Uri url = Uri.parse("${AppConfig.BASE_URL}/friends/remove?id=${id}");
    final response =
    await http.get(url);
    // print("${AppConfig.BASE_URL}/categories?parent_id=${parent_id}");
    print(response.body.toString());
    return finishedCounterResponseFromJson(response.body);
  }

}