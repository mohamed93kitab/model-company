import 'package:bab_algharb/components/shared_value_helper.dart';
import 'package:bab_algharb/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_config.dart';
import '../models/posts.dart';
import '../repositories/news_repository.dart';
import '../repositories/post_repository.dart';

class PostCard extends StatefulWidget {
  final avatar;
  final content;
  final photo;
  final user_name;
  final created_at;
  final id;
  final likes;
  const PostCard({ this.likes,this.id, this.avatar, this.content, this.photo, this.user_name,this.created_at});


  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int posts_likes_count = 0;

  final avatars = [4, 5, 6];
  likeUnlikePost() async {
    var postResponse = await PostRepository().likePost(post_id: widget.id, user_id: user_id.$);
    if(postResponse.status == true) {
      setState(() {
        posts_likes_count = postResponse.data[0].likes;

      });
    }
  }
  @override
  void initState() {
    avatars.shuffle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                 leading: widget.avatar == null ?
                 Container(
                   width: 90,
                   height: 90,
                   child: ClipRRect(
                       borderRadius: BorderRadius.circular(550.0),
                       child: Image.asset('assets/images/avatars/default_avatar.jpg')),
                 ) :
                 CircleAvatar(
                   radius: 45,
                   backgroundImage: NetworkImage(widget.avatar),
                 ),
                title: Text(
                    widget.user_name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),
                ),
                 subtitle: Text(
                   widget.created_at,
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
                    Text(widget.content, style: TextStyle(
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
              Image.network(widget.photo, width: MediaQuery.of(context).size.width,),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    // Row(
                    //   children: [
                    //     IconButton(
                    //         onPressed: (){},
                    //         icon: Icon(Icons.favorite_border, size: 30,)),
                    //     Text("+42", style: TextStyle(fontSize: 16),),
                    //
                    //     SizedBox(width: 16,),
                    //     Wrap(
                    //       spacing: 8,
                    //       children: List.generate(
                    //         avatars.length,
                    //             (index) => Transform.translate(
                    //           offset: Offset(index * 25.0, 0),
                    //           child: ClipRRect(
                    //             key: Key(index.toString()),
                    //             borderRadius: BorderRadius.circular(22),
                    //             child: Image.asset(
                    //                 "assets/images/avatars/avatar_${avatars[index]}.jpg",
                    //                 width: 34,
                    //                 height: 34),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //
                    //     IconButton(
                    //         onPressed: (){},
                    //         icon: Icon(Icons.card_giftcard, size: 30,)),
                    //   ],
                    //
                    // ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: (){
                              likeUnlikePost();
                            },
                            icon: Icon(Icons.favorite_border, size: 30,)),
                        Text(widget.likes.toString(), style: TextStyle(fontSize: 16),),

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
}


class ExpandableText extends StatefulWidget {
  const ExpandableText(
      this.text, {
        this.trimLines = 2,
      })  : assert(text != null);

  final String text;
  final int trimLines;

  @override
  ExpandableTextState createState() => ExpandableTextState();
}

class ExpandableTextState extends State<ExpandableText> {
  bool _readMore = true;
  void _onTapLink() {
    setState(() => _readMore = !_readMore);
  }

  @override
  Widget build(BuildContext context) {
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
    final colorClickableText = AppTheme.accentColor;
    final widgetColor = AppTheme.backgroundDark;
    TextSpan link = TextSpan(
        text: _readMore ? " ... عرض المزيد" : " أقل",
        style: TextStyle(
          color: AppTheme.backgroundDark,
        ),
        recognizer: TapGestureRecognizer()..onTap = _onTapLink
    );
    Widget result = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        assert(constraints.hasBoundedWidth);
        final double maxWidth = constraints.maxWidth;
        // Create a TextSpan with data
        final text = TextSpan(
          text: widget.text,
        );
        // Layout and measure link
        TextPainter textPainter = TextPainter(
          text: link,
          textDirection: TextDirection.rtl,//better to pass this from master widget if ltr and rtl both supported
          maxLines: widget.trimLines,
          ellipsis: ' ... ',
        );
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final linkSize = textPainter.size;
        // Layout and measure text
        textPainter.text = text;
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final textSize = textPainter.size;
        // Get the endIndex of data
        int endIndex;
        final pos = textPainter.getPositionForOffset(Offset(
          textSize.width - linkSize.width,
          textSize.height,
        ));
        endIndex = textPainter.getOffsetBefore(pos.offset);
        var textSpan;
        if (textPainter.didExceedMaxLines) {
          textSpan = TextSpan(
            text: _readMore
                ? widget.text.substring(0, endIndex)
                : widget.text,
            style: GoogleFonts.cairo(
              textStyle: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppTheme.backgroundDark,
                fontSize: 14
              )
            ),
            children: <TextSpan>[link],
          );
        } else {
          textSpan = TextSpan(
            text: widget.text,
          );
        }
        return RichText(
          softWrap: true,
          overflow: TextOverflow.clip,
          text: textSpan,
        );
      },
    );
    return result;
  }
}