import 'package:ahia/Providers/StoreProvider.dart';
import 'package:ahia/Services/StoreServices.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VendorBanner extends StatefulWidget {
  @override
  _VendorBannerState createState() => _VendorBannerState();
}

class _VendorBannerState extends State<VendorBanner> {
  StoreServices _services = StoreServices();

  int _index = 0;
  int _dataLenght = 1;

  @override
  void didChangeDependencies() {
    var _storeProvider = Provider.of<StoreProvider>(context);
    getVendorBannerFromDb(_storeProvider);

    super.didChangeDependencies();
  }

  Future getVendorBannerFromDb(StoreProvider storeProvider) async {
    var _firestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await _firestore
        .collection('vendorBanner')
        .where('sellerUid', isEqualTo: storeProvider.storeDetails['uid'])
        .get();
    if (mounted) {
      setState(() {
        _dataLenght = snapshot.docs.length;
      });
    }
    return snapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    var _storeProvider = Provider.of<StoreProvider>(context);

    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          if (_dataLenght != 0)
            FutureBuilder(
                future: getVendorBannerFromDb(_storeProvider),
                builder: (_, snapShot) {
                  return snapShot.data == null
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 1.0),
                          child: CarouselSlider.builder(
                            itemCount: snapShot.data.length,
                            itemBuilder:
                                (BuildContext context, int itemIndex, index) {
                              DocumentSnapshot sliderImage =
                                  snapShot.data[itemIndex];
                              Map getImage = sliderImage.data();

                              return SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Image.network(
                                  getImage['bannerUrl'],
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                            options: CarouselOptions(
                                viewportFraction: 1,
                                initialPage: 0,
                                autoPlay: true,
                                height: 180,
                                onPageChanged:
                                    (int i, carouselPageChangedReason) {
                                  setState(() {
                                    _index = i;
                                  });
                                }),
                          ),
                        );
                }),
          if (_dataLenght != 0)
            DotsIndicator(
              dotsCount: _dataLenght,
              position: _index.toDouble(),
              decorator: DotsDecorator(
                activeColor: Theme.of(context).primaryColor,
                color: Colors.grey,
                size: const Size.square(5.0),
                activeSize: const Size(18.0, 5.0),
                activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
              ),
            ),
        ],
      ),
    );
  }
}
