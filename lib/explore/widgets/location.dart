import 'package:Ohstel_app/utilities/app_style.dart';
import 'package:flutter/material.dart';

class ExploreLocationWidget extends StatefulWidget {
  @override
  _ExploreLocationWidgetState createState() => _ExploreLocationWidgetState();
}

class _ExploreLocationWidgetState extends State<ExploreLocationWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 20.0),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(15.0),
              image: DecorationImage(
                image: NetworkImage(
                    'https://images.unsplash.com/photo-1562214682-28767fbefa33?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2550&q=80'),
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
                color: Colors.white,
                size: 60.0,
              ),
              onPressed: () {
                print('pressed');
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
                    'Summer in Spain',
                    style: heading2.copyWith(color: Colors.white),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'If you want to experience a real spanish summer, learn English',
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
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.white,
                          ),
                          Text(
                            'Vernice, Italy',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 30.0,
                        width: 70.0,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Center(
                          child: Text(
                            '\$ 7 000',
                            style: body1.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
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
    );
  }
}
