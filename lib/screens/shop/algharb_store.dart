import 'package:bab_algharb/theme.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:bab_algharb/screens/shop/Widgets/product_card.dart';
import 'package:bab_algharb/screens/shop/Widgets/category_card.dart';
import 'package:bab_algharb/screens/shop/cart.dart';
import 'package:bab_algharb/screens/shop/Widgets/user_name_card.dart';
import 'package:bab_algharb/screens/shop/products_screen.dart';

class AlgharbStore extends StatefulWidget {
  const AlgharbStore();

  @override
  State<AlgharbStore> createState() => _AlgharbStoreState();
}

class _AlgharbStoreState extends State<AlgharbStore> {

  ScrollController _featuredCategoryScrollController;
  var _featuredCategoryList = [
    
  ];
  bool _isCategoryInitial = false;

  var selectedIndex = '1';

  List _carouselImageList = [
    "dummy_assets/fd1.jpg",
    "dummy_assets/fd2.jpg",
    "dummy_assets/fd3.jpg",
  ];
  int _current_slider = 0;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppTheme.light_bg,
      appBar: AppBar(
        backgroundColor: AppTheme.accentColor,
        centerTitle: true,
        title: Text("الغرب ستور", style: TextStyle(color: AppTheme.white, fontWeight: FontWeight.bold),),
        actions: [
          IconButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ShoppingCart()));
          }, icon: Icon(Icons.shopping_bag, size: 28,))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              SizedBox(height: 20,),
              CarouselSlider(
                // carouselController: _carouselController,
                  items: _carouselImageList.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          padding: const EdgeInsets.only(
                              left: 8, right: 8, top: 0, bottom: 0),
                          color: Theme.of(context).colorScheme.background,
                          child: Column(
                            children: <Widget>[
                              Container(

                                  color: Theme.of(context).colorScheme.background,
                                  width: double.infinity,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.asset(
                                       i,
                                      fit: BoxFit.cover,
                                      height: 170,
                                    ),
                                  )),
                            ],
                          ),
                        );
                      },
                    );
                  }).toList(),
                  options: CarouselOptions(
                    aspectRatio: 338 / 138,
                    viewportFraction: .9,
                    initialPage: 1,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 6),
                    autoPlayAnimationDuration: Duration(milliseconds: 1000),
                    autoPlayCurve: Curves.easeInExpo,
                    enlargeCenterPage: false,
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current_slider = index;
                      });
                    },
                  )),
                  SizedBox(height: 15,),
                  Align(
                alignment: Alignment.center,
                child: AnimatedSmoothIndicator(
                  activeIndex: _current_slider,
                  count: _carouselImageList.length,
                  effect: ExpandingDotsEffect(
                      dotHeight: 10,
                      dotWidth: 10,
                      activeDotColor: AppTheme.accentColor,
                      dotColor: AppTheme.background2.withOpacity(.2)
                  ),
                ),
              ),

              SizedBox(height: 20,),

              SizedBox(
                height: 475,
                //child: buildHomeFeaturedCategories(context),
                child: GridView.builder(
          padding:
              const EdgeInsets.only(left: 18, right: 18, top: 13, bottom: 20),
          scrollDirection: Axis.horizontal,
          itemCount: 9,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 3 / 2.4,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              mainAxisExtent: 120),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ProductScreen(
                    title: "المنتجات",
                  );
                }));
              },
              child: Container(
                padding: EdgeInsets.only(top: 10, bottom: 4),
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.circular(8)
                ),
                child: Column(
                 // mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                            color: AppTheme.light_bg,
                            borderRadius: BorderRadius.circular(88),

                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(88),
                            child: Image.asset(
                            index == 0 ? 'dummy_assets/fc3.jpeg' :
                            index == 1 ? 'dummy_assets/fc8.jpeg' :
                            index == 2 ? 'dummy_assets/fc1.jpeg' :
                            index == 3 ? 'dummy_assets/fc2.jpeg' :
                            index == 4 ? 'dummy_assets/fc6.jpeg' :
                            index == 5 ? 'dummy_assets/fc9.jpeg' :
                            index == 6 ? 'dummy_assets/fc7.jpeg' :
                            index == 7 ? 'dummy_assets/fc4.jpeg' :
                            index == 8 ? 'dummy_assets/fc5.jpeg' :
                            'dummy_assets/fc3.jpeg',
                              fit: BoxFit.cover,
                              width: 90,
                            ))),
                    Container(
                    //  margin: EdgeInsets.only(top: 12),
                      alignment: Alignment.center,
                    //  color: MyTheme.accent_color,
                      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                      child: Text(
                        index == 0 ? 'سيارات' :
                            index == 3 ? 'حاسبات' :
                            index == 6 ? 'مواد تجميل' :
                            index == 1 ? 'مواد بناء' :
                            index == 4 ? 'موبايلات' :
                            index == 7 ? 'ألعاب أطفال' :
                            index == 2 ? 'ملابس رجالية' :
                            index == 5 ? 'أثاث' :
                            index == 8 ? 'تجهيزات رياضية' :
                            'dummy_assets/fc3.jpeg',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: true,
                        style:
                            TextStyle(fontSize: 12, color: AppTheme.backgroundDark, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            );
          })
              ),

               Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: CupertinoSlidingSegmentedControl(
                      backgroundColor: AppTheme.backgroundDark.withOpacity(.3),
                      padding: EdgeInsets.all(4),
                      groupValue: selectedIndex,
                      children: {
                        "1": Padding(
                          padding: EdgeInsets.all(8),
                          child: Text("الألعاب", style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                          ),),
                        ),
                        "2": Padding(
                          padding: EdgeInsets.all(8),
                          child: Text("بطاقات الشحن", style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                          ),),
                        ),
                        "3": Padding(
                          padding: EdgeInsets.all(8),
                          child: Text("يوزرات", style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                          ),),
                        ),
                      },
                      onValueChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedIndex = value;
                          });
                        }
                      },
                    )),

                selectedIndex == "1" ? 
                Container(
                  child: GridView.builder(
                  itemCount: 4,
                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.909),
                  padding: EdgeInsets.all(8.0),
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, indx) {
                     return GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> ProductScreen(title: "الألعاب", type: "games",)));
                      },
                      child: CategoryCard(
                      category_image: "dummy_assets/g"+(indx+1).toString()+".png",
                      category_name: indx == 0 ? "بوبجي" : indx == 1 ? "فورتنايت" : indx == 2 ? "كلاش رويال" : "كلاش أوف كلانس"
                     ),
                     );
                }),
                ):
                selectedIndex == '2' ?
                
                Container(
                  child: GridView.builder(
                  itemCount: 3,
                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.770),
                  padding: EdgeInsets.all(8.0),
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, indx) {
                     return GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ProductScreen(title: "بطاقات الشحن", type: "cards",)));
                      },
                      child: ProductCard(
                      type: "cards",
                      product_image: indx == 0 ?
                       "dummy_assets/asiacell.png" :
                        indx == 1 ? "dummy_assets/zain-iraq.png" :
                        indx == 2 ? "dummy_assets/korek.png" : "",
                      product_price: indx == 0 ? "آسياسيل" : indx == 1 ? "زين العراق" : indx == 2 ? "كورك" : indx == 3 ? "25,000" : indx == 4 ? "50,000" : "10,000"
                     ),
                     );
                }),
                ) : 
                selectedIndex == '3' ? Container(
                  child: GridView.builder(
                  itemCount: 8,
                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.3),
                  padding: EdgeInsets.all(8.0),
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, indx) {
                     return UserNameCard(
                      username: indx == 0 ?
                       "@MK" :
                        indx == 1 ? "@m.h" :
                        indx == 2 ? "@s.h" :
                        indx == 3 ? "@lmn"
                        : indx == 4 ? "@CDC" : indx == 5 ? "@QDC" : indx == 6 ? "@IQ.m" : indx == 7 ? "@QC" : "",
                      product_price: indx == 0 ? "5,000" : indx == 1 ? "25,000" : indx == 2 ? "5,000" : indx == 3 ? "25,000" : indx == 4 ? "50,000" :indx == 5 ? "50,000" :indx == 6 ? "150,000" : "10,000"
                     );
                }),
                ): Container(),

                SizedBox(height: 25,)
            ],
          ),
        ),
      ),
    );
  }



  Widget  buildHomeFeaturedCategories(context) {
    if (_isCategoryInitial && _featuredCategoryList.length == 0) {
      return Center(child: CircularProgressIndicator());
    } else if (_featuredCategoryList.length > 0) {
      //snapshot.hasData
      return GridView.builder(
          padding:
              const EdgeInsets.only(left: 18, right: 18, top: 13, bottom: 20),
          scrollDirection: Axis.horizontal,
          controller: _featuredCategoryScrollController,
          itemCount: _featuredCategoryList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              mainAxisExtent: 110),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) {
                //   return CategoryProducts(
                //     category_id: _featuredCategoryList[index].id,
                //     category_name: _featuredCategoryList[index].name,
                //   );
                // }));
              },
              child: Container(
                padding: EdgeInsets.only(top: 10, bottom: 4),
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.circular(8)
                ),
                child: Column(
                 // mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                            color: AppTheme.light_bg,
                            borderRadius: BorderRadius.circular(88),

                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(88),
                            child: FadeInImage.assetNetwork(
                              placeholder: 'assets/placeholder.png',
                              image: _featuredCategoryList[index].icon,
                              fit: BoxFit.cover,
                              width: 90,
                            ))),
                    Container(
                    //  margin: EdgeInsets.only(top: 12),
                      alignment: Alignment.center,
                    //  color: MyTheme.accent_color,
                      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                      child: Text(
                        _featuredCategoryList[index].name,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: true,
                        style:
                            TextStyle(fontSize: 12, color: AppTheme.backgroundDark, fontWeight: FontWeight.bold),
                      ),
                    ),

                    Container(
                    //  margin: EdgeInsets.only(top: 12),
                      alignment: Alignment.center,
                    //  color: MyTheme.accent_color,
                      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 6),
                      child: Text(
                        _featuredCategoryList[index].description == null ? "" : _featuredCategoryList[index].description,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: true,
                        style:
                            TextStyle(fontSize: 11, color: AppTheme.background.withOpacity(.6), fontWeight: FontWeight.w300),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    } else if (!_isCategoryInitial && _featuredCategoryList.length == 0) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            "لا توجد بيانات",
            style: TextStyle(color: AppTheme.backgroundDark),
          )));
    } else {
      // should not be happening
      return Container(
        height: 100,
      );
    }
  }

}