import 'package:flutter/material.dart';
import 'package:bab_algharb/theme.dart';
class CategoryCard extends StatefulWidget {
  String category_image;
  String category_name;

   CategoryCard({this.category_image, this.category_name});



  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
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
                          child: Image.asset(widget.category_image, height: 120,fit: BoxFit.cover,width: 170,),
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(
                          horizontal: 16,  
                          vertical: 12
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          Text(widget.category_name, style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),)
                        ],)
                        )
                      ]),
                     );
  }
}