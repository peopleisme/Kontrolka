import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'color_schemes.g.dart';
import 'main.dart';
import 'problem.dart';
import 'models/boxes.dart';
import 'models/problem_model.dart';

class _BrainstormingPageState extends State<BrainstormingPage> {
  final textController = new TextEditingController();
  final ProblemFormKey = GlobalKey<FormState>();
  final problemKey = GlobalKey<_ListOf_problemsState>();
  final List<String> list = <String>['Urgent', 'Lifetime', 'Thoughts'];
  static const String defaultDropdown = "Thoughts";
  String dropdownValue = defaultDropdown;
  bool submit = false;

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    textController.addListener(() {
      // setState(() {
      //   submit = textController.text.isNotEmpty;
      //   print(textController.text);
      // });
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    Future<Box>? _data;
    void initState() {
      // _data = Hive.openBox('BS');
    }

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
                  centerTitle: false,
                  title: Text('BRAINSTORMING',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: context.isDarkMode
                              ? Colors.grey.shade100
                              : Colors.grey.shade900,
                          fontFamily: 'Koulen',
                          fontWeight: FontWeight.w500,
                          fontSize: 22))),
              body: SingleChildScrollView(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [ListOf_problems(key: problemKey)],
              )),
              floatingActionButton: FloatingActionButton(
                tooltip: 'New Problem',
                child: const Icon(Icons.add),
                onPressed: () async {
                  textController.clear();
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return StatefulBuilder(
                            builder: (context, setStateSB) => Dialog(
                                  child: SizedBox(
                                      width: 220,
                                      child: Padding(
                                        padding: const EdgeInsets.all(26.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text("New Problem",
                                                textWidthBasis:
                                                    TextWidthBasis.longestLine,
                                                style: TextStyle(fontSize: 24),
                                                textAlign: TextAlign.start),
                                            Form(
                                              key: ProblemFormKey,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  TextFormField(
                                                      controller: textController,
                                                      decoration:
                                                          InputDecoration(
                                                        labelText: 'Problem',
                                                      ),
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return 'Input problem!';
                                                        }
                                                        return null;
                                                      }),
                                                  DropdownButton<String>(
                                                    //alignment: AlignmentDirectional.center,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black),
                                                    value: dropdownValue,
                                                    isExpanded: true,
                                                    items: list.map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                        (String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(value),
                                                      );
                                                    }).toList(),
                                                    onChanged: (String?
                                                        selectedvalue) {
                                                      dropdownValue =
                                                          selectedvalue!;
                                                      setState(
                                                          () {}); // update the main(state) UI
                                                      setStateSB(
                                                          () {}); // update UI inside Dialog
                                                    },
                                                  )
                                                ],
                                              ),
                                            ),
                                            OutlinedButton(
                                              child: Text("Add"),
                                              onPressed: () {
                                                if (ProblemFormKey.currentState!
                                                    .validate()) {
                                                  Navigator.pop(context);
                                                  final state =
                                                      problemKey.currentState!;
                                                  state.addProblem(
                                                      textController.text,
                                                      dropdownValue);
                                                  textController.clear();
                                                  dropdownValue =
                                                      defaultDropdown;
                                                }
                                              },
                                            )
                                          ],
                                        ),
                                      )),
                                ));
                      });
                },
              )));
    });
  }
}

// ignore: camel_case_types
class ListOf_problems extends StatefulWidget {
  ListOf_problems({Key? key}) : super(key: key);

  @override
  _ListOf_problemsState createState() => _ListOf_problemsState();
}

class _ListOf_problemsState extends State<ListOf_problems> {
  Icon icon = Icon(Icons.question_mark_rounded);
  Color color = Colors.white;
  List<Problem> problems = <Problem>[];

  @override
  void initState() {
    super.initState();
    printHive();
  }

  Future<void> printHive() async {
    print(boxProblems.toMap());
  }

  Future<Map<dynamic, dynamic>> buildWidget() async {
    return boxProblems.toMap();
  }

