import 'package:bab_algharb/theme.dart';
import 'package:flutter/material.dart';
import 'package:bab_algharb/screens/shop/Widgets/product_card.dart';
import 'package:bab_algharb/screens/shop/Widgets/games_card.dart';
class ProductScreen extends StatefulWidget {
  String title;
  var type;
  ProductScreen({this.title, this.type});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.light_bg,
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
        backgroundColor: AppTheme.accentColor,
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Container(
                  child: GridView.builder(
                  itemCount: 4,
                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: widget.type == "games" ? 1.3: 0.760),
                  padding: EdgeInsets.all(8.0),
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, indx) {
                     return widget.type == "cards" ? ProductCard(
                      product_image: indx == 0 ?
                       "dummy_assets/asiacell-5000.png" :
                        indx == 1 ? "dummy_assets/zain-iraq-25000.png" :
                        indx == 2 ? "dummy_assets/zain-iraq-5000.png" :
                        indx == 3 ? "dummy_assets/asiacell-25000.png"
                        : indx == 4 ? "dummy_assets/asiacell-50000.png" :
                         indx == 5 ? "dummy_assets/zain-iraq-10000.png" :
                        indx == 6 ? "dummy_assets/zain-iraq-25000.png" : "",
                      product_price: indx == 0 ? "5,000" : indx == 1 ? "25,000" : indx == 2 ? "5,000" : indx == 3 ? "25,000" : indx == 4 ? "50,000" : "10,000"
                     ) : widget.type == "games" ? GamesCard(
                      coins : indx == 0 ? "5,000 شحن" : indx == 1 ? "4,000 شحن" : indx == 2 ? "7,000 شحن" : indx == 3 ? "2,000 شحن" : "",
                      price: indx == 0 ? "8,000" : indx == 1 ? "9,000" : indx == 2 ? "12,000" : indx == 3 ? "1,000" : "",
                     ) : ProductCard(
                      product_image: "dummy_assets/p"+(indx+1).toString()+".jpeg",
                      product_price: indx == 0 ? "100,000" : indx == 1 ? "8,000" : indx == 2 ? "70,000" : "4,000"
                     );
                }),
                ),
      ),
    );
  }
}