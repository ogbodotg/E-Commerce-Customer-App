import 'package:ahia/Providers/StoreProvider.dart';
import 'package:ahia/Services/ProductServices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductFilterWidget extends StatefulWidget {
  @override
  _ProductFilterWidgetState createState() => _ProductFilterWidgetState();
}

class _ProductFilterWidgetState extends State<ProductFilterWidget> {
  List _subCatList = [];
  ProductServices _services = ProductServices();

  @override
  void didChangeDependencies() {
    var _store = Provider.of<StoreProvider>(context);

    FirebaseFirestore.instance
        .collection('products')
        .where('category.mainCategory',
            isEqualTo: _store.selectedProductCategory)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          _subCatList.add(doc['category']['subCategory']);
        });
      });
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var _storeData = Provider.of<StoreProvider>(context);

    return FutureBuilder<DocumentSnapshot>(
      future: _services.category.doc(_storeData.selectedProductCategory).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (!snapshot.hasData) {
          return Container();
        }

        Map<String, dynamic> data = snapshot.data.data();
        return Container(
          height: 50,
          color: Colors.grey,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              SizedBox(width: 10),
              ActionChip(
                elevation: 4,
                label: Text('All ${_storeData.selectedProductCategory}'),
                onPressed: () {
                  _storeData.selectedCategorySub(null);
                },
                backgroundColor: Colors.white,
              ),
              ListView.builder(
                itemCount: data.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                physics: ScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: _subCatList
                            .contains(data['subCat'][index]['categoryName'])
                        ? ActionChip(
                            elevation: 4,
                            label: Text(data['subCat'][index]['categoryName']),
                            onPressed: () {
                              _storeData.selectedCategorySub(
                                  data['subCat'][index]['categoryName']);
                            },
                            backgroundColor: Colors.white,
                          )
                        : Container(),
                  );
                },
              )
            ],
          ),
        );
      },
    );
  }
}
