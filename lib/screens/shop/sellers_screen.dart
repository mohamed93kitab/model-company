import 'package:bab_algharb/theme.dart';
import 'package:flutter/material.dart';
import 'package:bab_algharb/screens/shop/seller_screen.dart';
class Sellers extends StatefulWidget {
  const Sellers({Key key}) : super(key: key);

  @override
  State<Sellers> createState() => _SellersState();
}

class _SellersState extends State<Sellers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppTheme.accentColor,
        title: Text("التجار"),
      ),
      backgroundColor: AppTheme.light_bg,
      body: Container(
        height: 500,
        margin: EdgeInsets.only(top: 20),
        child: GridView.builder(
          padding:
              const EdgeInsets.only(left: 18, right: 18, top: 13, bottom: 20),
          scrollDirection: Axis.horizontal,
          itemCount: 9,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 3 / 3,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              mainAxisExtent: 120),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SellerScreen(
                    title: "المنتجات",
                  );
                }));
              },
              child: Container(
               
                child: Column(
                 // mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Stack(
                      children: [
                        Container(
                      width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                            color: AppTheme.light_bg,
                            borderRadius: BorderRadius.circular(88),

                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(88),
                            child: Image.asset(
                            index == 0 ? 'dummy_assets/s1.jpg' :
                            index == 1 ? 'dummy_assets/s2.jpg' :
                            index == 2 ? 'dummy_assets/s3.jpg' :
                            index == 3 ? 'dummy_assets/s4.jpg' :
                            index == 4 ? 'dummy_assets/s5.jpg' :
                            index == 5 ? 'dummy_assets/s6.jpg' :
                            index == 6 ? 'dummy_assets/s7.jpg' :
                            index == 7 ? 'dummy_assets/s8.jpg' :
                            index == 8 ? 'dummy_assets/s9.jpg' :
                            'dummy_assets/fc3.jpeg',
                              fit: BoxFit.cover,
                              width: 90,
                            ))),
                     index == 3 || index == 5 || index == 7 || index == 1 ? Positioned(
                        bottom: 4,
                        left: 0,
                        child: Image.network("https://bab-algharb.com/storage/app/public/virified/default-icon.png", width: 27,)
                      ) :Container(),
                      ],
                    ),
                    Container(
                    //  margin: EdgeInsets.only(top: 12),
                      alignment: Alignment.center,
                    //  color: MyTheme.accent_color,
                      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                      child: Text(
                        index == 0 ? 'Fashion' :
                            index == 3 ? 'Fashion' :
                            index == 6 ? 'Tiffany & co' :
                            index == 1 ? 'Clarks' :
                            index == 4 ? 'Motorcycle' :
                            index == 7 ? 'UGG' :
                            index == 2 ? 'Computers Zone' :
                            index == 5 ? 'New Balance' :
                            index == 8 ? 'Vans' :
                            'dummy_assets/fc3.jpeg',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: true,
                        style:
                            TextStyle(fontSize: 16, color: AppTheme.backgroundDark, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
      ),
    );
  }
}