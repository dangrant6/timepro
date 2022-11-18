import 'dart:async';

import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timepro/pages/profile.dart';
import '../widgets/size.dart';
import 'settings.dart';
import 'timerr.dart';
import '../widgets/notification.dart';
import '../widgets/task.dart';
import '../widgets/taskcontrol.dart';
import '../widgets/tile.dart';
import 'createtaskscreen.dart';
import 'calendar.dart';
import 'moti.dart';


class homeScreen extends StatefulWidget {
  @override
  homeScreenState createState() => homeScreenState();
}

class homeScreenState extends State<homeScreen> {
  DateTime _selectedDate = DateTime.parse(DateTime.now().toString());
  final _taskController = Get.put(TaskController());
  late var notifyHelper;
  bool animate=false;
  double left=630;
  double top=900;
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
    _timer = Timer(Duration(milliseconds: 500), () {
      setState(() {
        animate=true;
        left=30;
        top=top/3;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          dateBar(),
          calBar(),
          SizedBox(
            height: 12,
          ),
          showTasks(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          iconSize: 35,
          selectedIconTheme: IconThemeData(color: Colors.yellow, size: 35),
          selectedItemColor: Colors.yellow,
          unselectedIconTheme: IconThemeData(
            color: Colors.yellow,
          ),
          unselectedItemColor: Colors.yellow,
          backgroundColor: Colors.deepPurple,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: IconButton(
                icon: Icon(Icons.person_outline), onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context) => profileScreen())); },
              ),
              label: "Profile",
            ),
            BottomNavigationBarItem(
              icon: IconButton(
                icon: Icon(Icons.add),
                onPressed: ()async{
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CreateNewTaskPage()));
                  //await Get.to(CreateNewTaskPage());
                  _taskController.getTasks();
                },//onPressed: () async{ Navigator.push(context, MaterialPageRoute(builder: (context) => CreateNewTaskPage())); },
              ),
              label: "Add Task",
            ),
            BottomNavigationBarItem(
              icon: IconButton(
                icon: Icon(Icons.timer_outlined), onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context) => timerScreen())); },
              ),
              label: "Timer",
            ),
          ]
      ),
    );
  }

  calBar() {
    return Container(
      margin: EdgeInsets.only(bottom: 10, left: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20)
        ),
        child: DatePicker(
          DateTime.now(),
          height: 100.0,
          width: 80,
          initialSelectedDate: DateTime.now(),
          selectionColor: Colors.deepPurple,
          //selectedTextColor: primaryClr,
          selectedTextColor: Colors.yellow,
          dateTextStyle: GoogleFonts.lato(
            textStyle: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          dayTextStyle: GoogleFonts.lato(
            textStyle: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          monthTextStyle: GoogleFonts.lato(
            textStyle: TextStyle(
              fontSize: 10.0,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),

          onDateChange: (date) {
            // New date selected

            setState(
              () {
                _selectedDate = date;
              },
            );
          },
        ),
      ),
    );
  }

  dateBar() {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Today's Date",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10,),
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _appBar() {
    return AppBar(
        elevation: 0,
        backgroundColor: Colors.deepPurple,
        title: Text('TimePro', style: TextStyle(color: Colors.yellow, fontSize: 25, fontWeight: FontWeight.w700),),
        actions: [
          IconButton(
            icon: Icon(Icons.settings,
              color: Colors.yellow,
              size: 30,
            ), onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context) => settingsScreen())); },
          ),
          IconButton(
            icon: Icon(Icons.announcement_outlined,
              color: Colors.yellow,
              size: 30,
            ), onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context) => motiScreen())); },
          ),
          IconButton(
            icon: Icon(Icons.calendar_today_outlined,
                color: Colors.yellow,
                size: 30), onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context) => calScreen())); },
          ),
          SizedBox(
            width: 20,
          ),
        ]);
  }

  showTasks() {
    return Expanded(
      child: Obx(() {
        if (_taskController.taskList.isEmpty) {
          return _noTaskMsg();
        } else
          return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: _taskController.taskList.length,
              itemBuilder: (context, index) {
                Task task = _taskController.taskList[index];
                var hour= task.startTime.toString().split(":")[0];
                var minutes = task.startTime.toString().split(":")[1];
                debugPrint("My time is "+hour);
                debugPrint("My minute is "+minutes);
                DateTime date= DateFormat.jm().parse(task.startTime!);
                var myTime = DateFormat("HH:mm").format(date);
                notifyHelper.scheduledNotification(int.parse(myTime.toString().split(":")[0]),
                    int.parse(myTime.toString().split(":")[1]), task);
                if (task.repeat == 'Daily') {
                  var hour= task.startTime.toString().split(":")[0];
                  var minutes = task.startTime.toString().split(":")[1];
                  debugPrint("My time is "+hour);
                  debugPrint("My minute is "+minutes);
                  DateTime date= DateFormat.jm().parse(task.startTime!);
                  var myTime = DateFormat("HH:mm").format(date);
                  notifyHelper.scheduledNotification(int.parse(myTime.toString().split(":")[0]),
                      int.parse(myTime.toString().split(":")[1]), task);

                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 1375),
                    child: SlideAnimation(
                      horizontalOffset: 300.0,
                      child: FlipAnimation(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  showBottomSheet(context, task);
                                },
                                child: TaskTile(task)),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                if (task.date == DateFormat.yMd().format(_selectedDate)) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 1375),
                    child: FlipAnimation(
                      child: ScaleAnimation(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                                onTap: () {

                                  showBottomSheet(context, task);
                                },
                                child: TaskTile(task)),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              });
      }),
    );
  }

  showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(top: 4),
        height: task.isCompleted == 1
            ? SizeConfig.screenHeight * 0.24
            : SizeConfig.screenHeight * 0.32,
        width: SizeConfig.screenWidth,
        color: Colors.deepPurple,
        child: Column(children: [
          Container(
            height: 6,
            width: 120,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.yellow),
          ),
          Spacer(),
          task.isCompleted == 1
              ? Container()
              : _buildBottomSheetButton(
                  label: "Task Completed",
                  onTap: () {
                    _taskController.markTaskCompleted(task.id);
                    Get.back();
                  },
                  clr: Colors.yellow),
          _buildBottomSheetButton(
              label: "Delete Task",
              onTap: () {
                _taskController.deleteTask(task);
                Get.back();
              },
              clr: Colors.red[500]!),
          SizedBox(
            height: 20,
          ),
          _buildBottomSheetButton(
              label: "Close",
              onTap: () {
                Get.back();
              },
              //isClose: true
              ),
          SizedBox(
            height: 20,
          ),
        ]),
      ),
    );
  }

  _buildBottomSheetButton(
      {required String label, Function? onTap, Color? clr}) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: SizeConfig.screenWidth! * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: Colors.deepPurple,
          ),
          borderRadius: BorderRadius.circular(20),
          color: Colors.transparent,
        ),
        child: Center(
            child: Text(
          label,
          style: TextStyle(color: Colors.yellow),
        )),
      ),
    );
  }

  _noTaskMsg() {
    return Stack(
      children:[ AnimatedPositioned(
        duration: Duration(milliseconds: 2000),
        left: left,
        top:top,
        child: Container(

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/timesmall.png', scale: 3, alignment: Alignment.topCenter),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 62, vertical: 50),
                child: Text(
                  "Click the + button below to add new tasks",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(
                height: 80,
              ),
            ],
          )
        ),
      )],
    );
  }
}
