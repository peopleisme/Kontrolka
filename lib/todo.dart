import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:namer_app/models/boxes.dart';
import 'package:provider/provider.dart';
import 'color_schemes.g.dart';
import 'main.dart';
import 'models/task_model.dart';
import 'models/todoList_model.dart';

class _TodoPageState extends State<TodoPage> {
  final todoKey = GlobalKey<_Todo_listState>();
  final dateController = TextEditingController();
  final deadlineController = TextEditingController();
  final taskController = TextEditingController();
  final taskListController = TextEditingController();
  List<Task> entries = <Task>[];
  List<todoList> todoLists = <todoList>[];
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

  Future<Map<dynamic, dynamic>> buildWidget() async {
    if (formattedDate ==
            DateFormat('dd.MM.yyyy').format(DateTime(DateTime.now().year,
                DateTime.now().month, DateTime.now().day)) &&
        todoLists.length == 0) {
      addTodolists("Daily Tasks", formattedDate, true, <Task>[]);
    }

    return boxtodoList.toMap();
  }

  Future<void> addTodolists(title, date, isDaily, taskList) async {
    setState(() {
      boxtodoList.add(todoList(
          name: title, date: date, isDaily: isDaily, taskList: taskList));
      todoLists = [
        ...todoLists,
        todoList(name: title, date: date, isDaily: isDaily, taskList: taskList)
      ];
    });

    print(todoLists.length);
  }

