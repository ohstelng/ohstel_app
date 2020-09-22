import 'package:Ohstel_app/explore/models/location.dart';
import 'package:Ohstel_app/explore/pages/details.dart';
import 'package:Ohstel_app/utilities/app_style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ExploreLocationWidget extends StatefulWidget {
  final ExploreLocation location;

  ExploreLocationWidget(this.location);

  @override
  _ExploreLocationWidgetState createState() => _ExploreLocationWidgetState();
}

class _ExploreLocationWidgetState extends State<ExploreLocationWidget> {
  bool bookmarked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ExploreDetails(widget.location),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(right: 20.0),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(15.0),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(widget.location.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: -20.0,
              right: 30.0,
              child: IconButton(
                icon: Icon(
                  Icons.bookmark,
                  color: bookmarked
                      ? Theme.of(context).primaryColor
                      : Colors.white,
                  size: 60.0,
                ),
                onPressed: () {
                  setState(() {
                    bookmarked = !bookmarked;
                  });
                },
              ),
            ),
            Positioned(
              bottom: 0.0,
              child: Container(
                width: 330.0,
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.location.name,
                      style: heading2.copyWith(color: Colors.white),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      widget.location.description,
                      style: body1.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Expanded(
                                child: Container(
                                  child: Text(
                                    widget.location.address,
                                    style: body1.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Container(
                          height: 30.0,
                          padding: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '₦',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                  ),
                                ),
                                Text(
                                  widget.location.price.toString(),
                                  style: body1.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
