import 'package:carousel_slider/carousel_slider.dart';
import 'package:bab_algharb/components/shared_value_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:bab_algharb/components/hcard.dart';
import 'package:bab_algharb/components/vcard.dart';
import 'package:bab_algharb/models/courses.dart';
import 'package:bab_algharb/theme.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:hexagon/hexagon.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../app_config.dart';
import '../components/post_card.dart';
import '../components/postcard.dart';
import '../models/posts.dart';
import '../repositories/banner_repository.dart';
import '../repositories/news_repository.dart';
import '../repositories/post_repository.dart';

class HomeTabView extends StatefulWidget {
  const HomeTabView();

  @override
  State<HomeTabView> createState() => _HomeTabViewState();
}

class _HomeTabViewState extends State<HomeTabView> {

  List _latestPostList = [];
  int posts_likes_count = 0;
  List _newsList = [];
  bool _isNewsInitial = true;
  bool _avatar;

  int news_likes_count = 0;

  List _carouselImageList = [];
  bool _isBannerInitial = true;
  bool _isPostsInitial = true;
  final avatars = [4, 5, 6];
  fetchNews() async {
    var newsResponse = await NewsRepository().getLatestNews();
    _newsList.addAll(newsResponse.data);
    _isNewsInitial = false;
    // setState(() {});
  }

  fetchBanners() async {
    var carouselResponse = await BannerRepository().getLatestBanners();
    carouselResponse.data.forEach((slider) {
      _carouselImageList.add(slider.photo);
    });
    _isBannerInitial = false;
    setState(() {});
  }
  likeUnlikePost(post_id) async {
    var postResponse = await PostRepository().likePost(post_id: post_id, user_id: user_id.$);
    if(postResponse.status == true) {
      setState(() {
        posts_likes_count = postResponse.data[0].likes;
        _latestPostList.clear();
        _isPostsInitial = true;

        getLatestPosts();
      });
    }
  }



  int _current_slider = 0;

  final List<CourseModel> _courses = CourseModel.courses;
  final List<PostModel> _posts = PostModel.posts;
  final List<CourseModel> _courseSections = CourseModel.courseSections;

  @override
  void initState() {

    fetchNews();
    fetchBanners();
    getLatestPosts();
    avatars.shuffle();
    // TODO: implement initState
    super.initState();
  }

