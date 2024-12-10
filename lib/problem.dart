import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:markdown_toolbar/markdown_toolbar.dart';
import 'color_schemes.g.dart';
import 'main.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ProblemPage extends StatefulWidget {
  final String title, type, description;
  const ProblemPage(
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
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Visibility(
                  visible: true,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MarkdownToolbar(
                      controller: noteController, useIncludedTextField: true,
                    ),
                  ),
                ),
                Visibility(
                  visible: editMode,
                  child: Expanded(
                    child: Padding(
                      padding: EdgeInsetsGeometry.infinity,
                      child: TextField(
                        controller: noteController,
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: const InputDecoration(
                          hintText: 'Start writing something...',
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                        ),
                        onChanged: (value) {
                          setState(() {
                            //widget.note.noteText = value;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: editMode,
                  child: Expanded(
                    child: GestureDetector(
                      onDoubleTap: () => setState(() {
                        editMode = true;
                      }),
                      child: Markdown(
                        data: 'easdasdasdasdasdasdasdasdasd'
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ));
    });
 
}
}