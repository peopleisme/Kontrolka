import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'canvas.dart';
import 'color_schemes.g.dart';
import 'main.dart';


class _CanvasesPageState extends State<CanvasesPage> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

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
                  title: Text('CANVASES',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: context.isDarkMode
                              ? Colors.grey.shade100
                              : Colors.grey.shade900,
                          fontFamily: 'Koulen',
                          fontWeight: FontWeight.w500,
                          fontSize: 22))),
              body: SizedBox(
                height: 10,
                width: 10,
              ),
              floatingActionButton: FloatingActionButton(
                tooltip: 'New Canvas',
                child: const Icon(Icons.brush_rounded),
                onPressed: () {Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return CanvasPage();
                          }),
                        );},
              )));
    });
  }
}

class CanvasesPage extends StatefulWidget {
  @override
  State<CanvasesPage> createState() => _CanvasesPageState();
}
