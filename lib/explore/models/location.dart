class ExploreLocation {
  final String category;
  final int dateAdded;
  final String description;
  final String id;
  final String imageUrl;
  final String name;
  final int price;
  final String uniName;
  final String address;
  final int duration;

  ExploreLocation(
      {this.category,
      this.dateAdded,
      this.description,
      this.id,
      this.imageUrl,
      this.name,
      this.price,
      this.uniName,
      this.address,
      this.duration});

  factory ExploreLocation.fromDoc(Map<String, dynamic> doc) {
    return ExploreLocation(
      category: doc['category'],
      dateAdded: doc['dateAdded'],
      description: doc['description'],
      id: doc['id'],
      imageUrl: doc['imageUrl'],
      name: doc['name'],
      price: doc['price'],
      uniName: doc['uniName'],
      address: doc['address'],
      duration: doc['duration'],
    );
  }
}
