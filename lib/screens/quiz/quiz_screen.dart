import 'package:bab_algharb/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bab_algharb/controllers/question_controller.dart';

import 'package:bab_algharb/components/body.dart';

class QuizScreen extends StatefulWidget {
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  @override
  void initState() {
    Get.deleteAll();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    QuestionController _controller = Get.put(QuestionController());
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppTheme.background2,
      appBar: AppBar(
        // Fluttter show the back button automatically
        backgroundColor: Colors.transparent,
        elevation: 0,
        // actions: [
        //   TextButton(onPressed: _controller.nextQuestion, child: Text("Skip")),
        // ],
      ),
      body: Body(),
    );
  }
}
