import 'package:bab_algharb/components/shared_value_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../repositories/auth_repository.dart';
import '../theme.dart';
import 'package:dio/dio.dart';
import 'package:bab_algharb/app_config.dart';
class ProfileEdit extends StatefulWidget {
  const ProfileEdit();

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _con_passwordController = TextEditingController();
  final _passwordController = TextEditingController();
  var _avatar;
  String _name = '';
  ImagePicker imagePicker = ImagePicker();
  List<XFile> pickedImage = [];

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
    Dio().post('${AppConfig.BASE_URL}/auth/edit-profile?id=${user_id.$}&name=${_nameController.text}&con_password=${_con_passwordController.text}&password=${_passwordController.text}',
    data: formData,
      options: Options(
        contentType: 'multipart/form-data',
      ),
    ).then((value) {

      setState(() {
        user_name.$ = _nameController.text;
        user_name.save();
      });

      CherryToast.success(
        disableToastAnimation: true,
        title: Text(
          'تحديث الملف الشخصي',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        action: Text("تم تحديث الملف الشخصي بنجاح"),
        inheritThemeColors: true,
        actionHandler: () {},
        onToastClosed: () {},
      ).show(context);
      setState(() {
        Navigator.pop(context);
      });
      print(value.data);
    }).catchError((error) {
      print(error);
    });
  }


  Future<void> uploadPassword() async {
    var passResponse = await AuthRepository().updatePasswordResponse(password: _passwordController.text.toString(), con_password: _con_passwordController.text.toString());
    if(passResponse.success == true) {
      CherryToast.success(
        disableToastAnimation: true,
        title: Text(
          'تحديث كلمة المرور',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        action: Text(passResponse.message),
        inheritThemeColors: true,
        actionHandler: () {},
        onToastClosed: () {},
      ).show(context);
    }else {
      CherryToast.error(
        disableToastAnimation: true,
        title: Text(
          'تحديث كلمة المرور',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        action: Text(passResponse.message),
        inheritThemeColors: true,
        actionHandler: () {},
        onToastClosed: () {},
      ).show(context);
    }
  }

  bool _obscureText = true;

  String _password;

  // Toggles the password show status
  toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  getUserInfo() async {
    var infoResponse = await AuthRepository().getUserByTokenResponse();
    if (infoResponse.result == true) {
      setState(() {
        _name = infoResponse.name;
        _avatar = infoResponse.avatar;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "تعديل الملف الشخصي"
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            
            
            SizedBox(height: 26,),

            _avatar == null  ?  GestureDetector(
              onTap: () {
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
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius:BorderRadius.circular(60)
              ),
              child: pickedImage.length != 0 ? ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: Image.file(
                          File(pickedImage[index].path),
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    );
                  }, separatorBuilder: (BuildContext context, index) {
                return SizedBox(height: 10,);
              }, itemCount: pickedImage.length) :
              ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: Image.asset('assets/images/avatars/default_avatar.jpg')),
            ),
            ) :

            GestureDetector(
              onTap: () {
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
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                    color: AppTheme.light_bg,
                    borderRadius:BorderRadius.circular(60)
                ),
                child: pickedImage.length != 0 ? ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Image.file(
                          File(pickedImage[index].path),
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      );
                    }, separatorBuilder: (BuildContext context, index) {
                  return SizedBox(height: 10,);
                }, itemCount: pickedImage.length) :
                CircleAvatar(
                  radius: 45,
                  backgroundImage: NetworkImage('${AppConfig.IMAGES_PATH}'+_avatar),
                ),
              ),
            ),
            
            SizedBox(height: 26,),

            Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.symmetric(horizontal: 18),
                height: 100,
                decoration: BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: BorderRadius.circular(20)
                ),
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 14,),
                    Text("الأسم الكامل :", style: GoogleFonts.cairo(
                        fontSize: 12,
                        fontWeight: FontWeight.w400
                    ),),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: user_name.$
                      ),
                    ),
                  ],
                )
            ),

            // SizedBox(height: 26,),
            // Container(
            //     alignment: Alignment.centerRight,
            //     margin: EdgeInsets.symmetric(horizontal: 18),
            //     height: 100,
            //     decoration: BoxDecoration(
            //         color: AppTheme.white,
            //         borderRadius: BorderRadius.circular(20)
            //     ),
            //     padding: EdgeInsets.symmetric(horizontal: 18),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         SizedBox(height: 14,),
            //         Text("رقم الهاتف :", style: GoogleFonts.cairo(
            //             fontSize: 12,
            //             fontWeight: FontWeight.w400
            //         ),),
            //         TextField(
            //           controller: _phoneController,
            //           decoration: InputDecoration(
            //             border: InputBorder.none,
            //             hintText: user_phone.$
            //           ),
            //         ),
            //       ],
            //     )
            // ),
            SizedBox(height: MediaQuery.of(context).size.height * .05,),

            GestureDetector(
              onTap: () {
                uploadImage(imagesPath: pickedImage.map((e) => e.path).toList());
              },
              child: Container(
                alignment: Alignment.center,
                height: 50,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(right: 50, left: 50),
                decoration: BoxDecoration(
                    color: AppTheme.accentColor,
                    borderRadius: BorderRadius.circular(12)
                ),
                child: Text("حفظ", style: GoogleFonts.cairo(
                    fontSize: 16,fontWeight: FontWeight.bold, color: AppTheme.white
                ),),
              ),
            ),
            Divider(),
            SizedBox(height: 46,),
            Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.symmetric(horizontal: 18),
                height: 100,
                decoration: BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: BorderRadius.circular(20)
                ),
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 14,),
                    Text("تأكيد كلمة المرور القديمة :", style: GoogleFonts.cairo(
                        fontSize: 12,
                        fontWeight: FontWeight.w400
                    ),),
                    TextField(
                      controller: _con_passwordController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          onPressed: toggle,
                          icon: Icon(_obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                        ),
                      ),
                      obscureText: _obscureText,
                    ),
                  ],
                )
            ),
            SizedBox(height: 26,),
            Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.symmetric(horizontal: 18),
                height: 100,
                decoration: BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: BorderRadius.circular(20)
                ),
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 14,),
                    Text(" كلمة المرور الجديدة :", style: GoogleFonts.cairo(
                        fontSize: 12,
                        fontWeight: FontWeight.w400
                    ),),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          onPressed: toggle,
                          icon: Icon(_obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                        ),
                      ),
                      obscureText: _obscureText,
                    ),
                  ],
                )
            ),

            SizedBox(height: MediaQuery.of(context).size.height * .05,),


            GestureDetector(
              onTap: () {
                uploadPassword();
              },
              child: Container(
                alignment: Alignment.center,
                height: 50,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(right: 50, left: 50),
                decoration: BoxDecoration(
                    color: AppTheme.accentColor,
                    borderRadius: BorderRadius.circular(12)
                ),
                child: Text("تغيير كلمة المرور", style: GoogleFonts.cairo(
                    fontSize: 16,fontWeight: FontWeight.bold, color: AppTheme.white
                ),),
              ),
            ),



          ],
        ),
      ),
    );
  }
}
