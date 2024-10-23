import 'dart:convert';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:bab_algharb/components/shared_value_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import '../app_config.dart';
import '../repositories/users_repository.dart';
import '../theme.dart';
import 'dart:ui' as ui;

class FriendScreen extends StatefulWidget {
  const FriendScreen();

  @override
  State<FriendScreen> createState() => _FriendScreenState();
}

class _FriendScreenState extends State<FriendScreen> {
  String selectedIndex = '1';
  String selectedTitle = 'قائمة الأصدقاء';
  final _seachController = TextEditingController();
  final _seachMyfriendsController = TextEditingController();


  List _friendsNamesList = [
    "Ahmed Khaled",
    "محمد سلام",
    "سلمى عبدالله",
    "هبة سلمان",
    "وسام صباح"
  ];

  List _friendsuserNamesList = [
    "ahmed99khaled",
    "ms123",
    "salma1998",
    "heba_97",
    "wissam93sabah"
  ];

  var _searchList = [];
  var _searchedList = [];
  var _foundSearchList = [];
  var _requestsList = [];
  var _myFriendsList = [];
  bool _isSearchInitial = true;
  bool _isRequestInitial = true;
  bool _isFriendsInitial = true;

  String text = "";
  bool isRTL = false;
  getSearchUsers() async {
    var searchResponse = await UserRepository().getSearchFriends(user_id: user_id.$);
    _searchList.addAll(searchResponse.data);
    _isSearchInitial = false;
    setState(() {});
  }
  getSearched() async {
    var searchedResponse = await UserRepository().getSearchedFriends(user_id: user_id.$, keyword: _seachController.text.toString());
    _searchedList.addAll(searchedResponse.data);
    _isSearchInitial = false;
    setState(() {});
  }

  getRequests() async {
    var requestsResponse = await UserRepository().getRequests(user_id: user_id.$);
    _requestsList.addAll(requestsResponse.data);
    _isRequestInitial = false;
    setState(() {});
  }
  getFriends() async {
    var friendsResponse = await UserRepository().getFriends(user_id: user_id.$, keyword: _seachMyfriendsController.text);
    _myFriendsList.addAll(friendsResponse.data);
    _isFriendsInitial = false;
    setState(() {});
  }

