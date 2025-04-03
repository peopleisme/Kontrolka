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
      if (offsets[i].type != "break" && offsets[i + 1].type != "break") {
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
  bool drawingMode = true;
  double colorHeight = 50;
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
              child: Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: [
                  Container(
                    constraints: BoxConstraints.expand(),
                    color: Colors.white,
                    child: CustomPaint(
                      painter: MyPainter(offsets: offsets),
                    ),
                  ),
                  Container(
                    height: 200,
                    alignment: Alignment.bottomCenter,
                    width: 5000,
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              width: 56,
                              height: 200,
                              color: Theme.of(context).colorScheme.secondary,
                              child: Column(children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.horizontal_rule,
                                    size: 32,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.horizontal_rule,
                                    size: 32,
                                    grade: 1,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.horizontal_rule,
                                    size: 32,
                                  ),
                                ),
                              ]),
                            ),
                          ),
                          SizedBox(
                            width: 96,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.fastOutSlowIn,
                                width: 56,
                                height: colorHeight,
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      width: 2,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.red,
                                        Colors.blue,
                                        Colors.green,
                                        Colors.yellow,
                                        Colors.purple,
                                      ]),
                                ),
                              ),
                            ],
                          )
                        ]),
                  ),
                  Container(
                    // color: Colors.black,
                    height: 85,
                    alignment: Alignment.bottomCenter,
                    child: Center(
                      child: Container(
                        height: 75,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FloatingActionButton(
                                heroTag: null,
                                onPressed: () {},
                                child: Icon(
                                  Icons.delete_forever_rounded,
                                  size: 32,
                                )),
                            SizedBox(
                              width: 15,
                            ),
                            FloatingActionButton(
                                heroTag: null,
                                onPressed: () {},
                                child: Icon(
                                  Icons.horizontal_rule,
                                  size: 32,
                                )),
                            FloatingActionButton.large(
                              shape: const CircleBorder(),
                              onPressed: () {
                                print(drawingMode);
                                setState(() {
                                  drawingMode = !drawingMode;
                                });
                              },
                              child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 100),
                                  transitionBuilder: (child, anim) =>
                                      RotationTransition(
                                        turns: child.key == ValueKey('icon1')
                                            ? Tween<double>(
                                                    begin: 0.5, end: 0.0)
                                                .animate(anim)
                                            : Tween<double>(begin: 1, end: 1)
                                                .animate(anim),
                                        child: FadeTransition(
                                            opacity: anim, child: child),
                                      ),
                                  child: drawingMode
                                      ? Icon(Icons.edit,
                                          key: const ValueKey('icon1'))
                                      : Icon(
                                          Icons.pan_tool_alt,
                                          key: const ValueKey('icon2'),
                                        )),
                            ),
                            FloatingActionButton(
                                heroTag: null,
                                onPressed: () {
                                  setState(() {
                                    if (colorHeight == 50)
                                      colorHeight = 200;
                                    else
                                      colorHeight = 50;
                                  });
                                },
                                child: Icon(
                                  Icons.palette,
                                  size: 32,
                                )),
                            SizedBox(
                              width: 15,
                            ),
                            FloatingActionButton(
                                heroTag: null,
                                onPressed: () {},
                                child: Icon(
                                  Icons.save_rounded,
                                  size: 32,
                                )),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ));
    });
  }
}

class CanvasPage extends StatefulWidget {
  @override
  State<CanvasPage> createState() => _CanvasPageState();
}
