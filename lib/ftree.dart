import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:provider/provider.dart';
import 'color_schemes.g.dart';
import 'main.dart';
import 'dart:ui' as ui;
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
  Osoba osoba;
  double xStart;
  double yStart;
  double width;
  double height;
  double verticalSpacing;
  double horizontalSpacing;
  double mouseX;
  double mouseY;
  double scale;
  double personW;
  double personH;
  double index;
  Future<List> family;
  Future<List> relation;
  String membersString = "";
  bool mouseDown;
  // final double ViewX;
  // final double ViewY;

  MyPainter({
    required this.osoba,
    required this.xStart,
    required this.yStart,
    required this.width,
    required this.height,
    this.verticalSpacing = 10,
    this.horizontalSpacing = 15,
    this.mouseX = 0,
    this.mouseY = 0,
    this.scale = 1,
    this.personW = 45,
    this.personH = 35,
    this.index = 73,
    required this.family,
    required this.relation,
    this.membersString = "",
    this.mouseDown = false,
    // this.ViewX = width  / -2,
    // this.ViewY = this.height / -2,
  });

  @override
  Future<void> paint(Canvas canvas, Size size) async {
    // _paintOsoba(canvas, size, osoba, xStart, yStart);
    //  print(await family);
    var family = await fmember();
    var relation = await frelation();
    await drawTree(family, relation, index, 500, 500, 0);
    print(membersString);
    List<dynamic> membersList = jsonDecode(membersString) as List<dynamic>;

    Paint paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    // Rect rect = new Rect.fromLTWH(0, 0, 120, 40);
//canvas.drawRect(rect, paint);

    membersList.forEach((element) {
      TextPainter textPainter = TextPainter(
          text: TextSpan(
            text: element[3],
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
          textDirection: ui.TextDirection.ltr);
      textPainter.layout();
      textPainter.paint(canvas, Offset(element[1] + 10, element[2] + 10));
    });
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
          counter[0] += calculateKnownChildren(family, relation, element.id);
    }
    return result;
  }

  addMember(x, y, id, imie, nazwisko, relacja, plec) {
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

  Future<int> drawTree(family, relation, index, x, y, level) async {
    //console.log("drawTree: ",family[getIndexbyID(family,index)].imie , family[getIndexbyID(family,index)].Nazwisko)
    //console.log(calculateKnownParents(family,relation,index))

    if (level > 0 && family[getIndexbyID(family, index)]['Plec'] == "M") {
      x = x - (calculateKnownParents(family, relation, index) + 1) * personW;
      y = y - level * personH;
    } else if (level > 0 &&
        family[getIndexbyID(family, index)]['Plec'] == "K") {
      x = x + (calculateKnownParents(family, relation, index) + 1) * personW;
      y = y - level * personH;
    }
    var current = family[getIndexbyID(family, index)];
    //ctx.strokeText(family[getIndexbyID(family,index)].imie+" "+family[getIndexbyID(family,index)].Nazwisko, x, y);
    addMember(x, y, current['id'], current['imie'], current['Nazwisko'],
        current['relacja'], current['Plec']);
    if (family[getIndexbyID(family, index)]['relacja'] == 0) return 0;
    var KnownParents = await drawTree(
            family,
            relation,
            relation[getIndexbyID(
                    relation, family[getIndexbyID(family, index)]['relacja'])]
                ['Male'],
            x,
            y,
            level = level + 1) +
        await drawTree(
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
                      relation: frelation(),
                      width: MediaQuery.sizeOf(context).width,
                      height: MediaQuery.sizeOf(context).height,
                    ),
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
