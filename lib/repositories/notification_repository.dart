import 'package:http/http.dart' as http;
import '../app_config.dart';
import '../components/shared_value_helper.dart';
import '../models/notification_response.dart';

class NotificationRepository {

  Future<NotificationResponse> getLatestNotifications() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/notifications/get?user_id=${user_id.$}");
    final response =
    await http.get(url);
    // print("${AppConfig.BASE_URL}/categories?parent_id=${parent_id}");
    print("-----------------------------------------------------------++++++++++++++++++++++++++++++++++++++"+user_id.$.toString());
    return notificationsResponseFromJson(response.body);
  }

  Future<NotificationResponse> updatePlayerIdResponse(String osUserID, var user_id) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/notifications/update-playerId?user_id=${user_id}&notification_id=$osUserID");
    final response = await http.get(url,
        headers: {
          "Accept": "*/*",
          "Content-Type": "application/json",
        });
    return notificationsResponseFromJson(response.body);
  }

}