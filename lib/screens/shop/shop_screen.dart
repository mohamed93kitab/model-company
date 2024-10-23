import 'package:bab_algharb/screens/shop/algharb_store.dart';
import 'package:bab_algharb/screens/shop/sellers_screen.dart';
import 'package:bab_algharb/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class ShopScreen extends StatefulWidget {
  const ShopScreen({Key key}) : super(key: key);

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.light_bg,
      appBar: AppBar(
        backgroundColor: AppTheme.accentColor,
        title: Text("الغرب ستور"),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 220,
          margin: EdgeInsets.only(top: 20, right: 16, left: 16),
          child: Center(
            child: Column(
            children: [

              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AlgharbStore()));
                },
                 child:   Container(
                height: 140,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.circular(18)
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  SizedBox(width: 0,),
                  Text("الغرب ستور", style: GoogleFonts.cairo(
                    fontSize: 26,
                    color: AppTheme.accentColor,
                    fontWeight: FontWeight.bold
                  ),),
                 

                 Image.asset("assets/icons/bab_algharb.png", fit: BoxFit.cover,width: 200,)

                ]),
              ),
              ),

              
            
              SizedBox(height: 20,),

            GestureDetector(
              onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => Sellers()));
              },
              child:   Container(
                height: 140,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.circular(18)
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  SizedBox(width: 0,),
                  Text("التجار", style: GoogleFonts.cairo(
                    fontSize: 26,
                    color: AppTheme.accentColor,
                    fontWeight: FontWeight.bold
                  ),),
                 

                 Image.asset("assets/icons/sellers.png")

                ]),
              ),
            )


            ]
            )),
        ),
        )
      );
  }
}