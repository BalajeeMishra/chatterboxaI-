import 'dart:async';

import 'package:balajiicode/extensions/app_button.dart';
import 'package:balajiicode/extensions/extension_util/int_extensions.dart';
import 'package:balajiicode/extensions/extension_util/widget_extensions.dart';
import 'package:balajiicode/extensions/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../Constants/ImageConstant.dart';
import '../Model/AllGameModel.dart';
import 'ChooseWordScreen/PlayTabooScreen.dart';

class YoutubeVideoPlayerScreen extends StatefulWidget {
  final AllGameModel allGameModel;
  final int index;
  final String sessionId;
  final String gameName;

  YoutubeVideoPlayerScreen(
      this.allGameModel, this.index, this.sessionId, this.gameName);

  @override
  State<YoutubeVideoPlayerScreen> createState() =>
      _YoutubeVideoPlayerScreenState();
}

class _YoutubeVideoPlayerScreenState extends State<YoutubeVideoPlayerScreen> {
  YoutubePlayerController? _controller;

  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;

  bool _isPlayerReady = false;
  bool isVideoEnded = false;
  int _countdown = 5;
  Timer? _timer;
  String? videoId;

  @override
  void initState() {
    super.initState();
    videoId = YoutubePlayer.convertUrlToId(
        widget.allGameModel.allGame![widget.index].youtubeUrl ?? "");
    init();

  }

  init()async{
    if (videoId == null) {
      debugPrint("Invalid YouTube URL");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        PlayTabooScreen(
          widget.allGameModel,
          widget.index,
          Uuid().v4(),
          widget.gameName,
        ).launch(context);
      });
    } else {
      _controller = YoutubePlayerController(
        initialVideoId: videoId ?? "",
        flags: const YoutubePlayerFlags(
          mute: false,
          autoPlay: true,
          controlsVisibleAtStart: false,
          hideControls: true,
          hideThumbnail: true,
          disableDragSeek: false,
          loop: false,
          isLive: false,
          forceHD: true,
          enableCaption: false,
        ),
      )..addListener(listener);

      _videoMetaData = const YoutubeMetaData();
      _playerState = PlayerState.unknown;
    }
  }
  void listener() {
    if (videoId != null) {
      if (_isPlayerReady && mounted && !_controller!.value.isFullScreen) {
        setState(() {
          _playerState = _controller!.value.playerState;
          _videoMetaData = _controller!.metadata;
        });
      }
    }
    if (_controller!.value.playerState == PlayerState.ended) {
      _onVideoEnded();
    }
  }

  void _replayVideo() {
    if (_controller != null) {
      if (isVideoEnded) {
        print("Video is ended");
        setState(() {
          isVideoEnded = false;
        });
        _timer?.cancel();
        init();
      } else {
        print("Video is not ended yet.");
      }
    } else {
      print("Controller is null");
    }
  }

  void _closeVideo() async {
    _controller!.pause();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PlayTabooScreen(
                  widget.allGameModel,
                  widget.index,
                  Uuid().v4(),
                  widget.gameName,
                )));
  }

  @override
  void deactivate() {
    if (videoId != null) {
      _controller!.pause();
      super.deactivate();
    }
  }

  void _onVideoEnded() {
    setState(() {
      isVideoEnded = true;
      _startCountdown();
    });
  }

  void _startCountdown() {
    _countdown = 5;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          timer.cancel();
          _closeVideo();
        }
      });
    });
  }

  @override
  void dispose() {
    _controller!.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.white.withOpacity(0.1),
          centerTitle: false,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image(image: AssetImage(ImageConstant.backButtonIcon)),
          ),
          title: Text(widget.gameName),
          titleTextStyle: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w400, color: Colors.white),
        ),
        body:
        videoId != null ?Stack(
          children: [
            !isVideoEnded
                ? videoId != null
                    ? YoutubePlayer(
                        aspectRatio: MediaQuery.of(context).size.width /
                            MediaQuery.of(context).size.height,
                        controller: _controller!,
                        bottomActions: [
                          CurrentPosition(),
                          ProgressBar(isExpanded: true),
                        ],
                        onEnded: (metaData) {
                          setState(() {
                            isVideoEnded = true;
                          });
                          // _closeVideo();
                          print("Video     ended");
                        },
                      ).onTap(() {
                        setState(() {
                          if (_controller!.value.isPlaying) {
                            _controller!.pause();
                          } else {
                            _controller!.play();
                          }
                        });
                      }).center()
                    : Center(
                        child: Text(
                          "Invalid or no YouTube video available.",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                : SizedBox(),
            _controller!.value.isPlaying && !isVideoEnded
                ? Align(
                    alignment: Alignment.center,
                    child: IconButton(
                      icon: Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 70,
                      ),
                      onPressed: () {
                        setState(() {
                          if (_controller!.value.isPlaying) {
                            _controller!.pause();
                          } else {
                            _controller!.play();
                          }
                        });
                      },
                    ),
                  )
                : SizedBox(),
            isVideoEnded
                ? Align(
                    alignment: Alignment.center,
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.replay_rounded,
                            color: Colors.white,
                            size: 70,
                          ),
                          onPressed: () {
                            setState(() {
                              _replayVideo();
                            });
                          },
                        ),
                        15.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppButton(
                              shapeBorder: CircleBorder(),
                              onTap: _replayVideo,
                              color: Colors.white.withOpacity(0.1),
                              padding: EdgeInsets.zero,
                              height: 35,
                              // width: 160,
                              child: Text(
                                'Replay',
                                style: secondaryTextStyle(color: Colors.white),
                              ),
                            ),
                            10.width,
                            AppButton(
                              onTap: _closeVideo,
                              shapeBorder: CircleBorder(),
                              padding: EdgeInsets.zero,
                              height: 35,
                              width: 160,
                              child: Text(
                                'Practice Speaking',
                                style: secondaryTextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        18.height,
                        Text(
                          'Game Starts Automatically in $_countdown Seconds',
                          style:
                              secondaryTextStyle(color: Colors.white, size: 10),
                        )
                      ],
                    ),
                  )
                : SizedBox(),
          ],
        ):SizedBox(),
        floatingActionButton: !isVideoEnded
            ? AppButton(
                shapeBorder: CircleBorder(),
                onTap: _closeVideo,
                color: Colors.black.withOpacity(0.6),
                padding: EdgeInsets.zero,
                height: 35,
                width: 120,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.skip_next_rounded, color: Colors.white),
                    6.width,
                    Text(
                      'Skip Video',
                      style: secondaryTextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ).paddingBottom(70)
            : SizedBox());
  }
}
