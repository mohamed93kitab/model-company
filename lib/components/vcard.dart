import 'package:bab_algharb/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bab_algharb/models/courses.dart';

class VCard extends StatefulWidget {
  const VCard({ this.course});

  final CourseModel course;

  @override
  State<VCard> createState() => _VCardState();
}

class _VCardState extends State<VCard> {
  final avatars = [4, 5, 6];

  @override
  void initState() {
    avatars.shuffle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 260, maxHeight: 322),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [widget.course.color, widget.course.color.withOpacity(0.5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
        boxShadow: [
          BoxShadow(
            color: widget.course.color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: widget.course.color.withOpacity(0.3),
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
                child: Image.asset(widget.course.newsImage),
              ),
              const SizedBox(height: 8),
              Text(
                widget.course.subtitle,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                softWrap: false,
                style: TextStyle(
                    color: Colors.white.withOpacity(0.7), fontSize: 15),
              ),
              const SizedBox(height: 8),
              Text(
                widget.course.caption.toUpperCase(),
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
              SizedBox(height: 8,),
              Row(
                children: [
                  IconButton(
                      onPressed: (){},
                      icon: Icon(Icons.favorite_border, color: AppTheme.white, size: 30,)),
                  Text("+42", style: TextStyle(color: AppTheme.white, fontSize: 16),),
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
}