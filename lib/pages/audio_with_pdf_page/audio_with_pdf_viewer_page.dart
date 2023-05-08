import 'dart:developer';
import 'dart:ui';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:dio/dio.dart';
import 'package:ebook_app/controllers/parser/text_parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart' as rxdart;
import '../../controllers/music_payer/music_payer_controller.dart';
import '../../controllers/music_payer/music_position_data.dart';

class AudioWithPdfPage extends StatefulWidget {
  final String audioLink;
  final String title;
  final txtUrl;

  const AudioWithPdfPage({
    Key? key,
    required this.audioLink,
    required this.title,
    required this.txtUrl,
  }) : super(key: key);

  @override
  State<AudioWithPdfPage> createState() => _AudioWithPdfPageState();
}

class _AudioWithPdfPageState extends State<AudioWithPdfPage> {
  late PDFViewController controller;
  late AudioPlayer _audioPlayer;
  int pages = 0;
  int indexPage = 0;
  List<Chapters> chapters = [];
  bool isLoading = true;
  final _scrollController = ScrollController();

  void _scrollListener() {
    setState(() {});
  }

  Future<void> getChaptersText() async {
    Dio dio = Dio();
    final response = await dio.get(
      widget.txtUrl,
    );
    if (response.statusCode == 200) {
      setState(() {
        chapters.addAll(Chapters.parser(response.data));
        isLoading = false;
      });
    } else {
      log('Have arror');
    }
  }

  @override
  void initState() {
    super.initState();
    getChaptersText();
    _scrollController.addListener(_scrollListener);
    _audioPlayer = AudioPlayer()..setUrl(widget.audioLink);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _audioPlayer.dispose();
    super.dispose();
  }

  Stream<MusicPositionData> get _positionDataStream => rxdart.Rx.combineLatest3(
        _audioPlayer.positionStream,
        _audioPlayer.durationStream,
        _audioPlayer.bufferedPositionStream,
        (position, duration, bufferedPosition) => MusicPositionData(
          position: position,
          duration: duration,
          bufferedPosition: bufferedPosition,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final text = "${indexPage + 1} of $pages";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff2F2F2F),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            IconlyBroken.arrow_left,
            color: Color(0xffBFA054),
          ),
        ),
        title: Text(
          widget.title,
          style: const TextStyle(color: Color(0xffBFA054)),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 16, bottom: 140),
              child: StreamBuilder<MusicPositionData>(
                  stream: _positionDataStream,
                  builder: (context, snapshot) {
                    final data = snapshot.data ??
                        MusicPositionData(
                          position: Duration.zero,
                          duration: Duration.zero,
                          bufferedPosition: Duration.zero,
                        );
                    return CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        SliverList(
                          delegate:
                              SliverChildBuilderDelegate((context, index) {
                            bool isReading = false;
                            bool isReaded = false;
                            if (snapshot.data!.duration != null) {
                              Future.delayed(Duration.zero, () {
                                _scrollController.animateTo(
                                    chapters[index].start /
                                        snapshot.data!.duration!.inSeconds,
                                    duration: Duration.zero,
                                    curve: Curves.linear);
                              });
                            }
                            if (index != chapters.length - 1) {
                              if (data.position.inSeconds >
                                      chapters[index].start &&
                                  data.position.inSeconds <
                                      chapters[index + 1].start) {
                                isReading = true;
                              } else {
                                isReading = false;
                              }
                            } else {
                              if (data.duration != null) {
                                if (data.position.inSeconds >
                                        chapters[index].start &&
                                    data.position.inSeconds <
                                        data.duration!.inSeconds) {
                                  isReading = true;
                                } else {
                                  isReading = false;
                                }
                              }
                            }
                            if (data.position.inSeconds >
                                chapters[index].start) {
                              isReaded = true;
                            } else {
                              isReaded = false;
                            }
                            return textCard(
                              chapters[index],
                              () {
                                _audioPlayer.seek(
                                  Duration(
                                    seconds: chapters[index].start,
                                  ),
                                );
                              },
                              isReading,
                              isReaded,
                            );
                          }, childCount: chapters.length),
                        ),
                      ],
                    );
                  }),
            ),
      floatingActionButton: _audioPlayerWidget(),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
    );
  }

  Widget textCard(
      Chapters chapter, void Function() onTap, bool isReading, bool isReaded) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 24),
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          chapter.text.trim(),
          style: TextStyle(
            color: isReading
                ? const Color(0xffBFA054)
                : isReaded
                    ? Colors.black
                    : Colors.grey,
            fontSize: isReading ? 20 : 18,
            fontWeight: isReading ? FontWeight.w700 : FontWeight.w500,
          ),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }

  Widget _audioPlayerWidget() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(5), topRight: Radius.circular(5)),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaY: 10,
          sigmaX: 10,
        ),
        child: Container(
          height: Get.height * 0.2,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xff2F2F2F).withOpacity(0.2),
                const Color(0xff2F2F2F).withOpacity(0.2),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              StreamBuilder<MusicPositionData>(
                stream: _positionDataStream,
                builder: (context, snapshot) {
                  final positionData = snapshot.data;
                  return Padding(
                    padding: const EdgeInsets.only(right: 15, left: 15),
                    child: ProgressBar(
                      barHeight: 8,
                      baseBarColor: Colors.grey[600],
                      bufferedBarColor: Colors.grey,
                      progressBarColor: const Color(0xffFBF8F2),
                      thumbColor: const Color(0xffBFA054),
                      timeLabelTextStyle: const TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                      progress: positionData?.position ?? Duration.zero,
                      buffered: positionData?.bufferedPosition ?? Duration.zero,
                      total: positionData?.duration ?? Duration.zero,
                      onSeek: _audioPlayer.seek,
                    ),
                  );
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {

                          },
                          icon: const Icon(
                            IconlyBroken.arrow_left_circle,
                            size: 40,
                          ),
                        ),
                        Text("10 sec".tr),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MusicPlayerController(
                          audioplayer: _audioPlayer,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            IconlyBroken.arrow_right_circle,
                            size: 40,
                          ),
                        ),
                        Text("10 sec".tr),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
