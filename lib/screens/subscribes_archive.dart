import 'package:bab_algharb/repositories/counter_repository.dart';
import 'package:bab_algharb/theme.dart';
import 'package:flutter/material.dart';

import '../components/shared_value_helper.dart';
class SubArchive extends StatefulWidget {
  const SubArchive();

  @override
  State<SubArchive> createState() => _SubArchiveState();
}

class _SubArchiveState extends State<SubArchive> {

  var _allUserSubscribesList = [];
  bool _isUserSubscribesInitial = true;

  getSubscribes() async {
    var subscribesResponse = await CounterRepository().getMySubscribes();
    _allUserSubscribesList.addAll(subscribesResponse.data);
    setState(() {
      _isUserSubscribesInitial = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getSubscribes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.light_bg,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppTheme.accentColor,
        title: Text("سجل إشتراكاتي"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: _allUserSubscribesList.length == 0 && _isUserSubscribesInitial == false ?
        Center(
          child: Text("لا توجد أي إشتراكات!"),
        ) : _allUserSubscribesList.length != 0 && _isUserSubscribesInitial == false ?  ListView.builder(
            itemCount: _allUserSubscribesList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Container(
                height: 130,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(bottom: 16),
                padding: EdgeInsets.only(right: 16, left: 16),
                decoration: BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: BorderRadius.circular(12)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("الإشتراك : "),
                            Text(_allUserSubscribesList[index].name),
                          ],
                        ),
                        Row(
                          children: [
                            Text("السعر : "),
                            Text(_allUserSubscribesList[index].price.toString() + " " + "نقطة"),
                          ],
                        ),
                        Row(
                          children: [
                            Text("المكافئة : "),
                            Text(_allUserSubscribesList[index].gift.toString() + " " + "نقطة"),
                          ],
                        ),
                      ],
                    ),
                    VerticalDivider(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("تاريخ الإشتراك : "),
                            Text(_allUserSubscribesList[index].created_at),
                          ],
                        ),

                        Row(
                          children: [
                            Text("تاريخ الإنتهاء : "),
                            Text(_allUserSubscribesList[index].expired_at),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }) : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
