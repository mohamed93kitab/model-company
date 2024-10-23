import 'package:bab_algharb/app_config.dart';
import 'package:bab_algharb/components/auth_helper.dart';
import 'package:bab_algharb/components/shared_value_helper.dart';
import 'package:bab_algharb/screens/start.dart';
import 'package:bab_algharb/screens/vertual_device_screen.dart';
import 'package:bab_algharb/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'check_virtual.dart';
import 'home.dart';

class SplashScreen extends StatefulWidget {
  final is_logout;
  const SplashScreen({this.is_logout});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isVirtualApp = false;
  @override
  void initState() {
    // TODO: implement initState
    _checkIfRunningInVirtualApp();
       super.initState();
  }
  Future<void> _checkIfRunningInVirtualApp() async {
    final isVirtual = await isRunningInVirtualApp();
    setState(() {
      _isVirtualApp = isVirtual;
    });
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: getSharedValueHelperData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Future.delayed(Duration(seconds: 3)).then((value) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    //
                    // if(_isVirtualApp == false) {
                    //   return VirtualScreen();
                    // }

                    if (is_logged_in.$ == true) {
                      return HomeScreen();
                    } else {
                      return StartApp(is_logout: false);
                    }
                  },
                ),
                (route) => false,
              );
            });
          }
          return splashScreen();
        });
  }

  Widget splashScreen() {
    return Container(
      width: MediaQuery.of(context).size.height,
      height: MediaQuery.of(context).size.height,
      color: AppTheme.splash_screen_color,
      child: Stack(
        // mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // CircleAvatar(
          //   backgroundColor: Colors.transparent,
          //   child: Hero(
          //     tag: "backgroundImageInSplash",
          //     child: Container(
          //       child: Image.asset(
          //           "assets/splash_login_registration_background_image.png"),
          //     ),
          //   ),
          //   radius: 140.0,
          // ),
          Positioned.fill(
            top: MediaQuery.of(context).size.height / 2 - 92,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Hero(
                    tag: "splashscreenImage",
                    child: Container(
                      height: 92,
                      width: 92,
                      // padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
                      decoration: BoxDecoration(
                          border: Border.all(color: AppTheme.white, width: 1),
                          color: AppTheme.white,
                          borderRadius: BorderRadius.circular(22)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset(
                          "assets/images/splash_screen_logo.png",
                          filterQuality: FilterQuality.low,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 5.0),
                  child: Text(
                    AppConfig.app_name,
                    style: GoogleFonts.cairo(
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0,
                        color: AppTheme.backgroundDark),
                  ),
                ),
                Text(
                  "V " + AppConfig.version,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                    color: AppTheme.backgroundDark,
                  ),
                ),
              ],
            ),
          ),

          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 51.0),
                child: Text(
                  AppConfig.copyright_text,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 13.0,
                    color: AppTheme.backgroundDark,
                  ),
                ),
              ),
            ),
          ),
          /*
          Padding(
            padding: const EdgeInsets.only(top: 120.0),
            child: Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[

                  ],
                )),
          ),*/
        ],
      ),
    );
  }

  Future<String> getSharedValueHelperData() async {
    access_token.load().whenComplete(() {
      AuthHelper().fetch_and_set();
    });

    app_language.load();
    app_mobile_language.load();
    app_language_rtl.load();
    access_token.load();
    username.load();
    user_name.load();
    user_id.load();
    user_phone.load();
    photo.load();
    is_logged_in.load();

    // print("new splash screen ${app_mobile_language.$}");
    // print("new splash screen app_language_rtl ${app_language_rtl.$}");

    return app_mobile_language.$;
  }
}
