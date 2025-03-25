import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'color_schemes.g.dart';
import 'main.dart';

class Task {
  String task;
  String date;
  bool isChecked;
  Task({required this.task, required this.date, required this.isChecked});
}

class TaskList {
  String name;
  String date;
  bool isDaily;
  List<Task> taskList;
  TaskList(
      {required this.name,
      required this.date,
      required this.isDaily,
      required this.taskList});
}

class _TodoPageState extends State<TodoPage> {
  final dateController = TextEditingController();
  final deadlineController = TextEditingController();
  final taskController = TextEditingController();
  final taskListController = TextEditingController();
  List<Task> entries = <Task>[];
  List<TaskList> taskListList = <TaskList>[];
  int _selectedIndex = 0;
  double groupAlignment = -1.0;
  bool showLeading = true;
  bool showTrailing = false;
  bool isDaily = false;
  NavigationRailLabelType labelType = NavigationRailLabelType.all;
  bool submit = false;
  String formattedDate = DateFormat('dd.MM.yyyy').format(
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    final _formKey = GlobalKey<FormState>();
    String todayDate = DateFormat('dd.MM.yyyy').format(DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day));

    return LayoutBuilder(builder: (context, constraints) {
      return MaterialApp(
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('en'),
            const Locale('pl')
          ],
          theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
          darkTheme:
              ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
          home: Scaffold(
              appBar: AppBar(
                backgroundColor:
                    context.isDarkMode ? Colors.grey[850] : Colors.grey[250],
                leading: IconButton(
                  icon: Icon(Icons.arrow_back,
                      color: context.isDarkMode
                          ? Colors.grey.shade100
                          : Colors.grey.shade900),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${formattedDate.split('.')[0]}/",
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Koulen')),
                    Text("${formattedDate.split('.')[1]}/",
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Koulen',
                            color: context.isDarkMode
                                ? Colors.grey.shade100.withOpacity(0.5)
                                : Colors.grey.shade900.withOpacity(0.5))),
                    Text(formattedDate.split('.')[2],
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Koulen',
                            color: context.isDarkMode
                                ? Colors.grey.shade100.withOpacity(0.3)
                                : Colors.grey.shade900.withOpacity(0.3))),
                  ],
                ),
                centerTitle: true,
              ),
              drawer: Drawer(
                child: ListView(
                  children: [
                    FloatingActionButton(
                      tooltip: 'Select Day',
                      elevation: 0,
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1950),
                            lastDate: DateTime(2100));

                        if (pickedDate != null) {
                          formattedDate =
                              DateFormat('dd.MM.yyyy').format(pickedDate);
                          setState(() {
                            dateController.text = formattedDate;
                            print((formattedDate));

                            //set output date to TextField value.
                          });
                        } else {}
                      },
                      child: const Icon(Icons.calendar_month_outlined),
                    ),
                    Padding(padding: EdgeInsets.fromLTRB(0, 7, 0, 0)),
                    FloatingActionButton(
                      tooltip: 'New Task List',
                      elevation: 0,
                      onPressed: () {
                        taskListController.text = "";
                        isDaily = false;
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                  builder: (context, setState) => Dialog(
                                        child: SizedBox(
                                            width: 220,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(26.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text("New List",
                                                      textWidthBasis:
                                                          TextWidthBasis
                                                              .longestLine,
                                                      style: TextStyle(
                                                          fontSize: 24),
                                                      textAlign:
                                                          TextAlign.start),
                                                  Form(
                                                    // key:
                                                    //     FilmFormKey,
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        TextFormField(
                                                            controller:
                                                                taskListController,
                                                            decoration:
                                                                InputDecoration(
                                                              labelText:
                                                                  'Title',
                                                            ),
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return 'Input film!';
                                                              }
                                                              return null;
                                                            }),
                                                        Container(
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                                  0, 10, 0, 5),
                                                          child: SegmentedButton<
                                                                  bool>(
                                                              showSelectedIcon:
                                                                  false,
                                                              segments: const <ButtonSegment<
                                                                  bool>>[
                                                                ButtonSegment<
                                                                        bool>(
                                                                    value: true,
                                                                    label: Text(
                                                                        'Daily'),
                                                                    icon: Icon(Icons
                                                                        .event_rounded)),
                                                                ButtonSegment<
                                                                        bool>(
                                                                    value:
                                                                        false,
                                                                    label: Text(
                                                                        'Targeted'),
                                                                    icon: Icon(Icons
                                                                        .checklist_rounded)),
                                                              ],
                                                              selected:
                                                                  isDaily ==
                                                                          null
                                                                      ? {}
                                                                      : {
                                                                          isDaily!
                                                                        },
                                                              onSelectionChanged:
                                                                  (newSelection) {
                                                                setState(() {
                                                                  isDaily =
                                                                      newSelection
                                                                          .first;
                                                                });
                                                              }),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  OutlinedButton(
                                                    child: Text("Add"),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      taskListList.add(TaskList(
                                                          name:
                                                              taskListController
                                                                  .text,
                                                          date: todayDate,
                                                          isDaily: isDaily,
                                                          taskList: <Task>[]));
                                                      taskListController
                                                          .clear();
                                                    },
                                                  )
                                                ],
                                              ),
                                            )),
                                      ));
                            });
                      },
                      child: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
              body: Column(
                children: [
                  Expanded(
                      child: Row(
                    children: [
                      Container(
                        color: context.isDarkMode
                            ? Colors.grey[800]
                            : Colors.grey[200],
                        child: Row(
                          children: [
                            NavigationRail(
                              selectedIndex: _selectedIndex,
                              groupAlignment: groupAlignment,
                              onDestinationSelected: (int index) {
                                setState(() {
                                  _selectedIndex = index;
                                });
                              },
                              labelType: labelType,
                              leading: showLeading
                                  ? Column(
                                      children: [
                                        FloatingActionButton(
                                          tooltip: 'Select Day',
                                          elevation: 0,
                                          onPressed: () async {
                                            DateTime? pickedDate =
                                                await showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime(1950),
                                                    lastDate: DateTime(2100));

                                            if (pickedDate != null) {
                                              formattedDate =
                                                  DateFormat('dd.MM.yyyy')
                                                      .format(pickedDate);
                                              setState(() {
                                                dateController.text =
                                                    formattedDate;
                                                print((formattedDate));

                                                //set output date to TextField value.
                                              });
                                            } else {}
                                          },
                                          child: const Icon(
                                              Icons.calendar_month_outlined),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 7, 0, 0)),
                                        FloatingActionButton(
                                          tooltip: 'New Task List',
                                          elevation: 0,
                                          onPressed: () {
                                            taskListController.text = "";
                                            isDaily = false;
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return StatefulBuilder(
                                                      builder:
                                                          (context, setState) =>
                                                              Dialog(
                                                                child: SizedBox(
                                                                    width: 220,
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .all(
                                                                          26.0),
                                                                      child:
                                                                          Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: [
                                                                          Text(
                                                                              "New List",
                                                                              textWidthBasis: TextWidthBasis.longestLine,
                                                                              style: TextStyle(fontSize: 24),
                                                                              textAlign: TextAlign.start),
                                                                          Form(
                                                                            // key:
                                                                            //     FilmFormKey,
                                                                            child:
                                                                                Column(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: <Widget>[
                                                                                TextFormField(
                                                                                    controller: taskListController,
                                                                                    decoration: InputDecoration(
                                                                                      labelText: 'Title',
                                                                                    ),
                                                                                    validator: (value) {
                                                                                      if (value == null || value.isEmpty) {
                                                                                        return 'Input film!';
                                                                                      }
                                                                                      return null;
                                                                                    }),
                                                                                Container(
                                                                                  margin: EdgeInsets.fromLTRB(0, 10, 0, 5),
                                                                                  child: SegmentedButton<bool>(
                                                                                      showSelectedIcon: false,
                                                                                      segments: const <ButtonSegment<bool>>[
                                                                                        ButtonSegment<bool>(value: true, label: Text('Daily'), icon: Icon(Icons.event_rounded)),
                                                                                        ButtonSegment<bool>(value: false, label: Text('Targeted'), icon: Icon(Icons.checklist_rounded)),
                                                                                      ],
                                                                                      selected: isDaily == null ? {} : {isDaily!},
                                                                                      onSelectionChanged: (newSelection) {
                                                                                        setState(() {
                                                                                          isDaily = newSelection.first;
                                                                                        });
                                                                                      }),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          OutlinedButton(
                                                                            child:
                                                                                Text("Add"),
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                              taskListList.add(TaskList(name: taskListController.text, date: todayDate, isDaily: isDaily, taskList: <Task>[]));
                                                                              taskListController.clear();
                                                                            },
                                                                          )
                                                                        ],
                                                                      ),
                                                                    )),
                                                              ));
                                                });
                                          },
                                          child: const Icon(Icons.add),
                                        ),
                                      ],
                                    )
                                  : const SizedBox(),
                              trailing: showTrailing
                                  ? IconButton(
                                      onPressed: () {
                                        // Add your onPressed code here!
                                      },
                                      icon:
                                          const Icon(Icons.more_horiz_rounded),
                                    )
                                  : const SizedBox(),
                              destinations:
                                  // ListView.builder(
                                  //     itemCount: taskListList.length,
                                  //     itemBuilder:
                                  //         (BuildContext context, int index) {
                                  //        NavigationRailDestination(
                                  //         icon: Icon(Icons.circle_outlined),
                                  //         selectedIcon:
                                  //             Icon(Icons.circle_rounded),
                                  //         label: Text('Third'),
                                  //       );
                                  //     }),
                                  <NavigationRailDestination>[
                                NavigationRailDestination(
                                  icon: Icon(Icons.circle_outlined),
                                  selectedIcon: Icon(Icons.circle_rounded),
                                  label: Text('Third'),
                                ),
                                NavigationRailDestination(
                                  icon: Icon(Icons.circle_outlined),
                                  selectedIcon: Icon(Icons.circle_rounded),
                                  label: Text('Third'),
                                )
                              ],
                            ),
                            const VerticalDivider(thickness: 1, width: 1),
                            Container(
                              width: MediaQuery.of(context).size.width - 81,
                              height: double.infinity,
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ListView.separated(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      padding: const EdgeInsets.all(8),
                                      itemCount: entries.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return CheckboxListTile(
                                            title: Text(
                                              entries[index].task +
                                                  entries[index].date,
                                              style: TextStyle(
                                                  decoration: getBooleanValue(
                                                          entries[index]
                                                              .isChecked)
                                                      ? TextDecoration
                                                          .lineThrough
                                                      : TextDecoration.none,
                                                  decorationThickness: 2.0),
                                            ),
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            value: entries[index].isChecked,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                entries[index].isChecked =
                                                    value!;
                                              });
                                            }
                                            // secondary: const Icon(Icons.hourglass_empty),
                                            );
                                      },
                                      separatorBuilder:
                                          (BuildContext context, int index) {
                                        return Divider(
                                          color: context.isDarkMode
                                              ? Colors.white
                                              : Colors.grey[800],
                                          thickness: .5,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ))
                ],
              ),
              floatingActionButton: FloatingActionButton(
                tooltip: 'New Task',
                child: const Icon(Icons.add),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          scrollable: true,
                          title: Text('New Task'),
                          content: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: <Widget>[
                                  TextFormField(
                                      controller: taskController,
                                      decoration: InputDecoration(
                                        labelText: 'Task',
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Input task!';
                                        }
                                        return null;
                                      }),
                                  TextFormField(
                                    controller: deadlineController,
                                    decoration: InputDecoration(
                                      labelText: 'Date',
                                      icon: Icon(Icons.watch_later_outlined),
                                    ),
                                    onTap: () async {
                                      TimeOfDay initialTime = TimeOfDay.now();
                                      TimeOfDay? pickedTime =
                                          await showTimePicker(
                                        context: context,
                                        initialTime: initialTime,
                                      );
                                      deadlineController.text =
                                          "${pickedTime!.hour}:${pickedTime.minute.toString().padLeft(2, '0')}";
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          actions: [
                            StatefulBuilder(builder: (context, setState) {
                              return OutlinedButton(
                                child: Text("Add"),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    Navigator.pop(context);
                                    setState(() {
                                      entries = [
                                        ...entries,
                                        Task(
                                            task: taskController.text,
                                            date: deadlineController.text,
                                            isChecked: false)
                                      ];
                                    });
                                    taskController.clear();
                                    deadlineController.clear();
                                  }
                                },
                              );
                            }),
                          ],
                        );
                      });
                },
              )));
    });
  }
}

class TodoPage extends StatefulWidget {
  @override
  State<TodoPage> createState() => _TodoPageState();
}
