import 'package:bab_algharb/components/shared_value_helper.dart';
import 'package:bab_algharb/components/toast_componant.dart';
import 'package:flutter/material.dart';

import '../repositories/auth_repository.dart';
import '../screens/login_screen.dart';
import '../theme.dart';
import 'auth_helper.dart';
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
    if(deleteAccountResponse.success == true) {
      AuthHelper().clearUserData();
      ToastComponent.showDialog(deleteAccountResponse.message);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
        return const LoginScreen();
      }), (route) => false);
    }else {


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
                        color: AppTheme.accentColor.withOpacity(.4),
                        borderRadius: BorderRadius.circular(40)
                    ),
                    child: Text("تأكيد", style: TextStyle(
                        color: AppTheme.accentColor
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