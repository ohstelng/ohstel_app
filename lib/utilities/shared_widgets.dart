import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'app_style.dart';

//SEARCH BAR
class OhstelSearchBar extends StatelessWidget {
  const OhstelSearchBar({
    Key key,
    this.onTap,
  }) : super(key: key);
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: 48,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.24),
              offset: Offset(0, 2),
              blurRadius: 2,
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              offset: Offset(0, 0),
              blurRadius: 2,
              spreadRadius: 0,
            ),
          ],
        ),
        child: IconTheme(
          data: IconThemeData(
            color: Colors.black,
            opacity: 0.60,
            size: 20,
          ),
          child: Row(
            children: [
              Icon(Icons.search),
              Expanded(
                child: InkWell(
                  onTap: onTap,
                  child: Container(
                    padding: const EdgeInsets.only(left: 24),
                    child: Text(
                      'Search ',
                      style: heading2.copyWith(
                        fontWeight: FontWeight.normal,
                        color: Colors.black26,
                      ),
                    ),
                  ),
                ),
              ),
              Icon(Icons.mic)
            ],
          ),
        ),
      ),
    );
  }
}

//ADVERT SLIDESHOW
class AdvertSlides extends StatelessWidget {
  const AdvertSlides({
    Key key,
    @required this.builder,
    @required this.onPageChanged,
  }) : super(key: key);
  final List<Widget> Function() builder;
  final Function(int) onPageChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
      height: (MediaQuery.of(context).size.width * 0.3).clamp(150.0, 300.0),
      width: double.infinity,
      child: Center(
        child: CarouselSlider(
            options: CarouselOptions(
              onPageChanged: (index, reason) {
                onPageChanged(index);
              },
              height:
                  (MediaQuery.of(context).size.width * 0.3).clamp(150.0, 300.0),
              aspectRatio: 2.0,
              initialPage: 0,
              viewportFraction: 0.85,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              pauseAutoPlayOnTouch: true,
              enableInfiniteScroll: false,
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
            ),
            items: builder()),
      ),
    );
  }
}

//ADVERT SLIDESHOW PAGE INDICATOR
class AdvertSlidesPageIndicator extends StatelessWidget {
  const AdvertSlidesPageIndicator({
    Key key,
    @required int limit,
    @required ValueNotifier currentPageListenable,
  })  : _advertCurrentPageListenable = currentPageListenable,
        _limit = limit,
        super(key: key);

  final ValueNotifier _advertCurrentPageListenable;
  final int _limit;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: ValueListenableBuilder(
        valueListenable: _advertCurrentPageListenable,
        builder: (context, page, _) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              _limit,
              (index) => index == page
                  ? Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      height: 4,
                      width: 16,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: childeanFire,
                      ),
                    )
                  : Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      height: 4,
                      width: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: Colors.grey,
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}

//CUSTOM BUTTON - LONG
enum ButtonType { filledOrange, borderOrange, filledBlue, borderBlue }

class CustomLongButton extends StatelessWidget {
  const CustomLongButton({
    Key key,
    @required this.label,
    @required this.onTap,
    this.type = ButtonType.filledOrange,
  }) : super(key: key);
  final String label;
  final Function onTap;
  final ButtonType type;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 2, 16, 14),
      child: MaterialButton(
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: BorderSide(
              width: 1,
              color: type == ButtonType.filledBlue ||
                      type == ButtonType.filledOrange
                  ? Colors.transparent
                  : type == ButtonType.borderOrange
                      ? childeanFire
                      : midnightExpress,
            )),
        color: type == ButtonType.borderBlue || type == ButtonType.borderOrange
            ? Colors.transparent
            : type == ButtonType.filledOrange ? childeanFire : midnightExpress,
        height: 48,
        minWidth: double.infinity,
        child: Text(
          '$label',
          style: buttonStyle.copyWith(
            color:
                type == ButtonType.filledBlue || type == ButtonType.filledOrange
                    ? Colors.white
                    : type == ButtonType.borderOrange
                        ? childeanFire
                        : midnightExpress,
          ),
        ),
        onPressed: onTap,
      ),
    );
  }
}
