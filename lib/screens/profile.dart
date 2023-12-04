import 'dart:async';

import 'package:model_company/custom/box_decorations.dart';
import 'package:model_company/custom/device_info.dart';
import 'package:model_company/custom/lang_text.dart';
import 'package:model_company/helpers/auth_helper.dart';
import 'package:model_company/screens/auction_products.dart';
import 'package:model_company/screens/change_language.dart';
import 'package:model_company/screens/digital_products.dart';
import 'package:model_company/screens/filter.dart';
import 'package:model_company/screens/main.dart';
import 'package:model_company/screens/messenger_list.dart';
import 'package:model_company/screens/whole_sale_products.dart';
import 'package:model_company/screens/wishlist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:model_company/my_theme.dart';
import 'package:model_company/ui_sections/drawer.dart';
import 'package:model_company/helpers/shared_value_helper.dart';
import 'package:model_company/app_config.dart';
import 'package:model_company/screens/wallet.dart';
import 'package:model_company/screens/profile_edit.dart';
import 'package:model_company/screens/address.dart';
import 'package:model_company/screens/order_list.dart';
import 'package:model_company/screens/club_point.dart';
import 'package:model_company/screens/refund_request.dart';
import 'package:model_company/repositories/profile_repository.dart';
import 'package:model_company/custom/toast_component.dart';
import 'package:toast/toast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../ui_elements/custom_dialog.dart';

class Profile extends StatefulWidget {
  Profile({Key key, this.show_back_button = false}) : super(key: key);

