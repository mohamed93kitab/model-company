import 'package:model_company/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:model_company/screens/product_details.dart';
import 'package:model_company/custom/box_decorations.dart';
import 'package:intl/intl.dart' as Intl;
class MiniProductCard extends StatefulWidget {
  int id;
  String image;
  String name;
  String main_price;
  String stroked_price;
  String currency_symbol;
  bool has_discount;

  MiniProductCard({Key key, this.id, this.image, this.name, this.main_price,this.stroked_price,this.currency_symbol,this.has_discount})
      : super(key: key);

  @override
  _MiniProductCardState createState() => _MiniProductCardState();
}

class _MiniProductCardState extends State<MiniProductCard> {
  @override
  Widget build(BuildContext context) {
    var formatter = Intl.NumberFormat('#,###,000');

    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProductDetails(id: widget.id);
        }));
      },
      child: Container(
        width: 135,
        decoration: BoxDecorations.buildBoxDecoration_1(),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                    width: double.infinity,
                    child: ClipRRect(
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(6), bottom: Radius.zero),
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/placeholder.png',
                          image:  widget.image,
                          fit: BoxFit.cover,
                        ))),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(8, 4, 8, 6),
                child: Text(
                  widget.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                      color: MyTheme.white,
                      fontSize: 12,
                      height: 1.2,
                      fontWeight: FontWeight.w400),
                ),
              ),
              widget.has_discount ? Padding(
                padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Text(
                    formatter.format(int.parse(widget.stroked_price)) + " " + widget.currency_symbol,
                  maxLines: 1,
                  style: TextStyle(
                      decoration:TextDecoration.lineThrough,
                      color: MyTheme.secondary_color,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
              ):Container(),
              Padding(
                padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Text(
    formatter.format(int.parse(widget.main_price ))+ " " + widget.currency_symbol,
                  maxLines: 1,
                  style: TextStyle(
                      color: MyTheme.secondary_color,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
              ),

            ]),
      ),
    );
  }
}
