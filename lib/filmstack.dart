import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_pannable_rating_bar/flutter_pannable_rating_bar.dart';
import 'package:provider/provider.dart';
import 'color_schemes.g.dart';
import 'main.dart';
import 'models/boxes.dart';
import 'models/film_model.dart';
import 'dart:ui';

class _FilmStackPageState extends State<FilmStackPage> {
  final textController = TextEditingController();
  final FilmFormKey = GlobalKey<FormState>();
  final filmKey = GlobalKey<_ListOf_filmsState>();
  double rating = 0.0;
  String sortingDropdown = "asc_title";
  bool isGridView = false, SeenDisplay = false, isSeenform = true;
  String display = "list";

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    textController.addListener(() {
      // setState(() {
      //   submit = textController.text.isNotEmpty;
      //   print(textController.text);
      // });
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    textController.dispose();
    super.dispose();
  }

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
                  title: Text('FILM STACK',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: context.isDarkMode
                              ? Colors.grey.shade100
                              : Colors.grey.shade900,
                          fontFamily: 'Koulen',
                          fontWeight: FontWeight.w500,
                          fontSize: 22))),
              body: Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(12.5, 5, 12.5, 5),
                    height: 50,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: SearchAnchor(builder: (BuildContext context,
                              SearchController controller) {
                            return SearchBar(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.grey[700]),
                              surfaceTintColor:
                                  MaterialStateProperty.all(Colors.grey[700]),
                              controller: controller,
                              leading: Icon(Icons.search),
                              onTap: () {
                                controller.openView();
                              },
                              onChanged: (_) {
                                controller.openView();
                              },
                            );
                          }, suggestionsBuilder: (BuildContext context,
                              SearchController controller) {
                            return List<ListTile>.generate(5, (int index) {
                              final String item = 'item $index';
                              return ListTile(
                                title: Text(""),
                                onTap: () {
                                  setState(() {
                                    controller.closeView(item);
                                  });
                                },
                              );
                            });
                          }),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: DropdownButton<String>(
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                            value: sortingDropdown,
                            isExpanded: false,
                            items: [
                              DropdownMenuItem<String>(
                                  value: "asc_title",
                                  child: Text(
                                    "Sort by title",
                                    style: TextStyle(
                                        color: context.isDarkMode
                                            ? Colors.grey.shade100
                                            : Colors.grey.shade900),
                                  )),
                              DropdownMenuItem<String>(
                                  value: "desc_rating",
                                  child: Text(
                                    "Sort by rating",
                                    style: TextStyle(
                                        color: context.isDarkMode
                                            ? Colors.grey.shade100
                                            : Colors.grey.shade900),
                                  )),
                            ],
                            onChanged: (String? selectedvalue) {
                              sortingDropdown = selectedvalue!;
                              setState(() {});
                              // update UI inside Dialog
                            },
                          ),
                        ),
                        IconButton(
                          iconSize: 30.0,
                          padding: EdgeInsets.only(left: 4, right: 4, top: 0),
                          icon: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: SeenDisplay == true
                                  ? Icon(Icons.visibility_outlined)
                                  : Icon(Icons.visibility_off_outlined)),
                          onPressed: () {
                            setState(() {
                              SeenDisplay = !SeenDisplay;
                              // if (SeenDisplay)
                              //   display = "grid";
                              // else
                              //   display = "list";
                            });
                          },
                        ),
                        IconButton(
                            iconSize: 30.0,
                            padding: EdgeInsets.only(left: 4, right: 4, top: 0),
                            icon: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: isGridView == true
                                    ? Icon(Icons.view_list)
                                    : Icon(Icons.dashboard)),
                            onPressed: () {
                              setState(() {
                                isGridView = !isGridView;
                                if (isGridView) {
                                  display = "grid";
                                } else {
                                  display = "list";
                                }
                              });
                            }),
                      ],
                    ),
                  ),
                  Expanded(
                      child: SingleChildScrollView(
                          child: ListOf_films(
                    key: filmKey,
                    sorting: sortingDropdown,
                    display: display,
                    SeenDisplay: SeenDisplay,
                  )))
                ],
              ),
              floatingActionButton: FloatingActionButton(
                  tooltip: 'Add',
                  child: const Icon(Icons.add),
                  onPressed: () async {
                    textController.text = "";
                    rating = 2.5;
                    isSeenform = false;
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(
                              builder: (context, setState) => Dialog(
                                    child: SizedBox(
                                        width: 220,
                                        child: Padding(
                                          padding: const EdgeInsets.all(26.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text("New Film",
                                                  textWidthBasis: TextWidthBasis
                                                      .longestLine,
                                                  style:
                                                      TextStyle(fontSize: 24),
                                                  textAlign: TextAlign.start),
                                              Form(
                                                key: FilmFormKey,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    TextFormField(
                                                        controller:
                                                            textController,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText: 'Title',
                                                        ),
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return 'Input film!';
                                                          }
                                                          return null;
                                                        }),
                                                    Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              0, 10, 0, 5),
                                                      child: SegmentedButton<
                                                              bool>(
                                                          showSelectedIcon:
                                                              false,
                                                          segments: const <ButtonSegment<
                                                              bool>>[
                                                            ButtonSegment<bool>(
                                                                value: true,
                                                                label: Text(
                                                                    'Seen'),
                                                                icon: Icon(Icons
                                                                    .visibility_outlined)),
                                                            ButtonSegment<bool>(
                                                                value: false,
                                                                label: Text(
                                                                    'Not seen'),
                                                                icon: Icon(Icons
                                                                    .visibility_off_outlined)),
                                                          ],
                                                          selected:
                                                              isSeenform == null
                                                                  ? {}
                                                                  : {
                                                                      isSeenform!
                                                                    },
                                                          onSelectionChanged:
                                                              (newSelection) {
                                                            setState(() {
                                                              isSeenform =
                                                                  newSelection
                                                                      .first;
                                                            });
                                                          }),
                                                    ),
                                                    PannableRatingBar(
                                                      rate: rating,
                                                      items: List.generate(
                                                          5,
                                                          (index) =>
                                                              const RatingWidget(
                                                                selectedColor:
                                                                    Colors
                                                                        .orangeAccent,
                                                                unSelectedColor:
                                                                    Colors.grey,
                                                                child: Icon(
                                                                  Icons
                                                                      .star_border,
                                                                  size: 40,
                                                                ),
                                                              )),
                                                      onChanged: (value) {
                                                        // the rating value is updated on tap or drag.
                                                        setState(() {
                                                          rating = value;
                                                        });
                                                      },
                                                    )
                                                  ],
                                                ),
                                              ),
                                              OutlinedButton(
                                                child: Text("Add"),
                                                onPressed: () {
                                                  if (FilmFormKey.currentState!
                                                      .validate()) {
                                                    Navigator.pop(context);
                                                    final state =
                                                        filmKey.currentState!;
                                                    state.addFilm(
                                                        isSeenform,
                                                        textController.text,
                                                        "poster",
                                                        rating * 2,
                                                        0.0,
                                                        "lorem ipsum",
                                                        1970);
                                                    textController.clear();
                                                  }
                                                },
                                              )
                                            ],
                                          ),
                                        )),
                                  ));
                        });
                  })));
    });
  }
}

