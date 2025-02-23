import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:namer_app/bookstack.dart';
import 'package:namer_app/filmstack.dart';
import 'package:namer_app/ftree.dart';
import 'package:namer_app/ideas.dart';
import 'package:namer_app/models/problem_model.dart';
import 'package:namer_app/models/film_model.dart';
import 'package:namer_app/problems.dart';
import 'package:namer_app/todo.dart';
import 'package:provider/provider.dart';
import 'canvas.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/boxes.dart';
import 'package:http/http.dart' as http;


void main() async {
  await Hive.initFlutter(); 

  Hive.registerAdapter(ProblemAdapter());
  Hive.registerAdapter(FilmAdapter());
  boxProblems = await Hive.openBox<Problem>("problems");
  boxFilms = await Hive.openBox<Film>("films");
  runApp(MyApp());
}

extension DarkMode on BuildContext {
  /// is dark mode currently enabled?
  bool get isDarkMode {
    final brightness = MediaQuery.of(this).platformBrightness;
    return brightness == Brightness.dark;
  }
}

bool getBooleanValue(bool? result) {
  if (result != null) {
    // Handle the boolean value
    return (result);
  } else {
    // Handle the case where the value is null
    return false;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [const Locale('en'), const Locale('pl')],
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.green,
              primaryContainer: context.isDarkMode
                  ? Colors.grey.shade800
                  : Colors.grey.shade200),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = MainPage();
        break;
      case 1:
        page = TodoPage();
        break;
      case 3:
        page = FilmStackPage();
        break;
      case 4:
        page = BookStackPage();
        break;
      case 5:
        page = IdeasPage();
        break;
      case 6:
        page = BrainstormingPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return MaterialApp(
          theme: ThemeData(
              colorSchemeSeed: const Color(0xff6750a4), useMaterial3: true),
          home: Scaffold(
            appBar: AppBar(
              backgroundColor:
                  context.isDarkMode ? Colors.grey[850] : Colors.grey[250],
              title: Text('Kontrolka',
                  style: TextStyle(
                      fontFamily: 'Monoton',
                      fontSize: 40,
                      color: Colors.lightGreen)),
              centerTitle: true,
            ),
            body: Row(
              children: [
                Expanded(
                  child: Container(
                    color: context.isDarkMode
                        ? Colors.grey[800]
                        : Colors.grey[200],
                    child: page,
                  ),
                ),
              ],
            ),
          ));
    });
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            padding: const EdgeInsets.all(8),
            children: <Widget>[
              GestureDetector(
                  onTap: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return TodoPage();
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
                                  child: Text('TODO',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: context.isDarkMode
                                              ? Colors.grey.shade100
                                              : Colors.grey.shade900,
                                          fontFamily: 'Koulen',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20)),
                                ))),
                        Container(
                          height: 60,
                          width: 100,
                          margin: EdgeInsets.fromLTRB(0, 0, 5, 5),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.green.shade600,
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
                            child: Icon(
                              Icons.assignment_outlined,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
              GestureDetector(
                  onTap: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return CanvasPage();
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
                                  child: Text('CANVAS',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: context.isDarkMode
                                              ? Colors.grey.shade100
                                              : Colors.grey.shade900,
                                          fontFamily: 'Koulen',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20)),
                                ))),
                        Container(
                          height: 60,
                          width: 100,
                          margin: EdgeInsets.fromLTRB(0, 0, 5, 5),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.green.shade600,
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
                            child: Icon(
                              Icons.draw_outlined,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
              GestureDetector(
                  onTap: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return FtreePage();
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
                                  child: Text('FAMILY TREE',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: context.isDarkMode
                                              ? Colors.grey.shade100
                                              : Colors.grey.shade900,
                                          fontFamily: 'Koulen',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20)),
                                ))),
                        Container(
                          height: 60,
                          width: 100,
                          margin: EdgeInsets.fromLTRB(0, 0, 5, 5),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.green.shade600,
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
                            child: Icon(
                              Icons.account_tree_outlined,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
              GestureDetector(
                  onTap: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return FilmStackPage();
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
                                  child: Text('FILM STACK',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: context.isDarkMode
                                              ? Colors.grey.shade100
                                              : Colors.grey.shade900,
                                          fontFamily: 'Koulen',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20)),
                                ))),
                        Container(
                          height: 60,
                          width: 100,
                          margin: EdgeInsets.fromLTRB(0, 0, 5, 5),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.green.shade600,
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
                            child: Icon(
                              Icons.movie_outlined,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
              GestureDetector(
                  onTap: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return BookStackPage();
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
                                  child: Text('BOOK STACK',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: context.isDarkMode
                                              ? Colors.grey.shade100
                                              : Colors.grey.shade900,
                                          fontFamily: 'Koulen',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20)),
                                ))),
                        Container(
                          height: 60,
                          width: 100,
                          margin: EdgeInsets.fromLTRB(0, 0, 5, 5),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.green.shade600,
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
                            child: Icon(
                              Icons.menu_book_outlined,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
              GestureDetector(
                  onTap: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return IdeasPage();
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
                                  child: Text('IDEAS',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: context.isDarkMode
                                              ? Colors.grey.shade100
                                              : Colors.grey.shade900,
                                          fontFamily: 'Koulen',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20)),
                                ))),
                        Container(
                          height: 60,
                          width: 100,
                          margin: EdgeInsets.fromLTRB(0, 0, 5, 5),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.green.shade600,
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
                            child: Icon(
                              Icons.emoji_objects_outlined,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
              GestureDetector(
                  onTap: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return BrainstormingPage();
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
                                  child: Text('BRAINSTORMING',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: context.isDarkMode
                                              ? Colors.grey.shade100
                                              : Colors.grey.shade900,
                                          fontFamily: 'Koulen',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20)),
                                ))),
                        Container(
                          height: 60,
                          width: 100,
                          margin: EdgeInsets.fromLTRB(0, 0, 5, 5),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.green.shade600,
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
                            child: Icon(
                              Icons.psychology_outlined,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        )
                      ],
                    ),
                  ))

              // Container(
              //   height: 50,
              //   color: Colors.amber[100],
              //   child: const Center(child: Text('Entry C')),
              // ),
            ],
          )
        ],
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  // var current = WordPair.random();
  // var favorites = <WordPair>[];
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}







// class BigCard extends StatelessWidget {
//   const BigCard({
//     super.key,
//     required this.pair,
//   });

//   final WordPair pair;

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final style = theme.textTheme.displayMedium!.copyWith(
//       fontSize: 48,
//       color: theme.colorScheme.onPrimary,
//     );

//     return Card(
//       color: theme.colorScheme.primary,
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Text(
//           pair.asLowerCase,
//           style: style,
//           semanticsLabel: "${pair.first} ${pair.second}",
//         ),
//       ),
//     );
//   }
// }
