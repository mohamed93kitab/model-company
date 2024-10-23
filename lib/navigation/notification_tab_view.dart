import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../components/shared_value_helper.dart';
import '../repositories/notification_repository.dart';
import '../theme.dart';

class NotificationTabView extends StatefulWidget {
  const NotificationTabView();

  @override
  State<NotificationTabView> createState() => _NotificationTabViewState();
}

class _NotificationTabViewState extends State<NotificationTabView> {
  List _notificationsList = [];

  bool _isNotificatinInitial = true;

  var _current_slider = 0;


  fetchNotifications() async {
    var newsResponse = await NotificationRepository().getLatestNotifications();
    _notificationsList.addAll(newsResponse.data);
    _isNotificatinInitial = false;
     setState(() {});
  }

   @override
  void initState() {
    // TODO: implement initState
     fetchNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text("الإشعارات"),
        backgroundColor: AppTheme.accentColor,
      ),
      body: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: AppTheme.background,
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
              top: 20,
              bottom: MediaQuery.of(context).padding.bottom),
          child: Container(
            height: MediaQuery.of(context).size.height - 140,
            child:
              _isNotificatinInitial == true && _notificationsList.length == 0 ?
              Center( child: CircularProgressIndicator(),
              ) : _isNotificatinInitial == false && _notificationsList.length == 0 ? Center(
                child: Text("لا توجد أشعارات"),
              ) : ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: _notificationsList.length,
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
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.accentColor),
                                borderRadius: BorderRadius.circular(80)
                              ),
                              child: ClipRRect(
                              borderRadius: BorderRadius.circular(80.0),
                                  child: _notificationsList[index].photo == "" ? Image.asset("assets/notifi.png")
                                      : Image.network( _notificationsList[index].photo)
                              )
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 12,),
                              Container(
                                width: MediaQuery.of(context).size.width - 150,
                                child: Text(_notificationsList[index].title_ar, style: TextStyle(
                                    fontSize: 16,
                                  height: 1
                                ),),
                              ),
                              SizedBox(height: 0,),
                              Container(
                    width: MediaQuery.of(context).size.width - 150,
                                child: Text(_notificationsList[index].content_ar, style: TextStyle(
                                    fontSize: 14,
                                    height: 1.2,
                                    color: AppTheme.backgroundDark.withOpacity(.7)
                                ),
                                maxLines: 2,),
                              ),
                              SizedBox(height: 5,),
                              Text(_notificationsList[index].created_at, style: TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.backgroundDark.withOpacity(.4)
                              ),)
                            ],
                          ),


                        ],
                      ),
                    );
                  }),

              // SizedBox(height: 20),
              // Align(
              //   alignment: Alignment.center,
              // child: GestureDetector(
              //   child: Container(
              //     padding: EdgeInsets.symmetric(
              //       vertical: 10,
              //       horizontal: 18
              //     ),
              //     decoration: BoxDecoration(
              //       color: AppTheme.backgroundDark,
              //       borderRadius: BorderRadius.circular(42)
              //     ),
              //     child: Text("أضف إعلانك", style: TextStyle(
              //       color: AppTheme.white,
              //       fontSize: 16
              //     ),),
              //   ),
              // )
              // ),
          ),
        ),
      ),
    );
  }
}
