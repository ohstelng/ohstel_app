import 'package:Ohstel_app/explore/models/category.dart';
import 'package:Ohstel_app/utilities/app_style.dart';
import 'package:flutter/material.dart';

class ExploreCategoryWidget extends StatelessWidget {
  final ExploreCategory category;
  ExploreCategoryWidget(this.category);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      width: 86.0,
      child: Column(
        children: [
          CircleAvatar(
            radius: 35.0,
            backgroundColor: Theme.of(context).primaryColor,
            backgroundImage: NetworkImage(this.category.imageUrl),
          ),
          SizedBox(height: 10.0),
          Text(
            this.category.name,
            style: body1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
