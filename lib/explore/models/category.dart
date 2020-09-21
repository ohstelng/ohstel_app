class ExploreCategory {
  final String imageUrl;
  final String name;
  ExploreCategory({this.name, this.imageUrl});

  factory ExploreCategory.fromDocs(Map<String, dynamic> mapData) {
    return ExploreCategory(
      name: mapData['name'],
      imageUrl: mapData['imageUrl'],
    );
  }
}
