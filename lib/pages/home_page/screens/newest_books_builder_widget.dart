import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebook_app/pages/book_info_page/book_info_page.dart';
import 'package:ebook_app/services/hive_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

class NewestBooksBuilderWidget extends StatelessWidget {
  PageController controller;

  NewestBooksBuilderWidget({Key? key, required this.controller})
      : super(key: key);

  final CollectionReference _newest_podcasts =
      FirebaseFirestore.instance.collection("newest_podcasts");
  HiveDatabase hiveDatabase = new HiveDatabase();

  /// newest books builder widget
  @override
  Widget build(BuildContext context) {

    return SliverAppBar(
      backgroundColor: Color(0xffF5EFE1),
      expandedHeight: 300,
      floating: false,
      pinned: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: const EdgeInsets.all(15.0),
          child: StreamBuilder(
            stream: _newest_podcasts.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.hasData) {
                return PageView.builder(
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot =
                        streamSnapshot.data!.docs[index];
                    return _newestBooksView(
                      "${documentSnapshot["name"]}",
                      "${documentSnapshot["duration"]}",
                      "${documentSnapshot["textLink"]}",
                      "${documentSnapshot["imageLink"]}",
                      "${documentSnapshot["pdfLink"]}",
                      "${documentSnapshot["audioLink"]}",
                      "${documentSnapshot["releaseDate"]}",
                      "${documentSnapshot["synopsis"]}",
                      "${documentSnapshot["details"]}",
                      "${documentSnapshot["vocabularyLink"]}",
                      "${documentSnapshot.id}",

                    );
                  },
                  controller: controller,
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }

  /// newest books view widget
  Widget _newestBooksView(
      String name,
      String duration,
      String txt,
      String imageLink,
      String pdfLink,
      String audioLink,
      String releaseDate,
      String synopsis,
      String details,
      String vocabularyLink,
      String podcastId) {
    return Stack(
      children: [
        /// this container created for image
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black54,
            image: DecorationImage(
              image: NetworkImage(imageLink),
              fit: BoxFit.cover,
            ),
          ),
          // child: Image.network("${documentSnapshot["details"]}"),
        ),

        /// This gesture detector routes to Book Info Page
        GestureDetector(
          onTap: () {
            Get.to(BookInfoPage(
              name: name,
              text: txt,
              duration: duration,
              imageLink: imageLink,
              pdfLink: pdfLink,
              audioLink: audioLink,
              releaseDate: releaseDate,
              synopsis: synopsis,
              details: details,
              podcastId: podcastId,
              vocabularyLink: vocabularyLink,
            ));
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              //color: Colors.black54,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: EdgeInsets.only(right: 8, left: 8),
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Color(0xffFBF8F2),
                                      fontSize: 15,
                                      fontFamily:
                                          "PlayfairDisplay-VariableFont",
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          IconlyBold.play,
                                          color: Color(0xffFBF8F2),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          duration,
                                          style: const TextStyle(
                                            color: Color(0xffFBF8F2),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: const [
                                        Icon(
                                          IconlyBroken.arrow_right_circle,
                                          color: Color(0xffFBF8F2),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "Andrew Dalby",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Color(0xffFBF8F2),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        /// this button routes to Bookmark page
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: EdgeInsets.only(right: 8, left: 8),
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                      //border: Border.all(width: 1,color: Colors.white30)
                    ),
                    child: Center(
                      child: GestureDetector(
                        onTap: () async {
                          HiveDatabase.saveId(podcastId);
                          print(
                              "SAVED: ${await HiveDatabase.getId(podcastId)}");
                          Get.snackbar(
                            "Added to bookmarks".tr,
                            "You can listen this podcast in bookmark page".tr,
                            icon: const Icon(IconlyBroken.bookmark,
                                color: Colors.black),
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        },
                        child: const Icon(
                          IconlyBroken.bookmark,
                          color: Colors.black,
                          //Color(0xffFBF8F2),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
