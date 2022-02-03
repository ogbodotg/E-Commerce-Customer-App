import 'package:ahia/Helper/Constant.dart';
import 'package:ahia/Services/StoreServices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class NearByStores extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    StoreServices _storeServices = StoreServices();
    PaginateRefreshedChangeListener refreshedChangeListener =
        PaginateRefreshedChangeListener();

    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: _storeServices.getStores(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapShot) {
          if (!snapShot.hasData) return CircularProgressIndicator();
          return Padding(
            padding: EdgeInsets.all(8),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              RefreshIndicator(
                child: PaginateFirestore(
                  bottomLoader: SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor)),
                  ),
                  header: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 8, right: 8, top: 20),
                          child: Text('Featured Stores',
                              style: TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 18)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8, right: 8, bottom: 20),
                          child: Text('Buy Nigerian... Grow Nigeria',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey)),
                        ),
                      ]),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilderType: PaginateBuilderType.listView,
                  itemBuilder: (index, context, document) => Padding(
                    padding: const EdgeInsets.all(4),
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                  width: 100,
                                  height: 110,
                                  child: Card(
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          child: Image.network(
                                            document['shopImage'],
                                            fit: BoxFit.cover,
                                          )))),
                              SizedBox(width: 10),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      document.data()['shopName'],
                                      style: storeCardStyle,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width - 250,
                                    child: Text(
                                      document.data()['shopAddress'],
                                      overflow: TextOverflow.ellipsis,
                                      style: storeCardStyle,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    document.data()['shopCity'] +
                                        ' - ' +
                                        document.data()['shopState'],
                                    style: storeCardStyle,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 3),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        size: 12,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(width: 3),
                                      Text(
                                        '3.2',
                                        style: storeCardStyle,
                                      )
                                    ],
                                  )
                                ],
                              )
                            ])),
                  ),
                  query: _storeServices.getStoresPagination(),
                  listeners: [
                    refreshedChangeListener,
                  ],
                  footer: Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Container(
                      child: Stack(
                        children: [
                          Center(
                            child: Text('***'),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                onRefresh: () async {
                  refreshedChangeListener.refreshed = true;
                },
              )
            ]),
          );
        },
      ),
    );
  }
}
