import 'package:flutter/material.dart';

import '../onboarding/onboarding.dart';
import 'package:cherry_toast/cherry_toast.dart';
class StartApp extends StatefulWidget {
  final is_logout;
  const StartApp({this.is_logout});

  @override
  State<StartApp> createState() => _StartAppState();
}

class _StartAppState extends State<StartApp> {

  @override
  void initState() {
    // TODO: implement initState

    if(widget.is_logout == true) {
      CherryToast.success(
        disableToastAnimation: true,
        title: Text(
          'تسجيل الخروج',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        action: Text('تم تسجيل الخروج بنجاح'),
        inheritThemeColors: true,
        actionHandler: () {},
        onToastClosed: () {},
      ).show(context);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: OnBoardingView(),
    );
  }
}
