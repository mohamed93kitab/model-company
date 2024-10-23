
import 'package:dropdown_button2/dropdown_button2.dart';
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
import '../repositories/users_repository.dart';
class PaymentScreen extends StatefulWidget {
  const PaymentScreen();

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {

  final amountFieldController = TextEditingController();
  final numberFieldController = TextEditingController();
  final cardNameFieldController = TextEditingController();
  final expireFieldController = TextEditingController();

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
  List _paymentsList = [];
  bool _isPaymentsInitial = true;
  var paymentMethod;


  final List<String> items = [
    'ماستر كارد',
    // 'فاست باي',
    'مصرف العراق الأول (FIB)',
  ];
  String selectedValue;

  getPaymentsRequests() async {
    var paymentsResponse = await AuthRepository().getPaymentRequest();
    _paymentsList.addAll(paymentsResponse.data);
    _isPaymentsInitial = false;
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
  //
  sendRequest() async {
    var sendPaymentResponse = await AuthRepository().sendPaymentRequest(paymentMethod: paymentMethod, amount: amountFieldController.text, number: numberFieldController.text, card_name: cardNameFieldController.text, expire: expireFieldController.text);

    setState(() {});
    if(sendPaymentResponse.success == true) {
      CherryToast.success(
        disableToastAnimation: true,
        title: Text(
          'سجل السحب',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        action: Text(sendPaymentResponse.message),
        inheritThemeColors: true,
        actionHandler: () {},
        onToastClosed: () {},
      ).show(context);
      setState(() {
        paymentMethod = null;
        amountFieldController.clear();
        numberFieldController.clear();
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
    getPaymentsRequests();
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
                  height: MediaQuery.of(context).size.height * .25,
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
                            child: Text("طلبات سحب الأرباح", style: TextStyle(
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

                              Text(_points.toString(), style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold
                              ),)

                            ],
                          ),
                        ),
                      )


                    ],
                  ),
                ),
              ],
            ),
            Container(
              height: MediaQuery.of(context).size.height * .7,
              child: _paymentsList.length == 0 && _isPaymentsInitial == false ?
              Center(
                child: Text("لا يوجد سجل سحب"),
              ) : _paymentsList.length == 0 && _isPaymentsInitial == true ?
              Center(
                child: CircularProgressIndicator(),
              ) : ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: _paymentsList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: 120,
                      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: AppTheme.white
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                         Container(
                            margin: EdgeInsets.symmetric(vertical: 22),
                            padding: EdgeInsets.all(8),
                            width: 50,
                            child: Image.asset("assets/images/payment.png"),
                            decoration: BoxDecoration(
                              color: AppTheme.light_bg,
                              borderRadius: BorderRadius.circular(80)
                            ),
                         ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 15,),
                              Row(
                                children: [
                                  Text("وسيلة الدفع :", style: TextStyle(
                                    fontSize: 14
                                  ),),
                                  Text(_paymentsList[index].payment_method == null ? "" : _paymentsList[index].payment_method, style: TextStyle(
                                      fontSize: 13,
                                    color: AppTheme.backgroundDark.withOpacity(.7)
                                  ),),
                                ],
                              ),
                              SizedBox(height: 5,),
                              _paymentsList[index].amount == null ?
                              Container() :
                              Row(
                                children: [
                                  Text(
                                    "النقاط : ", style: TextStyle(
                                      fontSize: 14,
                                  ),),
                                  Text(
                                    _paymentsList[index].amount.toString(), style: TextStyle(
                                      fontSize: 13,
                                      color: AppTheme.backgroundDark.withOpacity(.7)
                                  ),)
                                ],
                              ),

                              SizedBox(height: 5,),

                              _paymentsList[index].created_at == null ?
                              Container() :
                              Row(
                                children: [
                                  Text(
                                    "التاريخ : ", style: TextStyle(
                                    fontSize: 14,
                                  ),),
                                  Text(
                                    _paymentsList[index].created_at.toString(), style: TextStyle(
                                      fontSize: 13,
                                      color: AppTheme.backgroundDark.withOpacity(.7)
                                  ),)
                                ],
                              )

                            ],
                          ),

                          Row(
                            children: [
                             Container(
                               padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                               decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(5),
                                 color: _paymentsList[index].status == 1 ? AppTheme.accentColor : AppTheme.danger
                               ),
                               child: Text(_paymentsList[index].status == 1 ? "مكتملة" : "قيد المراجعة", style: TextStyle(
                                 color: AppTheme.white,
                                 fontWeight: FontWeight.bold
                               ),),
                             )
                            ],
                          )


                        ],
                      ),
                    );
                  }),
            )

          ],
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () {
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
                              Text('النقاط'),
                              SizedBox(height: 12,),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 3, horizontal: 12),
                                color: Colors.white,
                                child: TextFormField(
                                  controller: amountFieldController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    counterText: "",
                                    hintText: "ضع عدد النقاط"
                                  ),
                                    maxLength: 8,

                                ),
                              ),
                              SizedBox(height: 10,),
                              DropdownButtonHideUnderline(
                                child: DropdownButton2<String>(
                                  isExpanded: true,
                                  hint: Row(
                                    children: [
                                      Icon(
                                        Icons.list,
                                        size: 16,
                                        color:AppTheme.backgroundDark
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Expanded(
                                        child: Text(
                                          selectedValue == null ? 'أختر وسيلة الدفع' : selectedValue.toString(),
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: AppTheme.backgroundDark,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  items: items
                                      .map((String item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.backgroundDark,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ))
                                      .toList(),
                                  value: selectedValue,
                                  onChanged: (String value) {
                                    setState(() {
                                      selectedValue = value;
                                    });
                                    setState(() {
                                      paymentMethod = selectedValue;
                                    });
                                  },
                                  buttonStyleData: ButtonStyleData(
                                    height: 50,
                                    width: 160,
                                    padding: const EdgeInsets.only(left: 14, right: 14),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2),
                                      border: Border.all(
                                        color: Colors.black26,
                                      ),
                                      color: AppTheme.white,
                                    ),
                                    elevation: 2,
                                  ),
                                  iconStyleData: const IconStyleData(
                                    icon: Icon(
                                      Icons.arrow_forward_ios_outlined,
                                    ),
                                    iconSize: 14,
                                    iconEnabledColor: AppTheme.backgroundDark,
                                    iconDisabledColor: Colors.grey,
                                  ),
                                  dropdownStyleData: DropdownStyleData(
                                    maxHeight: 200,
                                    width: 230,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2),
                                      color: AppTheme.white,
                                    ),
                                    offset: const Offset(0, 0),
                                    scrollbarTheme: ScrollbarThemeData(
                                      radius: const Radius.circular(40),
                                      thickness: MaterialStateProperty.all<double>(6),
                                      thumbVisibility: MaterialStateProperty.all<bool>(true),
                                    ),
                                  ),
                                  menuItemStyleData: const MenuItemStyleData(
                                    height: 40,
                                    padding: EdgeInsets.only(left: 14, right: 14),
                                  ),
                                ),
                              ),
                              paymentMethod == "ماستر كارد" ? Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 SizedBox(height: 10,),
                                 Text('أسم البطاقة'),
                                 SizedBox(height: 12,),
                                 Container(
                                   padding: EdgeInsets.symmetric(vertical: 3, horizontal: 12),
                                   color: Colors.white,
                                   child: TextFormField(
                                     controller:  cardNameFieldController,
                                     maxLength: 16,
                                     decoration: InputDecoration(
                                         border: InputBorder.none,
                                         hintText: "ضع أسم البطاقة"  ,
                                         counterText: ""
                                     ),
                                   ),
                                 ),
                                 SizedBox(height: 10,),
                                 Text('رقم البطاقة (القصير)'),
                                 SizedBox(height: 12,),
                                 Container(
                                   padding: EdgeInsets.symmetric(vertical: 3, horizontal: 12),
                                   color: Colors.white,
                                   child: TextFormField(
                                     controller:  expireFieldController,
                                     maxLength: 16,
                                     decoration: InputDecoration(
                                         border: InputBorder.none,
                                         hintText: "ex : 0824"  ,
                                         counterText: ""
                                     ),
                                   ),
                                 ),
                               ],
                             ) : Container(),
                              SizedBox(height: 10,),
                              Text('رقم البطاقة (الطويل)'),
                              SizedBox(height: 12,),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 3, horizontal: 12),
                                color: Colors.white,
                                child: TextFormField(
                                  controller: numberFieldController,
                                  maxLength: 16,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                      hintText: paymentMethod == "فاست باي" || paymentMethod == "مصرف العراق الأول (FIB)" ? "ضع رقم المحفظة" : "ضع رقم البطاقة",
                                    counterText: ""
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                  },
                ),
                backgroundColor: AppTheme.light_bg,
                title: Text('إستلام الأرباح '),
                // content: SingleChildScrollView(
                //   child: ListBody(
                //     children: <Widget>[
                //       SizedBox(height: 5,),
                //       Text('النقاط'),
                //       SizedBox(height: 12,),
                //       Container(
                //         padding: EdgeInsets.symmetric(vertical: 3, horizontal: 12),
                //         color: Colors.white,
                //         child: TextFormField(
                //           controller: amountFieldController,
                //           decoration: InputDecoration(
                //             border: InputBorder.none,
                //           ),
                //         ),
                //       ),
                //       SizedBox(height: 10,),
                //       DropdownButtonHideUnderline(
                //         child: DropdownButton2<String>(
                //           isExpanded: true,
                //           hint: Row(
                //             children: [
                //               Icon(
                //                 Icons.list,
                //                 size: 16,
                //                 color:AppTheme.backgroundDark
                //               ),
                //               SizedBox(
                //                 width: 4,
                //               ),
                //               Expanded(
                //                 child: Text(
                //                   selectedValue == null ? 'أختر وسيلة الدفع' : selectedValue.toString(),
                //                   style: TextStyle(
                //                     fontSize: 14,
                //                     fontWeight: FontWeight.bold,
                //                     color: AppTheme.backgroundDark,
                //                   ),
                //                   overflow: TextOverflow.ellipsis,
                //                 ),
                //               ),
                //             ],
                //           ),
                //           items: items
                //               .map((String item) => DropdownMenuItem<String>(
                //             value: item,
                //             child: Text(
                //               item,
                //               style: const TextStyle(
                //                 fontSize: 14,
                //                 fontWeight: FontWeight.bold,
                //                 color: AppTheme.backgroundDark,
                //               ),
                //               overflow: TextOverflow.ellipsis,
                //             ),
                //           ))
                //               .toList(),
                //           value: selectedValue,
                //           onChanged: (String value) {
                //             setState(() {
                //               selectedValue = value;
                //             });
                //             setState(() {
                //               paymentMethod = selectedValue;
                //             });
                //           },
                //           buttonStyleData: ButtonStyleData(
                //             height: 50,
                //             width: 160,
                //             padding: const EdgeInsets.only(left: 14, right: 14),
                //             decoration: BoxDecoration(
                //               borderRadius: BorderRadius.circular(2),
                //               border: Border.all(
                //                 color: Colors.black26,
                //               ),
                //               color: AppTheme.white,
                //             ),
                //             elevation: 2,
                //           ),
                //           iconStyleData: const IconStyleData(
                //             icon: Icon(
                //               Icons.arrow_forward_ios_outlined,
                //             ),
                //             iconSize: 14,
                //             iconEnabledColor: AppTheme.backgroundDark,
                //             iconDisabledColor: Colors.grey,
                //           ),
                //           dropdownStyleData: DropdownStyleData(
                //             maxHeight: 200,
                //             width: 230,
                //             decoration: BoxDecoration(
                //               borderRadius: BorderRadius.circular(2),
                //               color: AppTheme.white,
                //             ),
                //             offset: const Offset(0, 0),
                //             scrollbarTheme: ScrollbarThemeData(
                //               radius: const Radius.circular(40),
                //               thickness: MaterialStateProperty.all<double>(6),
                //               thumbVisibility: MaterialStateProperty.all<bool>(true),
                //             ),
                //           ),
                //           menuItemStyleData: const MenuItemStyleData(
                //             height: 40,
                //             padding: EdgeInsets.only(left: 14, right: 14),
                //           ),
                //         ),
                //       ),
                //       SizedBox(height: 10,),
                //       Text('الرقم'),
                //       SizedBox(height: 12,),
                //       Container(
                //         padding: EdgeInsets.symmetric(vertical: 3, horizontal: 12),
                //         color: Colors.white,
                //         child: TextFormField(
                //           controller: numberFieldController,
                //           decoration: InputDecoration(
                //             border: InputBorder.none,
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
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
                      sendRequest();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 26, horizontal: 23),
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppTheme.accentColor
          ),
          child: Text("طلب سحب", style: TextStyle(
            color: AppTheme.white,
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),),
        ),
      ),
    );
  }

}
