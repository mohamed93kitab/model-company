import 'package:model_company/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:model_company/screens/brand_products.dart';
import 'package:model_company/custom/box_decorations.dart';
class BrandSquareCard extends StatefulWidget {
  int id;
  String image;
  String name;

  BrandSquareCard({Key key, this.id,this.image, this.name}) : super(key: key);

  @override
  _BrandSquareCardState createState() => _BrandSquareCardState();
}

class _BrandSquareCardState extends State<BrandSquareCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return BrandProducts(id: widget.id,brand_name: widget.name,);
        }));
      },
      child: Container(
        decoration: BoxDecorations.buildBoxDecoration_1(radius: 18),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(8),
                  child: ClipRRect(
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16), bottom: Radius.circular(16)),
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/placeholder.png',
                        image:  widget.image,
                        fit: BoxFit.scaleDown,
                      ))),
              Container(
                height: 40,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Text(
                    widget.name,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                        color: MyTheme.font_grey,
                        fontSize: 14,
                        height: 1.6,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
