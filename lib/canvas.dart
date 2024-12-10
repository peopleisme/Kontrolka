import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'color_schemes.g.dart';
import 'main.dart';

class MyPainter extends CustomPainter {
  const MyPainter({required this.offsets});

  final List<Offset> offsets;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = Colors.blue.shade900;
    paint.strokeWidth = 5.0;

    for (int i = 0; i < offsets.length - 1; i++) {
      canvas.drawLine(offsets[i], offsets[i + 1], paint);
    }
  }

  @override
  bool shouldRepaint(MyPainter oldDelegate) => true;
}

class CanvasApp extends StatelessWidget {
  const CanvasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          colorSchemeSeed: const Color(0xff6750a4), useMaterial3: true),
      home: CanvasPage(),
    );
  }
}

class _CanvasPageState extends State<CanvasPage> {
  List<Offset> offsets = <Offset>[];
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
              ),
              body: GestureDetector(
                onPanUpdate: (DragUpdateDetails details) {
                  setState(() {
                    offsets.add(details.localPosition);
                  });
                },
                onPanEnd: (DragEndDetails details) => setState(() {}),
                child: Container(
                  constraints: BoxConstraints.expand(),
                  color: Colors.white,
                  child: CustomPaint(
                    painter: MyPainter(offsets: offsets),
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                tooltip: 'Favorite',
                child: const Icon(Icons.add),
                onPressed: () {},
              )));
    });
  }
}

class CanvasPage extends StatefulWidget {
  @override
  State<CanvasPage> createState() => _CanvasPageState();
}