  bool show_back_button;

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  ScrollController _mainScrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isDialogShowing = false;
  int _cartCounter = 0;
  String _cartCounterString = "...";
  int _wishlistCounter = 0;
  String _wishlistCounterString = "...";
  int _orderCounter = 0;
  String _orderCounterString = "...";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (is_logged_in.$ == true) {
      fetchAll();
    }
  }

  void dispose() {
    _mainScrollController.dispose();
    super.dispose();
  }

  Future<void> _onPageRefresh() async {
    reset();
    fetchAll();
  }

  onPopped(value) async {
    reset();
    fetchAll();
  }

  fetchAll() {
    fetchCounters();
  }

  fetchCounters() async {
    var profileCountersResponse =
        await ProfileRepository().getProfileCountersResponse();

    _cartCounter = profileCountersResponse.cart_item_count;
    _wishlistCounter = profileCountersResponse.wishlist_item_count;
    _orderCounter = profileCountersResponse.order_count;

    _cartCounterString =
        counterText(_cartCounter.toString(), default_length: 2);
    _wishlistCounterString =
        counterText(_wishlistCounter.toString(), default_length: 2);
    _orderCounterString =
        counterText(_orderCounter.toString(), default_length: 2);

    setState(() {});
  }

  String counterText(String txt, {default_length = 3}) {
    var blank_zeros = default_length == 3 ? "000" : "00";
    var leading_zeros = "";
    if (txt != null) {
      if (default_length == 3 && txt.length == 1) {
        leading_zeros = "00";
      } else if (default_length == 3 && txt.length == 2) {
        leading_zeros = "0";
      } else if (default_length == 2 && txt.length == 1) {
        leading_zeros = "0";
      }
    }

    var newtxt = (txt == null || txt == "" || txt == null.toString())
        ? blank_zeros
        : txt;

    // print(txt + " " + default_length.toString());
    // print(newtxt);

    if (default_length > txt.length) {
      newtxt = leading_zeros + newtxt;
    }
    //print(newtxt);

    return newtxt;
  }

  reset() {
    _cartCounter = 0;
    _cartCounterString = "...";
    _wishlistCounter = 0;
    _wishlistCounterString = "...";
    _orderCounter = 0;
    _orderCounterString = "...";
    setState(() {});
  }

  onTapLogout(context) async {
    AuthHelper().clearUserData();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
      return Main();
    }), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if(_isDialogShowing) {
          Navigator.of(context, rootNavigator: true).pop();
        }else {
          Navigator.pop(context);
        }
      },
      child: Directionality(
        textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
          key: _scaffoldKey,
          //drawer: MainDrawer(),
          backgroundColor: Colors.white,
          //appBar: buildAppBar(context),
          body: buildBody(context),
        ),
      ),
    );
  }

  Widget buildBody(context) {
    return Container(
      height: DeviceInfo(context).height,
      child: Stack(
        children: [
          Container(
              height: DeviceInfo(context).height / 1.6,
              width: DeviceInfo(context).width,
              color: MyTheme.accent_color,
              alignment: Alignment.topRight,
              child: Image.asset(
                "assets/background_1.png",
              )),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: PreferredSize(
              preferredSize: Size(DeviceInfo(context).width, 100),
              child: SafeArea(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        margin: EdgeInsets.only(right: 18),
                        height: 30,
                        child: InkWell(
                            onTap: (){
                              Navigator.pop(context);
                            }, child: Icon(Icons.close,color: MyTheme.white,size: 20,)),),
                    ),

                    // Container(
                    //   margin: EdgeInsets.symmetric(vertical: 8),
                    //   width: DeviceInfo(context).width,height: 1,color: MyTheme.medium_grey_50,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: buildTopSection(),
                    ),
                  ],
                ),
              ),
            ),
            body: RefreshIndicator(
              color: MyTheme.accent_color,
              backgroundColor: Colors.red,
              onRefresh: _onPageRefresh,
              displacement: 10,
              child: CustomScrollView(
                controller: _mainScrollController,
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate([

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: buildCountersRow(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: buildHorizontalSettings(),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      //   child: buildSettingAndAddonsVerticalMenu(),
                      // ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: buildSettingAndAddonsHorizontalMenu(),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      //   child: buildBottomVerticalCardList(),
                      // ),

                      InkWell(
                        onTap: () {
                          setState(() {
                            _isDialogShowing = true;
                          });
                          showDialog(context: context,
                              builder: (BuildContext context){
                                return CustomDialogBox(
                                  title: "هل أنت متأكد من حذف حسابك؟",
                                );
                              }
                          ).then((_) {
                            setState(() {
                              _isDialogShowing = false;
                            });
                          });

                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          decoration: BoxDecoration(
                              color: MyTheme.danger,
                              borderRadius: BorderRadius.circular(12)
                          ),
                          child: Text(
                            AppLocalizations.of(context).product_details_screen_delete_account,
                            style: TextStyle(
                                color: MyTheme.white
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 25,),
                    ]),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBottomVerticalCardList() {
    return Container(
      margin: EdgeInsets.only(bottom: 120, top: 14),
      padding: EdgeInsets.symmetric(horizontal: 22, vertical: 20),
      decoration: BoxDecorations.buildBoxDecoration_1(),
      child: Column(
        children: [
          Container(
            height: 40,
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                  splashFactory: NoSplash.splashFactory,
                  alignment: Alignment.center,
                  padding: EdgeInsets.zero),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 24.0),
                    child: Image.asset(
                      "assets/coupon.png",
                      height: 16,
                      width: 16,
                    ),
                  ),
                  Text(
                    LangText(context).local.profile_screen_coupons,
                    style:
                        TextStyle(fontSize: 12, color: MyTheme.dark_font_grey),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            thickness: 1,
            color: MyTheme.light_grey,
          ),
          Container(
            height: 40,
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                  splashFactory: NoSplash.splashFactory,
                  alignment: Alignment.center,
                  padding: EdgeInsets.zero),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 24.0),
                    child: Image.asset(
                      "assets/favoriteseller.png",
                      height: 16,
                      width: 16,
                    ),
                  ),
                  Text(
                    LangText(context).local.profile_screen_favorite_seller,
                    style:
                        TextStyle(fontSize: 12, color: MyTheme.dark_font_grey),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            thickness: 1,
            color: MyTheme.light_grey,
          ),
          Container(
            height: 40,
            child: TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                      return DigitalProducts(

                      );
                    }));
              },
              style: TextButton.styleFrom(
                  splashFactory: NoSplash.splashFactory,
                  alignment: Alignment.center,
                  padding: EdgeInsets.zero),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 24.0),
                    child: Image.asset(
                      "assets/download.png",
                      height: 16,
                      width: 16,
                    ),
                  ),
                  Text(
                    LangText(context).local.profile_screen_all_digital_products,
                    style:
                        TextStyle(fontSize: 12, color: MyTheme.dark_font_grey),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            thickness: 1,
            color: MyTheme.light_grey,
          ),
          Container(
            height: 40,
            child: TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                      return AuctionProducts(
                      );
                    }));
              },
              style: TextButton.styleFrom(
                  splashFactory: NoSplash.splashFactory,
                  alignment: Alignment.center,
                  padding: EdgeInsets.zero),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 24.0),
                    child: Image.asset(
                      "assets/auction.png",
                      height: 16,
                      width: 16,
                    ),
                  ),
                  Text(
                    LangText(context).local.profile_screen_on_auction_products,
                    style:
                        TextStyle(fontSize: 12, color: MyTheme.dark_font_grey),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            thickness: 1,
            color: MyTheme.light_grey,
          ),
          Container(
            height: 40,
            child: TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                      return WholeSaleProducts(

                      );
                    }));
              },
              style: TextButton.styleFrom(
                  splashFactory: NoSplash.splashFactory,
                  alignment: Alignment.center,
                  padding: EdgeInsets.zero),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 24.0),
                    child: Image.asset(
                      "assets/wholesale.png",
                      height: 16,
                      width: 16,
                    ),
                  ),
                  Text(
                    LangText(context).local.profile_screen_wholesale_products,
                    style:
                        TextStyle(fontSize: 12, color: MyTheme.dark_font_grey),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            thickness: 1,
            color: MyTheme.light_grey,
          ),
          Container(
            height: 40,
            child: TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                      return Filter(
                        selected_filter: "sellers",
                      );
                    }));
              },
              style: TextButton.styleFrom(
                  splashFactory: NoSplash.splashFactory,
                  alignment: Alignment.center,
                  padding: EdgeInsets.zero),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 24.0),
                    child: Image.asset(
                      "assets/shop.png",
                      height: 16,
                      width: 16,
                    ),
                  ),
                  Text(
                    LangText(context).local.profile_screen_browse_all_sellers,
                    style:
                        TextStyle(fontSize: 12, color: MyTheme.dark_font_grey),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            thickness: 1,
            color: MyTheme.light_grey,
          ),
          Container(
            height: 40,
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                  splashFactory: NoSplash.splashFactory,
                  alignment: Alignment.center,
                  padding: EdgeInsets.zero),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 24.0),
                    child: Image.asset(
                      "assets/blog.png",
                      height: 16,
                      width: 16,
                    ),
                  ),
                  Text(
                    LangText(context).local.profile_screen_blogs,
                    style:
                        TextStyle(fontSize: 12, color: MyTheme.dark_font_grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHorizontalSettings() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return ChangeLanguage();
                  },
                ),
              );
            },
            child: Column(
              children: [
                Image.asset(
                  "assets/language.png",
                  height: 16,
                  width: 16,
                  color: MyTheme.white,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  AppLocalizations.of(context).profile_screen_language,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 10,
                      color: MyTheme.white,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
          /*InkWell(
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context) {
              //   return OrderList();
              // }));
            },
            child: Column(
              children: [
                Image.asset(
                  "assets/currency.png",
                  height: 16,
                  width: 16,
                  color: MyTheme.white,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  AppLocalizations.of(context).profile_screen_currency,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 10,
                      color: MyTheme.white,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),*/
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ProfileEdit();
              })).then((value) {
                onPopped(value);
              });
            },
            child: Column(
              children: [
                Image.asset(
                  "assets/edit.png",
                  height: 16,
                  width: 16,
                  color: MyTheme.white,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  AppLocalizations.of(context).profile_edit_screen_edit_profile,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 10,
                      color: MyTheme.white,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Address();
                  },
                ),
              );
            },
            child: Column(
              children: [
                Image.asset(
                  "assets/location.png",
                  height: 16,
                  width: 16,
                  color: MyTheme.white,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  AppLocalizations.of(context).profile_screen_address,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 10,
                      color: MyTheme.white,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget buildSettingAndAddonsHorizontalMenu() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      margin: EdgeInsets.only(top: 14),
      width: DeviceInfo(context).width,
      decoration: BoxDecorations.buildBoxDecoration_1(radius: 12),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        //color: Colors.blue,
        child: Wrap(
          direction: Axis.horizontal,
          runAlignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          runSpacing: 20,
          spacing: 10,
          //mainAxisAlignment: MainAxisAlignment.start,
          alignment: WrapAlignment.spaceBetween,
          children: [
            // Container(
            //   // color: Colors.red,
            //   width: DeviceInfo(context).width / 4,
            //   child: InkWell(
            //     onTap: () {
            //       Navigator.push(context, MaterialPageRoute(builder: (context) {
            //         return Wallet();
            //       }));
            //     },
            //     child: Column(
            //       children: [
            //         Image.asset(
            //           "assets/wallet.png",
            //           width: 16,
            //           height: 16,
            //           color: MyTheme.dark_font_grey,
            //         ),
            //         SizedBox(
            //           height: 10,
            //         ),
            //         Text(
            //           AppLocalizations.of(context).wallet_screen_my_wallet,
            //           textAlign: TextAlign.center,
            //           style: TextStyle(
            //               color: MyTheme.dark_font_grey, fontSize: 12),
            //         )
            //       ],
            //     ),
            //   ),
            // ),
            Container(
              // color: Colors.orange,
              width: DeviceInfo(context).width / 4,
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return OrderList();
                  }));
                },
                child: Column(
                  children: [
                    Image.asset(
                      "assets/orders.png",
                      width: 16,
                      height: 16,
                      color: MyTheme.dark_font_grey,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      AppLocalizations.of(context).profile_screen_orders,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: MyTheme.dark_font_grey, fontSize: 12),
                    )
                  ],
                ),
              ),
            ),
            Container(
              // color: Colors.pink,
              width: DeviceInfo(context).width / 4,
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Wishlist();
                  }));
                },
                child: Column(
                  children: [
                    // Icon(Icons.favorite_border,size: 16,),
                    Image.asset(
                      "assets/heart.png",
                      width: 16,
                      height: 16,
                      color: MyTheme.dark_font_grey,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      AppLocalizations.of(context).main_drawer_my_wishlist,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: MyTheme.dark_font_grey, fontSize: 12),
                    )
                  ],
                ),
              ),
            ),
            // Container(
            //   //color: Colors.yellow,
            //   // color: Colors.pink,
            //   width: DeviceInfo(context).width / 4,
            //   child: InkWell(
            //     onTap: () {
            //       Navigator.push(context, MaterialPageRoute(builder: (context) {
            //         return Clubpoint();
            //       }));
            //     },
            //     child: Column(
            //       children: [
            //         Image.asset(
            //           "assets/points.png",
            //           width: 16,
            //           height: 16,
            //           color: MyTheme.dark_font_grey,
            //         ),
            //         SizedBox(
            //           height: 10,
            //         ),
            //         Text(
            //           AppLocalizations.of(context)
            //               .club_point_screen_earned_points,
            //           textAlign: TextAlign.center,
            //           style: TextStyle(
            //               color: MyTheme.dark_font_grey, fontSize: 12),
            //         )
            //       ],
            //     ),
            //   ),
            // ),
            // Container(
            //   // color: Colors.pink,
            //   width: DeviceInfo(context).width / 4,
            //   child: InkWell(
            //     onTap: () {
            //       Navigator.push(context, MaterialPageRoute(builder: (context) {
            //         return RefundRequest();
            //       }));
            //     },
            //     child: Column(
            //       children: [
            //         Image.asset(
            //           "assets/refund.png",
            //           width: 16,
            //           height: 16,
            //           color: MyTheme.dark_font_grey,
            //         ),
            //         SizedBox(
            //           height: 10,
            //         ),
            //         Text(
            //           AppLocalizations.of(context)
            //               .refund_request_screen_refund_requests,
            //           textAlign: TextAlign.center,
            //           style: TextStyle(
            //               color: MyTheme.dark_font_grey, fontSize: 12),
            //         )
            //       ],
            //     ),
            //   ),
            // ),
            Container(
              // color: Colors.pink,
              width: DeviceInfo(context).width / 4,
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return MessengerList();
                  }));
                },
                child: Column(
                  children: [
                    Image.asset(
                      "assets/messages.png",
                      width: 16,
                      height: 16,
                      color: MyTheme.dark_font_grey,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      AppLocalizations.of(context).main_drawer_messages,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: MyTheme.dark_font_grey, fontSize: 12),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSettingAndAddonsVerticalMenu() {
    return Container(
      margin: EdgeInsets.only(bottom: 120, top: 14),
      padding: EdgeInsets.symmetric(horizontal: 22, vertical: 20),
      decoration: BoxDecorations.buildBoxDecoration_1(),
      child: Column(
        children: [
          Visibility(
            visible: wallet_system_status.$,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 40,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return Wallet();
                      }));
                    },
                    style: TextButton.styleFrom(
                        splashFactory: NoSplash.splashFactory,
                        alignment: Alignment.center,
                        padding: EdgeInsets.zero),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/wallet.png",
                          width: 16,
                          height: 16,
                          color: MyTheme.dark_font_grey,
                        ),
                        SizedBox(
                          width: 24,
                        ),
                        Text(
                          AppLocalizations.of(context).wallet_screen_my_wallet,
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(color: MyTheme.dark_font_grey, fontSize: 12),
                        )
                      ],
                    ),
                  ),
                ),
                Divider(
                  thickness: 1,
                  color: MyTheme.light_grey,
                ),
              ],
            ),
          ),
          Container(
            height: 40,
            child: TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return OrderList();
                }));
              },
              style: TextButton.styleFrom(
                  splashFactory: NoSplash.splashFactory,
                  alignment: Alignment.center,
                  padding: EdgeInsets.zero),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/orders.png",
                    width: 16,
                    height: 16,
                    color: MyTheme.dark_font_grey,
                  ),
                  SizedBox(
                    width: 24,
                  ),
                  Text(
                    AppLocalizations.of(context).profile_screen_orders,
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(color: MyTheme.dark_font_grey, fontSize: 12),
                  )
                ],
              ),
            ),
          ),
          Divider(
            thickness: 1,
            color: MyTheme.light_grey,
          ),
          Container(
            height: 40,
            child: TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Wishlist();
                }));
              },
              style: TextButton.styleFrom(
                  splashFactory: NoSplash.splashFactory,
                  alignment: Alignment.center,
                  padding: EdgeInsets.zero),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/heart.png",
                    width: 16,
                    height: 16,
                    color: MyTheme.dark_font_grey,
                  ),
                  SizedBox(
                    width: 24,
                  ),
                  Text(
                    AppLocalizations.of(context).main_drawer_my_wishlist,
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(color: MyTheme.dark_font_grey, fontSize: 12),
                  )
                ],
              ),
            ),
          ),
          Divider(
            thickness: 1,
            color: MyTheme.light_grey,
          ),
          Visibility(
            visible: club_point_addon_installed.$,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 40,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return Clubpoint();
                      }));
                    },
                    style: TextButton.styleFrom(
                        splashFactory: NoSplash.splashFactory,
                        alignment: Alignment.center,
                        padding: EdgeInsets.zero),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/points.png",
                          width: 16,
                          height: 16,
                          color: MyTheme.dark_font_grey,
                        ),
                        SizedBox(
                          width: 24,
                        ),
                        Text(
                          AppLocalizations.of(context)
                              .club_point_screen_earned_points,
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(color: MyTheme.dark_font_grey, fontSize: 12),
                        )
                      ],
                    ),
                  ),
                ),
                Divider(
                  thickness: 1,
                  color: MyTheme.light_grey,
                ),
              ],
            ),
          ),
          Visibility(
            visible: refund_addon_installed.$,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 40,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return RefundRequest();
                      }));
                    },
                    style: TextButton.styleFrom(
                        splashFactory: NoSplash.splashFactory,
                        alignment: Alignment.center,
                        padding: EdgeInsets.zero),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/refund.png",
                          width: 16,
                          height: 16,
                          color: MyTheme.dark_font_grey,
                        ),
                        SizedBox(
                          width: 24,
                        ),
                        Text(
                          AppLocalizations.of(context)
                              .refund_request_screen_refund_requests,
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(color: MyTheme.dark_font_grey, fontSize: 12),
                        )
                      ],
                    ),
                  ),
                ),
                Divider(
                  thickness: 1,
                  color: MyTheme.light_grey,
                ),
              ],
            ),
          ),
          Visibility(
            visible: conversation_system_status.$,
            child: Container(
              height: 40,
              child: TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return MessengerList();
                  }));
                },
                style: TextButton.styleFrom(
                    splashFactory: NoSplash.splashFactory,
                    alignment: Alignment.center,
                    padding: EdgeInsets.zero),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/messages.png",
                      width: 16,
                      height: 16,
                      color: MyTheme.dark_font_grey,
                    ),
                    SizedBox(
                      width: 24,
                    ),
                    Text(
                      AppLocalizations.of(context).main_drawer_messages,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: MyTheme.dark_font_grey, fontSize: 12),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCountersRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildCountersRowItem(
          _cartCounterString,
          AppLocalizations.of(context).profile_screen_in_your_cart,
        ),
        buildCountersRowItem(
          _wishlistCounterString,
          AppLocalizations.of(context).profile_screen_in_wishlist,
        ),
        buildCountersRowItem(
          _orderCounterString,
          AppLocalizations.of(context).profile_screen_in_ordered,
        ),
      ],
    );
  }

  Widget buildCountersRowItem(String counter, String title) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.symmetric(vertical: 14),
      width: DeviceInfo(context).width / 3.6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: MyTheme.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            counter,
            maxLines: 2,
            style: TextStyle(
                fontSize: 16,
                color: MyTheme.dark_font_grey,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            title,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: MyTheme.dark_font_grey,
            ),
          ),
        ],
      ),
    );
  }
  Widget buildTopSection() {

    return Container(
      // color: Colors.amber,
      alignment: Alignment.center,
      height: 48,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /* Container(
            child: InkWell(
              //padding: EdgeInsets.zero,
              onTap: (){
              Navigator.pop(context);
            } ,child:Icon(Icons.arrow_back,size: 25,color: MyTheme.white,), ),
          ),*/
          // SizedBox(width: 10,),
          Padding(
            padding: const EdgeInsets.only(right: 14.0),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: MyTheme.white, width: 1),
                //shape: BoxShape.rectangle,
              ),
              child: ClipRRect(
                  clipBehavior: Clip.hardEdge,
                  borderRadius: BorderRadius.all(Radius.circular(100.0)),
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/placeholder.png',
                    image: "${avatar_original.$}",
                    fit: BoxFit.fill,
                  )),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Text(
                "${user_name.$}",
                style: TextStyle(
                    fontSize: 14,
                    color: MyTheme.white,
                    fontWeight: FontWeight.w600),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    //if user email is not available then check user phone if user phone is not available use empty string
                    "${user_email.$ != "" && user_email.$ != null ? user_email.$ : user_phone.$ != "" && user_phone.$ != null ? user_phone.$ : ''}",
                    style: TextStyle(
                      color: MyTheme.light_grey,
                    ),
                  )),
            ],
          ),
          Spacer(),
          Container(
            width: 90,
            height: 36,
            child: TextButton(
              // padding: EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              // // 	rgb(50,205,50)
              // shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(6),
              //     side: BorderSide(color: MyTheme.white)),
              child: Text(
                AppLocalizations.of(context).main_drawer_logout,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              onPressed: () {
                onTapLogout(context);
              },
            ),
          ),
        ],
      ),
    );
  }
  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      automaticallyImplyLeading: false,
      /* leading: GestureDetector(
        child: widget.show_back_button
            ? Builder(
                builder: (context) => IconButton(
                  icon:
                      Icon(CupertinoIcons.arrow_left, color: MyTheme.dark_grey),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              )
            : Builder(
                builder: (context) => GestureDetector(
                  onTap: () {
                    _scaffoldKey.currentState.openDrawer();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 18.0, horizontal: 0.0),
                    child: Container(
                      child: Image.asset(
                        'assets/hamburger.png',
                        height: 16,
                        color: MyTheme.dark_grey,
                      ),
                    ),
                  ),
                ),
              ),
      ),*/
      title: Text(
        AppLocalizations.of(context).profile_screen_account,
        style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }
}
