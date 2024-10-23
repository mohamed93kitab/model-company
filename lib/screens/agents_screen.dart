import 'package:bab_algharb/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import '../repositories/agent_repository.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class AgentScreen extends StatefulWidget {
  final state;
  const AgentScreen(this.state);

  @override
  State<AgentScreen> createState() => _AgentScreenState();
}

class _AgentScreenState extends State<AgentScreen> {
  var _agentsList = [];
  bool _isAgentsInitial = true;

  getAgents() async {
    var agentResponse =
        await AgentRepository().getLatestAgents(state:widget.state);
    if (agentResponse.status == true) {
      _agentsList.addAll(agentResponse.data);
      setState(() {
        _isAgentsInitial = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getAgents();
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
                                widget.state.toString(),
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
              child: _agentsList.length == 0 && _isAgentsInitial == true
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : _agentsList.length == 0 && _isAgentsInitial == false
                      ? Center(
                          child: Text("لا يوجد وكلاء"),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: _agentsList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              height: 235,
                              margin: EdgeInsets.only(
                                  left: 18, right: 18, bottom: 18),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  color: AppTheme.white),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          _agentsList[index].photo),
                                      radius: 35,
                                    ),
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
                                        _agentsList[index].name,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        _agentsList[index].governorate,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: AppTheme.backgroundDark
                                                .withOpacity(.7)),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        _agentsList[index].address,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: AppTheme.backgroundDark
                                                .withOpacity(.7)),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        _agentsList[index].phone_number,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: AppTheme.backgroundDark
                                                .withOpacity(.7)),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        _agentsList[index].code,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: AppTheme.backgroundDark
                                                .withOpacity(.7)),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          if (_agentsList[index].phone_number !=
                                              null) {
                                            launchWhatsApp(_agentsList[index]
                                                .phone_number);
                                          }
                                          print(
                                              "=============================" +
                                                  _agentsList[index]
                                                      .phone_number);
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
                                            "مراسلة",
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

  launchWhatsApp(String phone) async {
    final link = WhatsAppUnilink(
      phoneNumber: '${'+964' + phone}',
      text: "",
    );
    await launch('$link');
  }
}
