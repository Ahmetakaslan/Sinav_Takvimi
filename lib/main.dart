import 'dart:io';
import 'dart:async';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:sinav/dersdao.dart';

import 'ders_detay.dart';
import 'ders_kayit.dart';
import 'dersdb.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

 localizationsDelegates: [
         GlobalMaterialLocalizations.delegate
       ],
       supportedLocales: [
         const Locale('tr'),
         const Locale('fr')
       ],

      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AnaEkran(),
    );
  }
}

class AnaEkran extends StatefulWidget {
  const AnaEkran({super.key});

  @override
  State<AnaEkran> createState() => _AnaEkranState();
}

class _AnaEkranState extends State<AnaEkran> {
  @override
  void initState() {
    // TODO: implement initState
    debugPrint('${DateTime.now()}');
  }

  bool aramaYapiliyormu = false;
  String arama_kelimesi = "";
  Icon aramaIconu = Icon(Icons.search);

  int heseapla(String tarih)  {
    debugPrint("gelen tariih bu " + tarih);
    debugPrint('Tarihin gun olarak heasplanması ');
    debugPrint('şu anki tarih ${DateTime.now()}');
    DateTime parseEt = DateTime.parse(tarih);
    debugPrint('parse ettikte sonr ${parseEt}');
    DateTime simdi = DateTime.now();
    Duration fark = parseEt.difference(simdi);
    debugPrint('fark gun ${fark.inDays}');
    int gun = fark.inDays;
    if(gun==0){
      return 0;
    }else{
   return gun;
    }
 
  }

  Future<bool> uygulamayiKapat() async {
    return exit(0);
  }

  Future<List<Dersdb>> tumKisiler() async {
    late List<Dersdb> a;
    try {
      a = await Dersdao().tumKisiler();
      print(a[0].isim);
    } catch (e) {
      print(e);
    }
    return a;
  }

  Future<List<Dersdb>> kisiAra(String text) async {
    var a = await Dersdao().kisiAra(text);
    return a;
  }

  Future<void> sil(int id) async {
    try {
      Dersdao().kisiSil(id);
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  Future<void> Eminmisin(int id) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        title: Text(
          "Kişi Silinsin mi?",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        content: Text("Bu kişi cihazınızdan  kalıcı olarak silinecek?"),
        actions: [
          TextButton(
            onPressed: () {
              sil(id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  duration: Duration(seconds: 1),
                  content: Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.black),
                      child: Text(
                        "Silindi",
                        style: TextStyle(fontSize: 25, color: Colors.red),
                      )),
                  behavior: SnackBarBehavior.floating,
                ),
              );
              Navigator.pop(context);
            },
            child: Text("Sil"),
          ),
          TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.transparent,
                    duration: Duration(seconds: 1),
                    elevation: 0,
                    content: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20)),
                        height: 50,
                        child: Text(
                          "İpatl edildi",
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold),
                        )),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                Navigator.pop(context);
              },
              child: Text("Iptal")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF111328),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 36, 42, 93),

        /// kendi leadingine icon buton verererk basıldığında uygulamadan çıkış sağlanır
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => uygulamayiKapat(),
        ),
        title: aramaYapiliyormu
            ? TextFormField(
                style: TextStyle(color: Colors.white),
                
                onChanged: (value) {
                  print(value);
                  setState(() {
                    arama_kelimesi = value;
                  });
                  arama_kelimesi = value;
                },
              )
            : Text("Dersler"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: () {
                  if (aramaYapiliyormu == true) {
                    setState(() {
                      aramaIconu = Icon(Icons.search);
                      aramaYapiliyormu = false;
                      // burada TextDielde deki yazıyı siliyor
                      arama_kelimesi = "";
                    });
                  } else {
                    setState(() {
                      aramaIconu = Icon(Icons.close);
                      aramaYapiliyormu = true;
                    });
                  }
                },
                icon: aramaIconu),
          )
        ],
      ),
      body: WillPopScope(
        onWillPop: () => uygulamayiKapat(),
        child: FutureBuilder(
          future: aramaYapiliyormu ? kisiAra(arama_kelimesi) : tumKisiler(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var kisiler = snapshot.data;

              return GridView.builder(
                itemCount: kisiler!.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1, childAspectRatio: 1/1),
                itemBuilder: (context, index) {
                  var sirlisekilekle = kisiler![index];

                  return GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DersDetay(sirlisekilekle),
                        )),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Card(
                        color: Color.fromARGB(255, 246, 246, 247),
                        shape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(width: 2)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 40),
                                child: Text(
                                  "Ders adı    : ${sirlisekilekle.isim}",
                                  style: TextStyle(fontSize: 25,color: Colors.red),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 40),
                                child: Text(
                                    "Sınav Tarihi : ${sirlisekilekle.tarih.substring(0, 10)}",
                                    style: TextStyle(fontSize: 25,color: Colors.black)),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 40),
                                child: Text("Sınav gunu  : ${sirlisekilekle.gun}",
                                    style: TextStyle(fontSize: 25,color: Colors.blue)),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 40),
                                child: Text(
                                    "Kalan sure :${heseapla(sirlisekilekle.tarih)} gün",
                                    style: TextStyle(fontSize: 25,color: Colors.deepPurple)),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 40),
                                child: IconButton(
                                    onPressed: () {
                                      Eminmisin(sirlisekilekle.id);
                                    },
                                    icon: Icon(Icons.delete)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text("Veri Yok"),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Color(0xFF7B7D7D),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Ders_kaydet(),
                ));
          },
          label: Text("Ekle"),
          icon: Icon(Icons.add)),
    );
  }
}
