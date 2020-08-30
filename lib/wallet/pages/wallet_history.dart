import 'package:Ohstel_app/hostel_booking/_/model/wallet_history_model.dart';
import 'package:Ohstel_app/wallet/method.dart';
import 'package:flutter/material.dart';

class WalletHistory extends StatefulWidget {
  final String uid;
  WalletHistory(this.uid, {Key key}) : super(key: key);

  _WalletHistoryState createState() => _WalletHistoryState();
}

class _WalletHistoryState extends State<WalletHistory> {
  List<WalletHistoryModel> historys;
  @override
  void initState() {
    WalletMethods methods = WalletMethods(widget.uid);
    methods.fetchWalletHistory().then((data) {
      setState(() {
        historys = data;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //print(historys);
    return Scaffold(
        body: historys == null
            ? Center(child: CircularProgressIndicator())
            : Container(
                child: ListView.builder(
                  itemCount: historys.length,
                  itemBuilder: (context, index) {
                    return listHistory(historys[index]);
                  },
                ),
              ));
  }

  listHistory(WalletHistoryModel history) {
    return Card(
      child: Container(
        child: ListTile(
          leading: Icon(
            history.type == 'fund' ? Icons.add_circle : Icons.remove_circle,
            color: history.type == 'fund' ? Colors.green : Colors.red,
          ),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("NGN${history.amount.toString()}",
                  softWrap: true,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              SizedBox(
                height: 5,
              ),
              Text("NGN${history.balance.toString()}",
                  softWrap: true, style: TextStyle(fontSize: 12)),
            ],
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("${history.desc}(${history.type})",
                  softWrap: true,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(
                height: 5,
              ),
              Text("Date: ${history.date.toIso8601String()}",
                  softWrap: true, style: TextStyle(fontSize: 12))
            ],
          ),
        ),
      ),
    );
  }
}