class ListOf_films extends StatefulWidget {
  final String sorting, display;
  bool SeenDisplay;
  ListOf_films(
      {Key? key,
      required this.sorting,
      required this.display,
      required this.SeenDisplay})
      : super(key: key);

  @override
  _ListOf_filmsState createState() => _ListOf_filmsState();
}

class _ListOf_filmsState extends State<ListOf_films> {
  Icon icon = Icon(Icons.question_mark_rounded);
  Color color = Colors.white;
  List<Film> films = <Film>[];

  @override
  void initState() {
    super.initState();
    printHive();
  }

  Future<void> printHive() async {
    print(boxFilms.toMap());
  }

  Future<Map<dynamic, dynamic>> buildWidget() async {
    // final response = await http.get(Uri.parse(
    //     'http://www.omdbapi.com/?i=tt3896198&apikey=e386d16d&t=Scarface'));
    // print(response.body);
    return boxFilms.toMap();
  }

  Future<void> addFilm(seen, title,
      [poster = "",
      myRating = 0,
      imdbRating = 0,
      plot = "",
      year = 1970]) async {
    setState(() {
      boxFilms.add(Film(
          seen: seen,
          title: title,
          poster: poster,
          myRating: myRating,
          imdbRating: imdbRating,
          plot: plot,
          year: year));
      films = [
        ...films,
      ];
    });
  }

