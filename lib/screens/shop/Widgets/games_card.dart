import 'package:flutter/material.dart';
import 'package:bab_algharb/theme.dart';
class GamesCard extends StatefulWidget {
  String coins;
  String price;

   GamesCard({this.coins, this.price});



  @override
  State<GamesCard> createState() => _GamesCardState();
}

class _GamesCardState extends State<GamesCard> {
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
                  child: Text(widget.coins,style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
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
                  Text(widget.price, style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),)
                ],)
                )
              ]),
              );
  }
}