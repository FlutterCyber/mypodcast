import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:super_rich_text/super_rich_text.dart';
import '../../controllers/pdf_opener/pdf_opener.dart';
import '../../services/hive_database.dart';
import '../audio_with_pdf_page/audio_with_pdf_viewer_page.dart';
import '../pdf_viewer_page/pdf_viewer_page.dart';

class BookInfoPage extends StatefulWidget {
  String? name;
  String? duration;
  String? imageLink;
  String? pdfLink;
  String? audioLink;
  String? releaseDate;
  String? synopsis;
  String? details;
  String? podcastId;
  String? text;
  final vocabularyLink;

  BookInfoPage(
      {Key? key,
      required this.name,
      required this.duration,
      required this.imageLink,
      required this.pdfLink,
      required this.audioLink,
      required this.releaseDate,
      required this.synopsis,
      required this.details,
      required this.podcastId,
      required this.text,
      required this.vocabularyLink})
      : super(key: key);

  @override
  State<BookInfoPage> createState() => _BookInfoPageState();
}

class _BookInfoPageState extends State<BookInfoPage> {
  var complated = true.obs;
  List listVocabulary = [];
  String text = '';
  bool loading = true;

  Future<void> getVocabularyText() async {
    Dio dio = Dio();
    final response = await dio.get(
      widget.vocabularyLink.toString(),
    );

    if (response.statusCode == 200) {
      setState(() {
        text = response.data;
        listVocabulary.addAll(text.split(";"));
        loading = false;
      });
      print(
          "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<$listVocabulary>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    } else {
      print('Have error');
    }
  }

  @override
  void initState() {
    getVocabularyText();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Container(
        color: Color(0xffBFA054),
        child: const Center(
          child: CircularProgressIndicator(
            color: Colors.black,
          ),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: const Color(0xffFBF8F2),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xffFBF8F2),
          leading: IconButton(
            icon: const Icon(
              IconlyBroken.arrow_left,
              color: Color(0xff2F2F2F),
            ),
            onPressed: () {
              Get.back();
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(IconlyBroken.bookmark, color: Color(0xff2F2F2F)),
              onPressed: () async {
                HiveDatabase.saveId(widget.podcastId!);
                print("SAVED: ${await HiveDatabase.getId(widget.podcastId!)}");
                Get.snackbar(
                  "Added to bookmarks".tr,
                  "You can listen this podcast in bookmark page".tr,
                  icon: const Icon(IconlyBroken.bookmark, color: Colors.black),
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),
          ],
          title: Text(
            "Podcast Info".tr,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: Get.width,
                  height: Get.height * 0.28,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage(widget.imageLink!),
                        fit: BoxFit.cover,
                      )),
                ),
                const SizedBox(
                  height: 25,
                ),
                Text(
                  widget.name!,
                  style: const TextStyle(
                      fontSize: 22,
                      color: Color(0xff2F2F2F),
                      fontFamily: "PlayfairDisplay-VariableFont",
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "By Michael Crudden",
                      style: TextStyle(
                        fontSize: 17,
                        color: Color(0xff2F2F2F),
                      ),
                    ),
                    Text(
                      widget.duration!,
                      style: const TextStyle(
                          fontSize: 18,
                          color: Color(0xff2F2F2F),
                          fontFamily: "PlayfairDisplay-VariableFont",
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                  child: Center(
                    child: Text(
                      "Vocabulary".tr,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: "PlayfairDisplay-VariableFont",
                          color: Color(0xffBFA054)),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: listVocabulary.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.all(8),
                        width: Get.width * 0.27,
                        child: SuperRichText(
                          useGlobalMarkers: false,
                          text: listVocabulary[index],
                          maxLines: 2,
                          othersMarkers: [
                            MarkerText(
                              marker: "//",
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xffBFA054)),
                            )
                          ],
                        ),
                      ).paddingOnly(bottom: 5);
                    },
                  ).paddingOnly(bottom: 50),
                )
              ],
            ).paddingOnly(right: 15, left: 15, top: 10, bottom: 10),
            Obx(
              () => Container(
                child: complated.value
                    ? const SizedBox.shrink()
                    : const Center(
                        child: CircularProgressIndicator(
                        color: Color(0xffBFA054),
                      )),
              ),
            ),
          ],
        ),
        floatingActionButton: _bookInfoNavBar(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      );
    }
  }

  /// nav bar for these pages => for "Start  Reading" and "Play Audio" buttons
  Widget _bookInfoNavBar() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(5), topRight: Radius.circular(5)),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaY: 10,
          sigmaX: 10,
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 15, left: 15, bottom: 10),
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
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      complated.value = false;
                      PDFOpener.url = widget.pdfLink;
                      Get.to(
                        PDFViewerPage(
                          file: await PDFOpener.openMe(),
                        ),
                      );
                      complated.value = true;
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: const Color(0xffBFA054),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.book),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Start Reading".tr,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      Get.to(
                        AudioWithPdfPage(
                          title: widget.name ?? "",
                          txtUrl:
                              'https://firebasestorage.googleapis.com/v0/b/fluttuzlogin.appspot.com/o/test_files%2Fleonardo.txt?alt=media&token=7a9e9efe-7ae7-429f-8649-818c91e76a32',
                          audioLink: await widget.audioLink.toString(),
                        ),
                      );
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: const Color(0xff2F2F2F),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            IconlyBroken.play,
                            color: Color(0xffFBF8F2),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Play Audio".tr,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xffFBF8F2),
                            ),
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
      ),
    );
  }
}
