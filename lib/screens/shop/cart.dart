import 'package:bab_algharb/theme.dart';
import 'package:flutter/material.dart';

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({Key key}) : super(key: key);

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController _mainScrollController = ScrollController();

int  _quantity = 1;


  Future<void> _onRefresh() async {
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.light_bg,
      appBar: AppBar(
        backgroundColor: AppTheme.accentColor,
        title: Text("سلة التسوق"),
      ),

      body: Stack(
            children: [
              RefreshIndicator(
                color: AppTheme.accentColor,
                backgroundColor: Colors.white,
                onRefresh: _onRefresh,
                displacement: 0,
                child: CustomScrollView(
                  controller: _mainScrollController,
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  slivers: [
                     SliverList(
                      delegate: SliverChildListDelegate([
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: buildCartSellerList(),
                        ),
                      
                      ]),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate([
                       
                        Container(
                          height: 100,
                        )
                      ]),
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: buildBottomContainer(),
              )
            ],
          ),
    );
  }

   Container buildBottomContainer() {

    return Container(
      margin: EdgeInsets.only(bottom: 40, right: 18, left: 18),
      decoration: BoxDecoration(
        color: AppTheme.accentColor,
        borderRadius: BorderRadius.circular(18)
        /*border: Border(
                  top: BorderSide(color: MyTheme.light_grey,width: 1.0),
                )*/
      ),

      height: 200,
      //color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 15.0, right: 20, left: 20),
              child: Row(
                children: [
                  Text(
                    "المجموع الكلي",
                    style:
                        TextStyle(color: AppTheme.white, fontSize: 13,fontWeight: FontWeight.w700),
                  ),
                  Spacer(),
                  Text("50,000",
                      style: TextStyle(
                          color: AppTheme.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Padding(
                //   padding: const EdgeInsets.only(top: 8.0),
                //   child: Container(
                //     width: (MediaQuery.of(context).size.width / 3),
                //     height: 58,
                //     decoration: BoxDecoration(
                //         color: MyTheme.white.withOpacity(.5),
                //         borderRadius: BorderRadius.circular(18)
                //         // border:
                //         //     Border.all(color: MyTheme.accent_color, width: 1),
                //         // borderRadius: app_language_rtl.$
                //         //     ? const BorderRadius.only(
                //         //         topLeft: const Radius.circular(0.0),
                //         //         bottomLeft: const Radius.circular(0.0),
                //         //         topRight: const Radius.circular(6.0),
                //         //         bottomRight: const Radius.circular(6.0),
                //         //       )
                //         //     : const BorderRadius.only(
                //         //         topLeft: const Radius.circular(6.0),
                //         //         bottomLeft: const Radius.circular(6.0),
                //         //         topRight: const Radius.circular(0.0),
                //         //         bottomRight: const Radius.circular(0.0),
                //         //       )
                //     ),
                //     child: TextButton(
                //       // minWidth: MediaQuery.of(context).size.width,
                //       // //height: 50,
                //       // color: MyTheme.soft_accent_color,
                //       // shape: app_language_rtl.$
                //       //     ? RoundedRectangleBorder(
                //       //         borderRadius: const BorderRadius.only(
                //       //         topLeft: const Radius.circular(0.0),
                //       //         bottomLeft: const Radius.circular(0.0),
                //       //         topRight: const Radius.circular(6.0),
                //       //         bottomRight: const Radius.circular(6.0),
                //       //       ))
                //       //     : RoundedRectangleBorder(
                //       //         borderRadius: const BorderRadius.only(
                //       //         topLeft: const Radius.circular(6.0),
                //       //         bottomLeft: const Radius.circular(6.0),
                //       //         topRight: const Radius.circular(0.0),
                //       //         bottomRight: const Radius.circular(0.0),
                //       //       )),
                //       child: Text(
                //         AppLocalizations.of(context).cart_screen_update_cart,
                //         style: TextStyle(
                //             color: MyTheme.accent_color,
                //             fontSize: 15,
                //             fontWeight: FontWeight.w700),
                //       ),
                //       onPressed: () {
                //         onPressUpdate();
                //       },
                //     ),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    height: 58,
                    width: (MediaQuery.of(context).size.width / 2.3),
                    decoration: BoxDecoration(
                        color: AppTheme.white,
                        border:
                            Border.all(color: AppTheme.accentColor, width: 1),
                        borderRadius: BorderRadius.circular(18)
                        // borderRadius: app_language_rtl.$
                        //     ? const BorderRadius.only(
                        //         topLeft: const Radius.circular(6.0),
                        //         bottomLeft: const Radius.circular(6.0),
                        //         topRight: const Radius.circular(0.0),
                        //         bottomRight: const Radius.circular(0.0),
                        //       )
                        //     : const BorderRadius.only(
                        //         topLeft: const Radius.circular(0.0),
                        //         bottomLeft: const Radius.circular(0.0),
                        //         topRight: const Radius.circular(6.0),
                        //         bottomRight: const Radius.circular(6.0),
                        //       )
                    ),
                    child: TextButton(
                      // minWidth: MediaQuery.of(context).size.width,
                      // //height: 50,
                      // color: MyTheme.accent_color,
                      // shape: app_language_rtl.$
                      //     ? RoundedRectangleBorder(
                      //         borderRadius: const BorderRadius.only(
                      //         topLeft: const Radius.circular(6.0),
                      //         bottomLeft: const Radius.circular(6.0),
                      //         topRight: const Radius.circular(0.0),
                      //         bottomRight: const Radius.circular(0.0),
                      //       ))
                      //     : RoundedRectangleBorder(
                      //         borderRadius: const BorderRadius.only(
                      //         topLeft: const Radius.circular(0.0),
                      //         bottomLeft: const Radius.circular(0.0),
                      //         topRight: const Radius.circular(6.0),
                      //         bottomRight: const Radius.circular(6.0),
                      //       )),
                      child: Text(
                        "إرسال الطلب",
                        style: TextStyle(
                            color: AppTheme.accentColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w700),
                      ),
                      onPressed: () {

                      },
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }


    buildCartSellerList() {
    
      
      return SingleChildScrollView(
        child: ListView.separated(
          separatorBuilder: (context, index) => SizedBox(
            height: 26,
          ),
          itemCount: 1,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    children: [
                      Text(
                        "السعر الكلي",
                        style: TextStyle(
                            color: AppTheme.background2.withOpacity(.7),
                            fontWeight: FontWeight.w700,
                            fontSize: 12),
                      ),
                      Spacer(),
                      Text(
                        "50,000",
                        style: TextStyle(
                            color: AppTheme.accentColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 12),
                      ),
                    ],
                  ),
                ),
                buildCartSellerItemList(index),
              ],
            );
          },
        ),
      );
    
  }

    SingleChildScrollView buildCartSellerItemList(seller_index) {
    return SingleChildScrollView(
      child: ListView.separated(
        separatorBuilder: (context, index) => SizedBox(
          height: 14,
        ),
        itemCount: 1,
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
            return Column(
              children: [
                buildCartSellerItemCard(seller_index, index),
                SizedBox(height: 140,)
              ],
            );
          
        },
      ),
    );
  }

  buildCartSellerItemCard(seller_index, item_index) {

    return Container(
      height: 120,
      decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(18),
      color: AppTheme.white,
      boxShadow: [
        // BoxShadow(
        //   color: Colors.black.withOpacity(.08),
        //   blurRadius: 20,
        //   spreadRadius: 0.0,
        //   offset: Offset(0.0, 10.0), // shadow direction: bottom right
        // )
      ],
    ),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
                width: 120,
                height: 120,
                padding: EdgeInsets.all(8),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.asset(
                      "dummy_assets/pi1.jpg",
                      fit: BoxFit.cover,
                    ))),
            Container(
              //color: Colors.red,
              width: MediaQuery.of(context).size.width - 160,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 18.0),
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * .46,
                            child: Text(
                              "Iphone 14 Pro Max",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                height: 1.18,
                                  color: AppTheme.backgroundDark.withOpacity(.7),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Spacer(),
                          Container(
                            width: 32,
                            child: GestureDetector(
                                  onTap: () {
                                    
                                  },
                                  child: Container(
                                    child: Image.asset(
                                      'assets/trash.png',
                                      height: 16,
                                      color: Colors.red,
                                    ),
                                  ),
                                )
                          ),

                        ],
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _quantity = _quantity+1;
                                });
                              },
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration:BoxDecoration(
                                      borderRadius: BorderRadius.circular(16.0),
                                      color:  Color.fromRGBO(229,241,248, 1),

                                    ),                                
                                    child: Icon(
                                  Icons.add,
                                  color: AppTheme.accentColor,
                                  size: 12,
                                ),
                              ),
                            ),
                            SizedBox(width: 18,),
                            Text(
                              _quantity.toString(),
                              style:
                              TextStyle(color: AppTheme.accentColor, fontSize: 16),
                            ),
                            SizedBox(width: 18,),
                            GestureDetector(
                              onTap: () {
                                  if(_quantity > 1) {
                                  setState(() {
                                    _quantity = _quantity-1;
                                   });

                                  }
                                  
                              },
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration:
                                BoxDecoration(
                                      borderRadius: BorderRadius.circular(16.0),
                                      color:  Color.fromRGBO(229,241,248, 1),

                                    ),
                                child: Icon(
                                  Icons.remove,
                                  color: AppTheme.accentColor,
                                  size: 12,
                                ),
                              ),
                            ),
                          ],
                        ),

                        Spacer(),

                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                             "50,000",
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                color: AppTheme.accentColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ]),
    );
  }
}