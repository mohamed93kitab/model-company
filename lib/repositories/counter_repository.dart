

import 'package:bab_algharb/components/shared_value_helper.dart';
import 'package:http/http.dart' as http;
import '../app_config.dart';
import '../models/counter_response.dart';
import '../models/finished_counter.dart';
import '../models/subscribes_points_response.dart';

class CounterRepository {

  Future<FinishedCounterResponse> finishedCounter({int user_id}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/counters/finished-counter?user_id="+user_id.toString());
    final response =
    await http.get(url);
    // print("${AppConfig.BASE_URL}/categories?parent_id=${parent_id}");
    print(response.body.toString());
    return finishedCounterResponseFromJson(response.body);
  }
  Future<FinishedCounterResponse> subscribe({int counter_id,int user_id}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/counters/subscribe?user_id=${user_id}&counter_id="+counter_id.toString());
    final response =
    await http.get(url);
    // print("${AppConfig.BASE_URL}/categories?parent_id=${parent_id}");
    print("===================================================================================="+counter_id.toString());
    print(response.body.toString());
    return finishedCounterResponseFromJson(response.body);
  }
  Future<SubscribesPointsResponse> getAllSubscribesPoints({int user_id}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/counters/subscribe-daily?user_id="+user_id.toString());
    final response =
    await http.get(url);
    // print("${AppConfig.BASE_URL}/categories?parent_id=${parent_id}");
    print(response.body.toString());
    return subscribesPointsResponseFromJson(response.body);
  }
  Future<CounterResponse> getLatestCounters() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/counters");
    final response =
    await http.get(url);
    // print("${AppConfig.BASE_URL}/categories?parent_id=${parent_id}");
    print(response.body.toString());
    return counterResponseFromJson(response.body);
  }
  Future<CounterResponse> getMySubscribes() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/counters/my-subscribes?user_id=${user_id.$}");
    final response =
    await http.get(url);
    // print("${AppConfig.BASE_URL}/categories?parent_id=${parent_id}");
    print(response.body.toString());
    return counterResponseFromJson(response.body);
  }

}