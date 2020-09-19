import 'package:flutter/material.dart';

import '../utilities/app_style.dart';

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({
    Key key,
    @required this.onChanged,
    this.currentPage = -1,
    @required this.navBarObjects,
    this.homeButtonObject,
  }) : super(key: key);
  final Function(int) onChanged;
  final int currentPage;
  final List<NavBarObject> navBarObjects;
  final Widget homeButtonObject;

  int homeButtonWasBuilt(int i) {
    return homeButtonObject != null && i > navBarObjects.length / 2 ? i - 1 : i;
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: NavPainter(),
      child: Container(
        height: 72,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
          color: Colors.transparent,
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (int i = 0; i < navBarObjects.length + 1; i++)
              (i == navBarObjects.length / 2 && homeButtonObject != null)
                  //Build Home button
                  ? Transform.translate(
                      offset: Offset(0, -16),
                      child: InkWell(
                        child: homeButtonObject,
                        onTap: () => onChanged(i),
                      ),
                    )
                  //Else build normal Nav Button
                  : Flexible(
                      child: NavButton(
                        buttonData: navBarObjects[homeButtonWasBuilt(i)],
                        onTap: () => onChanged(i),
                        isCurrentPage: currentPage == i,
                      ),
                    ),
          ],
        ),
      ),
    );
  }
}

class NavBarObject {
  final Widget icon;
  final String label;

  const NavBarObject({@required this.icon, @required this.label});
}

/// Buttons on the Nav bar
///
/// Takes a requird [icon] widget and an optional [label] String.
class NavButton extends StatelessWidget {
  const NavButton({
    Key key,
    @required this.onTap,
    @required this.buttonData,
    @required this.isCurrentPage,
  }) : super(key: key);
  final Function onTap;
  final NavBarObject buttonData;
  final bool isCurrentPage;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: InkResponse(
        onTap: () {
          onTap();
        },
        child: Column(
          children: [
            SizedBox(
              height: 40,
              child: buttonData.icon ??
                  Placeholder(
                    fallbackWidth: 40,
                  ),
            ),
            if (buttonData.label != null)
              Text(
                '${buttonData.label}',
                style: TextStyle(
                  color: isCurrentPage ? childeanFire : textBlack,
                  fontSize: 10,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Painter for Nav bar
///
/// Caters for Nav bar color, border radius, and void for home button.
class NavPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double sw = size.width;
    final double sh = size.height;

    Paint paint = Paint();
    paint.color = Color(0xFFF4F5F6);
    paint.style = PaintingStyle.fill;

    Paint background = Paint();
    background.color = Color(0xFFDEDEDE);
    background.style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 10);
    path.relativeArcToPoint(
      Offset(10, -10),
      radius: Radius.circular(10),
    );
    path.lineTo(sw / 2 - 24, 0);
    path.relativeArcToPoint(
      Offset(48, 0),
      radius: Radius.circular(34),
      clockwise: false,
      largeArc: true,
    );
    path.lineTo(sw - 10, 0);
    path.relativeArcToPoint(
      Offset(10, 10),
      radius: Radius.circular(10),
    );
    path.lineTo(sw, sh);
    path.lineTo(0, sh);
    path.close();

    canvas.drawPath(path, background);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
