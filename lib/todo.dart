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



class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          colorSchemeSeed: const Color(0xff6750a4), useMaterial3: true),
      home: TodoPage(),
    );
  }
}

class _TodoPageState extends State<TodoPage> {
  TextEditingController dateInput = TextEditingController();
  final dateController = TextEditingController();
  final taskController = TextEditingController();
  List<Task> entries = <Task>[];
  bool submit = false;

  @override
  void initState() {
    super.initState();
    // Start listening to changes.
    taskController.addListener(() {
      setState(() {
        submit = taskController.text.length > 0;
        print(taskController.text);
      });
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    taskController.dispose();
    super.dispose();
  }

  int _selectedIndex = 0;
  NavigationRailLabelType labelType = NavigationRailLabelType.all;
  bool showLeading = true;
  bool showTrailing = false;
  double groupAlignment = -1.0;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    final _formKey = GlobalKey<FormState>();

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
                title: Text(dateInput.text,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
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
                                          elevation: 0,
                                          onPressed: () {
                                            // Add your onPressed code here!
                                          },
                                          child: const Icon(Icons.add),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 7, 0, 0)),
                                        FloatingActionButton(
                                          elevation: 0,
                                          onPressed: () async {
                                            DateTime? pickedDate =
                                                await showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime(1950),
                                                    //DateTime.now() - not to allow to choose before today.
                                                    lastDate: DateTime(2100));

                                            if (pickedDate != null) {
                                              print(
                                                  pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                              String formattedDate =
                                                  DateFormat('dd.MM.yyyy')
                                                      .format(pickedDate);
                                              print(
                                                  formattedDate); //formatted date output using intl package =>  2021-03-16
                                              setState(() {
                                                dateInput.text =
                                                    formattedDate; //set output date to TextField value.
                                              });
                                            } else {}
                                          },
                                          child: const Icon(
                                              Icons.calendar_month_outlined),
                                        )
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
                              destinations: const <NavigationRailDestination>[
                                NavigationRailDestination(
                                  icon: Icon(Icons.circle_outlined),
                                  selectedIcon: Icon(Icons.circle_rounded),
                                  label: Text('Today'),
                                ),
                                NavigationRailDestination(
                                  icon: Icon(Icons.circle_outlined),
                                  selectedIcon: Icon(Icons.circle_rounded),
                                  label: Text('Second'),
                                ),
                                NavigationRailDestination(
                                  icon: Icon(Icons.circle_outlined),
                                  selectedIcon: Icon(Icons.circle_rounded),
                                  label: Text('Third'),
                                ),
                              ],
                            ),
                            const VerticalDivider(thickness: 1, width: 1),
                            Container(
                              color: Colors.amberAccent,
                              width: MediaQuery.of(context).size.width - 81,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                                        entries[index].isChecked)
                                                    ? TextDecoration.lineThrough
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
                                    controller: dateController,
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
                                      dateController.text =
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
                                          date: dateController.text,
                                          isChecked: false
                                        )
                                      ];
                                    });
                                    taskController.clear();
                                    dateController.clear();
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
