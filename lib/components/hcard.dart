import 'package:flutter/material.dart';
import 'package:bab_algharb/models/courses.dart';

class HCard extends StatelessWidget {
  const HCard({ this.section});

  final CourseModel section;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 110),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      decoration: BoxDecoration(
        color: section.color,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section.title,
                  style: const TextStyle(
                      fontSize: 24, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  section.caption,
                  style: const TextStyle(
                      fontSize: 17, color: Colors.white),
                )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(20),
            child: VerticalDivider(thickness: 0.8, width: 0),
          ),
          Image.asset(section.image)
        ],
      ),
    );
  }
}