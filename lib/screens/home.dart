import 'package:bab_algharb/components/shared_value_helper.dart';
import 'package:bab_algharb/onboarding/signin_view.dart';
import 'package:bab_algharb/repositories/auth_repository.dart';
import 'package:bab_algharb/screens/profile_screen.dart';
import 'package:bab_algharb/screens/shop/shop_screen.dart';
import 'package:bab_algharb/tabs/search_tab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart' hide LinearGradient;
import 'dart:math' as math;
import 'package:bab_algharb/navigation/custom_tab_bar.dart';
import 'package:bab_algharb/navigation/home_tab_view.dart';
import 'package:bab_algharb/onboarding/onboarding.dart';
import 'package:bab_algharb/navigation/side_menu.dart';
import 'package:bab_algharb/theme.dart';
import 'package:bab_algharb/assets.dart' as app_assets;
import 'package:cherry_toast/cherry_toast.dart';
import '../navigation/notification_tab_view.dart';
import '../navigation/profile_tab_view.dart';
import '../navigation/timeline_tab_view.dart';

// Common Tab Scene for the tabs other than 1st one, showing only tab name in center
Widget commonTabScene(String tabName) {
  if(tabName == "Timer") {
    return SearchTab();
  }
  return Container(
      color: AppTheme.background,
      alignment: Alignment.center,
      child: Text(tabName,
          style: const TextStyle(
              fontSize: 28, fontFamily: "Poppins", color: Colors.black)));
}

class HomeScreen extends StatefulWidget {
  const HomeScreen();

  static const String route = '/course-rive';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
   AnimationController _animationController;
   AnimationController _onBoardingAnimController;
   Animation<double> _onBoardingAnim;
   Animation<double> _sidebarAnim;

   SMIBool _menuBtn;

   check_block() async {
    var checkResponse = await AuthRepository().checkBlock();
    if(checkResponse.success == true) {
      setState(() {
        is_logged_in.$ = false;
        is_logged_in.save();
        access_token.$ = "";
        access_token.save();
        user_id.$ = 0;
        user_id.save();
        user_name.$ = "";
        user_name.save();
        username.$ = "";
        username.save();
        user_phone.$ = "";
        user_phone.save();
        photo.$ = "";
        photo.save();
        user_points.$ = 0;
        user_points.save();
        user_stars.$ = 0;
        user_stars.save();



      });
      CherryToast.error(
        disableToastAnimation: true,
        title: Text(
          'حسابك محظور',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        action: Text("قام أحد المسؤولين بحظر حسابك!"),
        inheritThemeColors: true,
        actionHandler: () {},
        onToastClosed: () {},
      ).show(context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>SignInView()));
    }

   }

  bool _showOnBoarding = false;
  var _selectedIndex = 1;
  Widget _tabBody = Container(color: AppTheme.background);
  final List<Widget> _screens = [
    const HomeTabView(),
    const TimelineTabView(),
    commonTabScene("Timer"),
    const ShopScreen(),
    const ProfileTabView(),
  ];

   DateTime currentBackPressTime;

   Future<bool> onWillPop() {
     DateTime now = DateTime.now();
     if (currentBackPressTime == null ||
         now.difference(currentBackPressTime) > Duration(seconds: 2)) {
       currentBackPressTime = now;
       CherryToast.warning(
         disableToastAnimation: true,
         title: Text(
           "أضغط مرتين للخروج من التطبيق!",
           style: TextStyle(
             fontWeight: FontWeight.bold,
           ),
         ),
         action: Text(""),
         inheritThemeColors: true,
         actionHandler: () {},
         onToastClosed: () {},
       ).show(context);
       return Future.value(false);
     }
     return Future.value(true);
   }

  final springDesc = const SpringDescription(
    mass: 0.1,
    stiffness: 40,
    damping: 5,
  );

  void _onMenuIconInit(Artboard artboard) {
    final controller =
    StateMachineController.fromArtboard(artboard, "State Machine");
    artboard.addController(controller);
    _menuBtn = controller.findInput<bool>("isOpen") as SMIBool;
    _menuBtn.value = true;
  }

  void _presentOnBoarding(bool show) {
    if (show) {
      setState(() {
        _showOnBoarding = true;
      });
      final springAnim = SpringSimulation(springDesc, 0, 1, 0);
      _onBoardingAnimController?.animateWith(springAnim);
    } else {
      _onBoardingAnimController?.reverse().whenComplete(() => {
        setState(() {
          _showOnBoarding = false;
        })
      });
    }
  }

  void onMenuPress() {
    if (_menuBtn.value) {
      final springAnim = SpringSimulation(springDesc, 0, 1, 0);
      _animationController?.animateWith(springAnim);
    } else {
      _animationController?.reverse();
    }
    _menuBtn.change(!_menuBtn.value);

    SystemChrome.setSystemUIOverlayStyle(_menuBtn.value
        ? SystemUiOverlayStyle.dark
        : SystemUiOverlayStyle.light);
  }

  @override
  void initState() {
    check_block();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      upperBound: 1,
      vsync: this,
    );
    _onBoardingAnimController = AnimationController(
      duration: const Duration(milliseconds: 350),
      upperBound: 1,
      vsync: this,
    );

