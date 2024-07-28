import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:popup_card/popup_card.dart';
import 'package:taskmanagement/Tasks.dart';
import 'package:taskmanagement/AddTask.dart';
import 'package:taskmanagement/Database.dart';
import 'package:intl/intl.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:advance_water_drop_nav_bar/advance_water_drop_nav_bar.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _selectedIndex = 0;

  String getCurrentDate(String date) {
    DateTime now = DateTime.now();

    // Format the current date using the intl package (optional)
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    // Check if the given date is smaller than the current date
    if (date.substring(0, 10) == formattedDate) {
      return "Today";
    } else if (DateTime.parse(date.substring(0, 10)).isBefore(DateTime.now())) {
      print("\n\ntrue\n");
      return "Missing";

    }
    // Check if the given date is today

    // Check if the given date is tomorrow
    else if (date.substring(0, 10) == _getTomorrowDate(formattedDate)) {
      return "Tomorrow";
    }
    // Handle other cases
    else {
      return "Else";
    }
  }

// Helper function to get tomorrow's date
  String _getTomorrowDate(String formattedDate) {
    DateTime tomorrow = DateTime.now().add(const Duration(days: 1));
    String tomorrowFormattedDate = DateFormat('yyyy-MM-dd').format(tomorrow);
    return tomorrowFormattedDate;
  }

  TasksController controller = TasksController();
  List<Task> tasks = [];
  bool checks = false;
  String? Search = "";
  bool isSelected() {
    for (Task task in tasks) {
      if (task.delete == true) return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  DateTime get() {
    return DateTime.now();
  }

  Future<void> _loadTasks() async {
    tasks = await controller.loadTasks();
    setState(() {});
  }

  void deleteSelected() async {
    List<Task> temp = [];
    for (Task task in tasks) {
      if (task.delete == false) {
        temp.add(task);
      }
    }
    tasks = temp;
    await controller.saveTasks(tasks);
    setState(() {
      // Update any other UI-related state if needed
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: const Color.fromARGB(243, 243, 243, 1),//Colors.deepPurple,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.account_circle,size: 35,),
        ),
        elevation: 0,
        actions: [
          if (isSelected())
            IconButton(
              onPressed: isSelected() ? deleteSelected : null,
              icon: const Icon(Icons.delete),
            )
          else
            PopupMenuButton(
              icon: const Icon(
                Icons.settings,
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: '1',
                  child: TextButton(
                    child: const Text(
                      'Settings',
                      style: TextStyle(color: Colors.black, fontSize: 19),
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          const SizedBox(width: 13),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              setState(() {
                checks = !checks;
              });
            },
          ),
          const SizedBox(width: 13),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Manage Tasks ",
                    style: TextStyle(fontSize: 25, color: Colors.black87)),
                const Text("Seamlessly",
                    style: TextStyle(fontSize: 45, color: Colors.black)),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(244, 243, 243, 1),
                      borderRadius: BorderRadius.all(Radius.circular(13))),
                  child: TextField(
                    onSubmitted: (value) {
                      setState(() {
                        Search = value;
                      });
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search you're looking for",
                      hintStyle: const TextStyle(color: Colors.black54),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          if(_selectedIndex==0)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              "Due today",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              textAlign: TextAlign.start,
            ),
          ),
          if(_selectedIndex==1)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                "Tomorrow",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                textAlign: TextAlign.start,
              ),
            ),
          if(_selectedIndex==2)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                "Rest",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                textAlign: TextAlign.start,
              ),
            ),
          if(_selectedIndex==3)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                "Missed",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                textAlign: TextAlign.start,
              ),
            ),
          Flexible(
            fit: FlexFit.loose,
            child: Container(
              padding: const EdgeInsets.all(8.0),

              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  if (getCurrentDate(tasks[index].performanceTime) == "Today" &&
                      (Search == "" || Search == tasks[index].title)&&_selectedIndex==0) {
                    return MakingPage(index);
                  } else if (getCurrentDate(tasks[index].performanceTime) == "Tomorrow" &&
                      (Search == "" || Search == tasks[index].title)&&_selectedIndex==1) {
                    return MakingPage(index);
                  }
                  else if (getCurrentDate(tasks[index].performanceTime) == "Missing" &&
                      (Search == "" || Search == tasks[index].title)&&_selectedIndex==3) {
                    return MakingPage(index);
                  }
                  else if (getCurrentDate(tasks[index].performanceTime) == "Else" &&
                      (Search == "" || Search == tasks[index].title)&&_selectedIndex==2) {
                    return MakingPage(index);
                  }
                  else
                    {
                      return Container();
                    }
                },
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),





      WaterDropNavBar(
        backgroundColor: Colors.white,
        inactiveIconColor:Colors.blue,
        waterDropColor: Colors.blue,
        onItemSelected: (int index) {
          setState(() {
            _selectedIndex = index;
            // buildPages();
          });
        },
        selectedIndex: _selectedIndex,
        barItems: <BarItem>[
          BarItem(
              filledIcon: Icons.today,
              outlinedIcon: Icons.today_outlined,
              text: 'Due Today'),

          BarItem(
              filledIcon: Icons.access_time_filled,
              outlinedIcon: Icons.access_time_outlined,
              text: 'Due Tomorrow'),
          BarItem(
              filledIcon: Icons.assignment_rounded,
              outlinedIcon: Icons.assignment_outlined,
              text: 'Rest '),
          BarItem(
              filledIcon: Icons.assignment_late_rounded,
              outlinedIcon: Icons.assignment_late_outlined,
              text: 'Missed'),
        ],
      ),
        ],
      ),
      floatingActionButton: PopupItemLauncher(
        tag: 'test',

        popUp: PopUpItem(

          padding: const EdgeInsets.all(8),
          color: Colors.white,
          shape: const RoundedRectangleBorder(),
          elevation: 1,
          tag: 'test',
          child: PopUpItemBody(
            id: (tasks.length + 1).toString(),
            onTaskAdded: () {
              _loadTasks(); // Reload tasks after a new task is added
            },
          ),
        ),
        child: Container(
          color: Colors.white,
          child: Icon(
            Icons.add_rounded,
            size: 56,
          ),
        ),

      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat
    );
  }
  Widget MakingPage(int index){
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color.fromRGBO(244, 243, 243, 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SwipeActionCell(
              key: ObjectKey(tasks[index]),
              trailingActions: <SwipeAction>[
                SwipeAction(
                  performsFirstActionWithFullSwipe: true,
                  title: "Done",
                  onTap: (CompletionHandler handler) async {
                    tasks.removeAt(index);
                    controller.saveTasks(tasks);
                    setState(() {});
                  },
                  color: Colors.lightBlueAccent,
                ),
                SwipeAction(
                  widthSpace: 120,
                  title: "Delete",
                  onTap: (CompletionHandler handler) async {
                    handler(false);
                    showCupertinoDialog(
                      context: context,
                      builder: (c) {
                        return CupertinoAlertDialog(
                          title: const Text(
                              'Are you sure You want to delete it'),
                          actions: <Widget>[
                            CupertinoDialogAction(
                              isDestructiveAction: true,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('confirm'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  color: Colors.orange,
                ),
              ],
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Text(
                  tasks[index].title,
                  style: const TextStyle(
                      fontSize: 24, color: Colors.black87),
                ),
                subtitle: tasks[index].description == "Medium"
                    ? Container(
                  width: 5,
                  decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(15)
                  ),
                  height: 25,

                  child: Center(child: Text("Medium",style: TextStyle(color: Colors.white),)),
                )
                    : tasks[index].description == "High"
                    ? Container(
                  width: 5,
                  decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(15)
                  ),
                  height: 25,

                  child: Center(child: Text("High",style: TextStyle(color: Colors.white),)),
                )
                    : tasks[index].description == "Low"
                    ? Container(
                  width: 5,
                  decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      borderRadius: BorderRadius.circular(15)
                  ),
                  height: 25,

                  child: Center(child: Text("Low",style: TextStyle(color: Colors.white),)),
                )
                    : null,
                leading: checks
                    ? tasks[index].delete
                    ? IconButton(
                  onPressed: () {
                    setState(() {
                      tasks[index].delete = false;
                    });
                  },
                  icon: const Icon(Icons.check_box,
                      color: Colors.black87),
                )
                    : IconButton(
                  onPressed: () {
                    setState(() {
                      tasks[index].delete = true;
                    });
                  },
                  icon: const Icon(
                      Icons.check_box_outline_blank,
                      color: Colors.black87),
                )
                    : null,
                trailing: Text(
                  tasks[index].performanceTime,
                  style: const TextStyle(color: Colors.black87),
                ),
                onTap: () {},
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

}
