import 'package:bab_algharb/repositories/auth_repository.dart';
import 'package:bab_algharb/components/shared_value_helper.dart';
class AuthHelper {
  setUserData(loginResponse) {
    if (loginResponse.success == true) {
      is_logged_in.$ = true;
      is_logged_in.save();
      access_token.$ = loginResponse.data.token;
      access_token.save();
      user_id.$ = loginResponse.data.id;
      user_id.save();
      user_name.$ = loginResponse.data.name;
      user_name.save();
      username.$ = loginResponse.data.username;
      username.save();
      user_phone.$ = loginResponse.data.phone_number;
      user_phone.save();
      user_points.$ = loginResponse.data.points;
      user_points.save();
      user_stars.$ = loginResponse.data.stars;
      user_stars.save();
      role_name.$ = loginResponse.data.role_name;
      role_name.save();
      if(loginResponse.data.photo != null) {
        photo.$ = loginResponse.data.photo;
        photo.save();
      }

    }
  }

  clearUserData() {
    is_logged_in.$ = false;
    is_logged_in.save();
    access_token.$ = "";
    access_token.save();
    user_id.$ = 0;
    user_id.save();
    user_name.$ = "";
    user_name.save();
    username.$ = "";
    username.save();
    user_phone.$ = "";
    user_phone.save();
    photo.$ = "";
    photo.save();
    user_points.$ = 0;
    user_points.save();
    user_stars.$ = 0;
    user_stars.save();
    role_name.$ = '';
    role_name.save();
  }


  fetch_and_set() async {
    var userByTokenResponse = await AuthRepository().getUserByTokenResponse();

    if (userByTokenResponse.result == true) {
      is_logged_in.$ = true;
      is_logged_in.save();
      user_id.$ = userByTokenResponse.id;
      user_id.save();
      user_name.$ = userByTokenResponse.name;
      user_name.save();
      username.$ = userByTokenResponse.email;
      username.save();
      user_phone.$ = userByTokenResponse.phone;
      user_phone.save();
    }else{
      is_logged_in.$ = false;
      is_logged_in.save();
      user_id.$ = 0;
      user_id.save();
      user_name.$ = "";
      user_name.save();
      username.$ = "";
      username.save();
      user_phone.$ = "";
      user_phone.save();
      photo.$ = "";
      photo.save();
    }
  }
}