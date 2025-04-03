import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:provider/provider.dart';
import 'color_schemes.g.dart';
import 'main.dart';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

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

class FamilyMember {
  final double x;
  final double y;
  final int id;
  final String imie;
  final String nazwisko;
  final int relacja;
  final String plec;

  FamilyMember({
    required this.x,
    required this.y,
    required this.id,
    required this.imie,
    required this.nazwisko,
    required this.relacja,
    required this.plec,
  });
}

class MyPainter extends CustomPainter {
  // final double ViewX;
  // final double ViewY;
  List membersList;
  double width;
  double height;

  MyPainter(
      {required this.membersList, required this.width, required this.height});

  @override
  paint(Canvas canvas, Size size) {
    membersList.forEach((element) {
      _paintOsoba(canvas, size, element[1], element[2], element[3], element[4]);
    });
  }

  void _paintOsoba(Canvas canvas, Size size, double x, double y, String Name,
      String surName) {
    Paint paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    Rect rect = Rect.fromLTWH(x, y, 120, 40);
    canvas.drawRect(rect, paint);

    // Rysowanie tekstu z imieniem osoby
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: "${Name} ${surName}",
        style: TextStyle(color: Colors.black, fontSize: 16),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(x, y));
  }

  @override
  bool shouldRepaint(MyPainter oldDelegate) => false;
}

class FamilyTree extends StatefulWidget {
  @override
  createState() => new _FamilyTreeState();
}

class _FamilyTreeState extends State<FamilyTree> {
  List<dynamic> membersList = [];
  double xStart = 0;
  double yStart = 0;
  double width = 0;
  double height = 0;
  double verticalSpacing = 0;
  double horizontalSpacing = 0;
  double mouseX = 0;
  double mouseY = 0;
  double scale = 1;
  double personW = 50;
  double personH = 20;
  double index = 73;
  List family = [];
  List relation = [];
  String membersString = "";
  bool mouseDown = false;

  @override
  initState() {
    super.initState();
    main();
  }

  void main() async {
    // membersString = "";
    family = await fmember();
    relation = await frelation();
    drawTree(family, relation, index, 500, 500, 0);
    setState(() => membersList = jsonDecode(membersString) as List<dynamic>);
  }

  int getIndexbyID(List<dynamic> table, id) {
    // return table ['id'];

    int counter = 0;
    int result = 0;
    table.forEach((element) {
      if (element['id'].toInt() == id) {
        result = counter;
      } else
        counter++;
    });
    return result;
  }

  int calculateKnownParents(family, relation, index) {
    //console.log("calculateKnownParents: ",family[getIndexbyID(family,index)].imie , family[getIndexbyID(family,index)].Nazwisko)
    if (family[getIndexbyID(family, index)]['relacja'] == 0) return 2;

    var KnownParents = calculateKnownParents(
            family,
            relation,
            relation[getIndexbyID(
                    relation, family[getIndexbyID(family, index)]['relacja'])]
                ['Male']) +
        calculateKnownParents(
            family,
            relation,
            relation[getIndexbyID(
                    relation, family[getIndexbyID(family, index)]['relacja'])]
                ['Female']) +
        2;

    return KnownParents;
  }

  List getKnownSiblings(family, relation, index) {
    var relationID = family[getIndexbyID(family, index)]['relacja'];
    var siblingsArray = [];

    for (var element in family) {
      if (element['relacja'] == relationID && element['id'] != index) {
        siblingsArray.add(element['id']);
      }
    }

    return siblingsArray;
  }

  int getRelation(relation, index) {
    var relationID = 0;

    for (var element in relation) {
      if (element['Male'] == index || element['Female'] == index) {
        relationID = element[
            'id']; //jeżeli ma obsługiwać dzieci z więcej niż jednego małżeństwa tu musi zwracać array
      }
    }
    return relationID;
  }

  List getKnownChildren(family, relation, index) {
    var childArray = [];
    var relationID = getRelation(relation, index);
    if (relationID == 0) return [];

    for (var element in family) {
      if (element['relacja'] == relationID) childArray.add(element);
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
      //print(element);
      level++;
      result =
          counter[0] += calculateKnownChildren(family, relation, element['id']);
    }
    return result;
  }

  void addMember(x, y, id, imie, nazwisko, relacja, plec) {
    List<dynamic> membersList = [];
    if (membersString.isEmpty) {
      membersList = [
        [
          id,
          x.toDouble(),
          y.toDouble(),
          imie.toString(),
          nazwisko,
          relacja,
          plec.toString()
        ]
      ];
    } else {
      membersList = jsonDecode(membersString) as List<dynamic>;
      membersList.add([
        id,
        x.toDouble(),
        y.toDouble(),
        imie.toString(),
        nazwisko,
        relacja,
        plec.toString()
      ]);
    }
    membersString = jsonEncode(membersList);
  }

  int drawTree(family, relation, index, x, y, level) {
    if (level > 0 && family[getIndexbyID(family, index)]['Plec'] == "M") {
      x = x - (calculateKnownParents(family, relation, index) + 1) * personW;
      y = y - level * personH;
    } else if (level > 0 &&
        family[getIndexbyID(family, index)]['Plec'] == "K") {
      x = x + (calculateKnownParents(family, relation, index) + 1) * personW;
      y = y - level * personH;
    }
    var current = family[getIndexbyID(family, index)];
    addMember(x, y, current['id'], current['imie'], current['Nazwisko'],
        current['relacja'], current['Plec']);
    if (family[getIndexbyID(family, index)]['relacja'] == 0) return 0;
    var KnownParents = drawTree(
            family,
            relation,
            relation[getIndexbyID(
                    relation, family[getIndexbyID(family, index)]['relacja'])]
                ['Male'],
            x,
            y,
            level = level + 1) +
        drawTree(
            family,
            relation,
            relation[getIndexbyID(
                    relation, family[getIndexbyID(family, index)]['relacja'])]
                ['Female'],
            x,
            y,
            level) +
        2;
    return KnownParents;
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MyPainter(membersList: membersList, height: 100, width: 100),
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
                    print(details.delta);
                  });
                },
                onPanEnd: (DragEndDetails details) => setState(() {}),
                child: Container(
                  constraints: BoxConstraints.expand(),
                  color: Colors.white,
                  child: InteractiveViewer(
                    constrained: false,
                    panAxis: PanAxis.free,
                    trackpadScrollCausesScale: true,
                    minScale: 0.01,
                    maxScale: 5,
                    child: Expanded(child: FamilyTree()),
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