  void setfilms(films) {
    setState(() {
      films = films;
    });
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;

    return FutureBuilder<Map<dynamic, dynamic>>(
      future: buildWidget(),
      builder: (BuildContext context, snapshot) {
        var sdata = snapshot.data;
        // sdata =sdata!.entries.where((seen) => seen == 0) as Map;
        //print(sdata!.entries.toList().where((element) => true));
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            Map<dynamic, dynamic> MapEntries;
            List<dynamic> sEntries;
            MapEntries = Map.fromEntries(sdata!.entries
                .where((element) => element.value.seen == widget.SeenDisplay));
            sEntries = MapEntries.entries.toList();
            switch (widget.sorting) {
              case "asc_title":
                sEntries = sEntries
                  ..sort((e1, e2) => e1.value.title.compareTo(e2.value.title));
                break;
              case "desc_title":
                sEntries = sEntries
                  ..sort((e1, e2) => e2.value.title.compareTo(e1.value.title));
                break;
              case "asc_rating":
                sEntries = sEntries
                  ..sort((e1, e2) =>
                      e1.value.myRating.compareTo(e2.value.myRating));
                break;
              case "desc_rating":
                sEntries = sEntries
                  ..sort((e1, e2) =>
                      e2.value.myRating.compareTo(e1.value.myRating));
                break;
            }
            if (widget.display == "list") {
              return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(8),
                itemCount: sEntries.length,
                itemBuilder: (BuildContext context, int index) {
                  var element = sEntries.elementAt(index).value;
                  if (widget.SeenDisplay == element.seen) {
                    return GestureDetector(
                      onTap: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return Placeholder();
                          }),
                        )
                      },
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                                child: Container(
                                    margin: EdgeInsets.fromLTRB(5, 0, 0, 5),
                                    decoration: BoxDecoration(
                                      color: context.isDarkMode
                                          ? Colors.grey[700]
                                          : Colors.grey[200],
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          bottomLeft: Radius.circular(12)),
                                      border: Border(
                                        top: BorderSide(
                                            color: Colors.grey
                                                .shade900, // Set border color
                                            width: 1.0),
                                        right: BorderSide(
                                            color: Colors.grey
                                                .shade900, // Set border color
                                            width: 0.0),
                                        bottom: BorderSide(
                                            color: Colors.grey
                                                .shade900, // Set border color
                                            width: 1.0),
                                        left: BorderSide(
                                            color: Colors.grey
                                                .shade900, // Set border color
                                            width: 1.0),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(element.title,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: context.isDarkMode
                                                  ? Colors.grey.shade100
                                                  : const Color.fromARGB(
                                                      255, 2, 2, 2),
                                              fontFamily: 'Oswald',
                                              fontWeight: FontWeight.w300,
                                              fontSize: 16)),
                                    ))),
                            Container(
                              height: 60,
                              width: 100,
                              margin: EdgeInsets.fromLTRB(0, 0, 5, 5),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.amber,
                                    border: Border(
                                      top: BorderSide(
                                          color: Colors.grey
                                              .shade900, // Set border color
                                          width: 1.0),
                                      right: BorderSide(
                                          color: Colors.grey
                                              .shade900, // Set border color
                                          width: 1.0),
                                      bottom: BorderSide(
                                          color: Colors.grey
                                              .shade900, // Set border color
                                          width: 1.0),
                                      left: BorderSide(
                                          color: Colors.grey
                                              .shade900, // Set border color
                                          width: 0.0),
                                    ), // Set border width
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10.0),
                                        bottomRight: Radius.circular(10.0))
                                    // Set rounded corner radius
                                    ),
                                child: Center(
                                    child: Text(
                                        style: TextStyle(
                                            fontFamily: 'Koulen',
                                            color: Colors.black87,
                                            fontSize: 24),
                                        element.myRating.toString())),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              );
            } else if (widget.display == "grid") {
              return GridView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(8),
                  itemCount: sEntries.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          (orientation == Orientation.portrait) ? 2 : 4,
                      childAspectRatio: 0.66,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10),
                  itemBuilder: (BuildContext context, int index) {
                    var element = sEntries.elementAt(index).value;
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                            image: FileImage(File("images/default_poster.jpg")),
                            fit: BoxFit.fill),
                      ),
                      child: Text(element.title.toString(),
                          style: TextStyle(color: Colors.black)),
                    );
                  });
            } else {
              return Placeholder();
            }
          }
        } else {
          return Text("nie wiem co robie sorki");
        }
      },
    );
  }
}

class FilmStackPage extends StatefulWidget {
  @override
  State<FilmStackPage> createState() => _FilmStackPageState();
}
