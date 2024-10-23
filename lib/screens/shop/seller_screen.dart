import 'package:flutter/material.dart';
class SellerScreen extends StatefulWidget {
  String title;
  SellerScreen({this.title});

  @override
  State<SellerScreen> createState() => _SellerScreenState();
}

class _SellerScreenState extends State<SellerScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController _mainScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: CustomScrollView(
                  controller: _mainScrollController,
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  slivers: [
                     SliverList(
                      delegate: SliverChildListDelegate([
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(),
                        ),
                      
                      ]),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate([
                       
                        Container(
                          height: 100,
                        )
                      ]),
                    )
                  ],
                ),
      ),
    );
  }
}