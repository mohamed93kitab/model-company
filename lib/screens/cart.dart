import 'package:model_company/custom/box_decorations.dart';
import 'package:model_company/custom/common_functions.dart';
import 'package:model_company/custom/device_info.dart';
import 'package:model_company/custom/text_styles.dart';
import 'package:model_company/custom/useful_elements.dart';
import 'package:model_company/presenter/cart_counter.dart';
import 'package:model_company/screens/select_address.dart';
import 'package:model_company/screens/shipping_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:model_company/my_theme.dart';
import 'package:model_company/ui_sections/drawer.dart';
import 'package:flutter/widgets.dart';
import 'package:model_company/repositories/cart_repository.dart';
import 'package:model_company/helpers/shared_value_helper.dart';
import 'package:model_company/helpers/shimmer_helper.dart';
import 'package:model_company/custom/toast_component.dart';
import 'package:toast/toast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:model_company/custom/common_functions.dart';
import 'package:intl/intl.dart' as Intl;
class Cart extends StatefulWidget {
  Cart({Key key, this.has_bottomnav,this.from_navigation = false, this.counter}) : super(key: key);
  final bool has_bottomnav;
  final bool from_navigation;
  final CartCounter counter;

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController _mainScrollController = ScrollController();
  var _shopList = [];
  bool _isInitial = true;
  var _cartTotal = 0.00;
  var _cartTotalString = ". . .";
  var formatter = Intl.NumberFormat('#,##,000');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    /*print("user data");
    print(is_logged_in.$);
    print(access_token.value);
    print(user_id.$);
    print(user_name.$);*/