  likeUnlikeNews(news_id) async {
    var newsResponse = await NewsRepository().likeNews(news_id: news_id, user_id: user_id.$);
    if(newsResponse.status == true) {
      setState(() {
        news_likes_count = newsResponse.data[0].likes;
        _newsList.clear();
        _isNewsInitial = true;
        fetchNews();
      });
    }
  }
  getLatestPosts() async {
    var latestPostResponse = await PostRepository().getLatestPost();
    if (latestPostResponse.status == 200) {
      _latestPostList.addAll(latestPostResponse.data);
      setState(() {
        _isPostsInitial = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: AppTheme.background,
          borderRadius: BorderRadius.circular(30),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 60,
              bottom: MediaQuery.of(context).padding.bottom),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40,),
              _isBannerInitial == true && _carouselImageList.length == 0 ?
              Center( child: CircularProgressIndicator(),
              ) : CarouselSlider(
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
                                    child: Image.network(
                                       i,
                                      fit: BoxFit.cover,
                                      height: 150,
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
                    autoPlayInterval: Duration(seconds: 5),
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
              SizedBox(height: 8,),
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
              // SizedBox(height: 20),
              // Align(
              //   alignment: Alignment.center,
              // child: GestureDetector(
              //   child: Container(
              //     padding: EdgeInsets.symmetric(
              //       vertical: 10,
              //       horizontal: 18
              //     ),
              //     decoration: BoxDecoration(
              //       color: AppTheme.backgroundDark,
              //       borderRadius: BorderRadius.circular(42)
              //     ),
              //     child: Text("أضف إعلانك", style: TextStyle(
              //       color: AppTheme.white,
              //       fontSize: 16
              //     ),),
              //   ),
              // )
              // ),
              SizedBox(height: 40,),
               _newsList.length == 0 ? Container(): Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Text(
                  "الأخبار",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),

              Container(
                height: 350,
                margin: EdgeInsets.only(right: 20, bottom: 20),
                child: _isNewsInitial && _newsList.length == 0 ? Center(
                  child: CircularProgressIndicator(),
                )  : _newsList.length > 0 ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: _newsList.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                           return Container(
                             constraints: const BoxConstraints(maxWidth: 260, maxHeight: 350),
                             padding: const EdgeInsets.all(16),
                             margin: EdgeInsets.only(left: 20),
                             decoration: BoxDecoration(
                               gradient: LinearGradient(
                                   colors: [ Color(0xFF7850F0),  Color(0xFF7850F0).withOpacity(0.5)],
                                   begin: Alignment.topLeft,
                                   end: Alignment.bottomRight),
                               boxShadow: [
                                 BoxShadow(
                                   color: Color(0xFF7850F0).withOpacity(0.3),
                                   blurRadius: 8,
                                   offset: const Offset(0, 12),
                                 ),
                                 BoxShadow(
                                   color:  Color(0xFF7850F0).withOpacity(0.3),
                                   blurRadius: 2,
                                   offset: const Offset(0, 1),
                                 )
                               ],
                               borderRadius: BorderRadius.circular(30),
                             ),
                             child: Stack(
                               clipBehavior: Clip.none,
                               children: [
                                 Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     // Container(
                                     //   constraints: const BoxConstraints(maxWidth: 170),
                                     //   child: Text(
                                     //     widget.course.title,
                                     //     style: const TextStyle(
                                     //         fontSize: 24, color: Colors.white),
                                     //   ),
                                     // ),
                                     ClipRRect(
                                       borderRadius: BorderRadius.circular(12.0),
                                       child: Image.network(_newsList[index].photo, height: 155, width: MediaQuery.of(context).size.width, fit: BoxFit.cover,),
                                     ),
                                     const SizedBox(height: 8),
                                     Text(
                                       _newsList[index].content,
                                       overflow: TextOverflow.ellipsis,
                                       maxLines: 2,
                                       softWrap: false,
                                       style: TextStyle(
                                           color: Colors.white.withOpacity(0.7), fontSize: 15),
                                     ),
                                     const SizedBox(height: 8),
                                     Text(
                                       _newsList[index].created_at.toUpperCase(),
                                       style: const TextStyle(
                                           fontSize: 13,
                                           fontWeight: FontWeight.w600,
                                           color: Colors.white),
                                     ),
                                     SizedBox(height: 8,),
                                     Row(
                                       children: [
                                         IconButton(
                                             onPressed: (){
                                               likeUnlikeNews(
                                                   _newsList[index].id
                                               );
                                             },
                                             icon: Icon(Icons.favorite_border, color: AppTheme.white, size: 30,)),
                                         Text(_newsList[index].likes.toString(), style: TextStyle(color: AppTheme.white, fontSize: 16),),
                                         SizedBox(width: 16,),


                                       ],
                                     )
                                   ],
                                 ),
                                 // Positioned(
                                 //     right: -10, top: -10, child: Image.asset(widget.course.image))
                               ],
                             ),
                           );

                    }
                ) : !_isNewsInitial && _newsList.length == 0 ? Center(
                  child: Text("لا توجد أخبار"),
                ) : Container(),
              ),
              // SingleChildScrollView(
              //   padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
              //   scrollDirection: Axis.horizontal,
              //   child: Row(
              //     children: _courses
              //         .map(
              //           (course) => Padding(
              //         key: course.id,
              //         padding: const EdgeInsets.all(10),
              //         child: VCard(course: course),
              //       ),
              //     )
              //         .toList(),
              //   ),
              // ),
              const Padding(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: Text(
                  "أخر المنشورات",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 10),
              //   child: Wrap(
              //     children: List.generate(
              //       _courseSections.length,
              //           (index) => Container(
              //         key: _courseSections[index].id,
              //         width: MediaQuery.of(context).size.width > 992
              //             ? ((MediaQuery.of(context).size.width - 20) / 2)
              //             : MediaQuery.of(context).size.width,
              //         padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
              //         child: HCard(section: _courseSections[index]),
              //       ),
              //     ),
              //   ),
              // )
              _latestPostList.length == 0 ? Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * .6,
                child: Center(
                  child: Text("لا توجد لديك أي منشورات"),
                ),
              ) : ListView.builder(
                  shrinkWrap: true,
                  itemCount: _latestPostList.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ListTile(
                                leading: _latestPostList[index].avatar == null ?
                                CircleAvatar(
                                  radius: 45,
                                  backgroundImage: NetworkImage('${_latestPostList[index].avatar}'),
                                ) :
                                CircleAvatar(
                                  radius: 45,
                                  backgroundImage: NetworkImage('${_latestPostList[index].avatar}'),
                                ),
                                title: Text(
                                  _latestPostList[index].user_name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                subtitle: Text(
                                  _latestPostList[index].created_at,
                                  style: TextStyle(
                                      color: AppTheme.backgroundDark.withOpacity(.6),
                                      fontWeight: FontWeight.w200
                                  ),
                                ),
                              ),
                              // Container(
                              //   constraints: const BoxConstraints(maxWidth: 170),
                              //   child: Text(
                              //     widget.course.title,
                              //     style: const TextStyle(
                              //         fontSize: 24, color: Colors.white),
                              //   ),
                              // ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 8),
                                    Text(_latestPostList[index].content, style: TextStyle(
                                        color: AppTheme.backgroundDark,
                                        overflow: TextOverflow.ellipsis
                                    ), softWrap: false,maxLines: 3,),
                                    // Text(
                                    //
                                    //   overflow: TextOverflow.ellipsis,
                                    //   maxLines: 3,
                                    //   softWrap: false,
                                    //   style: TextStyle(fontSize: 15),
                                    // ),
                                    const SizedBox(height: 12),
                                    // Text(
                                    //   widget.post.caption.toUpperCase(),
                                    //   style: const TextStyle(
                                    //       fontSize: 13,
                                    //       fontWeight: FontWeight.w600,
                                    //       color: Colors.white),
                                    // ),
                                  ],
                                ),
                              ),
                              Image.network(_latestPostList[index].photo, width: MediaQuery.of(context).size.width,),
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                            onPressed: (){
                                              likeUnlikePost(
                                                  _latestPostList[index].id
                                              );
                                            },
                                            icon: Icon(Icons.favorite_border, size: 30,)),
                                        Text(_latestPostList[index].likes.toString(), style: TextStyle(fontSize: 16),),

                                        // SizedBox(width: 16,),
                                        // Wrap(
                                        //   spacing: 8,
                                        //   children: List.generate(
                                        //     avatars.length,
                                        //         (index) => Transform.translate(
                                        //       offset: Offset(index * 25.0, 0),
                                        //       child: ClipRRect(
                                        //         key: Key(index.toString()),
                                        //         borderRadius: BorderRadius.circular(22),
                                        //         child: Image.asset(
                                        //             "assets/images/avatars/avatar_${avatars[index]}.jpg",
                                        //             width: 34,
                                        //             height: 34),
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ),
                                        //
                                        // IconButton(
                                        //     onPressed: (){},
                                        //     icon: Icon(Icons.card_giftcard, size: 30,)),
                                      ],

                                    ),

                                  ],
                                ),
                              ),

                            ],
                          ),
                          // Positioned(
                          //     right: -10, top: -10, child: Image.asset(widget.course.image))
                        ],
                      ),
                    );
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RPSCustomPainter extends CustomPainter{

  @override
  void paint(Canvas canvas, Size size) {



    // Layer 1

    Paint paint_fill_0 = Paint()
      ..color = const Color.fromARGB(255, 0, 101, 198)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width*0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;


    Path path_0 = Path();
    path_0.moveTo(size.width*0.3341667,size.height*0.3571429);
    path_0.lineTo(size.width*0.2933333,size.height*0.4285714);
    path_0.lineTo(size.width*0.3341667,size.height*0.5000000);
    path_0.lineTo(size.width*0.5008333,size.height*0.5000000);
    path_0.lineTo(size.width*0.5425000,size.height*0.4271429);
    path_0.lineTo(size.width*0.5008333,size.height*0.3571429);
    path_0.lineTo(size.width*0.3341667,size.height*0.3571429);
    path_0.close();

    canvas.drawPath(path_0, paint_fill_0);


    // Layer 1

    Paint paint_stroke_0 = Paint()
      ..color = const Color.fromARGB(255, 33, 150, 243)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width*0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;



    canvas.drawPath(path_0, paint_stroke_0);



    // Text Layer 1

    canvas.save();
    final pivot_8338057300081 = Offset(size.width*0.35,size.height*0.41);
    canvas.translate(pivot_8338057300081.dx,pivot_8338057300081.dy);
    canvas.rotate(0);
    canvas.translate(-pivot_8338057300081.dx,-pivot_8338057300081.dy);
    TextPainter tp_8338057300081 = TextPainter(
      text:  TextSpan(text: """You Text Here""", style: TextStyle(
        fontSize: size.width*0.02,
        fontWeight: FontWeight.normal,
        color: Color(0xff000000),
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.none,
      )),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    )..layout(maxWidth: size.width*0.13, minWidth: size.width*0.13);
    tp_8338057300081.paint(canvas,pivot_8338057300081);
    canvas.restore();


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}
