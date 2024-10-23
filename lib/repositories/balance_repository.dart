import 'dart:convert';

import 'package:bab_algharb/components/shared_value_helper.dart';

import '../app_config.dart';
import '../models/login_response.dart';
import 'package:http/http.dart' as http;

class BalanceRepository {
  Future<LoginResponse> minusStarsResponse(int stars) async {
    var post_body = jsonEncode({
      "user_id": "${user_id.$}",
      "stars": "$stars",
    });

    Uri url = Uri.parse("${AppConfig.BASE_URL}/stars/minus");
    final response = await http.post(url,
        headers: {
          "Accept": "*/*",
          "Content-Type": "application/json",
        },
        body: post_body);

    print("++++++++++++++++++++++++++++++++++++++++++++++" + response.body);

    return loginResponseFromJson(response.body);
  }
}