    if (is_logged_in.$ == true) {
      fetchData();
    }
  }


  @override
  void dispose() {
    super.dispose();
    _mainScrollController.dispose();
  }


  getCartCount()async {
    var res = await CartRepository().getCartCount();
    widget.counter.controller.sink.add(res.count);
  }

  fetchData() async {
    getCartCount();
    var cartResponseList =
        await CartRepository().getCartResponseList(user_id.$);

    if (cartResponseList != null && cartResponseList.length > 0) {
      _shopList = cartResponseList;
    }
    _isInitial = false;
    getSetCartTotal();
    setState(() {});
  }

  getSetCartTotal() {
    _cartTotal = 0.00;
    if (_shopList.length > 0) {
      _shopList.forEach((shop) {
        if (shop.cart_items.length > 0) {
          shop.cart_items.forEach((cart_item) {
            _cartTotal +=  double.parse(
                ((cart_item.price + cart_item.tax) * cart_item.quantity)
                    .toStringAsFixed(0));
            _cartTotalString =
                "${cart_item.currency_symbol}${formatter.format(int.parse(_cartTotal.toStringAsFixed(0)))}";
          });
        }
      });
    }

    setState(() {});
  }

  partialTotalString(index) {
    var partialTotal = 0.00;
    var partialTotalString = "";
    if (_shopList[index].cart_items.length > 0) {
      _shopList[index].cart_items.forEach((cart_item) {
        partialTotal += (cart_item.price + cart_item.tax) * cart_item.quantity;
        partialTotalString =
            "${cart_item.currency_symbol}${formatter.format(int.parse(partialTotal.toStringAsFixed(0)))}";
      });
    }

    return partialTotalString;
  }

  onQuantityIncrease(seller_index, item_index) {
    if (_shopList[seller_index].cart_items[item_index].quantity <
        _shopList[seller_index].cart_items[item_index].upper_limit) {
      _shopList[seller_index].cart_items[item_index].quantity++;
      getSetCartTotal();
      setState(() {});
    } else {
      ToastComponent.showDialog(
          "${AppLocalizations.of(context).cart_screen_cannot_order_more_than} ${_shopList[seller_index].cart_items[item_index].upper_limit} ${AppLocalizations.of(context).cart_screen_items_of_this}",
          gravity: Toast.center,
          duration: Toast.lengthLong);
    }
  }

  onQuantityDecrease(seller_index, item_index) {
    if (_shopList[seller_index].cart_items[item_index].quantity >
        _shopList[seller_index].cart_items[item_index].lower_limit) {
      _shopList[seller_index].cart_items[item_index].quantity--;
      getSetCartTotal();
      setState(() {});
    } else {
      ToastComponent.showDialog(
          "${AppLocalizations.of(context).cart_screen_cannot_order_more_than} ${_shopList[seller_index].cart_items[item_index].lower_limit} ${AppLocalizations.of(context).cart_screen_items_of_this}",
          gravity: Toast.center,
          duration: Toast.lengthLong);
    }
  }

  onPressDelete(cart_id) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: EdgeInsets.only(
                  top: 16.0, left: 2.0, right: 2.0, bottom: 2.0),
              content: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Text(
                  AppLocalizations.of(context).cart_screen_sure_remove_item,
                  maxLines: 3,
                  style: TextStyle(color: MyTheme.font_grey, fontSize: 14),
                ),
              ),
              actions: [
                TextButton(
                  child: Text(
                    AppLocalizations.of(context).cart_screen_cancel,
                    style: TextStyle(color: MyTheme.medium_grey),
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
                TextButton(
                 // color: MyTheme.soft_accent_color,
                  child: Text(
                    AppLocalizations.of(context).cart_screen_confirm,
                    style: TextStyle(color: MyTheme.dark_grey),
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    confirmDelete(cart_id);
                  },
                ),
              ],
            ));
  }

  confirmDelete(cart_id) async {
    var cartDeleteResponse =
        await CartRepository().getCartDeleteResponse(cart_id);

    if (cartDeleteResponse.result == true) {
      ToastComponent.showDialog(cartDeleteResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);

      reset();
      fetchData();
    } else {
      ToastComponent.showDialog(cartDeleteResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
    }
  }

  onPressUpdate() {
    process(mode: "update");
  }

  onPressProceedToShipping() {
    process(mode: "proceed_to_shipping");
  }

  process({mode}) async {
    var cart_ids = [];
    var cart_quantities = [];
    if (_shopList.length > 0) {
      _shopList.forEach((shop) {
        if (shop.cart_items.length > 0) {
          shop.cart_items.forEach((cart_item) {
            cart_ids.add(cart_item.id);
            cart_quantities.add(cart_item.quantity);
          });
        }
      });
    }

    if (cart_ids.length == 0) {
      ToastComponent.showDialog(
          AppLocalizations.of(context).cart_screen_cart_empty,
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    }

    var cart_ids_string = cart_ids.join(',').toString();
    var cart_quantities_string = cart_quantities.join(',').toString();

    print(cart_ids_string);
    print(cart_quantities_string);

    var cartProcessResponse = await CartRepository()
        .getCartProcessResponse(cart_ids_string, cart_quantities_string);

    if (cartProcessResponse.result == false) {
      ToastComponent.showDialog(cartProcessResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
    } else {
      ToastComponent.showDialog(cartProcessResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);

      if (mode == "update") {
        reset();
        fetchData();
      } else if (mode == "proceed_to_shipping") {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return SelectAddress();
        })).then((value) {
          onPopped(value);
        });
      }
    }
  }

  reset() {
    _shopList = [];
    _isInitial = true;
    _cartTotal = 0.00;
    _cartTotalString = ". . .";

    setState(() {});
  }

  Future<void> _onRefresh() async {
    reset();
    fetchData();
  }

  onPopped(value) async {
    reset();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
          key: _scaffoldKey,
          //drawer: MainDrawer(),
          backgroundColor: Colors.white,
          appBar: buildAppBar(context),
          body: Stack(
            children: [
              RefreshIndicator(
                color: MyTheme.accent_color,
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
                        Container(
                          height: widget.has_bottomnav ? 140 : 100,
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
          )),
    );
  }

  Container buildBottomContainer() {
    return Container(
      margin: EdgeInsets.only(bottom: 40, right: 18, left: 18),
      decoration: BoxDecoration(
        color: MyTheme.accent_color,
        borderRadius: BorderRadius.circular(18)
        /*border: Border(
                  top: BorderSide(color: MyTheme.light_grey,width: 1.0),
                )*/
      ),

      height: widget.has_bottomnav ? 200 : 180,
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
                    AppLocalizations.of(context).cart_screen_total_amount,
                    style:
                        TextStyle(color: MyTheme.white, fontSize: 13,fontWeight: FontWeight.w700),
                  ),
                  Spacer(),
                  Text("${_cartTotalString}",
                      style: TextStyle(
                          color: MyTheme.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    width: (MediaQuery.of(context).size.width / 3),
                    height: 58,
                    decoration: BoxDecoration(
                        color: MyTheme.white.withOpacity(.5),
                        borderRadius: BorderRadius.circular(18)
                        // border:
                        //     Border.all(color: MyTheme.accent_color, width: 1),
                        // borderRadius: app_language_rtl.$
                        //     ? const BorderRadius.only(
                        //         topLeft: const Radius.circular(0.0),
                        //         bottomLeft: const Radius.circular(0.0),
                        //         topRight: const Radius.circular(6.0),
                        //         bottomRight: const Radius.circular(6.0),
                        //       )
                        //     : const BorderRadius.only(
                        //         topLeft: const Radius.circular(6.0),
                        //         bottomLeft: const Radius.circular(6.0),
                        //         topRight: const Radius.circular(0.0),
                        //         bottomRight: const Radius.circular(0.0),
                        //       )
                    ),
                    child: TextButton(
                      // minWidth: MediaQuery.of(context).size.width,
                      // //height: 50,
                      // color: MyTheme.soft_accent_color,
                      // shape: app_language_rtl.$
                      //     ? RoundedRectangleBorder(
                      //         borderRadius: const BorderRadius.only(
                      //         topLeft: const Radius.circular(0.0),
                      //         bottomLeft: const Radius.circular(0.0),
                      //         topRight: const Radius.circular(6.0),
                      //         bottomRight: const Radius.circular(6.0),
                      //       ))
                      //     : RoundedRectangleBorder(
                      //         borderRadius: const BorderRadius.only(
                      //         topLeft: const Radius.circular(6.0),
                      //         bottomLeft: const Radius.circular(6.0),
                      //         topRight: const Radius.circular(0.0),
                      //         bottomRight: const Radius.circular(0.0),
                      //       )),
                      child: Text(
                        AppLocalizations.of(context).cart_screen_update_cart,
                        style: TextStyle(
                            color: MyTheme.accent_color,
                            fontSize: 15,
                            fontWeight: FontWeight.w700),
                      ),
                      onPressed: () {
                        onPressUpdate();
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    height: 58,
                    width: (MediaQuery.of(context).size.width / 2.3),
                    decoration: BoxDecoration(
                        color: MyTheme.white,
                        border:
                            Border.all(color: MyTheme.accent_color, width: 1),
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
                        AppLocalizations.of(context)
                            .cart_screen_proceed_to_shipping,
                        style: TextStyle(
                            color: MyTheme.accent_color,
                            fontSize: 15,
                            fontWeight: FontWeight.w700),
                      ),
                      onPressed: () {
                        onPressProceedToShipping();
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

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: Builder(
        builder: (context) =>
            widget.from_navigation ? UsefulElements.backToMain(context, go_back: false) : UsefulElements.backButton(context),
      ),
      title: Text(
        AppLocalizations.of(context).cart_screen_shopping_cart,
        style: TextStyles.buildAppBarTexStyle(),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  buildCartSellerList() {
    if (is_logged_in.$ == false) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            AppLocalizations.of(context).cart_screen_please_log_in,
            style: TextStyle(color: MyTheme.font_grey),
          )));
    } else if (_isInitial && _shopList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildListShimmer(item_count: 5, item_height: 100.0));
    } else if (_shopList.length > 0) {
      return SingleChildScrollView(
        child: ListView.separated(
          separatorBuilder: (context, index) => SizedBox(
            height: 26,
          ),
          itemCount: _shopList.length,
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
                        AppLocalizations.of(context).cart_screen_total_price,
                        style: TextStyle(
                            color: MyTheme.dark_font_grey,
                            fontWeight: FontWeight.w700,
                            fontSize: 12),
                      ),
                      Spacer(),
                      Text(
                        partialTotalString(index),
                        style: TextStyle(
                            color: MyTheme.accent_color,
                            fontWeight: FontWeight.w700,
                            fontSize: 12),
                      ),
                    ],
                  ),
                ),
                buildCartSellerItemList(index),
               // SizedBox(height: MediaQuery.of(context).size.height * .2,),
              ],
            );
          },
        ),
      );
    } else if (!_isInitial && _shopList.length == 0) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            AppLocalizations.of(context).cart_screen_cart_empty,
            style: TextStyle(color: MyTheme.font_grey),
          )));
    }
  }

  SingleChildScrollView buildCartSellerItemList(seller_index) {
    return SingleChildScrollView(
      child: ListView.separated(
        separatorBuilder: (context, index) => SizedBox(
          height: 14,
        ),
        itemCount: _shopList[seller_index].cart_items.length,
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          if(index == _shopList[seller_index].cart_items.length - 1) {
            return Column(
              children: [
                buildCartSellerItemCard(seller_index, index),
                SizedBox(height: 120,)
              ],
            );
          }else {
            return buildCartSellerItemCard(seller_index, index);
          }

        },
      ),
    );
  }

  buildCartSellerItemCard(seller_index, item_index) {
    return Container(
      height: 120,
      decoration: BoxDecorations.buildBoxDecoration_1(radius: 18),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
                width: 120,
                height: 120,
                padding: EdgeInsets.all(8),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/placeholder.png',
                      image: _shopList[seller_index]
                          .cart_items[item_index]
                          .product_thumbnail_image,
                      fit: BoxFit.cover,
                    ))),
            Container(
              //color: Colors.red,
              width: DeviceInfo(context).width - 160,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * .46,
                            child: Text(
                              _shopList[seller_index]
                                  .cart_items[item_index]
                                  .product_name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                height: 1.18,
                                  color: MyTheme.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Spacer(),
                          Container(
                            width: 32,
                            child: GestureDetector(
                                  onTap: () {
                                    onPressDelete(
                                        _shopList[seller_index].cart_items[item_index].id);
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

                    Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: Text(_shopList[seller_index]
                          .cart_items[item_index]
                          .variation, style: TextStyle(
                        color: MyTheme.light_grey,
                        fontSize: 14
                      ),),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                onQuantityIncrease(seller_index, item_index);
                              },
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration:
                                BoxDecorations.buildCartCircularButtonDecoration(),
                                child: Icon(
                                  Icons.add,
                                  color: MyTheme.accent_color,
                                  size: 12,
                                ),
                              ),
                            ),
                            SizedBox(width: 18,),
                            Text(
                              _shopList[seller_index]
                                  .cart_items[item_index]
                                  .quantity
                                  .toString(),
                              style:
                              TextStyle(color: MyTheme.secondary_color, fontSize: 16),
                            ),
                            SizedBox(width: 18,),
                            GestureDetector(
                              onTap: () {
                                onQuantityDecrease(seller_index, item_index);
                              },
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration:
                                BoxDecorations.buildCartCircularButtonDecoration(),
                                child: Icon(
                                  Icons.remove,
                                  color: MyTheme.accent_color,
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
                            formatter.format(int.parse(
                                (_shopList[seller_index]
                                    .cart_items[item_index]
                                    .price *
                                    _shopList[seller_index]
                                        .cart_items[item_index]
                                        .quantity)
                                    .toStringAsFixed(0))) + " " + _shopList[seller_index]
                              .cart_items[item_index]
                              .currency_symbol,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,

                            style: TextStyle(
                                color: MyTheme.secondary_color,
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
