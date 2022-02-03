import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';

class ImageSlider extends StatefulWidget {
  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int _index = 0;
  int _dataLenght = 1;

  @override
  void initState() {
    getSliderImageFromDb();
    super.initState();
  }

  Future getSliderImageFromDb() async {
    var _firestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await _firestore.collection('slider').get();
    if (mounted) {
      setState(() {
        _dataLenght = snapshot.docs.length;
      });
    }
    return snapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (_dataLenght != 0)
          FutureBuilder(
              future: getSliderImageFromDb(),
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
                                getImage['banner'],
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
    );
  }
}
