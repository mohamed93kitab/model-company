import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bab_algharb/controllers/question_controller.dart';
import 'package:bab_algharb/models/questions.dart';
import 'package:flutter_svg/svg.dart';

import '../theme.dart';
import 'progress_bar.dart';
import 'question_card.dart';

class Body extends StatelessWidget {
  const Body();

  @override
  Widget build(BuildContext context) {
    // So that we have acccess our controller
    QuestionController _questionController = Get.put(QuestionController());
    return Stack(
      children: [
        SvgPicture.asset("assets/icons/bg.svg", fit: BoxFit.fill),
        SafeArea(
          child: Container(
            color: AppTheme.background2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: AppTheme.defaultPadding),
                  child: ProgressBar(),
                ),
                SizedBox(height: AppTheme.defaultPadding),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: AppTheme.defaultPadding),
                  child: Obx(
                        () => Text.rich(
                      TextSpan(
                        text:
                        "سؤال : ${_questionController.questionNumber.value}",
                        style: Theme.of(context)
                            .textTheme
                            .headline4
                            ?.copyWith(color: AppTheme.secondaryColor),
                        children: [
                          TextSpan(
                            text: "/${_questionController.questions.length}",
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                ?.copyWith(color: AppTheme.secondaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Divider(thickness: 1.5),
                SizedBox(height: AppTheme.defaultPadding),
                Expanded(
                  child: PageView.builder(
                    // Block swipe to next qn
                    physics: NeverScrollableScrollPhysics(),
                    controller: _questionController.pageController,
                    onPageChanged: _questionController.updateTheQnNum,
                    itemCount: _questionController.questions.length,
                    itemBuilder: (context, index) => QuestionCard(
                        question: _questionController.questions[index]),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}