  void setProblems(todoLists) {
    setState(() {
      todoLists = todoLists;
    });
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    final _formKey = GlobalKey<FormState>();
    String todayDate = DateFormat('dd.MM.yyyy').format(DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day));
    return FutureBuilder(
        future: buildWidget(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
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
                  theme: ThemeData(
                      useMaterial3: true, colorScheme: lightColorScheme),
                  darkTheme: ThemeData(
                      useMaterial3: true, colorScheme: darkColorScheme),
                  home: Scaffold(
                      appBar: AppBar(
                        backgroundColor: context.isDarkMode
                            ? Colors.grey[850]
                            : Colors.grey[250],
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
                                        : Colors.grey.shade900
                                            .withOpacity(0.5))),
                            Text(formattedDate.split('.')[2],
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Koulen',
                                    color: context.isDarkMode
                                        ? Colors.grey.shade100.withOpacity(0.3)
                                        : Colors.grey.shade900
                                            .withOpacity(0.3))),
                          ],
                        ),
                        centerTitle: true,
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
                                    Container(
                                      height: double.infinity,
                                      width: 75,
                                      color: context.isDarkMode
                                          ? Colors.grey[900]
                                          : Colors.grey[300],
                                      child: Column(
                                        children: [
                                          SizedBox(height: 10),
                                          FloatingActionButton(
                                            heroTag: null,
                                            tooltip: 'Select Day',
                                            elevation: 0,
                                            onPressed: () async {
                                              DateTime? pickedDate =
                                                  await showDatePicker(
                                                      context: context,
                                                      initialDate:
                                                          DateTime.now(),
                                                      firstDate: DateTime(1950),
                                                      lastDate: DateTime(2100));

                                              if (pickedDate != null) {
                                                formattedDate =
                                                    DateFormat('dd.MM.yyyy')
                                                        .format(pickedDate);
                                                setState(() {
                                                  dateController.text =
                                                      formattedDate;
                                                  print((todayDate));
                                                  print((formattedDate));
                                                  print((formattedDate ==
                                                      todayDate));
                                                });
                                              } else {}
                                            },
                                            child: const Icon(
                                                Icons.calendar_month_outlined),
                                          ),
                                          SizedBox(height: 10),
                                          FloatingActionButton(
                                            heroTag: null,
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
                                                            (context,
                                                                    setState) =>
                                                                Dialog(
                                                                  child: SizedBox(
                                                                      width: 220,
                                                                      child: Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(26.0),
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            Text("New List",
                                                                                textWidthBasis: TextWidthBasis.longestLine,
                                                                                style: TextStyle(fontSize: 24),
                                                                                textAlign: TextAlign.start),
                                                                            Form(
                                                                              // key:
                                                                              //     FilmFormKey,
                                                                              child: Column(
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
                                                                              child: Text("Add"),
                                                                              onPressed: () {
                                                                                addTodolists(taskListController.text, todayDate, isDaily, <Task>[]);

                                                                                Navigator.pop(context);
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
                                          SizedBox(height: 10),
                                          Expanded(
                                            child: StatefulBuilder(
                                              builder: (context, setState) {
                                                int? leng = todoLists.length;

                                                return
                                                    // Column(children: [
                                                    //   Radio<int>(
                                                    //     value: 0,
                                                    //     groupValue: _selectedIndex,
                                                    //     onChanged: (int? value) {
                                                    //       setState(() =>
                                                    //           _selectedIndex = 0);
                                                    //     },
                                                    //   ),
                                                    ListView.separated(
                                                        itemCount:
                                                            todoLists.length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          return Column(
                                                            children: [
                                                              Radio<int>(
                                                                value: index,
                                                                groupValue:
                                                                    _selectedIndex,
                                                                onChanged: (int?
                                                                    value) {
                                                                  setState(() =>
                                                                      _selectedIndex =
                                                                          index);
                                                                },
                                                              ),
                                                              Text(todoLists[
                                                                      index]
                                                                  .name),
                                                            ],
                                                          );
                                                        },
                                                        separatorBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          return Divider(
                                                            color: context
                                                                    .isDarkMode
                                                                ? Colors.white
                                                                : Colors
                                                                    .grey[800],
                                                            thickness: .5,
                                                          );
                                                        });
                                                //]);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Divider(
                                      thickness: 1,
                                      height: 1,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width -
                                          76,
                                      height: double.infinity,
                                      child: SingleChildScrollView(
                                        child: Todo_list(key: todoKey),
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
                        heroTag: null,
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
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Input task!';
                                                }
                                                return null;
                                              }),
                                          TextFormField(
                                            controller: deadlineController,
                                            decoration: InputDecoration(
                                              labelText: 'Date',
                                              icon: Icon(
                                                  Icons.watch_later_outlined),
                                            ),
                                            onTap: () async {
                                              TimeOfDay initialTime =
                                                  TimeOfDay.now();
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
                                    StatefulBuilder(
                                        builder: (context, setState) {
                                      return OutlinedButton(
                                        child: Text("Add"),
                                        onPressed: () {
                                          final state = todoKey.currentState!;
                                          if (_formKey.currentState!
                                              .validate()) {
                                            Navigator.pop(context);
                                            state.addTask(taskController.text,
                                                deadlineController.text, false);
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
        });
  }
}

class Todo_list extends StatefulWidget {
  Todo_list({super.key});

  @override
  _Todo_listState createState() => _Todo_listState();
}

class _Todo_listState extends State<Todo_list> {
  List<Task> tasks = <Task>[];

  Future<void> addTask(task, time, isChecked) async {
    setState(() {
      // boxProblems
      //     .add(Problem(title: title, type: type, description: "lelum polelum"));
      tasks = [...tasks, Task(task: task, time: time, isChecked: isChecked)];
    });
  }

  void setTasks(tasks) {
    setState(() {
      tasks = tasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ListView.separated(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(8),
          itemCount: tasks.length,
          itemBuilder: (BuildContext context, int index) {
            return CheckboxListTile(
                title: Text(
                  tasks[index].task,
                  style: TextStyle(
                      decoration: getBooleanValue(tasks[index].isChecked)
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      decorationThickness: 2.0),
                ),
                controlAffinity: ListTileControlAffinity.leading,
                value: tasks[index].isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    tasks[index].isChecked = value ?? false;
                  });
                },
                secondary: Row(mainAxisSize: MainAxisSize.min, children: [
                  tasks[index].isChecked ? Text("") : Text(tasks[index].time),
                  tasks[index].isChecked
                      ? const Icon(
                          Icons.check,
                          color: Colors.lightGreen,
                          size: 30,
                        )
                      : const Icon(
                          Icons.hourglass_empty,
                          color: Colors.amber,
                          size: 28,
                        ),
                ]));
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              color: context.isDarkMode ? Colors.white : Colors.grey[800],
              thickness: .5,
            );
          },
        ),
      ],
    );
  }
}

class TodoPage extends StatefulWidget {
  TodoPage({super.key});
  @override
  State<TodoPage> createState() => _TodoPageState();
}
