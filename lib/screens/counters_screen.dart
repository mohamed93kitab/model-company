import 'package:bab_algharb/repositories/counter_repository.dart';
import 'package:flutter/material.dart';

import 'package:cherry_toast/cherry_toast.dart';
import '../components/shared_value_helper.dart';
import '../theme.dart';

class CounterScreen extends StatefulWidget {
  const CounterScreen();

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
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

  subscribe(counter_id) async {
    var counterResponse = await CounterRepository()
        .subscribe(counter_id: counter_id, user_id: user_id.$);
    if (counterResponse.success == true) {
      setState(() {
        CherryToast.success(
          disableToastAnimation: true,
          title: Text(
            'إشتراك',
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

  @override
  void initState() {
    // TODO: implement initState
    getCounters();
    super.initState();
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
                  height: MediaQuery.of(context).size.height * .23,
                  padding: EdgeInsets.only(top: 25),
                  decoration: BoxDecoration(
                      gradient: AppTheme.secondaryGradient,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                      )),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(15),
                            child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(
                                Icons.arrow_back_ios,
                                color: AppTheme.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(15),
                            child: Text(
                              "قائمة الوكلاء",
                              style: TextStyle(
                                  color: AppTheme.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
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
                              borderRadius: BorderRadius.circular(30)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "العدادات",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              height: MediaQuery.of(context).size.height - 150,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: _countersList.length == 0 && _isCountersInitial == true
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : _countersList.length == 0 && _isCountersInitial == false
                      ? Center(
                          child: Text("لا يوجد عدادات"),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: _countersList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              height: 210,
                              margin: EdgeInsets.only(
                                  left: 18, right: 18, bottom: 18),
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
                                        "الأسم : " + _countersList[index].name,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "المدة : " +
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
                                        "السعر : " +
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
                                        "يبدأ العداد من : " +
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
                                                          'تأكد جيداً من العداد قبل الإشتراك'),
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
                          }),
            )
          ],
        ),
      ),
    );
  }
}
