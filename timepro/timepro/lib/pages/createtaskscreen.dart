import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../widgets/fonts.dart';
import '../widgets/inputbox.dart';
import '../widgets/task.dart';
import '../widgets/taskcontrol.dart';

class CreateNewTaskPage extends StatefulWidget {
  @override
  CreateNewTaskPageState createState() => CreateNewTaskPageState();
}

class CreateNewTaskPageState extends State<CreateNewTaskPage> {
  final TaskController _taskController = Get.find<TaskController>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String? _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String? _selectedRepeat = 'None';
  List<String> repeatList = ['None', 'Daily'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: context.theme.backgroundColor,
      backgroundColor: Colors.transparent,
      appBar: _appBar(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/timeb2.jpg'),fit: BoxFit.fill),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40,
              ),
              InputField(
                title: "Title",
                hint: "Enter Title",
                controller: _titleController,
              ),
              SizedBox(
                height: 40,
              ),
              InputField(
                  title: "Description",
                  hint: "Enter Description",
                  controller: _noteController),
              SizedBox(
                height: 20,
              ),
              InputField(
                title: "Date",
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  icon: (Icon(
                   Icons.calendar_month_sharp,
                    color: Colors.yellow,
                  )),
                  onPressed: () {
                    //_showDatePicker(context);
                    _getDateFromUser();
                  },
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      title: "Reminder Time",
                      hint: _startTime,
                      widget: IconButton(
                        icon: (Icon(
                          Icons.alarm,
                          color: Colors.yellow,
                        )),
                        onPressed: () {
                          _getTimeFromUser(isStartTime: true);
                          setState(() {
                            //scheduledNotification;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              InputField(
                title: "Frequency",
                hint: _selectedRepeat,
                widget: Row(
                  children: [
                    Container(
                      child: DropdownButton<String>(
                dropdownColor: Colors.deepPurple,
                          //value: _selectedRemind.toString(),
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.yellow,
                          ),
                          iconSize: 32,
                          elevation: 4,
                          style: subTitleTextStle,
                          underline: Container(height: 6, ),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedRepeat = newValue;
                            });
                          },
                          items: repeatList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: TextStyle(color:Colors.yellow),),
                            );
                          }).toList()),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(70, 20, 70, 20),
                      side: const BorderSide(width: 2.0, color: Colors.deepPurple),
                      shape: new RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Text("Create Task",
                      style: TextStyle(
                        color: Colors.yellow,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    onPressed: ()async{
                      _validateInputs();
                      //Navigator.push(context, MaterialPageRoute(builder: (context) => homeScreen()));
                      //addTaskData();
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 30.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _validateInputs() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTaskToDB();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar(
        "Required",
        "All fields are required.",
        snackPosition: SnackPosition.BOTTOM,
          titleText: Text("Error", style: TextStyle(color: Colors.yellow)),
          messageText: Text("All fields need to be filled out.", style: TextStyle(color: Colors.yellow))
      );
    } else {
      print("ERROR");
    }
  }

  _addTaskToDB() async {
    await _taskController.addTask(
      task: Task(
        description: _noteController.text,
        title: _titleController.text,
        date: DateFormat.yMd().format(_selectedDate),
        startTime: _startTime,
        repeat: _selectedRepeat,
        isCompleted: 0,
      ),
    );
  }

  _appBar() {
    return AppBar(
        elevation: 0,
        backgroundColor: Colors.deepPurple,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back_ios, size: 24, color: Colors.yellow),
        ),
        actions: [
          Text(
            "New Task",
            style: TextStyle(color: Colors.yellow, fontSize: 25, fontWeight: FontWeight.bold, ),
          ),
          SizedBox(
            width: 20,
          ),
        ]);
  }

  double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;

  _getTimeFromUser({required bool isStartTime}) async {
    var _pickedTime = await _showTimePicker();
    print(_pickedTime.format(context));
    String? _formatedTime = _pickedTime.format(context);
    print(_formatedTime);
    if (_pickedTime == null)
      print("time canceld");
    else if (isStartTime)
      setState(() {
        _startTime = _formatedTime;
      });
  }

  _showTimePicker() async {
    return showTimePicker(
      initialTime: TimeOfDay(
          hour: int.parse(_startTime!.split(":")[0]),
          minute: int.parse(_startTime!.split(":")[1].split(" ")[0])),
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
    );
  }

  _getDateFromUser() async {
    final DateTime? _pickedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2022),
        lastDate: DateTime(2101));
    if (_pickedDate != null) {
      setState(() {
        _selectedDate = _pickedDate;
      });
    }
  }
}
