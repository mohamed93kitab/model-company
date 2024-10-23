

import 'package:http/http.dart' as http;

import '../app_config.dart';
import '../models/transfer_response.dart';
import '../models/user_response.dart';
class TransferRepository {

  Future<TransferResponse> sendTransfer({from_id, to_id, points}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/transfer?from_id=${from_id}&to_id=${to_id}&points=${points}");
    final response = await http.get(url);
    // print("${AppConfig.BASE_URL}/categories?parent_id=${parent_id}");
    // print(response.body.toString());
    return transferResponseFromJson(response.body);
  }
  Future<TransferResponse> getTransfersRequests({user_id}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/transfer/my-tranfers?user_id=${user_id}");
    final response =
    await http.get(url);
    // print("${AppConfig.BASE_URL}/categories?parent_id=${parent_id}");
    // print(response.body.toString());
    return transferResponseFromJson(response.body);
  }
  Future<TransferResponse> getTransfersArchive({user_id}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/transfer/archive?user_id=${user_id}");
    final response =
    await http.get(url);
    // print("${AppConfig.BASE_URL}/categories?parent_id=${parent_id}");
     print(response.body.toString());
    return transferResponseFromJson(response.body);
  }
  Future<TransferResponse> acceptForTransform({from_id, to_id, id, approval}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/transfer/accept?to_id=${to_id}&id=${id}&approval=${approval}");
    final response =
    await http.get(url);
    // print("${AppConfig.BASE_URL}/categories?parent_id=${parent_id}");
    // print(response.body.toString());
    return transferResponseFromJson(response.body);
  }
}