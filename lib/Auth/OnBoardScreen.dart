import 'package:ahia/Helper/Constant.dart';
import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';

class OnBoardScreen extends StatefulWidget {
  @override
  _OnBoardScreenState createState() => _OnBoardScreenState();
}

final _controller = PageController(
  initialPage: 0,
);

int _currentPage = 0;

List<Widget> _pages = [
  Column(
    children: [
      Expanded(
          child:
              Icon(Icons.location_city, size: 450, color: Color(0xFF84c225))),
      Text(
        'Set your delivery location',
        style: kPageViewTextStyle,
        textAlign: TextAlign.center,
      )
    ],
  ),
  Column(
    children: [
      Expanded(child: Icon(Icons.store, size: 450, color: Colors.grey)),
      Text(
        'Order from your favourite store',
        style: kPageViewTextStyle,
        textAlign: TextAlign.center,
      )
    ],
  ),
  Column(
    children: [
      Expanded(
          child: Icon(Icons.wallet_giftcard, size: 450, color: Colors.red)),
      Text(
        'Quick delivery to your doorstep',
        style: kPageViewTextStyle,
        textAlign: TextAlign.center,
      )
    ],
  ),
];

class _OnBoardScreenState extends State<OnBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView(
            controller: _controller,
            children: _pages,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
          ),
        ),
        SizedBox(
          height: 20,
        ),
        DotsIndicator(
          dotsCount: _pages.length,
          position: _currentPage.toDouble(),
          decorator: DotsDecorator(
            activeColor: Theme.of(context).primaryColor,
            color: Colors.grey,
            size: const Size.square(9.0),
            activeSize: const Size(18.0, 9.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
