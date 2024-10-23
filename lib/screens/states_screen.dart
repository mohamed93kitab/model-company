import 'package:bab_algharb/screens/agents_screen.dart';
import 'package:bab_algharb/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class StateScreen extends StatefulWidget {
  final country;
  StateScreen({this.country});

  @override
  State<StateScreen> createState() => _StateScreenState();
}

class _StateScreenState extends State<StateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.light_bg,
      appBar: AppBar(
        backgroundColor: AppTheme.accentColor,
        title: Text(
          "قائمة المحافظات",
          style: TextStyle(color: AppTheme.white),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 26, horizontal: 16),
        height: MediaQuery.of(context).size.height,
        child: widget.country == "العراق" ? SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AgentScreen("أربيل")));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * .42,
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppTheme.white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "أربيل",
                            style: TextStyle(
                                color: AppTheme.backgroundDark, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AgentScreen("الأنبار")));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * .42,
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppTheme.white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "الأنبار",
                            style: TextStyle(
                                color: AppTheme.backgroundDark, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 16,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AgentScreen("بابل")));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * .42,
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppTheme.white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "بابل",
                            style: TextStyle(
                                color: AppTheme.backgroundDark, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AgentScreen("بغداد")));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * .42,
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppTheme.white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "بغداد",
                            style: TextStyle(
                                color: AppTheme.backgroundDark, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AgentScreen("البصرة")));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * .42,
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppTheme.white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "البصرة",
                            style: TextStyle(
                                color: AppTheme.backgroundDark, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AgentScreen("دهوك")));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * .42,
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppTheme.white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "دهوك",
                            style: TextStyle(
                                color: AppTheme.backgroundDark, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AgentScreen("القادسية")));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * .42,
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppTheme.white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "القادسية",
                            style: TextStyle(
                                color: AppTheme.backgroundDark, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AgentScreen("ديالى")));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * .42,
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppTheme.white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "ديالى",
                            style: TextStyle(
                                color: AppTheme.backgroundDark, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AgentScreen("ذي قار")));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * .42,
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppTheme.white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "ذي قار",
                            style: TextStyle(
                                color: AppTheme.backgroundDark, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AgentScreen("السليمانية")));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * .42,
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppTheme.white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "السليمانية",
                            style: TextStyle(
                                color: AppTheme.backgroundDark, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AgentScreen("صلاح الدين")));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * .42,
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppTheme.white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "صلاح الدين",
                            style: TextStyle(
                                color: AppTheme.backgroundDark, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AgentScreen("كركوك")));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * .42,
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppTheme.white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "كركوك",
                            style: TextStyle(
                                color: AppTheme.backgroundDark, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AgentScreen("كربلاء")));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * .42,
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppTheme.white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "كربلاء",
                            style: TextStyle(
                                color: AppTheme.backgroundDark, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AgentScreen("المثنى")));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * .42,
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppTheme.white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "المثنى",
                            style: TextStyle(
                                color: AppTheme.backgroundDark, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AgentScreen("ميسان")));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * .42,
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppTheme.white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "ميسان",
                            style: TextStyle(
                                color: AppTheme.backgroundDark, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AgentScreen("النجف")));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * .42,
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppTheme.white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "النجف",
                            style: TextStyle(
                                color: AppTheme.backgroundDark, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AgentScreen("	نينوى")));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * .42,
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppTheme.white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "	نينوى",
                            style: TextStyle(
                                color: AppTheme.backgroundDark, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AgentScreen("	واسط")));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * .42,
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppTheme.white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "	واسط",
                            style: TextStyle(
                                color: AppTheme.backgroundDark, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ) : Center(
          child: Text("لا يوجد وكلاء!"),
        ),
      ),
    );
  }
}
