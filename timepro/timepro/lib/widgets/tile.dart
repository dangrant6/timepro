import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timepro/widgets/size.dart';
import 'package:timepro/widgets/task.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  TaskTile(this.task);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      width: SizeConfig.screenWidth,
      margin: EdgeInsets.only(bottom: getProportionateScreenHeight(12)),
      child: Container(
        padding: EdgeInsets.all(16),
        //  width: SizeConfig.screenWidth * 0.78,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          //color: _getBGClr(task.color),
          color: Colors.deepPurple,
        ),
        child: Row(children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title!,
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  task.description!,
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(fontSize: 15, color: Colors.yellow[100]),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.alarm_outlined,
                      color: Colors.yellow[200],
                      size: 18,
                    ),
                    SizedBox(width: 4),
                    Text(
                      "${task.startTime}",
                      style: GoogleFonts.lato(
                        textStyle:
                        TextStyle(fontSize: 13, color: Colors.yellow[100]),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          RotatedBox(
            quarterTurns: 8,
            child: Text(
              task.isCompleted == 1 ? "DONE" : "INCOMPLETE",
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow),
              ),
            ),
          ),
        ]),
      ),
    );
  }

}
