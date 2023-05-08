import 'dart:ui';
import 'package:ebook_app/pages/account_page/account_page.dart';
import 'package:ebook_app/pages/bookmark_page/bookmark_page.dart';
import 'package:ebook_app/pages/books_page/books_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

import '../home_page/home_page.dart';

class NavBarWidget extends StatefulWidget {
  static const String id = "nav_bar_widget";

  const NavBarWidget({Key? key}) : super(key: key);

  @override
  State<NavBarWidget> createState() => _NavBarWidgetState();
}

class _NavBarWidgetState extends State<NavBarWidget> {
  int currentIndex = 0;
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: PageView(
        controller: pageController,
        children: [
          HomePage(),
          BooksPage(),
          BookmarkPage(),
          AccountPage(),
        ],
        onPageChanged: (int index) {
          setState(
            () {
              currentIndex = index;
            },
          );
        },
      ),
      floatingActionButton: navBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  /// bottom navigation bar widget
  Widget navBar() {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5), topRight: Radius.circular(5)),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaY: 10,
          sigmaX: 10,
        ),
        child: Container(
          height: Get.height * 0.07,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xffffffff).withOpacity(0.3),
                const Color(0xffffffff).withOpacity(0.3),
              ],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ///1
              TextButton(onPressed: (){
                setState(() {
                  pageController.jumpToPage(0);
                  currentIndex = 0;
                });
              }, child: Icon(
                currentIndex == 0 ? IconlyBold.home : IconlyLight.home,
                color: currentIndex == 0 ? Color(0xff2F2F2F) : Colors.grey,
                size: currentIndex == 0 ? 30 : 28,
              )),
              ///2
              TextButton(onPressed: (){
                setState(() {
                  pageController.jumpToPage(1);
                  currentIndex = 1;
                });
              }, child: Icon(
                currentIndex == 1 ? IconlyBold.category : IconlyLight.category,
                color: currentIndex == 1 ? Color(0xff2F2F2F) : Colors.grey,
                size: currentIndex == 1 ? 30 : 28,
              )),
              ///3
              TextButton(onPressed: (){
                setState(() {
                  pageController.jumpToPage(2);
                  currentIndex = 2;
                });
              }, child: Icon(
                currentIndex == 2
                    ? IconlyBold.bookmark
                    : IconlyLight.bookmark,
                color: currentIndex == 2 ? Color(0xff2F2F2F) : Colors.grey,
                size: currentIndex == 2 ? 30 : 28,
              )),
              ///4
              TextButton(onPressed: (){
                setState(() {
                  pageController.jumpToPage(3);
                  currentIndex = 3;
                });
              }, child: Icon(
                currentIndex == 3 ? IconlyBold.profile : IconlyLight.profile,
                color: currentIndex == 3 ? Color(0xff2F2F2F) : Colors.grey,
                size: currentIndex == 3 ? 30 : 28,
              )),
              // GestureDetector(
              //   onTap: () {
              //     setState(() {
              //       pageController.jumpToPage(0);
              //       currentIndex = 0;
              //     });
              //   },
              //   child: Icon(
              //     currentIndex == 0 ? IconlyBold.home : IconlyLight.home,
              //     color: currentIndex == 0 ? Color(0xff2F2F2F) : Colors.grey,
              //     size: currentIndex == 0 ? 30 : 28,
              //   ),
              // ),
              // GestureDetector(
              //   onTap: () {
              //     setState(() {
              //       pageController.jumpToPage(1);
              //       currentIndex = 1;
              //     });
              //   },
              //   child: Icon(
              //     currentIndex == 1 ? IconlyBold.category : IconlyLight.category,
              //     color: currentIndex == 1 ? Color(0xff2F2F2F) : Colors.grey,
              //     size: currentIndex == 1 ? 30 : 28,
              //   ),
              // ),
              // GestureDetector(
              //   onTap: () {
              //     setState(() {
              //       pageController.jumpToPage(2);
              //       currentIndex = 2;
              //     });
              //   },
              //   child: Icon(
              //     currentIndex == 2
              //         ? IconlyBold.bookmark
              //         : IconlyLight.bookmark,
              //     color: currentIndex == 2 ? Color(0xff2F2F2F) : Colors.grey,
              //     size: currentIndex == 2 ? 30 : 28,
              //   ),
              // ),
              // GestureDetector(
              //   onTap: () {
              //     setState(() {
              //       pageController.jumpToPage(3);
              //       currentIndex = 3;
              //     });
              //   },
              //   child: Icon(
              //     currentIndex == 3 ? IconlyBold.profile : IconlyLight.profile,
              //     color: currentIndex == 3 ? Color(0xff2F2F2F) : Colors.grey,
              //     size: currentIndex == 3 ? 30 : 28,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
