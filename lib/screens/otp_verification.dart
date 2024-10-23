import 'package:bab_algharb/repositories/auth_repository.dart';
import 'package:bab_algharb/screens/home.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:bab_algharb/theme.dart';
import 'package:pinput/pinput.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../app_config.dart';
import '../components/auth_helper.dart';
import '../components/shared_value_helper.dart';
import '../repositories/notification_repository.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({this.register_by, this.phone, this.password, this.email, this.from_signup});
  final register_by;
  final phone;
  final password;
  final from_signup;
  final email;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otpController = TextEditingController();

  onConfirmPressed() async {
    var otpResponse = await AuthRepository().otpConfirm(register_by: widget.register_by, phone: widget.register_by == "phone" ? widget.phone : widget.email, email: widget.email, code: _otpController.text);
    if(otpResponse.success == true) {
      CherryToast.success(
        disableToastAnimation: true,
        title: Text(
          'تأكيد الحساب',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        action: Text('تم تأكيد الحساب بنجاح'),
        inheritThemeColors: true,
        actionHandler: () {},
        onToastClosed: () {},
      ).show(context);
      onPressLogin();
    }else {
      CherryToast.error(
        disableToastAnimation: true,
        title: Text(
          'تأكيد الحساب',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        action: Text(otpResponse.message),
        inheritThemeColors: true,
        actionHandler: () {},
        onToastClosed: () {},
      ).show(context);
    }

  }

  onPressLogin() async {

    var password = widget.password;
    var _phone_number = widget.register_by == 'phone' ? widget.phone : widget.phone;


    var loginResponse = await AuthRepository()
        .getLoginResponse(phone: _phone_number, password: password);

    if (loginResponse.success == false) {
      CherryToast.success(
        disableToastAnimation: true,
        title: Text(
          'خطأ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        action: Text(loginResponse.message),
        inheritThemeColors: true,
        actionHandler: () {},
        onToastClosed: () {},
      ).show(context);
    } else {

      //ToastComponent.showDialog(loginResponse.message!, gravity: Toast.center, duration: Toast.lengthLong);
      CherryToast.success(
        disableToastAnimation: true,
        title: Text(
          'login success',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        action: Text(loginResponse.message),
        inheritThemeColors: true,
        actionHandler: () {},
        onToastClosed: () {},
      ).show(context);


      AuthHelper().setUserData(loginResponse);
      //push norification ends
      final status = await OneSignal.shared.getDeviceState();
      final String osUserID = status.userId;
      //
      // print("testttttttttttttttttttttttttttttttttttttttttttttt"+loginResponse.user_id.toString());
      var notificationResponse = await NotificationRepository()
          .updatePlayerIdResponse(osUserID, user_id.$);
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/illustration-3.png',
                width: 150,
                height: 150,
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                "تأكيد الحساب",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "ضع الكود الذي تم إرساله لك",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 30,
              ),
              Pinput(
                length: 6,
                // defaultPinTheme: defaultPinTheme,
                // focusedPinTheme: focusedPinTheme,
                // submittedPinTheme: submittedPinTheme,
                controller: _otpController,

                showCursor: true,
                onCompleted: (pin) => print(pin),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () {
                      print("====================================="+_otpController.text);

                      onConfirmPressed();
                    },
                    child: Text("تأكيد")),
              ),
              // Row(
              //   children: [
              //     TextButton(
              //         onPressed: () {
              //           Navigator.pushNamedAndRemoveUntil(
              //             context,
              //             'phone',
              //                 (route) => false,
              //           );
              //         },
              //         child: Text(
              //           "Edit Phone Number ?",
              //           style: TextStyle(color: Colors.black),
              //         ))
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }

}
