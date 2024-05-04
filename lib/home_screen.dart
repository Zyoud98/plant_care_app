import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/services.dart';
import "lib.dart";

// InfoPage

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _pageController = PageController(initialPage: 0);

  final _controller = NotchBottomBarController(index: 0);

  int maxCount = 5;
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  final List<Widget> bottomBarPage = [
    const Page1(),
    const Page2(),
    const Page3(),
    const Page4(),
    const Page5(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 5,
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
          bottomBarPage.length,
          (index) => bottomBarPage[index],
        ),
      ),
      extendBody: true,
      bottomNavigationBar: (bottomBarPage.length <= maxCount)
          ? AnimatedNotchBottomBar(
              notchBottomBarController: _controller,
              color: const Color(0xFF426D53),
              showLabel: false,
              notchColor: const Color(0xFF426D53),
              removeMargins: false,
              bottomBarWidth: 600,
              durationInMilliSeconds: 300,
              bottomBarItems: const [
                const BottomBarItem(
                  inActiveItem: Icon(
                    Icons.home_filled,
                    color: Colors.grey,
                  ),
                  activeItem: Icon(
                    Icons.home_filled,
                    color: Colors.white,
                  ),
                  itemLabel: 'Page1',
                ),
                const BottomBarItem(
                  inActiveItem: Icon(
                    Icons.storage,
                    color: Colors.grey,
                  ),
                  activeItem: Icon(
                    Icons.storage,
                    color: Colors.white,
                  ),
                  itemLabel: 'Page2',
                ),
                const BottomBarItem(
                  inActiveItem: Icon(
                    Icons.add,
                    color: Colors.grey,
                  ),
                  activeItem: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  itemLabel: 'Page3',
                ),
                const BottomBarItem(
                  inActiveItem: Icon(
                    Icons.report,
                    color: Colors.grey,
                  ),
                  activeItem: Icon(
                    Icons.report,
                    color: Colors.white,
                  ),
                  itemLabel: 'Page4',
                ),
                const BottomBarItem(
                  inActiveItem: Icon(
                    Icons.settings,
                    color: Colors.grey,
                  ),
                  activeItem: Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                  itemLabel: 'Page5',
                ),
              ],
              onTap: (index) {
                log('current select index $index');
                _pageController.jumpToPage(index);
              },
              kIconSize: 25,
              kBottomRadius: 35,
            )
          : null,
    );
  }
}

class Page1 extends StatefulWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  @override
  Widget build(BuildContext context) {
    return PlantList();
  }
}

class Page2 extends StatefulWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  @override
  Widget build(BuildContext context) {
    return InfoPage();
  }
}

class Page3 extends StatefulWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  State<Page3> createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  List<Plant> Database = [];

  @override
  Widget build(BuildContext context) {
    return addList();
  }
}

class Page4 extends StatefulWidget {
  const Page4({Key? key}) : super(key: key);

  @override
  State<Page4> createState() => _Page4State();
}

class _Page4State extends State<Page4> {
  @override
  Widget build(BuildContext context) {
    return ReportProblemWidget();
  }
}

class Page5 extends StatefulWidget {
  const Page5({Key? key}) : super(key: key);

  @override
  State<Page5> createState() => _Page5State();
}

class _Page5State extends State<Page5> {
  @override
  Widget build(BuildContext context) {
    return buildSettingsUI(context);
  }
}
