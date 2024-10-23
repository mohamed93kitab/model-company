import 'dart:async';
import 'package:bab_algharb/screens/otp_verification.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:bab_algharb/screens/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart' hide LinearGradient;
import 'package:bab_algharb/assets.dart' as app_assets;
import '../components/auth_helper.dart';
import '../components/toast_componant.dart';
import '../repositories/auth_repository.dart';
import '../theme.dart';
import 'package:toast/toast.dart';
class RegisterScreen extends StatefulWidget {
  const RegisterScreen();

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _fullNameController = TextEditingController();
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

   SMITrigger _successAnim;
   SMITrigger _errorAnim;
   SMITrigger _confettiAnim;

  bool _isLoading = false;
  String register_by = 'phone';

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  void _onCheckRiveInit(Artboard artboard) {
    final controller =
    StateMachineController.fromArtboard(artboard, "State Machine 1");
    artboard.addController(controller);
    _successAnim = controller.findInput<bool>("Check") as SMITrigger;
    _errorAnim = controller.findInput<bool>("Error") as SMITrigger;
  }

  void _onConfettiRiveInit(Artboard artboard) {
    final controller =
    StateMachineController.fromArtboard(artboard, "State Machine 1");
    artboard.addController(controller);
    _confettiAnim =
    controller.findInput<bool>("Trigger explosion") as SMITrigger;
  }

  bool _obscureText = true;

   String _password;

  // Toggles the password show status
  toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  //controllers
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmController = TextEditingController();
  TextEditingController _user_nameController = TextEditingController();

  onPressSignUp() async {
    var name = _fullNameController.text.toString();
    var password = _passwordController.text.toString();
    var password_confirm = _passwordConfirmController.text.toString();
    var _phone = _phoneNumberController.text.toString();
    var _email = _emailController.text.toString();
    var _user_name = _user_nameController.text.toString();
    //
    // if (name == "") {
    //   ToastComponent.showDialog("حقل الإسم إجباري", gravity: Toast.center, duration: Toast.lengthLong);
    //   return;
    // } else if (_phone == "") {
    //   ToastComponent.showDialog("حقل رقم الهاتف إجباري", gravity: Toast.center, duration: Toast.lengthLong);
    //   return;
    // } else if (_phone.length < 10) {
    //   ToastComponent.showDialog("رقم الهاتف يجب أن يكون 10 أرقام", gravity: Toast.center, duration: Toast.lengthLong);
    //   return;
    // } else if (password == "") {
    //   ToastComponent.showDialog("كلمة المرور إجبارية", gravity: Toast.center, duration: Toast.lengthLong);
    //   return;
    // } else if (password.length < 8) {
    //   ToastComponent.showDialog(
    //       "كلمة المرور يجب أن تكون أطول من 8 أحرف أو أرقام", gravity: Toast.center, duration: Toast.lengthLong);
    //   return;
    // } else if (password != password_confirm) {
    //   ToastComponent.showDialog("كالمة المرور غير متطابقة", gravity: Toast.center, duration: Toast.lengthLong);
    //   return;
    // }

    var signupResponse = await AuthRepository().getSignupResponse(
        name: name,
       phone: register_by == 'phone' ? _phone : _email,
       password: password,
        password_confirm: password_confirm,
        register_by: register_by,
        user_name: _user_name
        );

    if (signupResponse.success == false) {
      CherryToast.error(
        disableToastAnimation: true,
        title: Text(
          'إنشاء حساب',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        action: Text("أسم المستخدم غير موجود!"),
        inheritThemeColors: true,
        actionHandler: () {},
        onToastClosed: () {},
      ).show(context);
    } else {
      print("00000000000000000000000000000000000000000000000000000000000000000000000000000000 "+register_by);
      //ToastComponent.showDialog(signupResponse.message, gravity: Toast.center, duration: Toast.lengthLong);
      Navigator.push(context, MaterialPageRoute(builder: (context) => OtpScreen(register_by: register_by, phone: _phoneNumberController.text.toString(), email: _emailController.text.toString(), password: _passwordController.text.toString(),from_signup: true)));


    }
  }

  onPressLogin() async {

    var password = _passwordController.text.toString();
    var _phone_number = register_by == 'phone' ? _phoneNumberController.text.toString() : _emailController.text.toString();


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

      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  constraints: const BoxConstraints(maxWidth: 600),
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [Colors.white.withOpacity(0.8), Colors.white10],
                    ),
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
                        const Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "الأسم الكامل",
                            style: TextStyle(
                                color: CupertinoColors.secondaryLabel,
                                fontSize: 15),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          decoration: authInputStyle("icon_email"),
                          controller: _fullNameController,
                        ),
                        register_by == 'phone' ? Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                         children: [
                           const SizedBox(height: 24),
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
                             keyboardType: TextInputType.phone,
                             controller: _phoneNumberController,
                           ),
                           GestureDetector(
                             onTap: () {
                               setState(() {
                                 register_by = "email";
                               });
                             },
                               child: Text("تسجيل الدخول بواسطة الإيميل")),
                         ],
                       ) :
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const SizedBox(height: 24),
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
                              keyboardType: TextInputType.emailAddress,
                              controller: _emailController,
                            ),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    register_by = "phone";
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
                        TextField(
                          obscureText: _obscureText,
                          decoration: InputDecoration(
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
                                child: Image.asset("assets/images/icon_lock.png")),
                            suffixIcon: IconButton(
                              onPressed: toggle,
                              icon: Icon(_obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                            ),
                          ),
                          controller: _passwordController,
                        ),
                        const SizedBox(height: 24),
                        const SizedBox(height: 8),
                        const Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "أسم المستخدم",
                            style: TextStyle(
                                color: CupertinoColors.secondaryLabel,
                                fontSize: 15),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          decoration: authInputStyle("icon_email"),
                          controller: _user_nameController,
                        ),
                        const SizedBox(height: 24),
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.accentColor.withOpacity(0.5),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              )
                            ],
                          ),
                          child: Column(
                            children: [
                              CupertinoButton(
                                padding: const EdgeInsets.all(20),
                                color: AppTheme.accentColor,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.arrow_forward_rounded),
                                    SizedBox(width: 4),
                                    Text(
                                      "إنشاء حساب",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                                onPressed: () {
                                      onPressSignUp();
                                },
                              ),
                            ],
                          ),
                        ),
                        Padding(padding: const EdgeInsets.symmetric(vertical: 24.0),),
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

                Positioned.fill(
                  child: IgnorePointer(
                    ignoring: true,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (_isLoading)
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: RiveAnimation.asset(
                              app_assets.checkRiv,
                              onInit: _onCheckRiveInit,
                            ),
                          ),
                        Positioned.fill(
                          child: SizedBox(
                            width: 500,
                            height: 500,
                            child: Transform.scale(
                              scale: 3,
                              child: RiveAnimation.asset(
                                app_assets.confettiRiv,
                                onInit: _onConfettiRiveInit,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Positioned(
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
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
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