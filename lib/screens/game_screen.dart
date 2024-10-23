import 'package:bab_algharb/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:bab_algharb/screens/quiz/quiz_screen.dart';
import 'package:google_fonts/google_fonts.dart';

import '../repositories/auth_repository.dart';
import '../repositories/balance_repository.dart';
import '../theme.dart';
import 'package:cherry_toast/cherry_toast.dart';
class GameScreen extends StatelessWidget {
  const GameScreen();


  minusStarsFromBalance( ) async {
    var balanceResponse = await BalanceRepository().minusStarsResponse(100);
    if(balanceResponse.success == true) {
      Get.to(QuizScreen());
    }else {
      CherryToast.error(
        disableToastAnimation: true,
        title: Text(
          'خطأ!',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        action: Text('رصيدك من النجوم غير كافً لدخول المسابقة'),
        inheritThemeColors: true,
        actionHandler: () {},
        onToastClosed: () {},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background2,
      body: Stack(
        children: [
          SvgPicture.asset("assets/icons/bg.svg", fit: BoxFit.fill),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacer(flex: 2), //2/6
                  Text(
                    "من أجل الدخول إلى المسابقة",
                    style: Theme.of(context).textTheme.headline4?.copyWith(
                        color: AppTheme.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 18,),
                  Text("سيتم إستقطاع 100 نجمة من رصيدك", style: GoogleFonts.cairo(
                     color: AppTheme.white.withOpacity(.8),
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),),
                  Spacer(), // 1/6
                  // TextField(
                  //   decoration: InputDecoration(
                  //     filled: true,
                  //     fillColor: Color(0xFF1C2341),
                  //     hintText: "Full Name",
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.all(Radius.circular(12)),
                  //     ),
                  //   ),
                  // ),
                  Spacer(), // 1/6
                  InkWell(
                    onTap: () {
                      minusStarsFromBalance();
                    },
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(AppTheme.defaultPadding * 0.75), // 15
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Text(
                        "بداية اللعبة",
                        style: Theme.of(context)
                            .textTheme
                            .button
                            ?.copyWith(color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(height: 18,),
                  InkWell(
                    onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen())),
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(AppTheme.defaultPadding * 0.75), // 15
                      decoration: BoxDecoration(
                       // gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        border: Border.all(color: AppTheme.secondaryColor, width: 3),
                      ),
                      child: Text(
                        "خروج",
                        style: Theme.of(context)
                            .textTheme
                            .button
                            ?.copyWith(color: AppTheme.secondaryColor),
                      ),
                    ),
                  ),
                  SizedBox(height: 18,),

                  Text("عند الإجابة على 10 أسئلة بشكل صحيح ستتحصل على 300 نقطة", style: GoogleFonts.cairo(
                      color: AppTheme.white.withOpacity(.8),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                  ), textAlign: TextAlign.center,),
                  Spacer(flex: 2), // it will take 2/6 spaces
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}