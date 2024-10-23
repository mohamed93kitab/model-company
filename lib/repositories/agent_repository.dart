import 'package:bab_algharb/components/shared_value_helper.dart';
import 'package:http/http.dart' as http;
import '../app_config.dart';
import '../models/agent_response.dart';

class AgentRepository {

  Future<AgentResponse> getLatestAgents({country, state}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/agents?governorate=$state");
    final response =
    await http.get(url);
    // print("${AppConfig.BASE_URL}/categories?parent_id=${parent_id}");
    print(response.body.toString());
    return agentResponseFromJson(response.body);
  }
  Future<AgentResponse> getMyAgents({search}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/agents/agents?user_id=${user_id.$}&search="+search.toString());
    final response =
    await http.get(url);
    // print("${AppConfig.BASE_URL}/categories?parent_id=${parent_id}");
    print(response.body.toString());
    return agentResponseFromJson(response.body);
  }

}