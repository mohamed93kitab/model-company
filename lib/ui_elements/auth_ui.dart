


import 'package:model_company/custom/box_decorations.dart';
import 'package:model_company/custom/device_info.dart';
import 'package:model_company/helpers/shared_value_helper.dart';
import 'package:model_company/my_theme.dart';
import 'package:flutter/material.dart';

class AuthScreen{
  static Widget buildScreen(BuildContext context,String headerText,Widget child){
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        //key: _scaffoldKey,
        //drawer: MainDrawer(),
        backgroundColor: Colors.white,
        //appBar: buildAppBar(context),
        body:Stack(
          children: [
            Positioned(
              top: 0,
              child: Container(
                  height: DeviceInfo(context).height / 3,
                  width: DeviceInfo(context).width,
                  color: MyTheme.accent_color,
                  alignment: Alignment.topRight,
                  child: Image.asset(
                    "assets/background_1.png",
                  ),),
            ),
            CustomScrollView(
              //controller: _mainScrollController,
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate(
                      [
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            margin: EdgeInsets.only(right: 18),
                            height: 30,
                            child: InkWell(
                                onTap: (){
                                  Navigator.pop(context);
                                }, child: Icon(Icons.close,color: MyTheme.white,size: 20,)),),
                        ),
                    Padding(
                      padding: const EdgeInsets.only(top: 48.0),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8,vertical: 12),

                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                                color: MyTheme.black,
                                borderRadius: BorderRadius.circular(8)),
                            child: Image.asset('assets/app_logo.png'),
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0,top: 10),
                      child: Text(
                        headerText,

                        style: TextStyle(
                            color: MyTheme.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Container(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecorations.buildBoxDecoration_1(radius: 16),
                          child: child,),
                    ),
                  ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}