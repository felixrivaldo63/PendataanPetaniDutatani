import 'dart:convert';
import 'package:flutter/material.dart';

class Petani {
  String id;
  String password;
  String nama;
  String jenis_kelamin;
  String tanggal_lahir;
  String alamat;
  String provinsi;
  String kabupaten;
  String kecamatan;
  String kelurahan_desa;
  String nomor_telpon;
  String email;
  String jum_pekerja;
  String jum_lahan;

  // String Foto;

  Petani({
    this.id,
    this.password,
    this.nama,
    this.jenis_kelamin,
    this.tanggal_lahir,
    this.alamat,
    this.provinsi,
    this.kabupaten,
    this.kecamatan,
    this.kelurahan_desa,
    this.nomor_telpon,
    this.email,
    this.jum_pekerja,
    this.jum_lahan,
    // this.Foto,
  });

  factory Petani.fromJson(Map<String, dynamic> map) {
    return Petani(
      id: map["ID_User"],
      password: map["Password"],
      nama: map["nama"],
      jenis_kelamin: map["jenis_kelamin"],
      tanggal_lahir: map["tanggal_lahir"],
      alamat: map["alamat"],
      provinsi: map["provinsi"],
      kabupaten: map["kabupaten"],
      kecamatan: map["kecamatan"],
      kelurahan_desa: map["kelurahan_desa"],
      nomor_telpon: map["nomor_telpon"],
      email: map["Email"],
      jum_pekerja: map["jml_tng_kerja_musiman"],
      jum_lahan: map["jml_lahan"],
      // Foto: map["Foto"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "ID_User": id,
      "Password": password,
      "nama": nama,
      "jenis_kelamin": jenis_kelamin,
      "tanggal_lahir": tanggal_lahir,
      "alamat": alamat,
      "provinsi": provinsi,
      "kabupaten": kabupaten,
      "kecamatan": kecamatan,
      "kelurahan_desa": kelurahan_desa,
      "nomor_telpon": nomor_telpon,
      "Email": email,
      "jml_tng_kerja_musiman": jum_pekerja,
      "jml_lahan": jum_lahan,
      // "Foto": Foto,
    };
  }
}

List<Petani> petaniFromJson(String jsonData) {
    var data = json.decode(jsonData); print("Data = " + data);
    List<Petani> itemList = [];
    data.map(( item) {
      itemList.add(Petani.fromJson(item));
    }).toList();
    return itemList;
  }


String petaniToJson(Petani data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}


class DataDashboard{
  int materi;
  int lahan;
  int petani;
  int berita;

  DataDashboard({this.materi, this.lahan, this.petani, this.berita});

  factory DataDashboard.fromJson(Map<String, dynamic> map){
    return DataDashboard(
        materi: map["materi"],
        lahan: map["lahan"],
        petani: map["petani"],
        berita: map["berita"]
    );
  }

  Map<String, dynamic> toJson(){
    return{"materi": materi, "lahan": lahan, "petani": petani, "berita": berita};
  }
}

List<DataDashboard> dataDashboardFromJson(String jsonData){
  final data = json.decode(jsonData);
  print(data);
  return List<DataDashboard>.from(data.map((item) => DataDashboard.fromJson(item)));
}

String dataDashboardToJson(DataDashboard data){
  final jsonData = data.toJson();
  return json.encode(jsonData);
}