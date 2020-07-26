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

  static void loadSubLocations() {
    try {
      subLocations = List<SubLocation>();
      var categoryMap = subLocationMap['subLocation'] as List;
      for (int i = 0; i < categoryMap.length; i++) {
        subLocations.add(SubLocation.fromJson(categoryMap[i]));
        print(SubLocation.fromJson(categoryMap[i]));
      }
    } catch (e) {
      print(e);
    }
  }
}

final Map subLocationMap = {
  'subLocation': [
    {
      'uni': 'Unilorin',
      'keyword': 'campus',
      'id': 1,
      'autocompleteTerm': 'Campus'
    },
    {
      'uni': 'Unilorin',
      'keyword': 'Unilorin',
      'id': 2,
      'autocompleteTerm': 'Unilorin Gate'
    },
    {
      'uni': 'Unilorin',
      'keyword': 'stella',
      'id': 3,
      'autocompleteTerm': 'Stella Maris'
    },
    {
      'uni': 'Unilorin',
      'keyword': 'oke',
      'id': 4,
      'autocompleteTerm': 'Oke Odo'
    },
    {
      'uni': 'Unilorin',
      'keyword': 'oke',
      'id': 5,
      'autocompleteTerm': 'Oke Oba'
    },
    {
      'uni': 'Unilorin',
      'keyword': 'sanrab',
      'id': 6,
      'autocompleteTerm': 'Sanrab'
    },
    {
      'uni': 'Unilorin',
      'keyword': 'mark',
      'id': 7,
      'autocompleteTerm': 'Mark',
    },
    {
      'uni': 'Unilorin',
      'keyword': 'tanke',
      'id': 8,
      'autocompleteTerm': 'Tanke Ajanaku'
    },
    {
      'uni': 'Unilorin',
      'keyword': 'tipper',
      'id': 9,
      'autocompleteTerm': 'Tipper Garage'
    },
    {
      'uni': 'Unilag',
      'keyword': 'akoka',
      'id': 10,
      'autocompleteTerm': 'Akoka'
    },
    {
      'uni': 'Unilag',
      'keyword': 'yaba',
      'id': 11,
      'autocompleteTerm': 'Yaba',
    },
    {
      'uni': 'Unilag',
      'keyword': 'onike',
      'id': 12,
      'autocompleteTerm': 'Onike'
    },
    {
      'uni': 'Lasu',
      'keyword': 'ojo',
      'id': 13,
      'autocompleteTerm': 'Ojo',
    },
    {
      'uni': 'Lasu',
      'keyword': 'ikotu',
      'id': 14,
      'autocompleteTerm': 'Ikotu',
    },
    {
      'uni': 'Lasu',
      'keyword': 'festac',
      'id': 15,
      'autocompleteTerm': 'Festac',
    },
    {
      'uni': 'Funaab',
      'keyword': 'oluwo',
      'id': 16,
      'autocompleteTerm': 'Oluwo Estate',
    },
    {
      'uni': 'Funaab',
      'keyword': 'isolu',
      'id': 17,
      'autocompleteTerm': 'Isolu',
    },
    {
      'uni': 'Funaab',
      'keyword': 'gate',
      'id': 18,
      'autocompleteTerm': 'Gate',
    },
    {
      'uni': 'Funaab',
      'keyword': 'camp',
      'id': 19,
      'autocompleteTerm': 'Camp',
    },
    {
      'uni': 'Funaab',
      'keyword': 'cele',
      'id': 20,
      'autocompleteTerm': 'Cele',
    },
    {
      'uni': 'KwaraPloy',
      'keyword': 'gate',
      'id': 21,
      'autocompleteTerm': 'Ploy Gate',
    },
    {
      'uni': 'KwaraPloy',
      'keyword': 'sango',
      'id': 22,
      'autocompleteTerm': 'Sango',
    },
    {
      'uni': 'KwaraPloy',
      'keyword': 'kulendu',
      'id': 23,
      'autocompleteTerm': 'Kulendu',
    },
    {
      'uni': 'KwaraPloy',
      'keyword': 'oyun',
      'id': 24,
      'autocompleteTerm': 'Oyun',
    },
    {
      'uni': 'KwaraPloy',
      'keyword': 'oke',
      'id': 25,
      'autocompleteTerm': 'Oke Osi',
    },
  ]
};
