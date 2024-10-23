import 'package:bab_algharb/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:bab_algharb/controllers/question_controller.dart';

class Option extends StatelessWidget {
  const Option({
     this.text,
     this.index,
     this.press,
  });
  final String text;
  final int index;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuestionController>(
        init: QuestionController(),
        builder: (qnController) {
          Color getTheRightColor() {
            if (qnController.isAnswered) {
              if (index == qnController.correctAns) {
                return AppTheme.accentColor;
              } else if (index == qnController.selectedAns &&
                  qnController.selectedAns != qnController.correctAns) {
                return AppTheme.danger;
              } else if (index != qnController.correctAns) {
                return AppTheme.transparent;
              }
            }
            return AppTheme.white.withOpacity(.9);
          }

          IconData getTheRightIcon() {
            return getTheRightColor() == AppTheme.danger
                ? Icons.close
                : Icons.done;
          }

          return InkWell(
            onTap: press,
            child: Container(
              margin: EdgeInsets.only(top: AppTheme.defaultPadding),
              padding: EdgeInsets.all(AppTheme.defaultPadding),
              decoration: BoxDecoration(
                border: Border.all(color: getTheRightColor()),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${index + 1}. $text",
                    style: TextStyle(color: getTheRightColor(), fontSize: 16),
                  ),
                  qnController.isAnswered
                      ? Container(
                          height: 26,
                          width: 26,
                          decoration: BoxDecoration(
                            color: getTheRightColor() ==
                                    AppTheme.backgroundDark.withOpacity(.4)
                                ? Colors.transparent
                                : getTheRightColor(),
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: getTheRightColor()),
                          ),
                          child: getTheRightColor() ==
                                  AppTheme.backgroundDark.withOpacity(.4)
                              ? null
                              : Icon(getTheRightIcon(), size: 16),
                        )
                      : Container()
                ],
              ),
            ),
          );
        });
  }
}
