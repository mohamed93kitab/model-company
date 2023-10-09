import 'dart:async';
import 'dart:io';

import 'package:model_company/custom/common_functions.dart';
import 'package:model_company/my_theme.dart';
import 'package:model_company/presenter/bottom_appbar_index.dart';
import 'package:model_company/presenter/cart_counter.dart';
import 'package:model_company/repositories/cart_repository.dart';
import 'package:model_company/screens/cart.dart';
import 'package:model_company/screens/category_list.dart';
import 'package:model_company/screens/home.dart';
import 'package:model_company/screens/login.dart';
import 'package:model_company/screens/profile.dart';
import 'package:model_company/screens/wishlist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:model_company/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:badges/badges.dart' as badges;
import 'package:route_transitions/route_transitions.dart';

import 'filter.dart';

class Main extends StatefulWidget {
  Main({Key key, go_back = true}) : super(key: key);

  bool go_back;

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  int _currentIndex = 0;
  //int _cartCount = 0;

  BottomAppbarIndex bottomAppbarIndex = BottomAppbarIndex();
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();


  var _children = [];


  void onTapped(int i) {
    if (!is_logged_in.$ && (i == 4 || i == 2)) {
      
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
      return;
    }

    if(i== 2){
      app_language_rtl.$ ?slideLeftWidget(newPage: Profile(), context: context):slideRightWidget(newPage: Profile(), context: context);
      return;
    }

    setState(() {
      _currentIndex = i;
    });
    //print("i$i");
  }


  void initState() {
    _children = [
      Home(),
      CategoryList(
        is_base_category: true,
      ),
      Profile(),
      Filter(),
      Wishlist(),
    ];
    // TODO: implement initState
    //re appear statusbar in case it was not there in the previous page
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.initState();
  }
  DateTime currentBackPressTime;



  DateTime pre_backpress = DateTime.now();


  @override
  Widget build(BuildContext context){
    return WillPopScope(
      onWillPop: () async {
        //print("_currentIndex");
        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
          return false;
        } else {
          final timegap = DateTime.now().difference(pre_backpress);

          final cantExit = timegap >= Duration(seconds: 2);

          pre_backpress = DateTime.now();

          if(cantExit){
            if(widget.go_back == false) {
              return false; // false will do nothing when back press
            }
            //show snackbar
            if (_key.currentState.isDrawerOpen) {
              _key.currentState.closeDrawer();
            }
            final snack = SnackBar(content: Text('أضغط مرتين للخروج من التطبيق', ),duration: Duration(seconds: 2),);

            ScaffoldMessenger.of(context).showSnackBar(snack);

            return false; // false will do nothing when back press
          }else{
            exit(0);// true will exit the app
          }

          // showDialog(
          //     context: context,
          //     barrierDismissible: true,
          //     builder: (context) => Directionality(
          //       textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
          //       child: AlertDialog(
          //         content: Text(AppLocalizations.of(context).home_screen_close_app),
          //         actions: [
          //           TextButton(
          //               onPressed: () {
          //                 Platform.isAndroid ? SystemNavigator.pop() : exit(0);
          //               },
          //               child: Text(AppLocalizations.of(context).common_yes)),
          //           TextButton(
          //               onPressed: () {
          //                 Navigator.pop(context);
          //               },
          //               child: Text(AppLocalizations.of(context).common_no)),
          //         ],
          //       ),
          //     ));
          // CommonFunctions(context).appExitDialog();
          //exit(0);

        }
        return widget.go_back;
      },
      child: Directionality(
        textDirection:
            app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
          key: _key,
          extendBody: true,
          body: _children[_currentIndex],
          bottomNavigationBar: BottomAppBar(
            color: Colors.transparent,

            clipBehavior: Clip.antiAlias,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
              child: SizedBox(
                height: 84,
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  onTap: onTapped,
                  currentIndex:_currentIndex,
                  backgroundColor: MyTheme.accent_color,
                  unselectedItemColor: MyTheme.secondary_color,
                  selectedItemColor: MyTheme.secondary_color,
                  selectedLabelStyle: TextStyle(fontWeight:FontWeight.w700,color: MyTheme.secondary_color,fontSize: 12 ),
                  unselectedLabelStyle: TextStyle(fontWeight:FontWeight.w400,color:MyTheme.secondary_color,fontSize: 12 ),

                  items: [
                    BottomNavigationBarItem(
                        icon: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Image.asset(
                            "assets/home.png",
                            color: _currentIndex == 0
                                ? MyTheme.secondary_color
                                : MyTheme.secondary_color,
                            height: 16,
                          ),
                        ),
                        label:  AppLocalizations.of(context)
                            .main_screen_bottom_navigation_home),
                    BottomNavigationBarItem(
                        icon: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Image.asset(
                            "assets/categories.png",
                            color: _currentIndex == 1
                                ? MyTheme.secondary_color
                                : MyTheme.secondary_color,
                            height: 16,
                          ),
                        ),
                        label: AppLocalizations.of(context)
                            .main_screen_bottom_navigation_categories),

                    BottomNavigationBarItem(
                      icon: Image.asset(
                        "assets/profile.png",
                        color: MyTheme.secondary_color,
                        height: 22,
                      ),
                      label: AppLocalizations.of(context)
                          .main_screen_bottom_navigation_profile,
                    ),

                    BottomNavigationBarItem(
                      icon: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Image.asset(
                          "assets/search.png",
                          color: _currentIndex == 3
                              ? MyTheme.secondary_color
                              : MyTheme.secondary_color,
                          height: 16,
                        ),
                      ),
                      label: AppLocalizations.of(context)
                          .home_screen_search,
                    ),


                    BottomNavigationBarItem(
                      icon: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Image.asset(
                          "assets/heart.png",
                          color: _currentIndex == 4
                              ? MyTheme.secondary_color
                              : MyTheme.secondary_color,
                          height: 16,
                        ),
                      ),
                      label: AppLocalizations.of(context)
                          .wishlist_screen_my_wishlist,
                    ),



                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


}
