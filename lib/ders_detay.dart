import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'dersdb.dart';
import 'dersdao.dart';

import 'main.dart';

class DersDetay extends StatefulWidget {
  Dersdb kisilerdb;
  DersDetay(this.kisilerdb);

  @override
  State<DersDetay> createState() => _DersDetayState();
}

class _DersDetayState extends State<DersDetay> {
  Future<void> kisi_guncelle(
      int id, String isim, String tarih, String gun) async {
    Dersdao().kisi_Guncelle(id, isim, tarih, gun);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: Duration(seconds: 1, microseconds: 50),
        behavior: SnackBarBehavior.floating,
        content: Padding(
          padding: const EdgeInsets.only(left: 80, right: 80),
          child: Container(
            //EdgeInsets.only(left: size.width/12),
            // EdgeInsets.symmetric(horizontal:size.width/4, vertical: 5),
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "${isim} Kaydedildi",
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
            decoration: BoxDecoration(
                color: Color(0xFFECF0F1),
                borderRadius: BorderRadius.circular(20)),
          ),
        ),
      ),
    );
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AnaEkran(),
        ));
  }

  var a = TextEditingController();
  var b = TextEditingController();
  var c = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    a.text = widget.kisilerdb.isim;
    b.text = widget.kisilerdb.tarih;
    c.text = widget.kisilerdb.gun;
  }

  DateTime _secilenTarih = DateTime.now();
  Future<void> _tarihSec() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
        locale: Locale("tr", "TR"));
    if (picked != null && picked != _secilenTarih) {
      setState(() {
        _secilenTarih = picked;
        b.text = _secilenTarih.toString();
        debugPrint(
            'detay sayfasında guncellerken seilen tarih ${_secilenTarih}');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF9A7D0A),
        title: Text("Derslerin ayrıntısı "),
      ),
      body: Center(
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
          Text("${b.text}",style: TextStyle(fontSize: 30),),
     
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
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _tarihSec();
                });
              },
              child: Text("Tarih Seç"),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {});
          debugPrint('b.text = ${b.text}');
          kisi_guncelle(widget.kisilerdb.id, a.text, b.text, c.text);
          print("Gucellendi");
        },
        tooltip: 'Increment',
        label: Text("Güncelle"),
        icon: const Icon(Icons.update),
      ),
    );
    ;
  }
}
