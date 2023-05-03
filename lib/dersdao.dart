

import 'package:sinav/VeriTabanYardimcisi.dart';

import 'dersdb.dart';

class Dersdao {
  Future<List<Dersdb>> tumKisiler() async {
    var db = await VeriTabaniYardimcisi.connectToDatabase();
    List<Map<String, dynamic>> listem =
        await db.rawQuery("Select * from Sinav");
    print("Tum Kisilerde "+listem.length.toString());
    return List.generate(listem.length, (index) {
      var sirali = listem[index];
      var id = sirali["id"];
      var isim = sirali["isim"];
      var tarih = sirali["tarih"];
      var gun=sirali["gun"];


      return Dersdb(id, isim, tarih,gun);
    });
  }

  Future<void> kisiSil(int id) async {
    var db = await VeriTabaniYardimcisi.connectToDatabase();
    try {
      db.delete("Sinav", where: "id=?", whereArgs: [id]);
    } catch (e) {
      print("Kisi Sil kısmında "+e.toString());
    }
  }

  Future<void> ders_kayit_et(String isim, String tarih ,String gun) async {
    var db = await VeriTabaniYardimcisi.connectToDatabase();

    try {
      var mapim =await  Map<String, dynamic>();
      mapim["isim"] = isim;
      mapim["tarih"] = tarih;
      mapim["gun"]=gun;
  
      db.insert("Sinav", mapim);
    } catch (e) {
      print("Kisi kayıt et Kısmı " + e.toString());
    }
  }

  Future<void> kisi_Guncelle(
      int id, String isim, String tarih,String gun) async {
    var db = await VeriTabaniYardimcisi.connectToDatabase();
    try {
      var mapim = await Map<String, dynamic>();
      mapim["id"] = id;
      mapim["isim"] = isim;
      mapim["tarih"] = tarih;
      mapim["gun"]=gun;
   
      db.update("Sinav", mapim, where: "id=?", whereArgs: [id]);
    } catch (e) {
      print("kisi_guncelle kısmında " + e.toString());
    }
  }

  Future<List<Dersdb>> kisiAra(String kisi_ad) async {
    var db = await VeriTabaniYardimcisi.connectToDatabase();
    late List<Map<String, dynamic>> listem;
    try {
      listem = await db.rawQuery(
          "Select * from Sinav where isim like '%${kisi_ad}%' or  tarih like '%${kisi_ad}%' or gun like '%${kisi_ad}%' ");
    } catch (e) {
//SELECT * FROM kisiler WHERE kisi_ad LIKE '%$kisi_ad%'
      print("kisi ara kısmında"+ e.toString());
    }
    print(listem.length);
    return List.generate(listem.length, (index) {
      var sirali = listem[index];
      var id = sirali["id"];
      var isim = sirali["isim"];
      var tarih = sirali["tarih"];
      var gun=sirali["gun"];
   

      return Dersdb(id, isim, tarih,gun);
    });
  }
}
