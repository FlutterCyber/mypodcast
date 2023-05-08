import 'dart:core';
import 'dart:ui';
import 'package:ebook_app/controllers/visibility/language_visibility.dart';
import 'package:ebook_app/pages/crud/add_podcast_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconly/iconly.dart';

class AccountPage extends GetView {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LanguageVisibleController lvc = LanguageVisibleController();
    return Obx(() => Scaffold(
        backgroundColor: Color(0xffFBF8F2),
        appBar: AppBar(
          //elevation: 0,
          backgroundColor: Color(0xffFBF8F2),

          title: Text(
            "Account".tr,
            style: const TextStyle(
                fontSize: 20,
                color: Color(0xff2F2F2F),
                fontFamily: "PlayfairDisplay-VariableFont",
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    lvc.changeVisibility();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    child: Container(
                      height: Get.height * 0.08,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xffBFA054).withOpacity(0.8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              child: const Icon(
                                Icons.language,
                                size: 25,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              "Language".tr,
                              style: const TextStyle(
                                color: Color(0xff2F2F2F),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: "PlayfairDisplay-VariableFont",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.snackbar(
                      "Not available yet".tr,
                      "",
                      icon:
                          const Icon(IconlyBroken.danger, color: Colors.black),
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    child: Container(
                      height: Get.height * 0.08,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xffBFA054).withOpacity(0.8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              child: const Icon(
                                Icons.mode_night_outlined,
                                size: 25,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              child: Text(
                                "Mode".tr,
                                style: const TextStyle(
                                  color: Color(0xff2F2F2F),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "PlayfairDisplay-VariableFont",
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.snackbar(
                      "Not available yet".tr,
                      "",
                      icon:
                          const Icon(IconlyBroken.danger, color: Colors.black),
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    child: Container(
                      height: Get.height * 0.08,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xffBFA054).withOpacity(0.8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              child: const Icon(
                                Icons.mode_night_outlined,
                                size: 25,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              child: Text(
                                "History".tr,
                                style: const TextStyle(
                                  color: Color(0xff2F2F2F),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "PlayfairDisplay-VariableFont",
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                /// add podcast
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 10, bottom: 10),
                  child: Container(
                    height: Get.height * 0.08,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Color(0xff2F2F2F)),
                      color: Color(0xffF5EFE1),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: const Icon(
                              Icons.language,
                              size: 25,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: () async {
                              Get.to(AddPodcastPage());
                            },
                            child: Text(
                              "Add podcast".tr,
                              style: const TextStyle(
                                color: Color(0xff2F2F2F),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: "PlayfairDisplay-VariableFont",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Visibility(
                visible: lvc.isVisible.value,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: Stack(
                  children: [
                    Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.grey.withOpacity(0.4),
                      child: GestureDetector(
                        onTap: () {
                          lvc.changeVisibility();
                        },
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              var locale = const Locale('ru', 'RU');
                              Get.updateLocale(locale);
                              lvc.changeVisibility();
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(Get.width * 0.5, 50),
                              primary: Color(0xff2F2F2F),
                            ),
                            child: const Text(
                              "Russian",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              var locale1 = const Locale('en', 'US');
                              Get.updateLocale(locale1);
                             lvc.changeVisibility();
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(Get.width * 0.5, 50),
                              primary: Color(0xff2F2F2F),
                            ),
                            child:  const Text(
                              "English",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ],
        )));
  }
}
