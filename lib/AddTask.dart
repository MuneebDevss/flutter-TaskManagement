import 'package:flutter/material.dart';
import 'package:taskmanagement/Database.dart';
import 'package:taskmanagement/Tasks.dart';
import 'package:date_time_picker_selector/date_time_picker_selector.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class PopUpItemBody extends StatefulWidget {
  final String? id;
  final Function()? onTaskAdded; // Callback function
  const PopUpItemBody({super.key, this.id, this.onTaskAdded});

  @override
  _PopUpItemBodyState createState() => _PopUpItemBodyState(id!);
}

class _PopUpItemBodyState extends State<PopUpItemBody> {
  _PopUpItemBodyState(this.Id);

  String title = "";
  static String description = 'High'; // Initialize with a default value
  DateTime? selectedDateTime; // Updated to store selected date and time
  String Id;
  final TasksController controller = TasksController();
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    tasks = await controller.loadTasks();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.limeAccent,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 10),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Title',
                hintStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                title = value;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DateTimePicker(
              type: DateTimePickerType.dateTimeSeparate,
              dateMask: 'd MMM, yyyy',
              initialValue: DateTime.now().toString(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              icon: const Icon(Icons.event),
              dateLabelText: 'Date',
              timeLabelText: "Hour",
              onChanged: (val) {
                setState(() {
                  selectedDateTime = DateTime.parse(val);
                });
              },
              validator: (val) {
                print(val);
                return null;
              },
              onSaved: (val) {
                // Not needed since onChanged is used for updating selectedDateTime
              },
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: DropDown(
                onDescriptionChanged: (value) {
                  setState(() {
                    description = value;
                  });
                },
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(fontWeight: FontWeight.w800),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
              const SizedBox(
                height: 23,
              ),
              Expanded(
                child: TextButton(
                  onPressed: () async {
                    if (selectedDateTime != null) {
                      Task task = Task(
                        title,
                        description,
                        selectedDateTime!.toString(),
                        Id,
                        false,
                      );
                      tasks.add(task);
                      await controller.saveTasks(tasks);
                      widget.onTaskAdded?.call(); // Call the callback function
                      Navigator.pop(context);
                    } else {
                      // Handle case where date and time are not selected
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Error"),
                            content: const Text("Please select a date and time."),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("OK"),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: const Text(
                    "Add",
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DropDown extends StatefulWidget {
  final ValueChanged<String> onDescriptionChanged;

  const DropDown({
    super.key,
    required this.onDescriptionChanged,
  });

  @override
  State<DropDown> createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  final List<String> items = [
    'High',
    'Medium',
    'Low',
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          hint: const Row(
            children: [
              Icon(
                Icons.list,
                size: 16,
                color: Colors.white,
              ),
              SizedBox(
                width: 4,
              ),
              Text(
                'Priority',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          items: items
              .map((String item) => DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ))
              .toList(),
          value: _PopUpItemBodyState.description.isNotEmpty
              ? _PopUpItemBodyState.description
              : null, // Ensure it matches an item in the list
          onChanged: (value) {
            setState(() {
              _PopUpItemBodyState.description = value!;
              widget.onDescriptionChanged(value);
            });
          },
          buttonStyleData: ButtonStyleData(
            padding: const EdgeInsets.only(left: 14, right: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.black26,
              ),
              color: Colors.black54,
            ),
            elevation: 2,
          ),
          iconStyleData: const IconStyleData(
            icon: Icon(
              Icons.arrow_forward_ios_outlined,
            ),
            iconSize: 14,
            iconEnabledColor: Colors.yellow,
            iconDisabledColor: Colors.grey,
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 200,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.lightBlueAccent,
            ),
            offset: const Offset(-20, 0),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(40),
              thickness: MaterialStateProperty.all(6),
              thumbVisibility: MaterialStateProperty.all(true),
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
            padding: EdgeInsets.only(left: 14, right: 14),
          ),
        ),
      ),
    );
  }
}
