import 'package:Ohstel_app/hive_methods/hive_class.dart';

class SubLocation {
  String keyword;
  int id;
  String autoCompleteTerm;
  String uni;

  SubLocation({this.keyword, this.id, this.autoCompleteTerm, this.uni});

  factory SubLocation.fromJson(Map<String, dynamic> map) {
    return SubLocation(
      keyword: map['keyword'] as String,
      id: map['id'] as int,
      autoCompleteTerm: map['autocompleteTerm'] as String,
      uni: map['uni'] as String,
    );
  }
}

class SubLocationViewModel {
  static List<SubLocation> subLocations;

  static Future<void> loadSubLocationsFromDb() async {
    subLocations = List<SubLocation>();
    Map locations = await HiveMethods().getLocationDataFromDb();
    print(locations);

    try {
      if (locations != null) {
        List categoryMap =
            locations.cast<String, dynamic>()['subLocation'] as List;
        print(categoryMap);
        print(categoryMap.runtimeType);
        for (int i = 0; i < categoryMap.length; i++) {
          Map currentData = categoryMap[i].cast<String, dynamic>();
          subLocations.add(SubLocation.fromJson(currentData));
//          print(SubLocation.fromJson(categoryMap[i].cast<String, dynamic>()));
        }
      }
    } catch (e) {
      print(e);
    }
  }
}
