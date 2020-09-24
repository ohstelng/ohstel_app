import 'package:Ohstel_app/auth/methods/auth_methods.dart';
import 'package:Ohstel_app/explore/models/ticket.dart';
import 'package:Ohstel_app/explore/pages/ticket.dart';
import 'package:Ohstel_app/explore/widgets/circular_progress.dart';
import 'package:Ohstel_app/wallet/method.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ExplorePaymentPopUp extends StatefulWidget {
  final Ticket ticket;
  final Map userData;

  ExplorePaymentPopUp({
    @required this.ticket,
    @required this.userData,
  });

  @override
  _ExplorePaymentPopUpState createState() => _ExplorePaymentPopUpState();
}

class _ExplorePaymentPopUpState extends State<ExplorePaymentPopUp> {
  bool loading = false;

  addTicketToFirestore(Ticket ticket) async {
    CollectionReference userTicketsRef = FirebaseFirestore.instance
        .collection('explore')
        .doc('userTickets')
        .collection(widget.userData['uid']);

    try {
      await userTicketsRef.add({
        'id': ticket.id,
        'date': ticket.date.millisecondsSinceEpoch,
        'name': ticket.name,
        'email': ticket.email,
        'phone': ticket.phone,
        'university': ticket.university,
        'department': ticket.department ?? '',
        'locationName': ticket.locationName,
        'locationDuration': ticket.locationDuration,
        'scheduledDate': ticket.scheduledDate.millisecondsSinceEpoch,
        'scheduledTime': ticket.scheduledTime.millisecondsSinceEpoch,
        'numberOfTickets': ticket.numberOfTickets,
        'finalAmount': ticket.finalAmount,
        'userId': ticket.userId,
      });

      Fluttertoast.showToast(
        msg: 'Sent Sucessfully!!',
        gravity: ToastGravity.CENTER,
      );

      // pop payment dialog
      Navigator.pop(context);

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => TicketScreen(ticket)));
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'An Error Occured :(',
        gravity: ToastGravity.CENTER,
      );
    }
  }

  Future<void> validateUser({@required String password}) async {
    // Map userDate = await HiveMethods().getUserData();

    await AuthService()
        .loginWithEmailAndPassword(
      email: widget.userData['email'],
      password: password,
    )
        .then((value) async {
      print(value);
      print('vvvvvvvvvvvvvvvvv');
      if (value != null) {
        await pay();
      }
    });
  }

  Future<void> pay() async {
    int result = await WalletMethods().deductWallet(
      amount: widget.ticket.finalAmount.toDouble(),
      payingFor: '${widget..ticket.name} ticket',
      itemId: widget.ticket.id,
    );
    if (result == 0) {
      addTicketToFirestore(widget.ticket);
    }
  }

  @override
  Widget build(BuildContext context) {
    String password;
    return Container(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'The Sum Of NGN ${widget.ticket.finalAmount} '
              'Will Be Deducted From Your Wallet Balance!',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter Your Password',
              ),
              obscureText: true,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              onChanged: (val) {
                password = val;
              },
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                loading
                    ? CustomCircularProgress()
                    : FlatButton(
                        onPressed: () async {
                          setState(() {
                            loading = true;
                          });
                          await validateUser(password: password);
                          setState(() {
                            loading = false;
                          });
                        },
                        child: Text('Proceed'),
                        color: Colors.green,
                      ),
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                  color: Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
