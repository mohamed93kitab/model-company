import 'package:flutter/material.dart';
import 'package:bab_algharb/theme.dart';
class ProductCard extends StatefulWidget {
  String product_image;
  String product_price;
  String type;

   ProductCard({this.product_image, this.product_price, this.type});



  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: AppTheme.white,
                          borderRadius: BorderRadius.circular(14)
                      ),
                      child: Column(children: [
                        Container(
                          margin: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Image.asset(widget.product_image),
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(
                          horizontal: 16,  
                          vertical: 12
                        ),
                        child: Row(
                           mainAxisAlignment: widget.type == "cards" ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
                          children: [
                         widget.type != "cards" ? Image.asset("assets/currency.png", color: AppTheme.accentColor, width: 25,) : SizedBox(),
                          Text(widget.product_price, style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),)
                        ],)
                        )
                      ]),
                     );
  }
}