import 'package:flutter/material.dart';
import 'package:bab_algharb/theme.dart';
class UserNameCard extends StatefulWidget {
  String username;
  String product_price;

   UserNameCard({this.username, this.product_price});



  @override
  State<UserNameCard> createState() => _UserNameCardState();
}

class _UserNameCardState extends State<UserNameCard> {
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
                          child: Text(widget.username, style: TextStyle(
                            fontSize: 19,
                            color: AppTheme.accentColor
                          ),),
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(
                          horizontal: 16,  
                          vertical: 12
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Image.asset("assets/currency.png", color: AppTheme.accentColor, width: 25,),
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