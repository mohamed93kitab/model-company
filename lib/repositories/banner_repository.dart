import 'package:http/http.dart' as http;
import '../app_config.dart';
import '../models/banner_response.dart';

class BannerRepository {

  Future<BannerResponse> getLatestBanners({user_id = 0}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/banners");
    final response =
    await http.get(url);
    // print("${AppConfig.BASE_URL}/categories?parent_id=${parent_id}");
    print(response.body.toString());
    return bannerResponseFromJson(response.body);
  }

}