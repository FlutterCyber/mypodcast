import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import '../../services/hive_database.dart';
import '../book_info_page/book_info_page.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({Key? key}) : super(key: key);

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  /// for firebase database table
  final CollectionReference newest_podcasts =
      FirebaseFirestore.instance.collection("newest_podcasts");

  @override
  Widget build(BuildContext context) {
    /// for getting all ids
    Iterable<String> ids = HiveDatabase.getAllId();

    return Scaffold(
      backgroundColor: Color(0xffFBF8F2),
      appBar: AppBar(
        // elevation: 0,
        backgroundColor: Color(0xffFBF8F2),
        actions: [
          IconButton(
            icon: const Icon(IconlyBroken.search, color: Color(0xff2F2F2F)),
            onPressed: () {
              Get.snackbar(
                "Not available yet".tr,
                "",
                icon: const Icon(IconlyBroken.danger, color: Colors.black),
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
        ],
        title: Text(
          "Bookmarks".tr,
          style: const TextStyle(
              fontSize: 20,
              color: Color(0xff2F2F2F),
              fontFamily: "PlayfairDisplay-VariableFont",
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ids.isNotEmpty
          ? StreamBuilder(
              stream: newest_podcasts
                  .where(FieldPath.documentId, whereIn: ids)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: streamSnapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot =
                          streamSnapshot.data!.docs[index];

                      return _markedBooks(
                        "${documentSnapshot["name"]}",
                        "${documentSnapshot["duration"]}",
                        "${documentSnapshot["imageLink"]}",
                        "${documentSnapshot["pdfLink"]}",
                        "${documentSnapshot["audioLink"]}",
                        "${documentSnapshot["releaseDate"]}",
                        "${documentSnapshot["synopsis"]}",
                        "${documentSnapshot["details"]}",
                        documentSnapshot.id,
                        "${documentSnapshot["textLink"]}",
                        "${documentSnapshot["vocabularyLink"]}",
                      );
                    },
                  );
                }
                return Center(
                  child: Text('Empty bookmarks'.tr),
                );
              },
            )
          : Center(child: Text('Empty bookmarks'.tr)),
    );
  }

  Widget _markedBooks(
    String name,
    String duration,
    String imageLink,
    String pdfLink,
    String audioLink,
    String releaseDate,
    String synopsis,
    String details,
    String podcastId,
    String txt,
    String vocabularyLink,
  ) {
    return GestureDetector(
      onTap: () {
        Get.to(
          BookInfoPage(
            name: name,
            duration: duration,
            imageLink: imageLink,
            pdfLink: pdfLink,
            audioLink: audioLink,
            releaseDate: releaseDate,
            synopsis: synopsis,
            details: details,
            podcastId: podcastId,
            text: txt,
            vocabularyLink: vocabularyLink,
          ),
        );
      },
      child: Padding(
        padding:
            const EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 10),
        child: ClipRRect(
          child: Container(
            child: Row(
              children: [
                Container(
                  height: 65,
                  width: 60,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(imageLink), fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xff2F2F2F),
                          fontWeight: FontWeight.bold,
                          fontFamily: "PlayfairDisplay-VariableFont",
                        ),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Row(
                        children: const [
                          Icon(
                            IconlyBroken.star,
                            size: 17,
                          ),
                          Icon(
                            IconlyBroken.star,
                            size: 17,
                          ),
                          Icon(
                            IconlyBroken.star,
                            size: 17,
                          ),
                          Icon(
                            IconlyBroken.star,
                            size: 17,
                          ),
                          Icon(
                            IconlyBroken.star,
                            size: 17,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    onPressed: () async {
                      await HiveDatabase.deleteId(podcastId);
                      setState(
                        () {},
                      );
                    },
                    icon: const Icon(IconlyBroken.delete),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
