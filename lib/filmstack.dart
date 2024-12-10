import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'color_schemes.g.dart';
import 'main.dart';

class CanvasApp extends StatelessWidget {
  const CanvasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          colorSchemeSeed: const Color(0xff6750a4), useMaterial3: true),
      home: FilmStackPage(),
    );
  }
}

class _FilmStackPageState extends State<FilmStackPage> {
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
                centerTitle: true,
                title: Text('FILM STACK',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: context.isDarkMode
                                              ? Colors.grey.shade100
                                              : Colors.grey.shade900,
                                          fontFamily: 'Koulen',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 24))
              ),
              body: SizedBox(height: 10,width: 10,),
              floatingActionButton: FloatingActionButton(
                tooltip: 'Favorite',
                child: const Icon(Icons.add),
                onPressed: () {},
              )));
    });
  }
}

class FilmStackPage extends StatefulWidget {
  @override
  State<FilmStackPage> createState() => _FilmStackPageState();
}
