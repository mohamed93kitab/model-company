import 'dart:ui';
import 'package:model_company/my_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:model_company/helpers/shared_value_helper.dart';
import 'package:model_company/helpers/auth_helper.dart';
import 'package:model_company/repositories/auth_repository.dart';
import 'package:model_company/screens/main.dart';

import 'package:model_company/custom/toast_component.dart';
import 'package:toast/toast.dart';

import '../custom/toast_component.dart';


class CustomDialogBox extends StatefulWidget {
  final String title;

  const CustomDialogBox({Key key, this.title}) : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  onTapDeleteAccount(context) async {
    var deleteAccountResponse =
    await AuthRepository().deleteAccountResponse(id: user_id.$.toString());
    if(deleteAccountResponse.result == true) {
      AuthHelper().clearUserData();
      ToastComponent.showDialog(deleteAccountResponse.message, gravity: Toast.center, duration: Toast.lengthLong);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
        return Main();
      }), (route) => false);
    }else {
      ToastComponent.showDialog("something went wrong!", gravity: Toast.center, duration: Toast.lengthLong);
      Navigator.pop(context);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }
  contentBox(context){
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left: 16,top: 36, right: 16,bottom: 16
            ),
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(color: Colors.black,offset: Offset(0,10),
                      blurRadius: 10
                  ),
                ]
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(widget.title,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
                SizedBox(height: 15,),


                GestureDetector(
                  onTap: () {
                    onTapDeleteAccount(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 15),
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    decoration: BoxDecoration(
                        color: MyTheme.soft_accent_color,
                        borderRadius: BorderRadius.circular(40)
                    ),
                    child: Text("تأكيد", style: TextStyle(
                        color: MyTheme.accent_color
                    ),),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}