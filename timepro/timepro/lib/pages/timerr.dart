import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
//import 'package:timepro/widgets.dart';


class timerScreen extends StatefulWidget {
  @override
  timerScreenState createState() => timerScreenState();
}
class timerScreenState extends State<timerScreen>
    with TickerProviderStateMixin {
  late AnimationController controller;

  bool isPlaying = false;

  String get countText {
    Duration count = controller.duration! * controller.value;
    return controller.isDismissed
        ? '${controller.duration!.inHours}:${(controller.duration!.inMinutes % 60).toString().padLeft(2, '0')}:${(controller.duration!.inSeconds % 60).toString().padLeft(2, '0')}'
        : '${count.inHours}:${(count.inMinutes % 60).toString().padLeft(2, '0')}:${(count.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  double progress = 1.0;

  void notify() {
    if (countText == '0:00:00') {
      FlutterRingtonePlayer.playNotification();
    }
  }


  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 0),
    );

    controller.addListener(() {
      //notify();
      if (controller.isAnimating) {
        setState(() {
          progress = controller.value;
        });
      } else {
        setState(() {
          progress = 1.0;
          isPlaying = false;
        });
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset('assets/timeb2.jpg', fit:BoxFit.fill,),
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 1,
          ),
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              Expanded(
                child: Container(
                  //decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/timeb2.jpg'), fit: BoxFit.fill),),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 300,
                        height: 300,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
                          backgroundColor: Colors.black,
                          value: progress,
                          strokeWidth: 6,
                        ),
                      ),
                      Container(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                            child: Text("Take a break and then complete your tasks", style: TextStyle(color: Colors.yellow,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),),
                          ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (controller.isDismissed) {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => Container(
                                height: 300,
                                child: CupertinoTimerPicker(
                                  initialTimerDuration: controller.duration!,
                                  onTimerDurationChanged: (time) {
                                    setState(() {
                                      controller.duration = time;
                                    });
                                  },
                                ),
                              ),
                            );
                          }
                        },
                        child: AnimatedBuilder(
                          animation: controller,
                          builder: (context, child) => Text(
                            countText,
                            style: TextStyle(
                              color: Colors.yellow,
                              fontSize: 60,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),


              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (controller.isAnimating) {
                          controller.stop();
                          setState(() {
                            isPlaying = false;
                          });
                        } else {
                          controller.reverse(
                              from: controller.value == 0 ? 1.0 : controller.value);
                          setState(() {
                            isPlaying = true;
                          });
                        }
                      },
                      child: RoundButton(
                        icon: isPlaying == true ? Icons.pause : Icons.play_arrow,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.reset();
                        setState(() {
                          isPlaying = false;
                        });
                      },
                      child: RoundButton(
                        icon: Icons.stop,

                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ]
    );
  }
}
/*
class timerScreenState extends State<timerScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 1,
      ),

    );
  }
}

 */

class RoundButton extends StatelessWidget {
  const RoundButton({
    Key? key,
    required this.icon,
  }) : super(key: key);
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
      ),
      child: CircleAvatar(
        backgroundColor: Colors.yellow,
        radius: 30,
        child: Icon(
          icon,
          size: 36,
          color: Colors.deepPurple,
        ),
      ),
    );
  }
}