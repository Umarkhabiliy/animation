import 'dart:async';

import 'package:animate_icons/animate_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class AnimationPractise extends StatefulWidget {
  const AnimationPractise({Key? key}) : super(key: key);

  @override
  _AnimationPractiseState createState() => _AnimationPractiseState();
}

class _AnimationPractiseState extends State<AnimationPractise>
    with TickerProviderStateMixin {
  bool isAnimated = false;
  Timer? timer;
  int _start = 0;
  double _width = 0;

  startTimer() async {
    final deviceWidth = MediaQuery.of(context).size.width;
    final onPeriod = deviceWidth / 5;
    final oneSecond = Duration(milliseconds: 1000);
    timer = Timer.periodic(oneSecond, (timer) {
      if (_start > 5) {
        if (_start == 6) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Procces is Succesfully")));
        }
        return timer.cancel();
      } else {
        setState(() {
          _width += onPeriod;
        });
      }
      _start += 1;
    });
  }

  bool get isPlaying => _controller?.isActive ?? false;

  Artboard? _riveArtboard;
  StateMachineController? _controller;
  SMIInput<double>? _levelInput;

  AnimationController? _animationController;
  AnimationController? _animaController;
  AnimateIconController? controller = AnimateIconController();
  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    _animaController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));

    rootBundle.load('assets/skills.riv').then(
      (data) async {
        // Load the RiveFile from the binary data.
        final file = RiveFile.import(data);

        // The artboard is the root of the animation and gets drawn in the
        // Rive widget.
        final artboard = file.mainArtboard;
        var controller =
            StateMachineController.fromArtboard(artboard, 'Designer\'s Test');
        if (controller != null) {
          artboard.addController(controller);
          _levelInput = controller.findInput('Level');
        }
        setState(() => _riveArtboard = artboard);
      },
    );
    super.initState();
  }

  bool isPlay = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: _riveArtboard == null
                    ? const CircularProgressIndicator()
                    : Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: SizedBox(
                              height: 200,
                              child: Rive(
                                artboard: _riveArtboard!,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                FloatingActionButton(
                                  backgroundColor: Color(0xFFC06C84),
                                  onPressed: () => _levelInput?.value = 0,
                                  child: const Icon(
                                    Icons.child_care_rounded,
                                  ),
                                ),
                                FloatingActionButton(
                                    backgroundColor: Color(0xFFC06C84),
                                    onPressed: () => _levelInput?.value = 1,
                                    child: const Icon(
                                        CupertinoIcons.smallcircle_circle)),
                                FloatingActionButton(
                                  backgroundColor: Color(0xFFC06C84),
                                  onPressed: () => _levelInput?.value = 2,
                                  child: const Icon(
                                      CupertinoIcons.largecircle_fill_circle),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
              Row(
                children: [
                  Flexible(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 200,
                        width: 200,
                        color:const  Color(0xFFF8B195),
                        child: AnimatedAlign(
                          alignment: isAnimated
                              ? Alignment.bottomRight
                              : Alignment.topLeft,
                          duration: const Duration(seconds: 1),
                          child: InkWell(
                            child: SizedBox(
                              width: 50.0,
                              height: 50.0,
                              child: isAnimated
                                  ? const Icon(
                                      Icons.surfing,
                                      size: 50,
                                    )
                                  : const Icon(
                                      Icons.skateboarding,
                                      size: 50,
                                      color: Colors.white,
                                    ),
                            ),
                            onTap: () {
                              setState(() {
                                isAnimated = !isAnimated;
                                isPlay = !isPlay;
                                isPlay
                                    ? _animaController!.forward()
                                    : _animaController!.reverse();
                                startTimer();
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Flexible(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 200,
                        width: 200,
                        color: Color(0xFFF8B195),
                        child: AnimatedAlign(
                          alignment: isAnimated
                              ? Alignment.bottomRight
                              : Alignment.topLeft,
                          duration: const Duration(seconds: 1),
                          child: InkWell(
                            child: SizedBox(
                              width: 50.0,
                              height: 50.0,
                              child: isAnimated
                                  ? AnimatedIcon(color: Colors.white,
                                      icon: AnimatedIcons.list_view,
                                      progress: _animaController!,
                                      size: 50,
                                    )
                                 
                                  : AnimatedIcon(
                                      icon: AnimatedIcons.menu_arrow,
                                      progress: _animaController!,
                                      size: 50,
                                    ),
                            ),
                            onTap: () {
                              setState(() {
                                isAnimated = !isAnimated;
                                isPlay = !isPlay;
                                isPlay
                                    ? _animaController!.forward()
                                    : _animaController!.reverse();
                                startTimer();
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              AnimatedContainer(
                color: Color(0xFF6C5B7B),
                duration: const Duration(seconds: 2),
                height: 60.0,
                width: _width,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      isPlay = !isPlay;
                      isPlay
                          ? _animationController!.forward()
                          : _animationController!.reverse();
                    });
                  },
                  iconSize: 30,
                  icon: AnimatedIcon(
                      icon: AnimatedIcons.play_pause,
                      progress: _animationController!),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
