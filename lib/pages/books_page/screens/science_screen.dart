import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../book_info_page/book_info_page.dart';

class ScienceScreen extends StatelessWidget {
  final CollectionReference _newest_podcasts =
      FirebaseFirestore.instance.collection("newest_podcasts");

  ScienceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFBF8F2),
      body: Padding(
        padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
        child: StreamBuilder(
          stream: _newest_podcasts.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return GridView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];
                  return _buildPodcastCard(
                    "${documentSnapshot["name"]}",
                    "${documentSnapshot["duration"]}",
                    "${documentSnapshot["imageLink"]}",
                    "${documentSnapshot["pdfLink"]}",
                    "${documentSnapshot["audioLink"]}",
                    "${documentSnapshot["releaseDate"]}",
                    "${documentSnapshot["synopsis"]}",
                    "${documentSnapshot["details"]}",
                    "${documentSnapshot.id}",
                    "${documentSnapshot["textLink"]}",
                    "${documentSnapshot["vocabularyLink"]}",
                  );
                },
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.64,
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPodcastCard(
      String name,
      String duration,
      String imageLink,
      String pdfLink,
      String audioLink,
      String releaseDate,
      String synopsis,
      String details,
      String podcastId,
      String text,
      String vocabularyLink,
      ) {
    return GestureDetector(
      onTap: () {
        Get.to(
          BookInfoPage(
            text: text,
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
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xffF5EFE1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  image: DecorationImage(
                    image: NetworkImage(imageLink),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              name,
              style: const TextStyle(
                  color: Color(0xff2F2F2F),
                  fontFamily: "PlayfairDisplay-VariableFont",
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 3,
            ),
            const Text(
              "By Michael Crudden",
              style: TextStyle(fontSize: 10),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              // crossAxisAlignment: CrossAxisAlignment.spa,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  duration,
                  style: const TextStyle(
                      color: Color(0xff2F2F2F),
                      fontFamily: "PlayfairDisplay-VariableFont",
                      fontWeight: FontWeight.bold),
                ),
                Container(
                  padding:
                      EdgeInsets.only(top: 3, bottom: 3, left: 15, right: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Color(0xff2F2F2F),
                  ),
                  child: const Text(
                    "Listen",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
