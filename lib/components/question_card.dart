import 'package:bab_algharb/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bab_algharb/controllers/question_controller.dart';
import 'package:bab_algharb/models/questions.dart';

import 'option.dart';

class QuestionCard extends StatelessWidget {
  const QuestionCard({
    // it means we have to pass this
     this.question,
  });

  final Question question;

  @override
  Widget build(BuildContext context) {
    QuestionController _controller = Get.put(QuestionController());
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppTheme.defaultPadding),
      padding: EdgeInsets.all(AppTheme.defaultPadding),
      decoration: BoxDecoration(
        color: AppTheme.background2,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          Text(
            question.question,
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(color: AppTheme.white),
          ),
          SizedBox(height: AppTheme.defaultPadding / 2),
          ...List.generate(
            question.options.length,
            (index) => Option(
              index: index,
              text: question.options[index],
              press: () => _controller.checkAns(question, index),
            ),
          ),
        ],
      ),
    );
  }
}
