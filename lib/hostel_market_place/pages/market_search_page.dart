import 'package:flutter/material.dart';

class MarketSearchPage extends StatefulWidget {
  @override
  _MarketSearchPageState createState() => _MarketSearchPageState();
}

class _MarketSearchPageState extends State<MarketSearchPage> {
  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();
//  List<HostelModel> searchList = [];
  String query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
