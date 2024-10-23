
import 'dart:ui';

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
  import '../app_config.dart';
import '../components/shared_value_helper.dart';
  import '../repositories/agent_repository.dart';
import '../repositories/users_repository.dart';
  class ConvertScreen extends StatefulWidget {
  const ConvertScreen();

  @override
  State<ConvertScreen> createState() => _ConvertScreenState();
  }

  class _ConvertScreenState extends State<ConvertScreen> {

  final pointsFieldController = TextEditingController();
  final _searchFieldController = TextEditingController();
  final _searchAgentsController = TextEditingController();
  final _searchFriendController = TextEditingController();

  String selectedIndex = '1';
  String _search = '';
  String _role = '';

  final coinsController = TextEditingController();
  final starsController = TextEditingController();
  var coins_converter;
  var stars_converter;

  var _selectedUserName;

  int _selectedUserId = 0;
  var _verified = '';

  sendTransfer() async {
    var transferResponse = await TransferRepository().sendTransfer(from_id: user_id.$, to_id: _selectedUserId, points: pointsFieldController.text);
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

  var _myFriendsList = [];
  bool _isFriendsInitial = true;

  var _allUsersList = [];
  bool _isUsersInitial = true;
  var _agentsList = [];
  bool _isAgentsInitial = true;
  getFriends() async {
    var friendsResponse = await UserRepository().getFriends(user_id: user_id.$, keyword: _searchFriendController.text);
    _myFriendsList.addAll(friendsResponse.data);
    _isFriendsInitial = false;
  }

  getAgents() async {
    var agentsResponse = await AgentRepository().getMyAgents(search: _searchAgentsController.text);
    _agentsList.addAll(agentsResponse.data);
    _isAgentsInitial = false;
  }
  getAllUsers() async {
    var allUsersResponse = await UserRepository().getSearchUsers(search: _searchFieldController.text);
    _allUsersList.addAll(allUsersResponse.data);
    _isUsersInitial = false;
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
        _role = infoResponse.role_name;
        _verified = infoResponse.verified;
        _isInfoInitial = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserInformation();
    getFriends();
    getAgents();
    getAllUsers();
    super.initState();
  }

  bool _dialogisOpen = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if(_dialogisOpen) {
          Navigator.of(context, rootNavigator: true).pop();
          setState(() {
            pointsFieldController.clear();
            _dialogisOpen = false;
          });
        }else {
          pointsFieldController.clear();
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * .35,
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
                              child: Text("تحويل النقاط", style: TextStyle(
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
                                    backgroundImage: NetworkImage(_avatar == "0" || _avatar == null ? "https://static.vecteezy.com/system/resources/previews/009/292/244/original/default-avatar-icon-of-social-media-user-vector.jpg" :  "${AppConfig.IMAGES_PATH}"+ _avatar),
                                  ),
                                ),
                          Transform.translate(
                            offset: Offset(20,0),
                            child: Align(
                              alignment: Alignment.center,
                              child: _verified == "" ? Container() : Image.network("${_verified}",
                                width: 25,
                              ),
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

                        _role == '' ? Center(
                          child: CircularProgressIndicator()
                        )  : _role == 'agent' ?
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 14),
                            child: CupertinoSlidingSegmentedControl(
                              backgroundColor: AppTheme.backgroundDark.withOpacity(.3),
                          padding: EdgeInsets.all(4),
                          groupValue: selectedIndex,
                          children: {
                            "1": Padding(
                                padding: EdgeInsets.all(8),
                            child: Text("صديق", style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                            ),),
                            ),
                            "2": Padding(
                              padding: EdgeInsets.all(8),
                              child: Text("الوكلاء", style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold
                              ),),
                            ),
                            "3": Padding(
                              padding: EdgeInsets.all(8),
                              child: Text("العام", style: TextStyle(
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
                       : Padding(
                          padding: EdgeInsets.symmetric(vertical: 14),
                            child: CupertinoSlidingSegmentedControl(
                              backgroundColor: AppTheme.backgroundDark.withOpacity(.3),
                          padding: EdgeInsets.all(4),
                          groupValue: selectedIndex,
                          children: {
                            "1": Padding(
                                padding: EdgeInsets.all(8),
                            child: Text("صديق", style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                            ),),
                            ),
                            "2": Padding(
                              padding: EdgeInsets.all(8),
                              child: Text("الوكلاء", style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold
                              ),),
                            ),

                            "3": Padding(
                              padding: EdgeInsets.all(8),
                              child: Text("التجار", style: TextStyle(
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
                        )),





                      ],
                    ),
                  ),
                ],
              ),


             selectedIndex == "3"  ? Container(
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.circular(18)
                ),
                margin: EdgeInsets.only(top: 22, right: 26, left: 26),
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  controller: _searchFieldController,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          setState(() {
                            _allUsersList.clear();
                            getAllUsers();
                          });
                        },
                      ),
                    border: InputBorder.none,
                    hintText: 'أبحث هنا ..',
                    helperStyle: TextStyle(
                      color: AppTheme.backgroundDark.withOpacity(.4)
                    )
                  ),

                ),
              ) : selectedIndex == "2" ? Container(
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.circular(18)
                ),
                margin: EdgeInsets.only(top: 22, right: 26, left: 26),
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  controller: _searchAgentsController,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          setState(() {
                            _agentsList.clear();
                            getAgents();
                          });
                        },
                      ),
                    border: InputBorder.none,
                    hintText: 'أبحث هنا ..',
                    helperStyle: TextStyle(
                      color: AppTheme.backgroundDark.withOpacity(.4)
                    )
                  ),
                ),
              ) : selectedIndex == "1" ? Container(
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.circular(18)
                ),
                margin: EdgeInsets.only(top: 22, right: 26, left: 26),
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  controller: _searchFriendController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'أبحث هنا ..',
                    helperStyle: TextStyle(
                      color: AppTheme.backgroundDark.withOpacity(.4)
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        setState(() {
                          _myFriendsList.clear();
                          getFriends();
                        });
                      },
                    ),
                  ),

                ),
              ) : Container(),

             _role == '' ? Center(
               child: CircularProgressIndicator(),
             ) : Column(
                children: [
                  selectedIndex == "1" ?
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text("أسم المستخدم للصديق المراد التحويل له :", style: TextStyle(
                        //     fontSize: 16
                        // ),),
                        // SizedBox(height: 12,),
                        // TextFormField(
                        //   keyboardType: TextInputType.text,
                        //   decoration: InputDecoration(
                        //       filled: true,
                        //       fillColor: AppTheme.background2.withOpacity(.1),
                        //       border: InputBorder.none,
                        //
                        //       suffixIcon: Container(
                        //         color: AppTheme.accentColor,
                        //         child: IconButton(onPressed: () {}, icon: SvgPicture.asset("assets/icons/search-friend.svg", width: 42,height: 32, color: Colors.white,)),
                        //       )
                        //   ),
                        // ),

                        SizedBox(height: 15,),

                        ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: _myFriendsList.length,
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
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(_myFriendsList[index].photo),
                                        radius: 30,
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 15,),
                                        Text(_myFriendsList[index].name, style: TextStyle(
                                            fontSize: 14
                                        ),),
                                        SizedBox(height: 5,),
                                        Text(_myFriendsList[index].username, style: TextStyle(
                                            fontSize: 12,
                                            color: AppTheme.backgroundDark.withOpacity(.7)
                                        ),)
                                      ],
                                    ),

                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedUserId = _myFriendsList[index].id;
                                          _selectedUserName= _myFriendsList[index].name;
                                        });
                                        setState(() {
                                          _dialogisOpen = true;
                                        });
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              backgroundColor: AppTheme.light_bg,
                                              title: Text('تحويل النقاط إلى ' + _selectedUserName),
                                              content: SingleChildScrollView(
                                                child: ListBody(
                                                  children: <Widget>[
                                                    SizedBox(height: 5,),
                                                    Text('تأكد جيداً من الرقم قبل إرساله!'),
                                                    SizedBox(height: 12,),
                                                    Container(
                                                      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 12),
                                                      color: Colors.white,
                                                      child: TextFormField(
                                                        controller: pointsFieldController,

                                                        decoration: InputDecoration(
                                                          border: InputBorder.none,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: Text('إلغاء'),
                                                  onPressed: () {
                                                    setState(() {
                                                      pointsFieldController.clear();
                                                    });
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                TextButton(
                                                  child: Container(
                                                      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                                                      decoration: BoxDecoration(
                                                          color: AppTheme.accentColor,
                                                          borderRadius: BorderRadius.circular(8)
                                                      ),
                                                      child: Text('تأكيد', style: TextStyle(
                                                          color: AppTheme.white
                                                      ),)),
                                                  onPressed: () {
                                                    sendTransfer();
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        ).then((_) {
                                          setState(() {
                                            pointsFieldController.clear();
                                            _dialogisOpen = false;
                                          });
                                        });
                                      },

                                      child: Container(
                                        alignment: Alignment.center,
                                        width: 80,
                                        height: 35,
                                        decoration: BoxDecoration(
                                            color: AppTheme.accentColor,
                                            borderRadius: BorderRadius.circular(8)
                                        ),
                                        child: Text("إرسال", style: TextStyle(
                                            color: AppTheme.white,
                                            fontWeight: FontWeight.bold
                                        ),),
                                      ),
                                    )


                                  ],
                                ),
                              );
                            }),

                        // TextButton(
                        //     onPressed: () {
                        //     },
                        //     child: Container(
                        //       alignment: Alignment.center,
                        //       width: MediaQuery.of(context).size.width,
                        //       height: 50,
                        //       decoration: BoxDecoration(
                        //           color: AppTheme.accentColor
                        //       ),
                        //       child: Text(
                        //         "موافق",
                        //         style: TextStyle(
                        //             fontSize: 18,
                        //             color: AppTheme.white
                        //         ),
                        //       ),
                        //     ))


                      ],
                    ),
                  ) :
                  selectedIndex == "2" ?
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text("أسم المستخدم للصديق المراد التحويل له :", style: TextStyle(
                        //     fontSize: 16
                        // ),),
                        // SizedBox(height: 12,),
                        // TextFormField(
                        //   keyboardType: TextInputType.text,
                        //   decoration: InputDecoration(
                        //       filled: true,
                        //       fillColor: AppTheme.background2.withOpacity(.1),
                        //       border: InputBorder.none,
                        //
                        //       suffixIcon: Container(
                        //         color: AppTheme.accentColor,
                        //         child: IconButton(onPressed: () {}, icon: SvgPicture.asset("assets/icons/search-friend.svg", width: 42,height: 32, color: Colors.white,)),
                        //       )
                        //   ),
                        // ),

                        SizedBox(height: 15,),

                        ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: _agentsList.length,
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
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(_agentsList[index].photo == null ? "" : _agentsList[index].photo),
                                        radius: 30,
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 15,),
                                        Text(_agentsList[index].name, style: TextStyle(
                                            fontSize: 14
                                        ),),
                                        SizedBox(height: 5,),
                                        Text(_agentsList[index].username == null ? "" : _agentsList[index].username, style: TextStyle(
                                            fontSize: 12,
                                            color: AppTheme.backgroundDark.withOpacity(.7)
                                        ),)
                                      ],
                                    ),

                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedUserId = _agentsList[index].id;
                                          _selectedUserName= _agentsList[index].name;
                                        });
                                        setState(() {
                                          _dialogisOpen = true;
                                        });
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              backgroundColor: AppTheme.light_bg,
                                              title: Text('تحويل النقاط إلى ' + _selectedUserName),
                                              content: SingleChildScrollView(
                                                child: ListBody(
                                                  children: <Widget>[
                                                    SizedBox(height: 5,),
                                                    Text('تأكد جيداً من الرقم قبل إرساله!'),
                                                    SizedBox(height: 12,),
                                                    Container(
                                                      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 12),
                                                      color: Colors.white,
                                                      child: TextFormField(
                                                        controller: pointsFieldController,

                                                        decoration: InputDecoration(
                                                          border: InputBorder.none,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: Text('إلغاء'),
                                                  onPressed: () {
                                                    setState(() {
                                                      pointsFieldController.clear();
                                                    });
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                TextButton(
                                                  child: Container(
                                                      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                                                      decoration: BoxDecoration(
                                                          color: AppTheme.accentColor,
                                                          borderRadius: BorderRadius.circular(8)
                                                      ),
                                                      child: Text('تأكيد', style: TextStyle(
                                                          color: AppTheme.white
                                                      ),)),
                                                  onPressed: () {
                                                    sendTransfer();
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        ).then((_) {
                                          setState(() {
                                            pointsFieldController.clear();
                                            _dialogisOpen = false;
                                          });
                                        });
                                      },

                                      child: Container(
                                        alignment: Alignment.center,
                                        width: 80,
                                        height: 35,
                                        decoration: BoxDecoration(
                                            color: AppTheme.accentColor,
                                            borderRadius: BorderRadius.circular(8)
                                        ),
                                        child: Text("إرسال", style: TextStyle(
                                            color: AppTheme.white,
                                            fontWeight: FontWeight.bold
                                        ),),
                                      ),
                                    )


                                  ],
                                ),
                              );
                            }),

                        // TextButton(
                        //     onPressed: () {
                        //     },
                        //     child: Container(
                        //       alignment: Alignment.center,
                        //       width: MediaQuery.of(context).size.width,
                        //       height: 50,
                        //       decoration: BoxDecoration(
                        //           color: AppTheme.accentColor
                        //       ),
                        //       child: Text(
                        //         "موافق",
                        //         style: TextStyle(
                        //             fontSize: 18,
                        //             color: AppTheme.white
                        //         ),
                        //       ),
                        //     ))


                      ],
                    ),
                  ) :
                  selectedIndex == "3" && _role == 'agent' ?
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        SizedBox(height: 15,),

                        ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: _allUsersList.length,
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
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(_allUsersList[index].photo == null ? "" : _allUsersList[index].photo),
                                        radius: 30,
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 15,),
                                        Text(_allUsersList[index].name, style: TextStyle(
                                            fontSize: 14
                                        ),),
                                        SizedBox(height: 5,),
                                        Text(_allUsersList[index].username == null ? "" : _allUsersList[index].username, style: TextStyle(
                                            fontSize: 12,
                                            color: AppTheme.backgroundDark.withOpacity(.7)
                                        ),)
                                      ],
                                    ),

                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedUserId = _allUsersList[index].id;
                                          _selectedUserName= _allUsersList[index].name;
                                        });
                                        setState(() {
                                          _dialogisOpen = true;
                                        });
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              backgroundColor: AppTheme.light_bg,
                                              title: Text('تحويل النقاط إلى ' + _selectedUserName),
                                              content: SingleChildScrollView(
                                                child: ListBody(
                                                  children: <Widget>[
                                                    SizedBox(height: 5,),
                                                    Text('تأكد جيداً من الرقم قبل إرساله!'),
                                                    SizedBox(height: 12,),
                                                    Container(
                                                      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 12),
                                                      color: Colors.white,
                                                      child: TextFormField(
                                                        controller: pointsFieldController,

                                                        decoration: InputDecoration(
                                                          border: InputBorder.none,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: Text('إلغاء'),
                                                  onPressed: () {
                                                    setState(() {
                                                      pointsFieldController.clear();
                                                    });
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                TextButton(
                                                  child: Container(
                                                      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                                                      decoration: BoxDecoration(
                                                          color: AppTheme.accentColor,
                                                          borderRadius: BorderRadius.circular(8)
                                                      ),
                                                      child: Text('تأكيد', style: TextStyle(
                                                          color: AppTheme.white
                                                      ),)),
                                                  onPressed: () {
                                                    sendTransfer();
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        ).then((_) {
                                          setState(() {
                                            pointsFieldController.clear();
                                            _dialogisOpen = false;
                                          });
                                        });
                                      },

                                      child: Container(
                                        alignment: Alignment.center,
                                        width: 80,
                                        height: 35,
                                        decoration: BoxDecoration(
                                            color: AppTheme.accentColor,
                                            borderRadius: BorderRadius.circular(8)
                                        ),
                                        child: Text("إرسال", style: TextStyle(
                                            color: AppTheme.white,
                                            fontWeight: FontWeight.bold
                                        ),),
                                      ),
                                    )


                                  ],
                                ),
                              );
                            }),

                        // TextButton(
                        //     onPressed: () {
                        //     },
                        //     child: Container(
                        //       alignment: Alignment.center,
                        //       width: MediaQuery.of(context).size.width,
                        //       height: 50,
                        //       decoration: BoxDecoration(
                        //           color: AppTheme.accentColor
                        //       ),
                        //       child: Text(
                        //         "موافق",
                        //         style: TextStyle(
                        //             fontSize: 18,
                        //             color: AppTheme.white
                        //         ),
                        //       ),
                        //     ))


                      ],
                    ),
                  ) :
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("عدد الكوينزات :", style: TextStyle(
                            fontSize: 16
                        ),),
                        SizedBox(height: 12,),
                        TextFormField(
                          controller: starsController,
                          onChanged: (text) {
                            stars_converter = int.parse(text) * 2;
                            setState(() {

                            });
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: AppTheme.background2.withOpacity(.1),
                              border: InputBorder.none,

                              suffixIcon: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: SvgPicture.asset("assets/icons/coins.svg", width: 12,height: 12, color: Colors.orange,),
                              )
                          ),
                        ),

                        SizedBox(height: 32,),

                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [


                              SvgPicture.asset("assets/icons/stars.svg", width: 32,height: 32, color: Colors.orange,),
                              Text(stars_converter == null ? "" : stars_converter.toString(),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.accentColor,
                                ),),
                            ],
                          ),
                        ),
                        SizedBox(height: 55,),

                        TextButton(
                            onPressed: () {
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: AppTheme.accentColor
                              ),
                              child: Text(
                                "تحويل",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: AppTheme.white
                                ),
                              ),
                            ))


                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

}
