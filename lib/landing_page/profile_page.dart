import 'package:Ohstel_app/auth/methods/auth_methods.dart';
import 'package:Ohstel_app/landing_page/homepage.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        centerTitle: true,
        title: Text(
          "Profile",
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
      body: Body(),
    );
  }
}

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Column(
          children: [
            CircleAvatar(
                radius: 80,
                backgroundImage: NetworkImage(
                    "https://lh3.googleusercontent.com/EbZOTY-dQqmhIFqKIZjPSUVUpqn0T7JrUEuj8tTBZ2JP58HB8vEwv0tJ9Q1pR8tZVyRzgg=s85")),
            Text(
              "Timmy Adebola",
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(
              height: 40,
            ),
            Items(
              Icons.person,
              "Personal Details",
            ),
            Items(Icons.credit_card, "Card Details"),
            Items(Icons.lock_outline, "Privacy & Services"),
            Items(
              Icons.info_outline,
              "Legal",
            ),
            Divider(),
            Expanded(
              child: ListTile(
                leading: CircleAvatar(
                    radius: 37,
                    backgroundColor: Color(0xffebf1ef),
                    child: Icon(
                      Icons.exit_to_app,
                      color: Colors.black,
                      size: 30,
                    )),
                title: Text('Log Out'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () async {
                  await AuthService().signOut();
                  Navigator.pop(context);
                },
              ),
            ),
            Divider()
          ],
        ),
      ),
    );
  }
}

class Items extends StatefulWidget {
  final IconData _icon;
  final String _title;

  Items(
    this._icon,
    this._title,
  );

  @override
  _ItemsState createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  void _navigate() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Homepage()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Divider(),
          Expanded(
            child: ListTile(
              leading: CircleAvatar(
                  radius: 37,
                  backgroundColor: Color(0xffebf1ef),
                  child: Icon(
                    widget._icon,
                    color: Colors.black,
                    size: 30,
                  )),
              title: Text(widget._title),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                _navigate();
              },
            ),
          ),
        ],
      ),
    );
  }
}
