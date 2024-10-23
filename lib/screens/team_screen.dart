import 'package:bab_algharb/theme.dart';
import 'package:flutter/material.dart';

import '../components/shared_value_helper.dart';
import '../repositories/users_repository.dart';
class TeamScreen extends StatefulWidget {
  const TeamScreen();

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {

  List _teamList = [];
  bool _isTeamInitial = true;

  getTeam() async {
    var teamResponse = await UserRepository().geTeam(user_id: user_id.$);
    _teamList.addAll(teamResponse.data);
    _isTeamInitial = false;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    getTeam();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.light_bg,
      appBar: AppBar(
        backgroundColor: AppTheme.accentColor,
        centerTitle: true,
        title: Text("الفريق"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: _teamList.length == 0 && _isTeamInitial == true ? Center(child: CircularProgressIndicator()) : _teamList.length == 0 && _isTeamInitial == false ?
        Center(
          child: Text("لا توجد بيانات"),
        ) : Column(
          children: [
            SizedBox(height: 10,),
            Text("عدد أعضاء الفريق : ${_teamList.length}"),
            Container(
              height: MediaQuery.of(context).size.height-115,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _teamList.length,
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
                          backgroundImage: NetworkImage(_teamList[index].photo),
                          radius: 35,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 15,),
                          Text(_teamList[index].name, style: TextStyle(
                              fontSize: 16
                          ),),
                          SizedBox(height: 5,),
                          Text(_teamList[index].username, style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.backgroundDark.withOpacity(.7)
                          ),)
                        ],
                      ),


                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
