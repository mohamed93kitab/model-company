import 'package:bab_algharb/app_config.dart';
import 'package:bab_algharb/components/auth_helper.dart';
import 'package:bab_algharb/components/shared_value_helper.dart';
import 'package:bab_algharb/repositories/auth_repository.dart';
import 'package:bab_algharb/screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:bab_algharb/models/courses.dart';
import 'package:bab_algharb/theme.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/dialogs.dart';
import '../components/post_card.dart';
import '../models/posts.dart';
import '../onboarding/onboarding.dart';
import '../onboarding/signin_view.dart';
import '../screens/profile_edit.dart';
import 'package:cherry_toast/cherry_toast.dart';

import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen();

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final List<PostModel> _posts = PostModel.posts;
  int _points = 0;
  int _stars = 0;
  var _avatar;
  var _frame;
  String _username = '';
  String _phone_number = '';
  String _email;
  String _name = '';
  String _verified = '';
  String _joined_at = '';
  bool _isDialogShowing = false;


  bool isInfoInitial = true;

  logout() async {
    var logoutResponse = await AuthRepository().getLogout();
    if (logoutResponse.success == true) {
      setState(() {
        is_logged_in.$ = false;
        is_logged_in.save();
        access_token.$ = "";
        access_token.save();
        user_id.$ = 0;
        user_id.save();
        user_name.$ = "";
        user_name.save();
        username.$ = "";
        username.save();
        user_phone.$ = "";
        user_phone.save();
        photo.$ = "";
        photo.save();
        user_points.$ = 0;
        user_points.save();
        user_stars.$ = 0;
        user_stars.save();
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('startTime');
      await prefs.remove('endTime');
      await prefs.remove('isPlaying');

        print("is logout =============================================================================");

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));


    }

  }

  getUserInfo() async {
    var infoResponse = await AuthRepository().getUserByTokenResponse();
    if (infoResponse.result == true) {
      setState(() {
        _name = infoResponse.name;
        _points = infoResponse.points;
        _stars = infoResponse.stars;
        _avatar = infoResponse.avatar;
        _username = infoResponse.username;
        _phone_number = infoResponse.phone;
        _frame = infoResponse.frame;
        _email = infoResponse.email;
        _verified = infoResponse.verified;
        _joined_at = infoResponse.created_at;
        isInfoInitial = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if(_isDialogShowing) {
          Navigator.of(context, rootNavigator: true).pop();
        }else {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: AppTheme.background,
            borderRadius: BorderRadius.circular(30),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [

                    SizedBox(height: 20,),

                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          height: MediaQuery.of(context).size.height * .15,
                          decoration: BoxDecoration(
                              color: AppTheme.accentColor,
                              borderRadius: BorderRadius.circular(22)
                          ),
                        ),

                        Positioned(
                          top: 22, child:
                        Container(
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          child: Text(_name, style: GoogleFonts.cairo(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.white
                          ), textAlign: TextAlign.center,),
                        ),
                        ),

                        Positioned.fill(
                          bottom: -125,
                          // right: MediaQuery.of(context).size.width * .5 - 58,

                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(width: 5, color: AppTheme.background)
                              ),
                              child: _avatar == null && isInfoInitial == true ?
                              Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                    color: AppTheme.white,
                                    borderRadius: BorderRadius.circular(50)
                                ),
                              ) :
                              _avatar == null && isInfoInitial == false ?
                              Container(
                                width: 90,
                                height: 90,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50.0),
                                    child: Image.asset('assets/images/avatars/default_avatar.jpg')),
                              ) :
                              CircleAvatar(
                                radius: 45,
                                backgroundImage: NetworkImage('${AppConfig.IMAGES_PATH}'+_avatar),
                              ),
                            ),
                          ),
                        ),

                        Positioned.fill(
                          bottom: -125,
                          // right: MediaQuery.of(context).size.width * .5 - 68,
                          child: Align(
                            alignment: Alignment.center,
                            child: _frame == null ? Container() : Image.network("${_frame}",
                              width: 110,
                            ),
                          ),
                        ),

                        Positioned.fill(
                          bottom: -200,
                          right: MediaQuery.of(context).size.width * .3 - 68,
                          child: Align(
                            alignment: Alignment.center,
                            child: _verified == "" ? Container() : Image.network("${_verified}",
                              width: 25,
                            ),
                          ),
                        )

                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(height: 50,)
                          // Spacer(),

                        ],
                      ),
                    ),

                    SizedBox(height: 26,),

                    Container(
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.symmetric(horizontal: 18),
                        height: 90,
                        decoration: BoxDecoration(
                            color: AppTheme.white,
                            borderRadius: BorderRadius.circular(20)
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 14,),
                            Text("أسم المستخدم :", style: GoogleFonts.cairo(
                                fontSize: 12,
                                fontWeight: FontWeight.w400
                            ),),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(_username, style: GoogleFonts.cairo(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold
                                ),),

                                IconButton(onPressed: () async {

                                  await Clipboard.setData(ClipboardData(text: _username));
                                  // copied successfully
                                  CherryToast.success(
                                    disableToastAnimation: true,
                                    title: Text(
                                      'نسخ أسم المستخدم',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    action: Text('تم النسخ بنجاح'),
                                    inheritThemeColors: true,
                                    actionHandler: () {},
                                    onToastClosed: () {},
                                  ).show(context);

                                }, icon: Icon(Icons.copy))
                              ],
                            ),
                          ],
                        )
                    ),

                    SizedBox(height: 26,),

                    Container(
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.symmetric(horizontal: 18),
                        height: 80,
                        decoration: BoxDecoration(
                            color: AppTheme.white,
                            borderRadius: BorderRadius.circular(20)
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 14,),
                            Text("رقم الهاتف :", style: GoogleFonts.cairo(
                                fontSize: 12,
                                fontWeight: FontWeight.w400
                            ),),
                            Text(_phone_number == null ? "لا يوجد" : _phone_number, style: GoogleFonts.cairo(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                            ),),
                          ],
                        )
                    ),

                    // SizedBox(height: 26,),
                    //
                    // Container(
                    //     alignment: Alignment.centerRight,
                    //     margin: EdgeInsets.symmetric(horizontal: 18),
                    //     height: 80,
                    //     decoration: BoxDecoration(
                    //         color: AppTheme.white,
                    //         borderRadius: BorderRadius.circular(20)
                    //     ),
                    //     padding: EdgeInsets.symmetric(horizontal: 18),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         Column(
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: [
                    //             SizedBox(height: 14,),
                    //             Text("حساب فيسبوك موثق :", style: GoogleFonts.cairo(
                    //                 fontSize: 12,
                    //                 fontWeight: FontWeight.w400
                    //             ),),
                    //             Text("لا يوجد", style: GoogleFonts.cairo(
                    //                 fontSize: 18,
                    //                 fontWeight: FontWeight.bold
                    //             ),),
                    //           ],
                    //         ),
                    //
                    //         // Icon(Icons.check_circle, color: AppTheme.accentColor,)
                    //         Icon(Icons.info_outline, color: AppTheme.accentColor,)
                    //       ],
                    //     )
                    // ),

                    SizedBox(height: 26,),
                    Container(
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.symmetric(horizontal: 18),
                        height: 80,
                        decoration: BoxDecoration(
                            color: AppTheme.white,
                            borderRadius: BorderRadius.circular(20)
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 18),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 14,),
                                Text("بريد إلكتروني موثق :", style: GoogleFonts.cairo(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400
                                ),),
                                Text(_email == null ? "لا يوجد" : _email, style: GoogleFonts.cairo(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold
                                ),),
                              ],
                            ),

                            // Icon(Icons.check_circle, color: AppTheme.accentColor,)
                            Icon(_email == null ? Icons.info_outline : Icons.check_circle, color: _email == null ? AppTheme.accentColor : AppTheme.green,)
                          ],
                        )
                    ),

                  ],
                ),
                SizedBox(height: 40),


                Align(
                  alignment: Alignment.center,
                  child: Text("version : 1.0.0"),
                ),

                SizedBox(height: 25,),

                Align(
                  alignment: Alignment.center,
                  child: Text("تاريخ الإنضمام : "+'$_joined_at'),
                ),

                InkWell(
                  onTap: () {
                    logout();
                  },
                  child: Container(
                    alignment:  Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    margin: EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.danger, width: 2)
                    ),
                    child: Text("تسجيل الخروج", style: GoogleFonts.cairo(
                        fontSize: 15,
                        color: AppTheme.danger,
                        fontWeight: FontWeight.bold
                    ),),
                  ),
                ),


                InkWell(
                  onTap: () {
                    setState(() {
                      _isDialogShowing = true;
                    });
                    showDialog(context: context,
                        builder: (BuildContext context){
                          return CustomDialogBox(
                            title: "هل أنت متأكد من حذف حسابك؟",
                          );
                        }
                    ).then((_) {
                      setState(() {
                        _isDialogShowing = false;
                      });
                    });

                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    decoration: BoxDecoration(
                        color: AppTheme.danger,
                        borderRadius: BorderRadius.circular(12)
                    ),
                    child: Text(
                      "حذف الحساب",
                      style: GoogleFonts.cairo(
                        fontSize: 15,
                        color: AppTheme.white,
                        fontWeight: FontWeight.bold
                    ),
                    ),
                  ),
                ),

                SizedBox(height: 20,),
                InkWell(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileEdit())),
                  child: Container(
                    alignment:  Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    margin: EdgeInsets.only(right: 18,left: 18, bottom: 45),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppTheme.accentColor
                    ),
                    child: Text("تعديل المعلومات الشخصية", style: GoogleFonts.cairo(
                        fontSize: 15,
                        color: AppTheme.white,
                        fontWeight: FontWeight.bold
                    ),),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}