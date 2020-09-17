import 'package:Ohstel_app/wallet/pages/wallet_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({
    Key key,
    @required this.onChanged,
    this.currentPage = 0,
  }) : super(key: key);
  final Function(int) onChanged;
  final int currentPage;

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
            Flexible(
              child: NavButton(
                icon: SvgPicture.asset("asset/hostel.svg"),
                onTap: () => onChanged(0),
                label: 'Hostel',
                isCurrentPage: currentPage == 0,
              ),
            ),
            Flexible(
              child: NavButton(
                icon: SvgPicture.asset("asset/food.svg"),
                onTap: () => onChanged(1),
                label: 'Food',
                isCurrentPage: currentPage == 1,
              ),
            ),
            Transform.translate(
              offset: Offset(0, -16),
              child: InkWell(
                child: Image.asset(
                  "asset/OHstel.png",
                  height: 60,
                  width: 60,
                  fit: BoxFit.contain,
                ),
                onTap: () => onChanged(2),
              ),
            ),
            Flexible(
              child: NavButton(
                icon: SvgPicture.asset("asset/market.svg"),
                onTap: () => onChanged(3),
                label: 'Market',
                isCurrentPage: currentPage == 3,
              ),
            ),
            Flexible(
              child: NavButton(
                icon: SvgPicture.asset("asset/wallet.svg"),
                onTap: () => onChanged(4),
                label: 'Wallet',
                isCurrentPage: currentPage == 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Buttons on the Nav bar
///
/// Takes a requird [icon] widget and an optional [label] String.
class NavButton extends StatelessWidget {
  const NavButton({
    Key key,
    @required this.onTap,
    @required this.icon,
    this.label,
    @required this.isCurrentPage,
  }) : super(key: key);
  final Function onTap;
  final Widget icon;
  final String label;
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
              child: icon ??
                  Placeholder(
                    fallbackWidth: 40,
                  ),
            ),
            if (label != null)
              Text(
                '$label',
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

    // Path cut = Path();
    // cut.moveTo(sw / 2 - 20, 0);
    // cut.relativeArcToPoint(
    //   Offset(40, 0),
    //   radius: Radius.circular(35),
    //   clockwise: false,
    //   largeArc: true,
    // );

    // canvas.drawPath(cut, paint);
    // canvas.drawCircle(Offset(sw / 2, sh / 2 - 8), 35, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
