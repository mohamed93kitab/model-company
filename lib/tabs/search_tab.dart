import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexagon/hexagon.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cherry_toast/cherry_toast.dart';
import '../components/shared_value_helper.dart';
import '../repositories/auth_repository.dart';
import '../repositories/counter_repository.dart';
import '../theme.dart';
class SearchTab extends StatefulWidget {
  const SearchTab( ) ;

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> with TickerProviderStateMixin {

  AnimationController _controller;

 int _totalSubscribesPoints = 0;

  bool isPlaying = false;
  bool done = true;
  var _countersList = [];
  bool _isCountersInitial = true;

  getCounters() async {
    var counterResponse = await CounterRepository().getLatestCounters();
    if (counterResponse.success == true) {
      _countersList.addAll(counterResponse.data);
      setState(() {
        _isCountersInitial = false;
      });
    }
  }
  int _stars = 0;
  int _points = 0;
  double _balance = 0;
  var _avatar;
  var _frame;
  String _username = '';
  String _phone_number = '';
  String _name = '';
  bool isInfoInitial = true;


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
        _balance = infoResponse.points/6000;
        isInfoInitial = false;
      });
    }
  }




  subscribe(counter_id) async {
    var counterResponse = await CounterRepository()
        .subscribe(counter_id: counter_id, user_id: user_id.$);
    if (counterResponse.success == true) {
      setState(() {
        CherryToast.success(
          disableToastAnimation: true,
          title: Text(
            'الإشتراك',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          action: Text(counterResponse.message),
          inheritThemeColors: true,
          actionHandler: () {},
          onToastClosed: () {},
        ).show(context);
      });
    } else {
      setState(() {
        CherryToast.error(
          disableToastAnimation: true,
          title: Text(
            'خطأ! رصيدك لا يكفي',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          action: Text(counterResponse.message),
          inheritThemeColors: true,
          actionHandler: () {},
          onToastClosed: () {},
        ).show(context);
      });
    }
  }

  getAllSubscribesPoints() async {
    var subscribesPointsResponse = await CounterRepository()
        .getAllSubscribesPoints(user_id: user_id.$);
    if (subscribesPointsResponse.success == true) {
      setState(() {
        _totalSubscribesPoints = subscribesPointsResponse.user_id;
      });
    } else {
      setState(() {
        _totalSubscribesPoints = 0;
      });
    }
  }

  finishedCounter() async {

      var finishedResponse = await CounterRepository().finishedCounter(
          user_id: user_id.$);

      if (finishedResponse.success == true) {
        CherryToast.success(
          disableToastAnimation: true,
          title: Text(
            finishedResponse.message,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          action: Text(""),
          inheritThemeColors: true,
          actionHandler: () {},
          onToastClosed: () {},
        ).show(context);
      }

  }



  String get countText {
    Duration count = _controller.duration * _controller.value;
    return _controller.isDismissed
        ? '${_controller.duration.inHours}:${(_controller.duration.inMinutes % 60).toString().padLeft(2, '0')}:${(_controller.duration.inSeconds % 60).toString().padLeft(2, '0')}'
        : '${count.inHours}:${(count.inMinutes % 60).toString().padLeft(2, '0')}:${(count.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  double progress = 1.0;

  void notify() {
    if (countText == '0:00:00') {

      FlutterRingtonePlayer.playNotification();


    }
  }

  int _selectedIndex = 2;
  int _coinBalance = 0;

  DateTime _startTime;
  DateTime _endTime;
  bool _isPlaying = false;
  double _progress = 1.0;


  Future<void> _loadCoinBalance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _coinBalance = prefs.getInt('coinBalance') ?? 0;
    });
  }

  Future<void> _saveCoinBalance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('coinBalance', _coinBalance);
  }


  Future<DateTime> _getOnlineTime() async {
    try {
      final response = await http.get(Uri.parse('http://worldtimeapi.org/api/timezone/Etc/UTC'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return DateTime.parse(data['utc_datetime']);
      } else {
        throw Exception('Failed to load time');
      }
    } catch (e) {
      print('Error fetching online time: $e');
      return DateTime.now();
    }
  }

  Future<void> _saveTimerState(DateTime startTime, DateTime endTime, bool isPlaying) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('startTime', startTime.toIso8601String());
    await prefs.setString('endTime', endTime.toIso8601String());
    await prefs.setBool('isPlaying', isPlaying);
  }

  Future<void> _loadTimerState() async {
    final prefs = await SharedPreferences.getInstance();
    final savedStartTimeString = prefs.getString('startTime');
    final savedEndTimeString = prefs.getString('endTime');
    final isPlaying = prefs.getBool('isPlaying') ?? false;

    if (savedStartTimeString != null && savedEndTimeString != null && isPlaying) {
      try {
        _startTime = DateTime.parse(savedStartTimeString);
        _endTime = DateTime.parse(savedEndTimeString);
        final currentTime = await _getOnlineTime();
        final totalDuration = _endTime.difference(_startTime).inSeconds;
        final remainingDuration = _endTime.difference(currentTime).inSeconds;

        if (remainingDuration > 0) {
          _startCountdown(remainingDuration, totalDuration);
        } else {
          _resetTimer();
        }
      } catch (e) {
        print('Error loading timer state: $e');
        _resetTimer();
      }
    }
  }

  void _startCountdown(int remainingSeconds, int totalSeconds) {
    setState(() {
      _isPlaying = true;
      _controller = AnimationController(
        vsync: this,
        duration: Duration(seconds: remainingSeconds),
      )..addListener(() {
        setState(() {
          _progress = _controller.value;
        });
      });
      _progress = remainingSeconds / totalSeconds;
      _controller?.forward().then((_) {
        _rewardUser();
        _resetTimer();
      });
    });
  }

  void _startTimer() async {
    _startTime = await _getOnlineTime();
    _endTime = _startTime.add(Duration(hours: 24));
    await _saveTimerState(_startTime, _endTime, true);
    _startCountdown(24 * 60 * 60, 24 * 60 * 60); // 24 hours in seconds
  }

  void _resetTimer() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('startTime');
    await prefs.remove('endTime');
    await prefs.remove('isPlaying');

    setState(() {
      _isPlaying = false;
      _progress = 1.0;
      _controller?.dispose();
      _controller = null;
    });
  }

  void _rewardUser() async {
    setState(() {
      _coinBalance += 50;
    });
    finishedCounter();
    await _saveCoinBalance();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _widgetOptions() {
    return <Widget>[
      Center(child: Text('Home Screen', style: TextStyle(fontSize: 24))),
      Center(child: Text('Activity Screen', style: TextStyle(fontSize: 24))),
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'رصيدك من النقاط',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '$_coinBalance',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 40),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: CircularProgressIndicator(
                    color:AppTheme.accentColor,
                    backgroundColor: Colors.grey.shade300,
                    value: _progress,
                    strokeWidth: 9,
                  ),
                ),
                AnimatedBuilder(
                  animation: _controller ?? AlwaysStoppedAnimation(0),
                  builder: (context, child) {
                    return Text(
                      _formatDuration(
                        _controller != null
                            ? _controller.duration * (1 - _controller.value)
                            : Duration(hours: 24),
                      ),
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: _isPlaying ? null : _startTimer,
              child: Container(
                  alignment: Alignment.center,
                  width: 60,
                  height: 35,
                  decoration: BoxDecoration(
                      color:  _isPlaying ? AppTheme.shadowDark.withOpacity(.2) : AppTheme.accentColor,borderRadius: BorderRadius.circular(12)
                  ),
                  child: Text(_isPlaying ? 'مفعل' : 'بدء', style: TextStyle(
                      color: AppTheme.white
                  ),)),
            ),
          ],
        ),
      ),

      Center(child: Text('Search Screen', style: TextStyle(fontSize: 24))),
      Center(child: Text('Profile Screen', style: TextStyle(fontSize: 24))),
    ];
  }


  @override
  void initState() {
    super.initState();
    _loadCoinBalance();
    _loadTimerState();
    getCounters();
    getAllSubscribesPoints();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(days: 1),
    );

    _controller.addListener(() {
      notify();
      if (_controller.isAnimating) {
        setState(() {
          progress = _controller.value;
        });

      } else {

        setState(() {
          progress = 1.0;
          isPlaying = false;
            done = !done;
        });

        finishedCounter();

      }
    });
    getUserInfo();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;

    return Container(
      height: MediaQuery.of(context).size.height,
      color: AppTheme.light_bg,
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * .1),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 0,),
                Column(
                  children: [
                    Text("رصيدك من النقاط", style: GoogleFonts.cairo(
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                    ),),
                    Text(_points.toString(),style: GoogleFonts.cairo(
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                    ),),
                  ],
                ),

                Column(
                  children: [
                    Text("رصيدك بالدولار", style: GoogleFonts.cairo(
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                    ),),
                    Text(_balance.toString(),style: GoogleFonts.cairo(
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                    ),),
                  ],
                ),
                SizedBox(width: 0,),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .03),

            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: CircularProgressIndicator(
                    color: AppTheme.accentColor,
                    backgroundColor: Colors.grey.shade300,
                    value: _progress,
                    strokeWidth: 9,
                  ),
                ),
                AnimatedBuilder(
                  animation: _controller ?? AlwaysStoppedAnimation(0),
                  builder: (context, child) {
                    return Text(
                      _formatDuration(
                        _controller != null
                            ? _controller.duration * (1 - _controller.value)
                            : Duration(hours: 24),
                      ),
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: _isPlaying ? null : _startTimer,
              child: Container(
                alignment: Alignment.center,
                width: 60,
                  height: 35,
                  decoration: BoxDecoration(
                    color: _isPlaying ? AppTheme.shadowDark.withOpacity(.2) : AppTheme.accentColor,borderRadius: BorderRadius.circular(12)
                  ),
                  child: Text(_isPlaying ? 'مفعل' : 'بدء', style: TextStyle(
                    color: AppTheme.white
                  ),)),
            ),

            //
            // Stack(
            //   alignment: Alignment.center,
            //   children: [
            //     SizedBox(
            //       width: 200,
            //       height: 200,
            //       child: CircularProgressIndicator(
            //         color: AppTheme.backgroundDark,
            //         backgroundColor: Colors.grey.shade300,
            //         value: progress,
            //         strokeWidth: 9,
            //       ),
            //     ),
            //     GestureDetector(
            //       onTap: () {
            //         if (controller.isDismissed) {
            //           showModalBottomSheet(
            //             context: context,
            //             builder: (context) => Container(
            //               height: 200,
            //               child: CupertinoTimerPicker(
            //                 initialTimerDuration: controller.duration,
            //                 onTimerDurationChanged: (time) {
            //                   setState(() {
            //                     controller.duration = time;
            //                   });
            //                 },
            //               ),
            //             ),
            //           );
            //         }
            //       },
            //       child: AnimatedBuilder(
            //         animation: controller,
            //         builder: (context, child) => Text(
            //           countText,
            //           style: TextStyle(
            //             fontSize: 30,
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Container(
            //         padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            //
            //         child: GestureDetector(
            //           onTap: () {
            //             // if (controller.isAnimating) {
            //             //   controller.stop();
            //             //   setState(() {
            //             //     isPlaying = false;
            //             //   });
            //             // } else {
            //               controller.reverse(
            //                   from: controller.value == 0 ? 1.0 : controller.value);
            //               setState(() {
            //                 isPlaying = true;
            //               });
            //             // }
            //           },
            //           child: Row(
            //             children: [
            //               isPlaying ? Container() : HexagonWidget.pointy(
            //                 width: 40,
            //                 color: AppTheme.accentColor,
            //                 elevation: 8,
            //                 child: Icon(
            //                   Icons.play_arrow,
            //                   size: 22,
            //                   color: AppTheme.white,
            //
            //                 ),
            //               ),
            //               SizedBox(width: 8,),
            //               isPlaying ? Container() : Text("بدء العداد", style: TextStyle(
            //                 color: AppTheme.background2
            //               ),),
            //
            //             ],
            //           ),
            //         ),
            //       ),
            //
            //     ],
            //   ),
            // ),
            // HexagonWidget.pointy(
            //   width: 120,
            //   color: Colors.red,
            //   elevation: 8,
            //   child: Text('A pointy tile'),
            // )

            SizedBox(
              height: 40,
            ),
            Center(
              child: Text(
                " مجموع نقاطك اليومية هو : "+_totalSubscribesPoints.toString()+ "  نقطة", style: TextStyle(
                color: AppTheme.backgroundDark,
                fontSize: 15
              ),
              ),
            ),
            _countersList.length == 0 && _isCountersInitial == true
                ? Center(
              child: CircularProgressIndicator(),
            )
                : _countersList.length == 0 && _isCountersInitial == false
                ? Center(
              child: Text("لا يوجد عدادات"),
            )
                : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: _countersList.length,
                  physics: new NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(
                          left: 10, right: 10, bottom: 18),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: AppTheme.white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                _countersList[index].name,
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(

                                    _countersList[index].duration,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.backgroundDark
                                        .withOpacity(.7)),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(

                                    _countersList[index]
                                        .price
                                        .toString() +
                                    " نقطة",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.backgroundDark
                                        .withOpacity(.7)),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(

                                    _countersList[index]
                                        .gift
                                        .toString() +
                                    " نقطة",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.backgroundDark
                                        .withOpacity(.7)),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor:
                                        AppTheme.light_bg,
                                        title: Text(
                                            'تأكيد الإشتراك في ' +
                                                _countersList[index]
                                                    .name),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: <Widget>[
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                  'تأكد جيداً من الشراء قبل الإشتراك'),
                                              SizedBox(
                                                height: 12,
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('إلغاء'),
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop();
                                            },
                                          ),
                                          TextButton(
                                            child: Container(
                                                padding: EdgeInsets
                                                    .symmetric(
                                                    vertical: 6,
                                                    horizontal: 16),
                                                decoration: BoxDecoration(
                                                    color: AppTheme
                                                        .accentColor,
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                        8)),
                                                child: Text(
                                                  'تأكيد',
                                                  style: TextStyle(
                                                      color: AppTheme
                                                          .white),
                                                )),
                                            onPressed: () {
                                              subscribe(
                                                  _countersList[index]
                                                      .id);
                                              Navigator.of(context)
                                                  .pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 80,
                                  height: 35,
                                  decoration: BoxDecoration(
                                      color: AppTheme.accentColor,
                                      borderRadius:
                                      BorderRadius.circular(8)),
                                  child: Text(
                                    "أشتراك",
                                    style: TextStyle(
                                        color: AppTheme.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    );
                  }, gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
                  childAspectRatio: 0.75
            )),
                )
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }
}