  Future<void> addProblem(title, type) async {
    setState(() {
      boxProblems
          .add(Problem(title: title, type: type, description: "lelum polelum"));
      problems = [
        ...problems,
      ];
    });
  }

  void setProblems(problems) {
    setState(() {
      problems = problems;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<dynamic, dynamic>>(
      future: buildWidget(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(8),
              itemCount: snapshot.data?.length,
              itemBuilder: (BuildContext context, int index) {
                //print(snapshot.data?.keys);
                var sdata = snapshot.data?.entries.elementAt(index).value;
                switch (sdata.type) {
                  case "Urgent":
                    icon = Icon(Icons.warning_amber_rounded,
                        size: 40,
                        color: context.isDarkMode
                            ? Colors.grey.shade100
                            : Colors.grey.shade900);
                    color = Colors.amber;
                    break;
                  case "Lifetime":
                    icon = Icon(Icons.signpost_outlined,
                        size: 40,
                        color: context.isDarkMode
                            ? Colors.grey.shade100
                            : Colors.grey.shade900);
                    color = Colors.green;
                    break;
                  case "Thoughts":
                    icon = Icon(Icons.chat_bubble_outline_rounded,
                        size: 40,
                        color: context.isDarkMode
                            ? Colors.grey.shade100
                            : Colors.grey.shade900);
                    color = Colors.lightBlueAccent;
                    break;
                  default:
                    icon = Icon(Icons.question_mark_rounded,
                        size: 40,
                        color: context.isDarkMode
                            ? Colors.grey.shade100
                            : Colors.grey.shade900);
                    color = Colors.green;
                    break;
                }

                return GestureDetector(
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return ProblemPage(
                            title: sdata.title,
                            type: sdata.type,
                            description: sdata.description);
                      }),
                    )
                  },
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                            child: Container(
                                margin: EdgeInsets.fromLTRB(5, 0, 0, 5),
                                decoration: BoxDecoration(
                                  color: context.isDarkMode
                                      ? Colors.grey[700]
                                      : Colors.grey[200],
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      bottomLeft: Radius.circular(12)),
                                  border: Border(
                                    top: BorderSide(
                                        color: Colors
                                            .grey.shade900, // Set border color
                                        width: 1.0),
                                    right: BorderSide(
                                        color: Colors
                                            .grey.shade900, // Set border color
                                        width: 0.0),
                                    bottom: BorderSide(
                                        color: Colors
                                            .grey.shade900, // Set border color
                                        width: 1.0),
                                    left: BorderSide(
                                        color: Colors
                                            .grey.shade900, // Set border color
                                        width: 1.0),
                                  ),
                                ),
                                child: Center(
                                  child: Text(sdata.title,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: context.isDarkMode
                                              ? Colors.grey.shade100
                                              : const Color.fromARGB(
                                                  255, 2, 2, 2),
                                          fontFamily: 'Oswald',
                                          fontWeight: FontWeight.w300,
                                          fontSize: 16)),
                                ))),
                        Container(
                          height: 60,
                          width: 100,
                          margin: EdgeInsets.fromLTRB(0, 0, 5, 5),
                          child: Container(
                            decoration: BoxDecoration(
                                color: color,
                                border: Border(
                                  top: BorderSide(
                                      color: Colors
                                          .grey.shade900, // Set border color
                                      width: 1.0),
                                  right: BorderSide(
                                      color: Colors
                                          .grey.shade900, // Set border color
                                      width: 1.0),
                                  bottom: BorderSide(
                                      color: Colors
                                          .grey.shade900, // Set border color
                                      width: 1.0),
                                  left: BorderSide(
                                      color: Colors
                                          .grey.shade900, // Set border color
                                      width: 0.0),
                                ), // Set border width
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0))
                                // Set rounded corner radius
                                ),
                            child: icon,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }
        } else {
          return Text("nie wiem co robie sorki");
        }
      },
    );
  }
}

class BrainstormingPage extends StatefulWidget {
  @override
  State<BrainstormingPage> createState() => _BrainstormingPageState();
}
