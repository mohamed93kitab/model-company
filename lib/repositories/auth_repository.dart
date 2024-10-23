import 'package:bab_algharb/app_config.dart';
import 'package:bab_algharb/components/shared_value_helper.dart';
import 'package:http/http.dart' as http;
import 'package:bab_algharb/models/login_response.dart';
import 'package:bab_algharb/models/signup_response.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

import '../models/otp_response.dart';
import '../models/payment_repository.dart';
import '../models/user_by_id.dart';

class AuthRepository {
  Future<LoginResponse> getLoginResponse({String phone, String password, String login_by}) async {
    var post_body = jsonEncode({
      "phone_number": "${phone}",
      "password": "$password",
      "login_by" : "$login_by"
    });

    print("$phone");

    Uri url = Uri.parse("${AppConfig.BASE_URL}/auth/login");
    final response = await http.post(url,
        headers: {
          "Accept": "*/*",
          "Content-Type": "application/json",
        },
        body: post_body);

    print("++++++++++++++++++++++++++++++++++++++++++++++"+response.body);

    return loginResponseFromJson(response.body);
  }

  Future<LoginResponse> getSocialLoginResponse(@required String social_provider,
      @required String name, @required String email, @required String provider,
      {access_token = ""}) async {
    email = email == ("null") ? "" : email;

    var post_body = jsonEncode(
        {"name": "${name}", "email": email, "provider": "$provider","social_provider":"$social_provider","access_token":"$access_token"});

    Uri url = Uri.parse("${AppConfig.BASE_URL}/auth/social-login");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
        },
        body: post_body);
    print(post_body);
    print(response.body.toString());
    return loginResponseFromJson(response.body);
  }


  Future<SignupResponse> getSignupResponse(
      {String name, String phone, String password, String password_confirm, String register_by, String user_name}
      ) async {
    var post_body = jsonEncode({
      "name": "$name",
      "phone_number": "${phone}",
      "password": "$password",
      "password_confirmation": "${password_confirm}",
      "register_by": "$register_by",
      "username" : "$user_name"
    });

    print("phone"+phone+register_by+user_name);

    Uri url = Uri.parse("${AppConfig.BASE_URL}/auth/register");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
        },
        body: post_body);


    return signupResponseFromJson(response.body);
  }

  Future<SignupResponse> updatePasswordResponse(
      { String password, String con_password}
      ) async {
    var post_body = jsonEncode({
      "id": "${user_id.$}",
      "password": "$password",
      "con_password": "${con_password}",
    });

    Uri url = Uri.parse("${AppConfig.BASE_URL}/auth/update-password");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
        },
        body: post_body);

    print("===================================="+response.body);


    return signupResponseFromJson(response.body);
  }

  Future<UserByIdResponse> getUserByTokenResponse() async {
    var post_body = jsonEncode({"id": "${user_id.$}"});
    Uri url = Uri.parse("${AppConfig.BASE_URL}/auth/get-user-by-id");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
        },
        body: post_body);

    print("===================="+response.body);

    return userByIdResponseFromJson(response.body);
  }
  Future<SignupResponse> checkBlock() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/auth/block-check?user_id=${user_id.$}");
    final response = await http.get(url,
        headers: {
          "Content-Type": "application/json",
        },
        );

    print("===================="+response.body);

    return signupResponseFromJson(response.body);
  }
  Future<SignupResponse> otpConfirm({register_by, phone, code, email}) async {
    print("===================="+code.toString());
    Uri url = Uri.parse("${AppConfig.BASE_URL}/auth/otp/confirm-code?phone_number=${phone}&code=${code}&email=${email}&register_by=${register_by}");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
        },
        );

    print("===================="+response.body.toString());

    return signupResponseFromJson(response.body);
  }
  Future<SignupResponse> getLogout() async {
    var post_body = jsonEncode({"id": "${user_id.$}"});
    Uri url = Uri.parse("${AppConfig.BASE_URL}/auth/logout");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
        },
        body: post_body);

    print("===================="+response.body);

    return signupResponseFromJson(response.body);
  }

  Future<PaymentResponse> sendPaymentRequest({var amount,var paymentMethod,var number, var card_name, var expire}) async {
    var post_body = jsonEncode({
      "user_id": "${user_id.$}",
      "username" : "${user_name}",
      "amount" : "${amount}",
      "payment_method" : "${paymentMethod}",
      "number" : "${number}",
      "card_name" : "${card_name}",
      "expire" : "${expire}",
      });
    Uri url = Uri.parse("${AppConfig.BASE_URL}/auth/payment-request");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
        },
        body: post_body);

    print("===================="+response.body);

    return paymentResponseFromJson(response.body);
  }

  Future<PaymentResponse> getPaymentRequest() async {

    Uri url = Uri.parse("${AppConfig.BASE_URL}/auth/payment-request/get?user_id=${user_id.$}");
    final response = await http.get(url,
        headers: {
          "Content-Type": "application/json",
        });

    print("===================="+response.body);

    return paymentResponseFromJson(response.body);
  }


  Future<SignupResponse> deleteAccountResponse({id}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/auth/delete-account?user_id="+id.toString());
    final response = await http.post(
      url,
      headers: {
        "Accept": "*/*",
        "Content-Type": "application/json",
        "App-Language": app_language.$,
      },
    );

    print(response.body);

    return signupResponseFromJson(response.body);
  }


}