  sendFriendRequest({ int following, int follower}) async {
    var sendRequestResponse = await UserRepository().sendFriendRequest(following_id: following, follower_id: follower);
    if(sendRequestResponse.success == true) {
      setState(() {
        CherryToast.success(
          disableToastAnimation: true,
          title: Text(
            'طلب صداقة',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          action: Text(sendRequestResponse.message),
          inheritThemeColors: true,
          actionHandler: () {},
          onToastClosed: () {},
        ).show(context);
      });

      print("==============}}}}}}}}}}}}}}}}}}}"+sendRequestResponse.message);
    }
  }

  remove(request_id) async {
    var acceptedResponse = await UserRepository().removeRequest(id:request_id);
    if(acceptedResponse.success == true) {

      setState(() {
        CherryToast.success(
          disableToastAnimation: true,
          title: Text(
            'إلغاء صداقة',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          action: Text(acceptedResponse.message),
          inheritThemeColors: true,
          actionHandler: () {},
          onToastClosed: () {},
        ).show(context);
        print("==============<<<<<<<<<<<<<<<|||>>>>>>>>>>>>>>>"+acceptedResponse.message);
        setState(() {
          _requestsList.clear();
          getRequests();
          _myFriendsList.clear();
          getFriends();
          _foundSearchList.clear();
          getSearchUsers();
        });

      });

    }
  }

  accept({ var id,  String approv}) async {
    var acceptedResponse = await UserRepository().acceptRequest(id: id, approval: approv);
    if(acceptedResponse.success == true) {

      setState(() {
        CherryToast.success(
          disableToastAnimation: true,
          title: Text(
            'طلب صداقة',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          action: Text(acceptedResponse.message),
          inheritThemeColors: true,
          actionHandler: () {},
          onToastClosed: () {},
        ).show(context);
        print("==============<<<<<<<<<<<<<<<|||>>>>>>>>>>>>>>>"+acceptedResponse.message);
        setState(() {
          _requestsList.clear();
          getRequests();
          _myFriendsList.clear();
          getFriends();
          _foundSearchList.clear();
          getSearchUsers();
        });

      });

    }
  }




  @override
  void initState() {
    getSearchUsers();
    getRequests();
    getFriends();
    getSearched();
    _foundSearchList = _searchList;
    // TODO: implement initState
    super.initState();
  }

  _runFilter(String enteredKeyword) {
    List results = [];
    if(enteredKeyword.isEmpty) {
      results = _searchList;
    }else {
      results = _searchList.where((element) => element['data']['username'].toString().toLowerCase().contains(enteredKeyword.toLowerCase())).toList();
    }

    setState(() {
      _foundSearchList = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppTheme.accentColor,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, color: AppTheme.white,),
        ),
        title: Text(selectedTitle, style: TextStyle(color: AppTheme.white),),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 18),
              child: CupertinoSlidingSegmentedControl(
                backgroundColor: AppTheme.backgroundDark.withOpacity(.3),
                padding: EdgeInsets.all(4),
                groupValue: selectedIndex,
                children: const {
                  "1": Padding(
                    padding: EdgeInsets.all(0),
                    child: Text("قائمة الأصدقاء", style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),),
                  ),
                  "2": Padding(
                    padding: EdgeInsets.all(0),
                    child: Text("طلبات الصداقة", style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),),
                  ),
                  "3": Padding(
                    padding: EdgeInsets.all(8),
                    child: Text("بحث", style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),),
                  ),
                },
                onValueChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedIndex = value;
                      if(value == "1") {
                        setState(() {
                          selectedTitle = "قائمة الأصدقاء";
                        });
                      }else if(value == "2") {
                        selectedTitle = "طلبات الصداقة";
                      }else if(value == "3") {
                        selectedTitle = "بحث";
                      }
                    });
                  }
                },
              )),

          SizedBox(height: 5,),

          selectedIndex == "3" ?
          Container(
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(20)
            ),
            margin: EdgeInsets.symmetric(horizontal: 18, vertical: 5),
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        _searchedList.clear();
                        getSearched();
                      });
                    },
                  ),
                hintText: 'بحث ...',
                border: InputBorder.none,
              ),
              controller: _seachController,
            ),
          ) : selectedIndex == "1" ?
          Container(
            decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(20)
            ),
            margin: EdgeInsets.symmetric(horizontal: 18, vertical: 5),
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
                textDirection: ui.TextDirection.rtl,
                decoration: InputDecoration(
                  hintText: 'بحث ...',
                  border: InputBorder.none,
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
              controller: _seachMyfriendsController,

            ),
          ) : Container(),

          Container(
            height: MediaQuery.of(context).size.height - 245,
            child: selectedIndex == "1" ? ListView.builder(
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
                            radius: 35,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 15,),
                            Text(_myFriendsList[index].name, style: TextStyle(
                                fontSize: 16
                            ),),
                            SizedBox(height: 5,),
                            Text(_myFriendsList[index].username, style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.backgroundDark.withOpacity(.7)
                            ),)
                          ],
                        ),


                       GestureDetector(
                         onTap: (){
                           showDialog(
                             context: context,
                             builder: (BuildContext context) {
                               return AlertDialog(
                                 contentPadding: EdgeInsets.symmetric(horizontal: 18),
                                 content: StatefulBuilder(
                                   builder: (BuildContext context, StateSetter setState) {
                                     return  SingleChildScrollView(
                                       child: ListBody(
                                         children: <Widget>[
                                           SizedBox(height: 5,),
                                           Text('هل تريد بالفعل إلغاء الصداقة؟'),
                                           SizedBox(height: 12,),



                                         ],
                                       ),
                                     );
                                   },
                                 ),
                                 backgroundColor: AppTheme.light_bg,
                                 title: Text('إلغاء الصداقة'),

                                 actions: <Widget>[
                                   TextButton(
                                     child: Text('إلغاء'),
                                     onPressed: () {
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
                                       remove(_myFriendsList[index].request_id);
                                       _myFriendsList.clear();
                                       getFriends();
                                       Navigator.of(context).pop();
                                     },
                                   ),
                                 ],
                               );
                             },
                           );
                         },
                         child: Container(
                             alignment: Alignment.center,
                             width: 35,
                             height: 35,
                             decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(8),
                                 color: AppTheme.danger
                             ),
                             child: Icon(Icons.close, color: AppTheme.white,)),
                       )



                      ],
                    ),
                  );
                }) :
            selectedIndex == "2" ? ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: _requestsList.length,
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
                            backgroundImage: NetworkImage(_requestsList[index].photo),
                            radius: 35,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 15,),
                            Text(_requestsList[index].name, style: TextStyle(
                                fontSize: 16
                            ),),
                            SizedBox(height: 5,),
                            Text(_requestsList[index].username, style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.backgroundDark.withOpacity(.7)
                            ),)
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  accept(
                                      id: _requestsList[index].request_id,
                                      approv: "remove"
                                  );
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 35,
                                  height: 35,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: AppTheme.danger
                                  ),
                                  child: Icon(Icons.close, color: AppTheme.white,),
                                ),
                              ),
                              SizedBox(width: 16,),
                              GestureDetector(
                                onTap: () async {
                                  print("==========================================================="+_requestsList[index].id.toString());
                                  accept(
                                      id: _requestsList[index].request_id,
                                      approv: "accepted"
                                  );
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 35,
                                  height: 35,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: AppTheme.accentColor
                                  ),
                                  child: Icon(Icons.check, color: AppTheme.white,),
                                ),
                              ),
                            ],
                          ),
                          ),

                      ],
                    ),
                  );
                }) :
            ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: _searchedList.length,
                itemBuilder: (context, index) {

                  if(user_id.$ == _searchedList[index].id) {
                    return Container();
                  }
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: 90,
                    margin: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: AppTheme.white
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(_searchedList[index].photo),
                            radius: 35,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 15,),
                            Text(_searchedList[index].name, style: TextStyle(
                                fontSize: 16
                            ),),
                            SizedBox(height: 5,),
                            Text(_searchedList[index].username, style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.backgroundDark.withOpacity(.7)
                            ),)
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: GestureDetector(
                            onTap: () async {

                              // var response = await http.get(Uri.parse('${AppConfig.BASE_URL}/friends/send-request?following_id=${user_id.$}&follower_id=${_searchList[index].id}'));
                              // var res = jsonDecode(response.body);
                              // if(res["message"] == "false") {
                              //   print("=======================================)))))))))))))))))))))) false");
                                sendFriendRequest(
                                    following: user_id.$,
                                    follower: _foundSearchList[index].id
                                );
                              // }else {
                              //   print("=======================================)))))))))))))))))))))) true");
                              //
                              // }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 80,
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: AppTheme.accentColor
                              ),
                              child: Text("إرسال طلب", style: TextStyle(
                                color: AppTheme.white,
                                fontWeight: FontWeight.bold
                              ),),
                            ),
                          ),
                        ),

                      ],
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
