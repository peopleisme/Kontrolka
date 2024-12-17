import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:markdown_toolbar/markdown_toolbar.dart';
import 'color_schemes.g.dart';
import 'main.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class FilmPage extends StatefulWidget {
  final String title, type, description;
  const FilmPage(
      {Key? key,
      required this.title,
      required this.type,
      required this.description})
      : super(key: key);

  @override
  State<ProblemPage> createState() => _ProblemPageState();
}

class _ProblemPageState extends State<ProblemPage> {
  bool editMode = true;
  TextEditingController noteController = TextEditingController();
  UndoHistoryController undoController = UndoHistoryController();

  @override
  Widget build(BuildContext context) {
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
                centerTitle: editMode,
                title: Center(
                  child: Text(widget.title,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: context.isDarkMode
                              ? Colors.grey.shade100
                              : Colors.grey.shade900,
                          fontFamily: 'Koulen',
                          fontWeight: FontWeight.w100,
                          fontSize: 24)),
                )),
            body: Column(),
          ));
    });
 
}
}