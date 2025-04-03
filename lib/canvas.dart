import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'color_schemes.g.dart';
import 'main.dart';

class drawing {
  final String type;
  final double x;
  final double y;
  final Color color;
  final double width;

  drawing(this.type, this.x, this.y, this.color, this.width);
}

class MyPainter extends CustomPainter {
  const MyPainter({required this.offsets});

  final List<dynamic> offsets;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = Colors.blue.shade900;
    paint.strokeWidth = 5.0;
    paint.style = PaintingStyle.stroke;

    for (int i = 0; i < offsets.length - 1; i++) {
      var triangle = Path();
      if (offsets[i].type != "break" && offsets[i+1].type != "break" ) {
        triangle.moveTo(offsets[i + 1].x, offsets[i + 1].y);
        triangle.lineTo(offsets[i].x, offsets[i].y);
        canvas.drawPath(triangle, paint);
      }
    }
  }

  @override
  bool shouldRepaint(MyPainter oldDelegate) => true;
}

class _CanvasPageState extends State<CanvasPage> {
  List<drawing> offsets = <drawing>[];
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
                    offsets.add(drawing("line", details.localPosition.dx,
                        details.localPosition.dy, Colors.black, 5.0));
                  });
                },
                onPanEnd: (DragEndDetails details) => setState(() {
                  offsets.add(drawing("break", 0.0, 0.0, Colors.black, 0.0));
                }),
                child: Container(
                  constraints: BoxConstraints.expand(),
                  color: Colors.white,
                  child: CustomPaint(
                    painter: MyPainter(offsets: offsets),
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                heroTag: null,
                tooltip: 'Favorite',
                child: const Icon(Icons.add),
                onPressed: () {},
                
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,));
    });
  }
}

class CanvasPage extends StatefulWidget {
  @override
  State<CanvasPage> createState() => _CanvasPageState();
}
