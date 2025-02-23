import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'color_schemes.g.dart';
import 'main.dart';
import 'dart:ui' as ui;
import 'package:mysql_client/mysql_client.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List> fmember() async {
  var response = await http.get(Uri.parse('http://localhost:3000/fmember'));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load users');
  }
}

Future<List> frelation() async {
  var response = await http.get(Uri.parse('http://localhost:3000/frelation'));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load users');
  }
}

class Osoba {
  final String imie;
  final String id;
  final List<Osoba> dzieci;
  Osoba({required this.imie, required this.id, this.dzieci = const []});
}

Osoba dziadek = Osoba(imie: 'Dziadek', id: '1');
Osoba babcia = Osoba(imie: 'Babcia', id: '2');
Osoba tata = Osoba(imie: 'Tata', id: '3', dzieci: [Osoba(imie: 'Ja', id: '5')]);
Osoba mama = Osoba(imie: 'Mama', id: '4', dzieci: [Osoba(imie: 'Ja', id: '5')]);

Osoba ja = Osoba(imie: 'Ja', id: '5', dzieci: []);

List<Osoba> rodzina = [dziadek, babcia, tata, mama, ja];

class MyPainter extends CustomPainter {
  final Osoba osoba;
  final double xStart;
  final double yStart;
  final double verticalSpacing;
  final double horizontalSpacing;
  final Future<List> family;
  final Future<List> relation;

  MyPainter(
      {required this.osoba,
      required this.xStart,
      required this.yStart,
      required this.family,
      required this.relation,
      this.verticalSpacing = 10,
      this.horizontalSpacing = 15});

  @override
  Future<void> paint(Canvas canvas, Size size) async {
    _paintOsoba(canvas, size, osoba, xStart, yStart);
    print(await family);
  }

  int getIndexbyID(table, id) {
    return table[id];
  }

  int calculateKnownParents(family, relation, index) {
    //console.log("calculateKnownParents: ",family[getIndexbyID(family,index)].imie , family[getIndexbyID(family,index)].Nazwisko)
    if (family[getIndexbyID(family, index)].relacja == 0) return 2;

    var KnownParents = calculateKnownParents(
            family,
            relation,
            relation[getIndexbyID(
                    relation, family[getIndexbyID(family, index)].relacja)]
                .Male) +
        calculateKnownParents(
            family,
            relation,
            relation[getIndexbyID(
                    relation, family[getIndexbyID(family, index)].relacja)]
                .Female) +
        2;

    return KnownParents;
  }

  List getKnownSiblings(family, relation, index) {
    var relationID = family[getIndexbyID(family, index)].relacja;
    var siblingsArray = [];

    for (var element in family) {
      if (element.relacja == relationID && element.id != index)
        siblingsArray.add(element.id);
    }

    return siblingsArray;
  }

  int getRelation(relation, index) {
    var relationID = 0;

    for (var element in relation) {
      if (element.Male == index || element.Female == index)
        relationID = element
            .id; //jeżeli ma obsługiwać dzieci z więcej niż jednego małżeństwa tu musi zwracać array
    }
    return relationID;
  }

  List getKnownChildren(family, relation, index) {
    var childArray = [];
    var relationID = getRelation(relation, index);
    if (relationID == 0) return [];

    for (var element in family) {
      if (element.relacja == relationID) childArray.add(element);
    }
    return childArray;
  }

  int calculateKnownChildren(family, relation, index) {
    var counter = [1, 0];
    var result;
    var level = 0;
    if (getKnownChildren(family, relation, index) == 0) {
      return 1;
    }

    for (var element in getKnownChildren(family, relation, index)) {
      print(element);
      level++;
      result =
          counter[0] += calculateKnownChildren(family, relation, element.id);
    }
    return result;
  }

  void _paintOsoba(Canvas canvas, Size size, Osoba osoba, double x, double y) {
    // Rysowanie prostokąta reprezentującego osobę
    Paint paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    Rect rect = Rect.fromLTWH(x, y, 120, 40);
    canvas.drawRect(rect, paint);

    // Rysowanie tekstu z imieniem osoby
    TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: osoba.imie,
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        textDirection: ui.TextDirection.ltr);
    textPainter.layout();
    textPainter.paint(canvas, Offset(x + 10, y + 10));

    // Rysowanie linii do dzieci
    if (osoba.dzieci.isNotEmpty) {
      double childX = x - (osoba.dzieci.length - 1) * horizontalSpacing / 2;
      double childY = y + verticalSpacing;

      for (var dziecko in osoba.dzieci) {
        // Rysowanie linii do dziecka
        Paint linePaint = Paint()
          ..color = Colors.black
          ..strokeWidth = 2;

        canvas.drawLine(
            Offset(x + 60, y + 40), Offset(childX + 60, childY), linePaint);

        // Rekurencyjne rysowanie drzewa dla dziecka
        _paintOsoba(canvas, size, dziecko, childX, childY);

        childX += horizontalSpacing;
      }
    }
  }

  @override
  bool shouldRepaint(MyPainter oldDelegate) => false;
}

class FtreeApp extends StatelessWidget {
  const FtreeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          colorSchemeSeed: const Color(0xff6750a4), useMaterial3: true),
      home: FtreePage(),
    );
  }
}

class _FtreePageState extends State<FtreePage> {
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
                    painter: MyPainter(
                        osoba: rodzina.first,
                        xStart: 250,
                        yStart: 200,
                        family: fmember(),
                        relation: frelation()),
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

class FtreePage extends StatefulWidget {
  @override
  State<FtreePage> createState() => _FtreePageState();
}