    _sidebarAnim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    ));

    _onBoardingAnim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _onBoardingAnimController,
      curve: Curves.linear,
    ));

    _tabBody = _screens.first;

    if(is_logged_in.$ != true) {
      CherryToast.success(
        disableToastAnimation: true,
        title: Text(
          'تسجيل الدخول',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        action: Text('تم تسجيل الدخول بنجاح'),
        inheritThemeColors: true,
        actionHandler: () {},
        onToastClosed: () {},
      ).show(context);
    }

    super.initState();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _onBoardingAnimController?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: WillPopScope(
        onWillPop: onWillPop,
        child: Stack(
          children: [
            Positioned(child: Container(color: AppTheme.background2)),
            RepaintBoundary(
              child: AnimatedBuilder(
                animation: _sidebarAnim,
                builder: (BuildContext context, Widget child) {
                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(((1 - _sidebarAnim.value) * -30) * math.pi / 180)
                      ..translate((1 - _sidebarAnim.value) * 300),
                    child: child,
                  );
                },
                child: FadeTransition(
                  opacity: _sidebarAnim,
                  child: SideMenu(),
                ),
              ),
            ),
            RepaintBoundary(
              child: AnimatedBuilder(
                animation: _showOnBoarding ? _onBoardingAnim : _sidebarAnim,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1 -
                        (_showOnBoarding
                            ? _onBoardingAnim.value * 0.08
                            : _sidebarAnim.value * 0.1),
                    child: Transform.translate(
                      offset: Offset(_sidebarAnim.value * -290, 0),
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY((_sidebarAnim.value * 30) * math.pi / 180),
                        child: child,
                      ),
                    ),
                  );
                },
                child: _tabBody,
              ),
            ),
          _selectedIndex == 3 ? Container() : AnimatedBuilder(
              animation: _sidebarAnim,
              builder: (context, child) {
                return Positioned(
                  top: _selectedIndex == 4 ? MediaQuery.of(context).padding.top + 40 :MediaQuery.of(context).padding.top + 20,
                  left: _selectedIndex == 4 ? (_sidebarAnim.value * -100) + 36 : (_sidebarAnim.value * -100) + 16,
                  child: child,
                );
              },
              child: GestureDetector(
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.shadow.withOpacity(0.2),
                          blurRadius: 5,
                          offset: const Offset(0, 5),
                        )
                      ],
                    ),
                    child: const Icon(Icons.notifications_outlined),
                  ),
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationTabView()));
                 // _presentOnBoarding(true);
                },
              ),
            ),
            Positioned(
              top: _selectedIndex == 4 ? MediaQuery.of(context).padding.top - 10 : null,
              right: _selectedIndex == 4 ? (_sidebarAnim.value * -100) + 20 : null,
              child: RepaintBoundary(
                child: AnimatedBuilder(
                  animation: _sidebarAnim,
                  builder: (context, child) {
                    return SafeArea(
                      child: Row(
                        children: [
                          // There's an issue/behaviour in flutter where translating the GestureDetector or any button
                          // doesn't translate the touch area, making the Widget unclickable, so instead setting a SizedBox
                          // in a Row to have a similar effect
                          SizedBox(width: _sidebarAnim.value * 216),
                          child,
                        ],
                      ),
                    );
                  },
                  child: _selectedIndex == 3 ? Container() : GestureDetector(
                    onTap: onMenuPress,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        width: 44,
                        height: 44,
                        margin: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(44 / 2),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.shadow.withOpacity(0.2),
                              blurRadius: 5,
                              offset: const Offset(0, 5),
                            )
                          ],
                        ),
                        child: RiveAnimation.asset(
                          app_assets.menuButtonRiv,
                          stateMachines: const ["State Machine"],
                          animations: const ["open", "close"],
                          onInit: _onMenuIconInit,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (_showOnBoarding)
              RepaintBoundary(
                child: AnimatedBuilder(
                  animation: _onBoardingAnim,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(
                          0,
                          -(MediaQuery.of(context).size.height +
                              MediaQuery.of(context).padding.bottom) *
                              (1 - _onBoardingAnim.value)),
                      child: child,
                    );
                  },
                  child: SafeArea(
                    top: false,
                    maintainBottomViewPadding: true,
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      margin: EdgeInsets.only(
                          bottom: MediaQuery.of(context).padding.bottom + 18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 40,
                              offset: const Offset(0, 40))
                        ],
                      ),
                      child: OnBoardingView(
                        closeModal: () {
                          _presentOnBoarding(false);
                        },
                      ),
                    ),
                  ),
                ),
              ),
            // White underlay behind the bottom tab bar
            IgnorePointer(
              ignoring: true,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedBuilder(
                    animation: !_showOnBoarding ? _sidebarAnim : _onBoardingAnim,
                    builder: (context, child) {
                      return Container(
                        height: 150,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.background.withOpacity(0),
                              AppTheme.background.withOpacity(1 -
                                  (!_showOnBoarding
                                      ? _sidebarAnim.value
                                      : _onBoardingAnim.value))
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: RepaintBoundary(
        child: AnimatedBuilder(
          animation: !_showOnBoarding ? _sidebarAnim : _onBoardingAnim,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(
                  0,
                  !_showOnBoarding
                      ? _sidebarAnim.value * 300
                      : _onBoardingAnim.value * 200),
              child: child,
            );
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomTabBar(
                onTabChange: (tabIndex) {
                  setState(() {
                    _selectedIndex = tabIndex;
                    _tabBody = _screens[tabIndex];
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}