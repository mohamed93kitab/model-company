import 'package:bab_algharb/screens/splash_screen.dart';
import 'package:bab_algharb/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_value/shared_value.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

 await OneSignal.shared.setAppId("cc7837e0-673e-4db6-b5cf-c03363470901");

//  The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  await OneSignal.shared.promptUserForPushNotificationPermission(
    fallbackToSettings: true,
  );


  runApp(
      SharedValue.wrapApp(
      MyApp()
  )
  );
}

class MyApp extends StatelessWidget {
  const MyApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GetMaterialApp(
      title: 'Bab Algharb',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale("ar", "AE"), // OR Locale('ar', 'AE') OR Other RTL locales
      ],
      locale: Locale("ar", "AE") ,// OR Locale('ar', 'AE') OR Other RTL locales,
      theme: ThemeData(
        // useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.light(
            background: AppTheme.light_bg,
            secondary: Color(0xffffffff),
            tertiary: Color(0xffeeeeee)
        ),
        textTheme: GoogleFonts.cairoTextTheme(textTheme).copyWith(
          bodyText1: GoogleFonts.cairo(textStyle: textTheme.bodyText1),
          bodyText2: GoogleFonts.cairo(textStyle: textTheme.bodyText1, fontSize: 12),
        )
      ),
      home: SplashScreen(),
    );
  }
}
