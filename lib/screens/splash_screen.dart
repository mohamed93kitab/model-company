import 'package:model_company/app_config.dart';
import 'package:model_company/custom/device_info.dart';
import 'package:model_company/helpers/addons_helper.dart';
import 'package:model_company/helpers/auth_helper.dart';
import 'package:model_company/helpers/business_setting_helper.dart';
import 'package:model_company/helpers/shared_value_helper.dart';
import 'package:model_company/my_theme.dart';
import 'package:model_company/providers/locale_provider.dart';
import 'package:model_company/screens/main.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  PackageInfo _packageInfo = PackageInfo(
    appName: AppConfig.app_name,
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initPackageInfo();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: getSharedValueHelperData(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            Future.delayed(Duration(seconds: 3)).then((value) {
              Provider.of<LocaleProvider>(context,listen: false).setLocale(app_mobile_language.$);
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context) {
                    return Main(go_back: false,);
                  },
                  ),(route)=>false,);
            }
            );

          }
          return splashScreen();
        }
    );
  }

  Widget splashScreen() {
    return Container(
      width: DeviceInfo(context).height,
      height: DeviceInfo(context).height,
      color:  MyTheme.splash_screen_color,
      child: InkWell(
        child: Stack(

          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Opacity(
              opacity: 0.0,
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Hero(
                  tag: "backgroundImageInSplash",
                  child: Container(
                    child: Image.asset(
                        "assets/splash_login_registration_background_image.png"),
                  ),
                ),
                radius: 140.0,
              ),
            ),
            Positioned.fill(
              top: DeviceInfo(context).height/2-72,
              child: Column(
                children: [
                  Hero(
                    tag: "splashscreenImage",
                    child: Container(
                      height: 172,
                      width: 172,
                      padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
                      decoration: BoxDecoration(
                        color: MyTheme.black,
                        borderRadius: BorderRadius.circular(8)
                      ),
                      child: Image.asset(
                          "assets/splash_screen_logo.png",
                        filterQuality: FilterQuality.low,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      AppConfig.app_name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          color: Colors.white),
                    ),
                  ),
                  Text(
                    "V " + AppConfig.version,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13.0,
                        color: Colors.white,
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
                    "",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 13.0,
                      color: Colors.white,
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
      ),
    );
  }

  Future<String>  getSharedValueHelperData()async{
    access_token.load().whenComplete(() {
      AuthHelper().fetch_and_set();
    });
    AddonsHelper().setAddonsData();
    BusinessSettingHelper().setBusinessSettingData();
    await app_language.load();
    await app_mobile_language.load();
    await app_language_rtl.load();

    // print("new splash screen ${app_mobile_language.$}");
    // print("new splash screen app_language_rtl ${app_language_rtl.$}");

    return app_mobile_language.$;

  }
}
