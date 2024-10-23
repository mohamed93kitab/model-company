import 'package:bab_algharb/app_config.dart';
import 'package:bab_algharb/components/auth_helper.dart';
import 'package:bab_algharb/components/shared_value_helper.dart';
import 'package:bab_algharb/repositories/auth_repository.dart';
import 'package:bab_algharb/screens/splash_screen.dart';
import 'package:bab_algharb/screens/start.dart';
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
import '../components/post_card.dart';
import '../models/posts.dart';
import '../onboarding/onboarding.dart';
import '../onboarding/signin_view.dart';
import '../repositories/post_repository.dart';
import '../screens/profile_edit.dart';
import 'package:cherry_toast/cherry_toast.dart';

class ProfileTabView extends StatefulWidget {
  const ProfileTabView();

  @override
  State<ProfileTabView> createState() => _ProfileTabViewState();
}

class _ProfileTabViewState extends State<ProfileTabView> {

  // final List<PostModel> _posts = PostModel.posts;
  var _posts = [];
  int _points = 0;
  int _stars = 0;
  var _avatar;
  var _frame;
  int _id = 0;
  String _username = '';
  String _phone_number = '';
  String _name = '';
  String _verified = '';

  bool isInfoInitial = true;
  bool isPostsInitial = false;

  getMyPosts() async {
    var postResponse =
    await PostRepository().getMyPosts(user_id: user_id.$);
    if (postResponse.status == 200) {
      _posts.addAll(postResponse.data);
      setState(() {
        isPostsInitial = true;
      });
    }
  }

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

      SchedulerBinding.instance.addPostFrameCallback((_) {

        // add your code here.

        Navigator.push(context, MaterialPageRoute(builder: (context) => SignInView(is_logout: true)));

      });

    }

    }

  getUserInfo() async {
    var infoResponse = await AuthRepository().getUserByTokenResponse();
    if (infoResponse.result == true) {
      setState(() {
        _id = infoResponse.id;
        _name = infoResponse.name;
        _points = infoResponse.points;
        _stars = infoResponse.stars;
        _avatar = infoResponse.avatar;
        _username = infoResponse.username;
        _phone_number = infoResponse.phone;
        _frame = infoResponse.frame;
        _verified = infoResponse.verified;
        isInfoInitial = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserInfo();

    getMyPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

                  _posts.length == 0 ? Container(
                    height: MediaQuery.of(context).size.height * .6,
                    child: Center(
                      child: Text("لا توجد لديك أي منشورات"),
                    ),
                  ) : ListView.builder(
                      shrinkWrap: true,
                      itemCount: _posts.length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return PostCard(
                          id: _posts[index].id,
                          avatar: _posts[index].avatar,
                          content: _posts[index].content,
                          photo: _posts[index].photo,
                          user_name: _posts[index].user_name,
                            created_at: _posts[index].created_at,
                            likes: _posts[index].likes
                        );
                      }
                  ),



                ],
              ),
              SizedBox(height: 8),


              Align(
                alignment: Alignment.center,
                child: Text("version : 1.0.0"),
              ),

            ],
          ),
        ),
      ),
    );
  }
}