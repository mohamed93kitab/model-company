import 'package:bab_algharb/screens/register.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:rive/rive.dart';
import 'package:bab_algharb/assets.dart' as app_assets;
import '../components/auth_helper.dart';
import '../components/shared_value_helper.dart';
import '../repositories/auth_repository.dart';
import '../repositories/notification_repository.dart';
import '../theme.dart';
import 'home.dart';
import 'otp_verification.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen();

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  ScaffoldState scaffold;

  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passController = TextEditingController();


  bool _isLoading = false;
  String login_by = 'phone';


  void login() async {
    var password = _passController.text.toString();
    var _phone_number = _phoneController.text.toString();
    var _email = _emailController.text.toString();


    var loginResponse = await AuthRepository()
        .getLoginResponse(
        phone: login_by == 'phone' ? _phone_number : _email,
        password:  password,
        login_by: login_by
    );

    if (loginResponse.success == false) {
      CherryToast.error(
        disableToastAnimation: true,
        title: Text(
          "خطأ",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        action: Text("خطأ في تسجيل الدخول"),
        inheritThemeColors: true,
        actionHandler: () {},
        onToastClosed: () {},
      ).show(context);
    } else if(loginResponse.data.verified_account == 1 || loginResponse.data.verified_account == null) {
      AuthHelper().setUserData(loginResponse);
      final status = await OneSignal.shared.getDeviceState();
      final String osUserID = status.userId;
      //
      // print("testttttttttttttttttttttttttttttttttttttttttttttt"+loginResponse.user_id.toString());
      var notificationResponse = await NotificationRepository()
          .updatePlayerIdResponse(osUserID, user_id.$);

      setState(() {
        _isLoading = true;
      });

      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));

    }else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => OtpScreen(register_by: login_by, phone: _phoneController.text, password: _passController.text,)));
    }


    bool isEmailValid = _emailController.text.trim().isNotEmpty;
    bool isPassValid = _passController.text.trim().isNotEmpty;
    bool isValid = isEmailValid && isPassValid;





  }
  bool _obscureText = true;

  String _password;

  // Toggles the password show status
  toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    Future<Null>.delayed(Duration.zero, () {
      _showSnackbar();
    });
    super.initState();
  }

  void _showSnackbar() {
    SnackBar(content: Text("تم تسجيل الخروج بنجاح"),);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  constraints: const BoxConstraints(maxWidth: 600),
                  margin: const EdgeInsets.all(16),
                  padding: EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(29),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: AppTheme.shadow.withOpacity(0.3),
                              offset: const Offset(0, 3),
                              blurRadius: 5),
                          BoxShadow(
                              color: AppTheme.shadow.withOpacity(0.3),
                              offset: const Offset(0, 30),
                              blurRadius: 30)
                        ],
                        color: CupertinoColors.secondarySystemBackground,
                        // This kind of give the background iOS style "Frosted Glass" effect,
                        // it works for this particular color, might not for other
                        backgroundBlendMode: BlendMode.luminosity),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "تسجيل الدخول",
                          style: TextStyle( fontSize: 34),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                            "سجل الدخول لحسابك للدخول إلى التطبيق",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600)),
                        const SizedBox(height: 24),
                        login_by == 'phone' ? Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "رقم الهاتف",
                                style: TextStyle(
                                    color: CupertinoColors.secondaryLabel,
                                    fontSize: 15),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              decoration: authInputStyle("icon_email"),
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                            ),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    login_by = "email";
                                  });
                                },
                                child: Text("تسجيل الدخول بواسطة الإيميل")),
                          ],
                        ): Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "البريد الإلكتروني",
                                style: TextStyle(
                                    color: CupertinoColors.secondaryLabel,
                                    fontSize: 15),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              decoration: authInputStyle("icon_email"),
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    login_by = "phone";
                                  });
                                },
                                child: Text("تسجيل الدخول بواسطة رقم الهاتف")),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "كلمة المرور",
                            style: TextStyle(
                                color: CupertinoColors.secondaryLabel,
                                fontSize: 15),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppTheme.white,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.black.withOpacity(0.1))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.black.withOpacity(0.1))),
                            contentPadding: const EdgeInsets.all(15),
                            prefixIcon: Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: Image.asset("assets/images/icon_lock.png")),
                            suffixIcon: IconButton(
                              onPressed: toggle,
                              icon: Icon(_obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                            ),
                          ),
                          controller: _passController,
                        ),
                        const SizedBox(height: 24),
                        Column(
                          children: [
                            CupertinoButton(
                              padding: const EdgeInsets.all(20),
                              color: const Color(0xFFF77D8E),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.arrow_forward_rounded),
                                  SizedBox(width: 4),
                                  Text(
                                    "تسجيل الدخول",
                                    style: GoogleFonts.cairo(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              onPressed: () {
                                if (!_isLoading) login();
                              },
                            ),
                            SizedBox(height: 18,),
                            CupertinoButton(
                              padding: const EdgeInsets.all(20),
                              color: AppTheme.accentColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.arrow_forward_rounded),
                                  SizedBox(width: 4),
                                  Text(
                                    "إنشاء حساب",
                                    style: GoogleFonts.cairo(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 70,)
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(vertical: 24.0),
                        //   child: Row(
                        //     children: [
                        //       const Expanded(child: Divider()),
                        //       Padding(
                        //         padding:
                        //         const EdgeInsets.symmetric(horizontal: 8),
                        //         child: Text(
                        //           "أو",
                        //           style: TextStyle(
                        //             color: Colors.black.withOpacity(0.3),
                        //             fontSize: 15,),
                        //         ),
                        //       ),
                        //       const Expanded(child: Divider()),
                        //     ],
                        //   ),
                        // ),
                        // const Text("الدخول من خلال",
                        //     style: TextStyle(
                        //         color: CupertinoColors.secondaryLabel,
                        //         fontSize: 15)),
                        // const SizedBox(height: 24),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Image.asset(app_assets.logoEmail),
                        //     Image.asset(app_assets.logoApple),
                        //     Image.asset(app_assets.logoGoogle)
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ),


                Visibility(
                  visible: false,
                  child: Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Align(
                      alignment: Alignment.center,
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        borderRadius: BorderRadius.circular(36 / 2),
                        minSize: 36,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(36 / 2),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.shadow.withOpacity(0.3),
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              )
                            ],
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.black,
                          ),
                        ),
                        onPressed: () {
                        //  widget.closeModal();
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
InputDecoration authInputStyle(String iconName) {
  return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.black.withOpacity(0.1))),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.black.withOpacity(0.1))),
      contentPadding: const EdgeInsets.all(15),
      prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Image.asset("assets/images/$iconName.png")));
}