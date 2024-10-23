import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:bab_algharb/models/courses.dart';
import 'package:bab_algharb/theme.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_config.dart';
import '../components/post_card.dart';
import '../components/postcard.dart';
import '../components/shared_value_helper.dart';
import '../models/posts.dart';
import '../repositories/auth_repository.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cherry_toast/cherry_toast.dart';

import '../repositories/post_repository.dart';

class TimelineTabView extends StatefulWidget {
  const TimelineTabView();

  @override
  State<TimelineTabView> createState() => _TimelineTabViewState();
}

class _TimelineTabViewState extends State<TimelineTabView> {

  final _contentController = TextEditingController();
  List _latestPostList = [];
  bool avatar;
  bool _isPostsInitial = true;

  int _points = 0;
  int _stars = 0;
  var _avatar;
  String _username = '';
  String _phone_number = '';
  String _name = '';

  bool success_post = false;
  final avatars = [4, 5, 6];

  List _carouselImageList = [
    "assets/rive/banner1.jpeg",
    "assets/rive/banner2.jpeg"
  ];

  int _current_slider = 0;
  bool isInfoInitial = true;

  getLatestPosts() async {
    var latestPostResponse = await PostRepository().getLatestPost();
    if (latestPostResponse.status == 200) {
      _latestPostList.addAll(latestPostResponse.data);
      setState(() {
        _isPostsInitial = true;
      });
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
        isInfoInitial = false;
      });
    }
  }
  int posts_likes_count = 0;

  ImagePicker imagePicker = ImagePicker();
  List<XFile> pickedImage = [];

  likeUnlikePost(post_id) async {
    var postResponse = await PostRepository().likePost(post_id: post_id, user_id: user_id.$);
    if(postResponse.status == true) {
      setState(() {
        posts_likes_count = postResponse.data[0].likes;
        _latestPostList.clear();
        _isPostsInitial = true;

        getLatestPosts();
      });
    }
  }

  Future<void> pickFromCamera() async {
    try {
      XFile image = await imagePicker.pickImage(source: ImageSource.camera);
      if(image != null) {
        setState(() {
          pickedImage.add(image);
        });
      }else {
        setState(() {
          pickedImage=[image];
        });
      }
    } catch(e){
      print(e);
    }
  }
  Future<void> pickFromGallery() async {
    try {
      XFile image = await imagePicker.pickImage(source: ImageSource.gallery);
      if(image != null) {
        setState(() {
          pickedImage.add(image);
        });
      }else {
        setState(() {
          pickedImage = image as List<XFile>;
        });
      }
    } catch(e){
      print(e);
    }
  }

  Future<void> uploadImage({ List<String> imagesPath}) async {
    FormData formData = FormData();
    for(var file in imagesPath) {
      formData.files.add(
          MapEntry('photo', await MultipartFile.fromFile(file))
      );
    }
    Dio().post('${AppConfig.BASE_URL}/posts/store?user_id=${user_id.$}&content=${_contentController.text}',
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
      ),
    ).then((value) {
      print(value.data);
     // Navigator.pop(context);
      setState(() {
        pickedImage.clear();
        _contentController.clear();
        success_post = true;
      });

      CherryToast.success(
        disableToastAnimation: true,
        title: Text(
          'إضافة منشور جديد',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        action: Text('تم إضافة منشورك بنجاح'),
        inheritThemeColors: true,
        actionHandler: () {},
        onToastClosed: () {},
      ).show(context);


    }).catchError((error) {
      print(error);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserInfo();
    avatars.shuffle();
    getLatestPosts();
    super.initState();
  }

  final List<CourseModel> _courses = CourseModel.courses;
  final List<PostModel> _posts = PostModel.posts;
  final List<CourseModel> _courseSections = CourseModel.courseSections;



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
              top: MediaQuery.of(context).padding.top + 60,
              bottom: MediaQuery.of(context).padding.bottom),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
               Form(
                  child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Divider(
                        thickness: 1,
                        color: AppTheme.backgroundDark.withOpacity(.2),
                      ),
                      ListTile(
                       // contentPadding: EdgeInsets.zero,
                        leading: _avatar == null && isInfoInitial == true ?
                        Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                              color: AppTheme.white,
                              borderRadius: BorderRadius.circular(50)
                          ),
                        ) :
                        _avatar == null && isInfoInitial == false ?
                        Container(
                          width: 35,
                          height: 35,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(50.0),
                              child: Image.asset('assets/images/avatars/default_avatar.jpg')),
                        ) :
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage('${AppConfig.IMAGES_PATH}'+_avatar),
                        ),
                        title: Padding(
                          padding: EdgeInsets.only(top:8.0),
                          child: Text(_name),
                        ),
                        subtitle: Padding(
                          padding: EdgeInsets.only(top: 0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                      foregroundColor:  AppTheme.shadowDark.withOpacity(.4)),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        final size = MediaQuery.of(context).size;
                                        return Center(
                                          child: Dialog(
                                              backgroundColor: Colors.transparent, //must have
                                              elevation: 0,
                                              child: SizedBox(
                                                height: size.height * .6,
                                                child: Stack(
                                                  children: [
                                                    Positioned(
                                                        top: (size.height * .2) / 2.5,
                                                        child: Container(
                                                          height: size.height * .5,
                                                          width: size.width * .78,
                                                          decoration: BoxDecoration(
                                                              color: AppTheme.white,
                                                              borderRadius: BorderRadius.circular(18)
                                                          ),
                                                          alignment: Alignment.center,
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              GestureDetector(
                                                                onTap: (){
                                                                  pickFromCamera();
                                                                },
                                                                child: Container(
                                                                  decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(16),
                                                                      color: AppTheme.light_bg
                                                                  ),
                                                                  width: MediaQuery.of(context).size.width,
                                                                  height: 90,
                                                                  margin: EdgeInsets.only(left: 40, right: 40, bottom: 20),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                    children: [
                                                                      Icon(Icons.camera, size: 36,),
                                                                      Text("من الكاميرا", style: GoogleFonts.cairo(
                                                                          fontSize: 22
                                                                      ),)
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              GestureDetector(
                                                                onTap: (){
                                                                  pickFromGallery();
                                                                },
                                                                child: Container(
                                                                  decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(16),
                                                                      color: AppTheme.light_bg
                                                                  ),
                                                                  width: MediaQuery.of(context).size.width,
                                                                  height: 90,
                                                                  margin: EdgeInsets.only(left: 40, right: 40, bottom: 20),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                    children: [
                                                                      Icon(Icons.photo_library_sharp, size: 36,),
                                                                      Text("من الأستوديو", style: GoogleFonts.cairo(
                                                                          fontSize: 22
                                                                      ),)
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              )),
                                        );
                                      },
                                    );
                                  },
                                  icon: Icon(Icons.photo),
                                  label: Row(
                                    children: [
                                      Text('صورة'),
                                      Expanded(
                                        child: Icon(
                                          Icons.add,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),


                              // Expanded(
                              //   child: OutlinedButton.icon(
                              //     style: OutlinedButton.styleFrom(
                              //         foregroundColor: AppTheme.shadowDark.withOpacity(.4)),
                              //     onPressed: () {},
                              //     icon: Icon(Icons.video_camera_back_sharp),
                              //     label: Row(
                              //       children: [
                              //         Text('فيديو'),
                              //         Expanded(
                              //           child: Icon(
                              //             Icons.add,
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),

                            ],
                          ),
                        ),
                      ),

                      //------------
                      pickedImage.length != 0 ? ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 18.0),
                              child: Image.file(
                                File(pickedImage[index].path),
                                width: MediaQuery.of(context).size.width,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            );
                          }, separatorBuilder: (BuildContext context, index) {
                        return SizedBox(height: 10,);
                      }, itemCount: pickedImage.length) : SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextFormField(
                          controller: _contentController,
                          maxLines: 5,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'ما الذي يجول في خاطرك؟',
                            hintStyle: TextStyle(fontSize: 17, color: AppTheme.shadowDark.withOpacity(.4)),
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          if(pickedImage.length == 0) {
                            return null;
                          }
                          uploadImage(imagesPath: pickedImage.map((e) => e.path).toList());
                        },
                        child: Container(
                          width: 70,
                          height: 40,
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(horizontal: 18),
                          decoration: BoxDecoration(
                            color: AppTheme.accentColor,
                            borderRadius: BorderRadius.circular(8)
                          ),
                          child: Text("نشر", style: GoogleFonts.cairo(
                            fontSize: 14,
                            color: AppTheme.white
                          ),),
                        ),
                      )
                  ],
                  )
              ),
              SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: Text(
                  "أخر المنشورات",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 10),
              //   child: Wrap(
              //     children: List.generate(
              //       _courseSections.length,
              //           (index) => Container(
              //         key: _courseSections[index].id,
              //         width: MediaQuery.of(context).size.width > 992
              //             ? ((MediaQuery.of(context).size.width - 20) / 2)
              //             : MediaQuery.of(context).size.width,
              //         padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
              //         child: HCard(section: _courseSections[index]),
              //       ),
              //     ),
              //   ),
              //)
              _latestPostList.length == 0 ? Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * .6,
                child: Center(
                  child: Text("لا توجد لديك أي منشورات"),
                ),
              ) : ListView.builder(
                  shrinkWrap: true,
                  itemCount: _latestPostList.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ListTile(
                                leading: _latestPostList[index].avatar == null ?
                                CircleAvatar(
                                  radius: 45,
                                  backgroundImage: NetworkImage('${_latestPostList[index].avatar}'),
                                ) :
                                CircleAvatar(
                                  radius: 45,
                                  backgroundImage: NetworkImage('${_latestPostList[index].avatar}'),
                                ),
                                title: Text(
                                  _latestPostList[index].user_name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                subtitle: Text(
                                  _latestPostList[index].created_at,
                                  style: TextStyle(
                                      color: AppTheme.backgroundDark.withOpacity(.6),
                                      fontWeight: FontWeight.w200
                                  ),
                                ),
                              ),
                              // Container(
                              //   constraints: const BoxConstraints(maxWidth: 170),
                              //   child: Text(
                              //     widget.course.title,
                              //     style: const TextStyle(
                              //         fontSize: 24, color: Colors.white),
                              //   ),
                              // ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 8),
                                    Text(_latestPostList[index].content, style: TextStyle(
                                        color: AppTheme.backgroundDark,
                                        overflow: TextOverflow.ellipsis
                                    ), softWrap: false,maxLines: 3,),
                                    // Text(
                                    //
                                    //   overflow: TextOverflow.ellipsis,
                                    //   maxLines: 3,
                                    //   softWrap: false,
                                    //   style: TextStyle(fontSize: 15),
                                    // ),
                                    const SizedBox(height: 12),
                                    // Text(
                                    //   widget.post.caption.toUpperCase(),
                                    //   style: const TextStyle(
                                    //       fontSize: 13,
                                    //       fontWeight: FontWeight.w600,
                                    //       color: Colors.white),
                                    // ),
                                  ],
                                ),
                              ),
                              Image.network(_latestPostList[index].photo, width: MediaQuery.of(context).size.width,),
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                            onPressed: (){
                                              likeUnlikePost(
                                                  _latestPostList[index].id
                                              );
                                            },
                                            icon: Icon(Icons.favorite_border, size: 30,)),
                                        Text(_latestPostList[index].likes.toString(), style: TextStyle(fontSize: 16),),

                                        // SizedBox(width: 16,),
                                        // Wrap(
                                        //   spacing: 8,
                                        //   children: List.generate(
                                        //     avatars.length,
                                        //         (index) => Transform.translate(
                                        //       offset: Offset(index * 25.0, 0),
                                        //       child: ClipRRect(
                                        //         key: Key(index.toString()),
                                        //         borderRadius: BorderRadius.circular(22),
                                        //         child: Image.asset(
                                        //             "assets/images/avatars/avatar_${avatars[index]}.jpg",
                                        //             width: 34,
                                        //             height: 34),
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ),
                                        //
                                        // IconButton(
                                        //     onPressed: (){},
                                        //     icon: Icon(Icons.card_giftcard, size: 30,)),
                                      ],

                                    ),

                                  ],
                                ),
                              ),

                            ],
                          ),
                          // Positioned(
                          //     right: -10, top: -10, child: Image.asset(widget.course.image))
                        ],
                      ),
                    );
                  }
              ),
              // SingleChildScrollView(
              //   padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
              //   scrollDirection: Axis.horizontal,
              //   child: Column(
              //     children: _posts
              //         .map(
              //           (post) => Padding(
              //         key: post.id,
              //         padding: const EdgeInsets.all(0),
              //         child: PostContainer(post: post),
              //       ),
              //     )
              //         .toList(),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class RPSCustomPainter extends CustomPainter{

  @override
  void paint(Canvas canvas, Size size) {



    // Layer 1

    Paint paint_fill_0 = Paint()
      ..color = const Color.fromARGB(255, 0, 101, 198)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width*0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;


    Path path_0 = Path();
    path_0.moveTo(size.width*0.3341667,size.height*0.3571429);
    path_0.lineTo(size.width*0.2933333,size.height*0.4285714);
    path_0.lineTo(size.width*0.3341667,size.height*0.5000000);
    path_0.lineTo(size.width*0.5008333,size.height*0.5000000);
    path_0.lineTo(size.width*0.5425000,size.height*0.4271429);
    path_0.lineTo(size.width*0.5008333,size.height*0.3571429);
    path_0.lineTo(size.width*0.3341667,size.height*0.3571429);
    path_0.close();

    canvas.drawPath(path_0, paint_fill_0);


    // Layer 1

    Paint paint_stroke_0 = Paint()
      ..color = const Color.fromARGB(255, 33, 150, 243)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width*0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;



    canvas.drawPath(path_0, paint_stroke_0);



    // Text Layer 1

    canvas.save();
    final pivot_8338057300081 = Offset(size.width*0.35,size.height*0.41);
    canvas.translate(pivot_8338057300081.dx,pivot_8338057300081.dy);
    canvas.rotate(0);
    canvas.translate(-pivot_8338057300081.dx,-pivot_8338057300081.dy);
    TextPainter tp_8338057300081 = TextPainter(
      text:  TextSpan(text: """You Text Here""", style: TextStyle(
        fontSize: size.width*0.02,
        fontWeight: FontWeight.normal,
        color: Color(0xff000000),
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.none,
      )),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    )..layout(maxWidth: size.width*0.13, minWidth: size.width*0.13);
    tp_8338057300081.paint(canvas,pivot_8338057300081);
    canvas.restore();


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}
