import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/visibility/visibility_controller.dart';
import '../../book_info_page/book_info_page.dart';

class NotificationsWidget extends GetView {
  final CollectionReference _newest_podcasts =
      FirebaseFirestore.instance.collection("newest_podcasts");

  NotificationsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    VisibleController vv = Get.put(VisibleController());
    return Obx(
      () => Visibility(
        visible: vv.isVisible.value,
        maintainSize: true,
        maintainAnimation: true,
        maintainState: true,
        child: Padding(
          padding: const EdgeInsets.only(right: 15, left: 30),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(5),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaY: 10,
                sigmaX: 10,
              ),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xffffffff).withOpacity(0.3),
                      const Color(0xffffffff).withOpacity(0.3),
                    ],
                  ),
                  border: Border.all(color: const Color(0xffBFA054), width: 2),
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                ),
                child: StreamBuilder(
                  stream: _newest_podcasts.snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                    if (streamSnapshot.hasData) {
                      return ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: streamSnapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final DocumentSnapshot documentSnapshot =
                              streamSnapshot.data!.docs[index];
                          return _notificationsWidget(
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
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xffBFA054),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _notificationsWidget(
    String name,
    String duration,
    String imageLink,
    String pdfLink,
    String audioLink,
    String releaseDate,
    String synopsis,
    String details,
    String podcastId,
    String vocabularyLink,
    String txt,
  ) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Get.to(
          BookInfoPage(
            text: txt,
            name: name,
            duration: duration,
            imageLink: imageLink,
            pdfLink: pdfLink,
            audioLink: audioLink,
            releaseDate: releaseDate,
            synopsis: synopsis,
            details: details,
            podcastId: podcastId,
            vocabularyLink: vocabularyLink,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
                      Text(
                        duration,
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
                      const Text(
                        "Andrew Dalby",
                      ),
                    ],
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
