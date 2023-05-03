import 'dart:ffi';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:sinav/main.dart';

import 'dersdao.dart';

class Ders_kaydet extends StatefulWidget {
  const Ders_kaydet({super.key});

  @override
  State<Ders_kaydet> createState() => _Ders_kaydetState();
}

class _Ders_kaydetState extends State<Ders_kaydet> {
  late DateTime _secilenTarih=DateTime.now();

  Future<void> kisi_kayit_et(
      String isim, String tarih, String gun) async {
    Dersdao().ders_kayit_et(isim, tarih, gun);

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AnaEkran(),
        ));
  }

  Future<void> _tarihSec() async {

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      locale: Locale("tr", "TR")
    );
    if (picked != null && picked != _secilenTarih) {
      setState(() {
        _secilenTarih = picked;
      });
    }
     
  }

  var a = TextEditingController();
  var b = TextEditingController();
  var c = TextEditingController();
  var d = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //95A5A6
        //5B2C6F
        backgroundColor: Color(0xFF5B2C6F),
        title: Text("Kişiler Kaydet"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  decoration: BoxDecoration(
                      border: Border.all(width: 2),
                      borderRadius: BorderRadius.circular(20)),
                  child: TextField(
                    style: TextStyle(fontSize: 25),
                    decoration: InputDecoration(
                        hintText: "Isim Giriniz",
                        hintStyle: TextStyle(fontSize: 25)),
                    controller: a,
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    _tarihSec();
                  },
                  child: Text("Tarih seç",style: TextStyle(fontSize: 19),)),
              Text("Seçilen Tarih ${_secilenTarih.toString().substring(0,11)}",style: TextStyle(fontSize: 25),),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  decoration: BoxDecoration(
                      border: Border.all(width: 2),
                      borderRadius: BorderRadius.circular(20)),
                  child: TextField(
                    style: TextStyle(fontSize: 25),
                    controller: c,
                    decoration: InputDecoration(
                        hintText: "Gün giriniz",
                        hintStyle: TextStyle(fontSize: 25)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color(0xFF7B7D7D),
        onPressed: () {
          if (a.text == "" || c.text == "") {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
                    "Lütfen Alanları Doldurun",
                    style: TextStyle(fontSize: 25, color: Colors.red),
                  )),
              behavior: SnackBarBehavior.floating,
            ));
          } else {
            debugPrint('Secilen bu tariih ${_secilenTarih} veri tabanına iletildi ');
            kisi_kayit_et(a.text, _secilenTarih.toString(), c.text,);
          }
        },
        tooltip: 'Increment',
        label: Text("Kaydet"),
        icon: Icon(Icons.save),
      ),
    );
  }
}
