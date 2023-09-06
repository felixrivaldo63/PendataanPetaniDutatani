import 'dart:convert';
import 'dart:io';
import 'package:dutatani_mapping_iot/model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' show Client;
import 'package:http/http.dart' as http;

class ApiServices {
  final String baseUrl = "https://dutatani.id/";

  Client client = Client();

  Future<bool> regisPtnWithFoto(Petani data) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse("$baseUrl/api/register"));
    Map<String, String> headers = {"Content-type": "multipart/from-data"};
    request.headers.addAll(headers);
    // request.files.add(http.MultipartFile(
    //     "Foto", file.readAsBytes().asStream(), file.lengthSync(),
    //     filename: filename));

    request.fields.addAll({
      "ID_User": data.id,
      "Password": data.password,
      "nama": data.nama,
      "jenis_kelamin": data.jenis_kelamin.toString(),
      "tanggal_lahir": data.tanggal_lahir,
      "alamat": data.alamat,
      "provinsi": data.provinsi,
      "nomor_telpon": data.nomor_telpon,
      "Email": data.email,
    });

    var response = await request.send();
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  // Future<List<DataDashboard>> getDashboard() async {
  //   final response = await client.get("$baseUrl/api/dataDashboard");
  //   if (response.statusCode == 200) {
  //     return dataDashboardFromJson(response.body);
  //   } else {
  //     return null;
  //   }
  // }

  Future<DataDashboard> getDashboard() async {
    final response = await client.get("$baseUrl/api/dataDashboard");
    if (response.statusCode == 200) {
      return DataDashboard.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }

  Future<List<Petani>> getDafPet() async {
    final response = await client.get("$baseUrl/api/dafPetani");
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<Petani> itemList = [];
      data.map((item) {
        itemList.add(Petani.fromJson(item));
      }).toList();
      return itemList;
    } else {
      return null;
    }
  }

  Future<Petani> getPetani(String id_ptn) async {
    final response = await client.get("$baseUrl/api/dataPetani/$id_ptn");
    if (response.statusCode == 200) {
      return Petani.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }

  Future<Petani> delPetani(String id_ptn) async {
    final response = await client.delete("$baseUrl/api/delPet/$id_ptn");
    if (response.statusCode == 201) {
      return Petani.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }

  Future<Petani> getKabupaten(String prov) async {
    final response = await client.get("$baseUrl/api/dataPetani/$prov");
    if (response.statusCode == 200) {
      return Petani.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }

  Future<bool> updateProfil(
      // Petani data, File file, String nimcari) async {
    Petani data) async {
    // String isfotoupdate = "0";
    var request = http.MultipartRequest(
        'POST', Uri.parse("$baseUrl/api/profile/editprofile"));
    Map<String, String> headers = {"Content-type": "multipart/from-data"};

    request.headers.addAll(headers);

    // if (file != null) {
    //   request.files.add(http.MultipartFile(
    //       "foto", file.readAsBytes().asStream(), file.lengthSync(),
    //       filename: file.path));
    //   isfotoupdate = "1";
    // }

    request.fields.addAll({
      "ID_User": data.id,
      "nama": data.nama,
      "jenis_kelamin": data.jenis_kelamin.toString(),
      "tanggal_lahir": data.tanggal_lahir,
      "alamat": data.alamat,
      "provinsi": data.provinsi,
      "kabupaten": data.kabupaten,
      "kecamatan": data.kecamatan,
      "kelurahan_desa": data.kelurahan_desa,
      "nomor_telpon": data.nomor_telpon,
      "Email": data.email,
      "jml_tng_kerja_musiman": data.jum_pekerja,
      "jml_lahan": data.jum_lahan,
    });

    var response = await request.send();
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }
}