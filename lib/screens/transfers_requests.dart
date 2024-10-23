
import 'dart:ui';

import 'package:bab_algharb/app_config.dart';
import 'package:bab_algharb/repositories/auth_repository.dart';
import 'package:bab_algharb/repositories/transfer_repository.dart';
import 'package:bab_algharb/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cherry_toast/cherry_toast.dart';
import '../components/shared_value_helper.dart';
import '../repositories/users_repository.dart';
class TransferScreen extends StatefulWidget {
  const TransferScreen();

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {

  final pointsFieldController = TextEditingController();

  String selectedIndex = '1';

  final coinsController = TextEditingController();
  final starsController = TextEditingController();
  var coins_converter;
  var stars_converter;

  var _selectedUserName;

  int _from_id = 0;
  int _id = 0;
  String _approval = "";

  int _selectedUserId = 0;
  List _transfersList = [];
  List _archiveList = [];
  bool _isTransfersInitial = true;
  bool _isTransfersArchiveInitial = true;

  getTransfersRequests() async {
    var transferResponse = await TransferRepository().getTransfersRequests(user_id: user_id.$);
    _transfersList.addAll(transferResponse.data);
    _isTransfersInitial = false;
    setState(() {});
    // if(transferResponse.success == true) {
    //   CherryToast.success(
    //     disableToastAnimation: true,
    //     title: Text(
    //       'تحويل النقاط',
    //       style: TextStyle(
    //         fontWeight: FontWeight.bold,
    //       ),
    //     ),
    //     action: Text(transferResponse.message),
    //     inheritThemeColors: true,
    //     actionHandler: () {},
    //     onToastClosed: () {},
    //   ).show(context);
    //   setState(() {
    //     _selectedUserName = null;
    //     pointsFieldController.clear();
    //     _selectedUserId = 0;
    //   });
    // }
  }
  getTransfersArchive() async {
    var archiveResponse = await TransferRepository().getTransfersArchive(user_id: user_id.$);
    _archiveList.addAll(archiveResponse.data);
    _isTransfersArchiveInitial = false;
    setState(() {});

  }

  acceptRequest() async {
    print("------------------------------------------------------------------------------ "+_id.toString()+"********************* "+user_id.$.toString());
    var transferResponse = await TransferRepository().acceptForTransform(to_id: user_id.$, id: _id, approval: _approval);
    _transfersList.addAll(transferResponse.data);
    _isTransfersInitial = false;
    setState(() {});
    if(transferResponse.success == true) {
      CherryToast.success(
        disableToastAnimation: true,
        title: Text(
          'تحويل النقاط',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        action: Text(transferResponse.message),
        inheritThemeColors: true,
        actionHandler: () {},
        onToastClosed: () {},
      ).show(context);
      setState(() {
        _selectedUserName = null;
        pointsFieldController.clear();
        _selectedUserId = 0;
      });
    }
  }


  var _name;
  var _points = 0;
  var _stars = 0;
  var _avatar = "0";
  var _username;
  var _phone_number;
  var _frame;
  bool _isInfoInitial = true;

  getUserInformation() async {
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
        _isInfoInitial = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserInformation();
    getTransfersRequests();
    getTransfersArchive();
    super.initState();
    print("------------------------------------------------------------------------------ "+user_id.$.toString());

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * .32,
                  padding: EdgeInsets.only(top: 25),
                  decoration: BoxDecoration(
                      gradient: AppTheme.secondaryGradient,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                      )
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(15),
                            child: IconButton(onPressed: ()=> Navigator.pop(context), icon: Icon(Icons.arrow_back_ios, color: AppTheme.white,),),
                          ),
                          Padding(
                            padding: EdgeInsets.all(15),
                            child: Text("طلبات تحويل النقاط لك", style: TextStyle(
                                color: AppTheme.white,fontSize: 15, fontWeight: FontWeight.bold),),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 35),
                          ),
                        ],
                      ),

                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 200,
                          height: 60,
                          decoration: BoxDecoration(
                              color: AppTheme.white,
                              borderRadius: BorderRadius.circular(30)
                          ),
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 20),
                                decoration: BoxDecoration(
                                    color: AppTheme.white,
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(width: 4, color: AppTheme.white)
                                ),
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundImage: NetworkImage(_avatar == "0" || _avatar == null ? "https://static.vecteezy.com/system/resources/previews/009/292/244/original/default-avatar-icon-of-social-media-user-vector.jpg" : "${AppConfig.IMAGES_PATH}"+ _avatar),
                                ),
                              ),

                              Text(_points.toString(), style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold
                              ),)

                            ],
                          ),
                        ),
                      ),


                      Padding(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          child: CupertinoSlidingSegmentedControl(
                            backgroundColor: AppTheme.backgroundDark.withOpacity(.3),
                            padding: EdgeInsets.all(4),
                            groupValue: selectedIndex,
                            children: {
                              "1": Padding(
                                padding: EdgeInsets.all(8),
                                child: Text("طلبات التحويل", style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                ),),
                              ),
                              "2": Padding(
                                padding: EdgeInsets.all(8),
                                child: Text("السجل", style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                ),),
                              ),
                            },
                            onValueChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  selectedIndex = value;
                                });
                              }
                            },
                          ))

                    ],
                  ),
                ),
              ],
            ),
            selectedIndex == "1" ? Container(
              height: MediaQuery.of(context).size.height * .7,
              child: _transfersList.length == 0 && _isTransfersInitial == false ?
              Center(
                child: Text("لا توجد طلبات معلقة"),
              ) : _transfersList.length == 0 && _isTransfersInitial == true ?
              Center(
                child: CircularProgressIndicator(),
              ) : ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: _transfersList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: 90,
                      margin: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: AppTheme.white
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(_transfersList[index].avatar == null ? "https://static.vecteezy.com/system/resources/previews/009/292/244/original/default-avatar-icon-of-social-media-user-vector.jpg" : _transfersList[index].avatar),
                            radius: 35,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 15,),
                              Text(_transfersList[index].from == null ? "" : _transfersList[index].from, style: TextStyle(
                                  fontSize: 16
                              ),),
                              SizedBox(height: 5,),
                              _transfersList[index].from == null ?
                              Container() :
                              Text("يريد تحويل "+_transfersList[index].points.toString() + " نقطة لك", style: TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.backgroundDark.withOpacity(.7)
                              ),)
                            ],
                          ),

                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _id = _transfersList[index].id;
                                  _approval = "removed";
                                  acceptRequest();
                                  Navigator.pop(context);
                                },

                                child: Container(
                                  alignment: Alignment.center,
                                  width: 35,
                                  height: 35,
                                  decoration: BoxDecoration(
                                      color: AppTheme.danger,
                                      borderRadius: BorderRadius.circular(8)
                                  ),
                                  child: Icon(Icons.close, color: AppTheme.white,),
                                ),
                              ),
                              SizedBox(width: 12,),
                              GestureDetector(
                                onTap: () {
                                    setState(() {
                                    //  _from_id = _transfersList[index].from.
                                      _id = _transfersList[index].id;
                                      _approval = "accepted";
                                      print("======================================"+_id.toString());
                                    });
                                    acceptRequest();
                                    setState(() {
                                      _transfersList.clear();
                                      getTransfersRequests();
                                    });
                                  //  Navigator.pop(context);
                                },

                                child: Container(
                                  alignment: Alignment.center,
                                  width: 35,
                                  height: 35,
                                  decoration: BoxDecoration(
                                      color: AppTheme.accentColor,
                                      borderRadius: BorderRadius.circular(8)
                                  ),
                                  child: Icon(Icons.check, color: AppTheme.white,),
                                ),
                              ),
                            ],
                          )


                        ],
                      ),
                    );
                  }),
            ) : Container(
              height: MediaQuery.of(context).size.height * .7,
              child: _archiveList.length == 0 && _isTransfersArchiveInitial == false ?
              Center(
                child: Text("لا توجد طلبات"),
              ) : _archiveList.length == 0 && _isTransfersArchiveInitial == true ?
              Center(
                child: CircularProgressIndicator(),
              ) : ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: _archiveList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 90,
                        margin: EdgeInsets.only(left: 18, right: 18, top: 12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: AppTheme.white
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _archiveList[index].from_id == user_id.$ ?  CircleAvatar(
                              backgroundImage: NetworkImage(_archiveList[index].to_avatar == null ?"https://static.vecteezy.com/system/resources/previews/009/292/244/original/default-avatar-icon-of-social-media-user-vector.jpg" : _archiveList[index].to_avatar),
                              radius: 35,
                            ) : CircleAvatar(
                              backgroundImage: NetworkImage(_archiveList[index].avatar == null ? "https://static.vecteezy.com/system/resources/previews/009/292/244/original/default-avatar-icon-of-social-media-user-vector.jpg" : _archiveList[index].avatar),
                              radius: 35,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 15,),
                                _archiveList[index].from_id == user_id.$ ?
                                Text(_archiveList[index].to == null ? "" : _archiveList[index].to, style: TextStyle(
                                    fontSize: 16,
                                  height: .8
                                ),) :
                                Text(_archiveList[index].from == null ? "" : _archiveList[index].from, style: TextStyle(
                                    fontSize: 16,
                                  height: .8
                                ),),
                                _archiveList[index].from == null ?
                                Container() :
                                Text(" تحويل "+_archiveList[index].points.toString() + " نقطة", style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.backgroundDark.withOpacity(.7)
                                ),),

                                Text( _archiveList[index].created_at)
                              ],
                            ),

                            Padding(padding: EdgeInsets.all(10), child: Icon(_archiveList[index].from_id == user_id.$ ? Icons.upload : Icons.download, color: _archiveList[index].from_id == user_id.$ ? AppTheme.danger : Colors.green,),)




                          ],
                        ),
                      ),
                    );
                  }),
            )

          ],
        ),
      ),
    );
  }

}
