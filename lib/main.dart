import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'ders.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DissMissKeyboard(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Notum!',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const TakdirHomePage(),
      ),
    );
  }
}

class DissMissKeyboard extends StatelessWidget {
  final Widget child;

  const DissMissKeyboard({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: child,
    );
  }
}

class TakdirHomePage extends StatefulWidget {
  const TakdirHomePage({Key? key}) : super(key: key);

  @override
  State<TakdirHomePage> createState() => _TakdirHomePageState();
}

class _TakdirHomePageState extends State<TakdirHomePage> {
  @override
  void initState() {
    super.initState();
  }

  var dersNotu = 0.0;
  var dersHarfi = "AA";

  int dersSayisi = 0;
  String term = "Dönem";
  TextEditingController TamamlananKrediController = TextEditingController();
  TextEditingController GenelNotOrtalamasiController = TextEditingController();

  List<Ders> dersler = [];

  double genelOrt = 0.0;
  int genelKredi = 0;
  double donemOrt = 0.0;
  int toplamKredi = 0;
  double toplamMultip = 0.0;

  void Hesapla() {
    setState(() {
      donemOrt = 0;
      toplamKredi = 0;
      toplamMultip = 0;
      for (int i = 0; i < dersler.length; i++) {
        if (dersler[i].dersCreditController?.text == "" ||
            dersler[i].dersCreditController?.text == null) {
          dersler[i].dersCredit = 0;
        }
        if (dersler[i].TakdirDersGradeController?.text == "" ||
            dersler[i].dersCreditController?.text == null) {
          dersler[i].dersGrade = 0;
        }
        toplamKredi += dersler[i].dersCredit!;
        toplamMultip += dersler[i].dersCredit! * dersler[i].takdirDersGrade!;
        donemOrt = toplamMultip / toplamKredi;
      }
    });
    if (term == "Genel") {
      genelOrt = double.parse(GenelNotOrtalamasiController.text);
      genelKredi = int.parse(TamamlananKrediController.text);

      genelOrt =
          ((genelOrt * genelKredi) + toplamMultip) / (genelKredi + toplamKredi);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
            colors: [Colors.blueGrey, Colors.grey],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
              children: [
                Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 19, 0, 10),
                        child: Text(
                          'NotHesApp! TT',
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                      Divider(
                        color: Colors.black,
                        thickness: 2,
                        indent: 18,
                        endIndent: 18,
                      ),
                      Row(
                        children: [
                          //Ders Sayısı
                          Expanded(
                            child: ListTile(
                              title: const Text(
                                'Ders Sayısı',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              trailing: DropdownButton<int>(
                                  dropdownColor: Colors.red.withOpacity(0.8),
                                  hint: const Text("Pick"),
                                  value: dersSayisi,
                                  items: <int>[
                                    0,
                                    1,
                                    2,
                                    3,
                                    4,
                                    5,
                                    6,
                                    7,
                                    8,
                                    9,
                                    10,
                                    11,
                                    12,
                                    13,
                                    14,
                                    15
                                  ].map((int value) {
                                    return DropdownMenuItem<int>(
                                      value: value,
                                      child: Text(
                                        value.toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (newVal) {
                                    setState(() {
                                      dersSayisi = newVal!;
                                      if (dersSayisi > dersler.length) {
                                        for (int i = dersler.length - 1;
                                            i < dersSayisi;
                                            i++) {
                                          dersler.add(Ders(
                                            dersCredit: 0,
                                            takdirDersGrade: 0.0,
                                            TakdirDersGradeController:
                                                TextEditingController(),
                                            dersCreditController:
                                                TextEditingController(),
                                          ));
                                        }
                                      } else {
                                        // maybe if will be added
                                        for (int i = dersler.length - 1;
                                            i >= dersSayisi;
                                            i--) {
                                          dersler.removeLast();
                                        }
                                      }
                                    });
                                  }),
                            ),
                          ),
                          //Dönem - Genel Button
                          Container(
                            child: Expanded(
                              child: ListTile(
                                title: const Text(
                                  'Format',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                trailing: DropdownButton<String>(
                                    dropdownColor: Colors.red.withOpacity(0.8),
                                    hint: const Text(
                                      "Pick",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    value: term,
                                    items: <String>[
                                      "Dönem",
                                      "Genel",
                                    ].map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (newVal) {
                                      setState(() {
                                        term = newVal!;
                                      });
                                    }),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                term == "Genel"
                    ? Container(
                        child: Row(
                          children: [
                            //Tamamlanan Kredi
                            Container(
                              child: Expanded(
                                child: ListTile(
                                  leading: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white60,
                                    ),
                                    padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                                    child: const Text(
                                      'Önceki Dönem\nHaftalık Ders Saati',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(),
                                    ),
                                  ),
                                  title: TextField(
                                    style: TextStyle(color: Colors.white),
                                    cursorColor: Colors.white,
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    controller: TamamlananKrediController,
                                    decoration: const InputDecoration(
                                      hintStyle:
                                          TextStyle(color: Colors.white38),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.cyan),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.redAccent),
                                      ),
                                      hintText: "20",
                                    ),
                                    onChanged: (_) {
                                      setState(() {
                                        Hesapla();
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                            //Genel Not Ortalaması
                            Container(
                              child: Expanded(
                                child: ListTile(
                                  leading: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white60,
                                    ),
                                    padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                                    child: const Text(
                                      'Önceki Dönem\nNot Ortalaması',
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  title: TextField(
                                    style: TextStyle(color: Colors.white),
                                    cursorColor: Colors.white,
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    controller: GenelNotOrtalamasiController,
                                    decoration: const InputDecoration(
                                        hintStyle:
                                            TextStyle(color: Colors.white38),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.cyan),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.redAccent),
                                        ),
                                        hintText: "84.22"),
                                    onChanged: (_) {
                                      setState(() {
                                        Hesapla();
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  color: Colors.white,
                  thickness: 2,
                  indent: 18,
                  endIndent: 18,
                ),
                //Dersler---Büyük widget
                Container(
                  child: Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: dersSayisi,
                      itemBuilder: (BuildContext context, int index) {
                        return Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 8, 8, 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.redAccent.withOpacity(0.2),
                                  ),
                                  child: TextField(
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      hintText: "Ders ${index + 1}",
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.red.withOpacity(0.4)),
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    textAlign: TextAlign.center,
                                    controller:
                                        dersler[index].dersCreditController,
                                    decoration: const InputDecoration(
                                      hintText: "Ders Saati",
                                      border: InputBorder.none,
                                    ),
                                    onChanged: (_) {
                                      setState(() {
                                        if (dersler[index]
                                                    .dersCreditController
                                                    ?.text !=
                                                "" ||
                                            dersler[index]
                                                    .dersCreditController
                                                    ?.text !=
                                                null) {
                                          try {
                                            dersler[index].dersCredit =
                                                int.parse(dersler[index]
                                                    .dersCreditController!
                                                    .text);
                                          } catch (e) {
                                            dersler[index].dersCredit = 0;
                                          }
                                        } else {
                                          dersler[index].dersCredit = 0;
                                        }
                                        Hesapla();
                                      });
                                    },
                                    onTap: () {
                                      Hesapla();
                                    },
                                    onEditingComplete: () {
                                      Hesapla();
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.redAccent.withOpacity(0.7),
                                  ),
                                  alignment: Alignment.center,
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    controller: dersler[index]
                                        .TakdirDersGradeController,
                                    decoration: const InputDecoration(
                                      hintText: "Ders Notu",
                                      border: InputBorder.none,
                                    ),
                                    onChanged: (_) {
                                      setState(
                                        () {
                                          if (dersler[index]
                                                      .TakdirDersGradeController
                                                      ?.text !=
                                                  "" ||
                                              dersler[index]
                                                      .TakdirDersGradeController
                                                      ?.text !=
                                                  null) {
                                            try {
                                              dersler[index].takdirDersGrade =
                                                  double.parse(dersler[index]
                                                      .TakdirDersGradeController!
                                                      .text);
                                            } catch (e) {
                                              dersler[index].takdirDersGrade =
                                                  0.0;
                                            }
                                          } else {
                                            dersler[index].takdirDersGrade =
                                                0.0;
                                          }
                                          Hesapla();
                                        },
                                      );
                                    },
                                    onTap: () {
                                      Hesapla();
                                    },
                                    onEditingComplete: () {
                                      Hesapla();
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    dersler.removeAt(index);
                                    dersSayisi--;
                                    Hesapla();
                                  });
                                },
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                ),
                //Hesaplanan Genel Not Ortalaması
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.redAccent.withOpacity(0.9),
                    ),
                    width: double.infinity,
                    height: 50,
                    child: Text(
                      term == "Dönem"
                          ? "Dönem Not Ortalaması: ${donemOrt.isNaN ? "0.0" : donemOrt.toStringAsFixed(2)}"
                          : "Dönem Not Ortalaması: ${donemOrt.isNaN ? "0.0" : donemOrt.toStringAsFixed(2)} \nGenel Not Ortalaması: ${genelOrt.toStringAsFixed(2)}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
