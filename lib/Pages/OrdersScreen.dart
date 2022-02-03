import 'package:ahia/Providers/OrderProvider.dart';
import 'package:ahia/Services/OrderServices.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  OrderServices _orderServices = OrderServices();
  User user = FirebaseAuth.instance.currentUser;

  int tag = 0;
  List<String> options = [
    'All Orders',
    'Ordered',
    'Accepted',
    'Picked Up',
    'On the way',
    'Delivered',
    'Rejected',
  ];

  @override
  Widget build(BuildContext context) {
    var _orderProvider = Provider.of<OrderProvider>(context);
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
          title: Text('My Orders', style: TextStyle(color: Colors.white)),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(CupertinoIcons.search, color: Colors.white),
              onPressed: () {},
            )
          ]),
      body: Column(
        children: [
          Container(
            height: 56,
            width: MediaQuery.of(context).size.width,
            child: ChipsChoice<int>.single(
              value: tag,
              onChanged: (val) {
                if (val == 0) {
                  setState(() {
                    _orderProvider.status = null;
                  });
                }
                setState(() {
                  tag = val;
                  _orderProvider.status = options[val];
                });
              },
              choiceItems: C2Choice.listFrom<int, String>(
                source: options,
                value: (i, v) => i,
                label: (i, v) => v,
              ),
            ),
          ),
          Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: _orderServices.orders
                  .where('userId', isEqualTo: user.uid)
                  .where('orderStatus',
                      isEqualTo: tag > 0 ? _orderProvider.status : null)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.data.size == 0) {
                  return Center(
                    child: Text(tag > 0
                        ? '${options[tag]} category is empty'
                        : 'You have no order. Buy something today...'),
                  );
                }

                return Expanded(
                  child: new ListView(
                    children:
                        snapshot.data.docs.map((DocumentSnapshot document) {
                      return new Container(
                          color: Colors.white,
                          child: Column(children: [
                            ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 14,
                                child: _orderServices.statusIcon(
                                    document, context),
                              ),
                              title: Text(document.data()['orderStatus'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: _orderServices.statusColour(
                                        document, context),
                                    fontWeight: FontWeight.bold,
                                  )),
                              subtitle: Text(
                                  'On ${DateFormat.yMMMd().format(
                                    DateTime.parse(
                                        document.data()['timestamp']),
                                  )}',
                                  style: TextStyle(fontSize: 12)),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                      'Amount: \NGN${document.data()['total'].toStringAsFixed(0)}',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                      'Payment Method: ${document.data()['cod'] == true ? 'Cash on delivery' : 'Online payment'}',
                                      style: TextStyle(
                                        fontSize: 12,
                                      )),
                                ],
                              ),
                            ),
                            // Delivery boy contact area goes here
                            if (document.data()['deliveryBoy']['name'].length >
                                2)
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, right: 8),
                                child: ListTile(
                                  tileColor: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(.5),
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: document.data()['deliveryBoy']
                                                ['image'] ==
                                            null
                                        ? Container()
                                        : Image.network(
                                            document.data()['deliveryBoy']
                                                ['image'],
                                            height: 24),
                                  ),
                                  title: Text(
                                      document.data()['deliveryBoy']['name']),
                                  subtitle: Text(
                                      _orderServices.statusComment(document)),
                                ),
                              ),
                            ExpansionTile(
                              title: Text(
                                'Order details',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black),
                              ),
                              subtitle: Text(
                                'view order details',
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return ListTile(
                                      leading: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: Image.network(
                                              document.data()['products'][index]
                                                  ['productImage'])),
                                      title: Text(document.data()['products']
                                          [index]['productName']),
                                      subtitle: Text(
                                          'NGN${document.data()['products'][index]['price'].toStringAsFixed(0)} x qty (${document.data()['products'][index]['quantity']}) = ${document.data()['products'][index]['total'].toStringAsFixed(0)},',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12)),
                                    );
                                  },
                                  itemCount: document.data()['products'].length,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12, right: 12, top: 8, bottom: 8),
                                  child: Card(
                                    elevation: 4,
                                    // color: Theme.of(context)
                                    //     .primaryColor
                                    //     .withOpacity(.6),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(children: [
                                        Row(children: [
                                          Text('Seller: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12)),
                                          Text(
                                            document.data()['seller']
                                                ['shopName'],
                                            style: (TextStyle(fontSize: 12)),
                                          )
                                        ]),
                                        SizedBox(height: 10),
                                        if (int.parse(
                                                document.data()['discount']) >
                                            0)
                                          Column(children: [
                                            Row(children: [
                                              Text('Discount: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12)),
                                              Text(
                                                '\NGN${document.data()['discount']}',
                                              )
                                            ]),
                                            SizedBox(height: 10),
                                            Row(children: [
                                              Text('Discount Code: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12)),
                                              Text(
                                                  '${document.data()['discountCode']}',
                                                  style:
                                                      TextStyle(fontSize: 12))
                                            ])
                                          ]),
                                        SizedBox(height: 10),
                                        Row(children: [
                                          Text('Delivery Fee: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12)),
                                          Text(
                                              'NGN${document.data()['deliveryFee'].toString()}',
                                              style: TextStyle(fontSize: 12))
                                        ])
                                      ]),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Divider(height: 3, color: Colors.grey)
                          ]));
                    }).toList(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
