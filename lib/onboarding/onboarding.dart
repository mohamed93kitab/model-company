import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';
import 'package:rive/rive.dart';
import 'package:bab_algharb/theme.dart';
import 'package:bab_algharb/onboarding/signin_view.dart';
import 'package:bab_algharb/assets.dart' as app_assets;
import 'package:cherry_toast/cherry_toast.dart';
import '../components/auth_helper.dart';
import '../components/toast_componant.dart';
import '../repositories/auth_repository.dart';
import 'package:toast/toast.dart'
;

import '../screens/home.dart';
class OnBoardingView extends StatefulWidget {
  const OnBoardingView({this.closeModal, this.is_logout});

  // Close modal callback for any screen that uses this as a modal
  final Function closeModal;
  final bool is_logout;

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView>
    with TickerProviderStateMixin {
  // Animation controller that shows the sign up modal as well as translateY boarding content together
  AnimationController _signInAnimController;

  // Control touch effect animation for the "Start the Course" button
   RiveAnimationController _btnController;

  @override
  void initState() {
    super.initState();

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

    _signInAnimController = AnimationController(
        duration: const Duration(milliseconds: 350),
        upperBound: 1,
        vsync: this);

    _btnController = OneShotAnimation("active", autoplay: false);

    const springDesc = SpringDescription(
      mass: 0.1,
      stiffness: 40,
      damping: 5,
    );

    _btnController.isActiveChanged.addListener(() {
      if (!_btnController.isActive) {
        final springAnim = SpringSimulation(springDesc, 0, 1, 0);
        _signInAnimController?.animateWith(springAnim);
      }
    });
  }



  @override
  void dispose() {
    _signInAnimController?.dispose();
    _btnController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(children: [
        ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
          child: Center(
            child: OverflowBox(
              maxWidth: double.infinity,
              child: Transform.translate(
                offset: const Offset(200, 100),
                child: Image.asset(app_assets.spline, fit: BoxFit.cover),
              ),
            ),
          ),
        ),
        ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: const RiveAnimation.asset(app_assets.shapesRiv),
        ),
        AnimatedBuilder(
          animation: _signInAnimController,
          builder: (context, child) {
            return Transform(
                transform: Matrix4.translationValues(
                    0, -50 * _signInAnimController.value, 0),
                child: child);
          },
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(40, 80, 40, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 260,
                            padding: const EdgeInsets.only(bottom: 16),
                            child: const Text(
                              "باب الغرب",
                              style: TextStyle(
                                  fontSize: 60),
                            ),
                          ),
                          Text(
                            "تطبيق باب الغرب للتواصل الإجتماعي والحصول على المكافئات القيمة من خلال الدخول في تحديات معرفة مع زملائك",
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.7),
                                fontSize: 17),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // const Spacer(),
                  GestureDetector(
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        width: 236,
                        height: 64,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 10),
                            )
                          ],
                        ),
                        child: Stack(
                          children: [
                            RiveAnimation.asset(
                              app_assets.buttonRiv,
                              fit: BoxFit.cover,
                              controllers: [_btnController],
                            ),
                            Center(
                              child: Transform.translate(
                                offset: const Offset(4, 4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.arrow_forward_rounded),
                                    SizedBox(width: 4),
                                    Text(
                                      "تسجيل الدخول",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      _btnController.isActive = true;
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "إدعو أصدقائك للتسجيل في تطبيق باب الغرب والحصول على مكافئة النقاط",
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.7),
                        fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ),
        RepaintBoundary(
          child: AnimatedBuilder(
            animation: _signInAnimController,
            builder: (context, child) {
              return Stack(
                children: [
                  Visibility(
                    visible: false,
                    child: Positioned(
                        top: 100 - (_signInAnimController.value * 200),
                        left: 20,
                        child: SafeArea(
                          child: CupertinoButton(
                            padding: EdgeInsets.zero,
                            borderRadius: BorderRadius.circular(36 / 2),
                            minSize: 36,
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(36 / 2),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 10,
                                      offset: const Offset(0, 10))
                                ],
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {
                              widget.closeModal();
                            },
                          ),
                        )),
                  ),
                  Positioned.fill(
                    child: IgnorePointer(
                      ignoring: true,
                      child: Opacity(
                        opacity: 0.4 * _signInAnimController.value,
                        child: Container(color: AppTheme.shadow),
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(
                      0,
                      -MediaQuery.of(context).size.height *
                          (1 - _signInAnimController.value),
                    ),
                    child: child,
                  ),
                ],
              );
            },
            child: SignInView(
              closeModal: () {
                _signInAnimController?.reverse();
              },
            ),
          ),
        ),
      ]),
    );
  }
}