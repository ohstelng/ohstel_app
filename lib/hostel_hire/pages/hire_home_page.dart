import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../utilities/app_style.dart';
import '../../utilities/shared_widgets.dart';
import '../methods/hire_methods.dart';
import 'hire_search_page.dart';
import 'selected_categories_page.dart';

class HireHomePage extends StatelessWidget {
  final ValueNotifier _advertCurrentPageListenable = ValueNotifier(0);
  final List<Map> categoriesList = HireMethods().catList;

  _onAdvertPageChanged(int index) {
    _advertCurrentPageListenable.value = index;
  }

  List<Widget> _advertBuilder() {
    return List.generate(
      4,
      (index) => Placeholder(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDFDFD),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Color(0xFFFDFDFD),
        elevation: 0,
        iconTheme: IconThemeData(
          color: midnightExpress,
          size: 20,
        ),
      ),
      body: Column(
        children: [
          //Search Bar
          OhstelSearchBar(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => HireSearchPage(),
                ),
              );
            },
          ),

          //Advert slideshow
          AdvertSlides(
            onPageChanged: _onAdvertPageChanged,
            builder: _advertBuilder,
          ),

          SizedBox(height: 8),

          //Advert Slideshow Page Indicator
          AdvertSlidesPageIndicator(
            limit: 4,
            currentPageListenable: _advertCurrentPageListenable,
          ),

          //List of HIRE categories
          Expanded(
            child: NotificationListener(
              onNotification: (OverscrollIndicatorNotification notification) {
                notification.disallowGlow();
                return true;
              },
              child: ListView(
                  children: List.generate(
                categoriesList.length,
                (index) => ServiceCategoryListTile(
                  serviceName: categoriesList[index]['searchKey'],
                  imageUrl: categoriesList[index]['imageUrl'],
                  openPeriod: categoriesList[index]['openPeriod'],
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SelectedHireCategoryPage(
                          searchKey: categoriesList[index]['searchKey'],
                        ),
                      ),
                    );
                  },
                ),
              )
                  // [
                  //   ServiceCategoryListTile(
                  //     imageUrl:
                  //         'https://media.istockphoto.com/photos/laundry-room-with-a-washing-machine-picture-id1134696879?k=6&m=1134696879&s=612x612&w=0&h=XicuQ4eM3v7Z-MHWeU8NLsucvvfM9VoHVt_qsNxwdmg=',
                  //     serviceName: 'Laundry Service',
                  //     openPeriod: '8:30am-11:00pm(Everyday)',
                  //     onTap: () {},
                  //   ),
                  //   ServiceCategoryListTile(
                  //     imageUrl:
                  //         'https://media.istockphoto.com/photos/laundry-room-with-a-washing-machine-picture-id1134696879?k=6&m=1134696879&s=612x612&w=0&h=XicuQ4eM3v7Z-MHWeU8NLsucvvfM9VoHVt_qsNxwdmg=',
                  //     serviceName: 'Capentry Service',
                  //     openPeriod: '8:30am-11:00pm(Everyday)',
                  //     onTap: () {},
                  //   ),
                  //   ServiceCategoryListTile(
                  //     imageUrl:
                  //         'https://media.istockphoto.com/photos/laundry-room-with-a-washing-machine-picture-id1134696879?k=6&m=1134696879&s=612x612&w=0&h=XicuQ4eM3v7Z-MHWeU8NLsucvvfM9VoHVt_qsNxwdmg=',
                  //     serviceName: 'Electrical Service',
                  //     openPeriod: '8:30am-11:00pm(Everyday)',
                  //     onTap: () {},
                  //   ),
                  //   ServiceCategoryListTile(
                  //     imageUrl:
                  //         'https://media.istockphoto.com/photos/laundry-room-with-a-washing-machine-picture-id1134696879?k=6&m=1134696879&s=612x612&w=0&h=XicuQ4eM3v7Z-MHWeU8NLsucvvfM9VoHVt_qsNxwdmg=',
                  //     serviceName: 'Painting Service',
                  //     openPeriod: '8:30am-11:00pm(Everyday)',
                  //     onTap: () {},
                  //   ),
                  // ],
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceCategoryListTile extends StatelessWidget {
  const ServiceCategoryListTile({
    Key key,
    @required this.serviceName,
    this.openPeriod,
    this.onTap,
    this.imageUrl,
  }) : super(key: key);
  final String serviceName, openPeriod;
  final Function onTap;
  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cardBackground,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        height: 120,
        child: Row(
          children: [
            ExtendedImage.network(
              '$imageUrl',
              borderRadius: BorderRadius.circular(8),
              fit: BoxFit.fill,
              handleLoadingProgress: true,
              shape: BoxShape.rectangle,
              cache: false,
              enableMemoryCache: true,
              height: 100,
              width: 108,
            ),
            SizedBox(width: 8),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$serviceName',
                  style: heading2.copyWith(color: textAnteBlack),
                  softWrap: true,
                ),
                SizedBox(height: 8),
                Text(
                  '${openPeriod ?? 'NA'}',
                  softWrap: true,
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 13,
                    color: textAnteBlack,
                  ),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}

// class HireHomePage extends StatefulWidget {
//   @override
//   _HireHomePageState createState() => _HireHomePageState();
// }

// class _HireHomePageState extends State<HireHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: <Widget>[
//             searchBar(),
//             advert(),
//             Container(
//               margin: EdgeInsets.all(4.0),
//               child: InkWell(
//                 onTap: () {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (context) => HireAllCategoriesPage(),
//                     ),
//                   );
//                 },
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: <Widget>[
//                     Text('Veiw All'),
//                     Icon(
//                       Icons.arrow_forward_ios,
//                       size: 18,
//                       color: Colors.grey,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             categories(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget categories() {
//     List<Map> categoriesList = HireMethods().catList;

//     return Expanded(
//       child: GridView.count(
//         physics: BouncingScrollPhysics(),
//         crossAxisCount: 2,
//         children: List.generate(
//           categoriesList.length,
//           (index) {
//             return InkWell(
//               onTap: () {
//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (context) => SelectedHireCategoryPage(
//                       searchKey: categoriesList[index]['searchKey'],
//                     ),
//                   ),
//                 );
//               },
//               child: Container(
//                 child: Card(
//                   color: Colors.grey,
//                   child: Center(
//                     child: Text('${categoriesList[index]['searchKey']}'),
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget advert() {
//     return Container(
//       height: 180,
//       width: MediaQuery.of(context).size.width * .95,
//       decoration: BoxDecoration(
//         color: Colors.grey,
//         border: Border.all(color: Colors.black),
//         borderRadius: BorderRadius.circular(15.0),
//       ),
//       child: Center(
//         child: Text('Adverts'),
//       ),
//     );
//   }

//   Widget searchBar() {
//     return Container(
//       margin: EdgeInsets.all(10.0),
//       padding: EdgeInsets.all(10.0),
//       decoration: BoxDecoration(
//         color: Colors.grey[300],
//         borderRadius: BorderRadius.all(Radius.circular(10.0)),
//       ),
//       child: InkWell(
//         onTap: () {
//           Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (context) => HireSearchPage(),
//             ),
//           );
//         },
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: <Widget>[
//             Text('Search'),
//             Icon(Icons.search),
//           ],
//         ),
//       ),
//     );
//   }
// }
