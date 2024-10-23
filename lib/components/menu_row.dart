

import 'package:bab_algharb/screens/counters_screen.dart';
import 'package:bab_algharb/screens/countries.dart';
import 'package:bab_algharb/screens/game_screen.dart';
import 'package:bab_algharb/screens/subscribes_archive.dart';
import 'package:bab_algharb/screens/team_screen.dart';
import 'package:bab_algharb/screens/transfers_requests.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rive/rive.dart';
import 'package:bab_algharb/models/menu_item.dart';
import 'package:bab_algharb/assets.dart' as app_assets;

import '../screens/convert_screen.dart';
import '../screens/friends_screen.dart';
import '../screens/payment_requests.dart';
import '../screens/profile_screen.dart';

class MenuRow extends StatelessWidget {
  const MenuRow(
      { this.menu, this.selectedMenu = "Home", this.onMenuPress});

  final MenuItemModel menu;
  final String selectedMenu;
  final Function onMenuPress;

  void _onMenuIconInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
        artboard, menu.riveIcon.stateMachine);
    artboard.addController(controller);
    menu.riveIcon.status = controller.findInput<bool>("active") as SMIBool;
  }



  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // The menu button background that animates as we click on it
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: selectedMenu == menu.title ? 288.0 - 16 : 0,
          height: 56,
          curve: const Cubic(0.2, 0.8, 0.2, 1),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(10),
          ),
        ),

        CupertinoButton(
          padding: EdgeInsets.all(12),
          pressedOpacity: 1, // disable touch effect
          onPressed: () {
            if (selectedMenu != menu.title) {
              if(menu.title == "الدخول إلى المسابقة") {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => GameScreen()));
              }
              if(menu.title == "تحويل النقاط") {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => ConvertScreen()));
              }

              if(menu.title == "طلبات التحويل") {
                Navigator.push(context, MaterialPageRoute(builder: (context) => TransferScreen()));
              }
              if(menu.title == "الأصدقاء") {
                Navigator.push(context, MaterialPageRoute(builder: (context) => FriendScreen()));
              }
              if(menu.title == "المحفظة") {
                Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentScreen()));
              }
              if(menu.title == "الوكلاء") {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Country()));
              }
              if(menu.title == "العدادات") {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CounterScreen()));
              }
              if(menu.title == "سجل الإشتراكات") {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SubArchive()));
              }
              if(menu.title == "الفريق") {
                Navigator.push(context, MaterialPageRoute(builder: (context) => TeamScreen()));
              }

              if(menu.title == "إعدادات الخصوصية") {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
              }
              onMenuPress();
              menu.riveIcon.status.change(true);
              Future.delayed(const Duration(seconds: 1), () {
                menu.riveIcon.status.change(false);
              });
            }
          },
          child: Row(
            children: [
              menu.riveIcon.artboard == "convert coins" ?
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: Icon(Icons.repeat, color: Colors.white,),
                  ) :
              SizedBox(
                width: 32,
                height: 32,
                child: Opacity(
                  opacity: 0.6,
                  child: RiveAnimation.asset(
                    app_assets.iconsRiv,
                    stateMachines: [menu.riveIcon.stateMachine],
                    artboard: menu.riveIcon.artboard,
                    onInit: _onMenuIconInit,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Text(
                menu.title,
                style: GoogleFonts.cairo(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 17),
              )
            ],
          ),
        ),
      ],
    );
  }
}