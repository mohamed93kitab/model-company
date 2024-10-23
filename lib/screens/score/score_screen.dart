import 'package:bab_algharb/screens/game_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bab_algharb/theme.dart';
import 'package:flutter_svg/svg.dart';

import '../../controllers/question_controller.dart';

class ScoreScreen extends StatefulWidget {
  final zero;
  ScoreScreen({this.zero});
  @override
  State<ScoreScreen> createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  @override
  Widget build(BuildContext context) {
    QuestionController _qnController = Get.put(QuestionController());

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          SvgPicture.asset("assets/icons/bg.svg", fit: BoxFit.fill),
          Column(
            children: [
              Spacer(flex: 3),
              Text(
                "نتائجك",
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    ?.copyWith(color: AppTheme.accentColor),
              ),
              SizedBox(
                height: 20,
              ),
              widget.zero
                  ? Text(
                      "0",
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          ?.copyWith(color: AppTheme.secondaryColor),
                    )
                  : Text(
                      "${_qnController.numOfCorrectAns * 10}/${_qnController.questions.length * 10}",
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          ?.copyWith(color: AppTheme.secondaryColor),
                    ),
              SizedBox(height: 18),
              InkWell(
                onTap: () => Get.to(const GameScreen()),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 18),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(
                      AppTheme.defaultPadding * 0.75), // 15
                  decoration: const BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Text(
                    "خروج",
                    style: Theme.of(context)
                        .textTheme
                        .button
                        ?.copyWith(color: Colors.black),
                  ),
                ),
              ),
              Spacer(flex: 3),
            ],
          )
        ],
      ),
    );
  }
}
