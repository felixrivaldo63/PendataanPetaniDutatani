

class Lahan{
  final String ID_Lahan;
  final String nama_lahan;
  final String luas_lahan;
  final String jenis_lahan;
  final String Desa;
  final String status_organik;
  final String lat;
  final String longt;

  Lahan({
    this.ID_Lahan,
    this.nama_lahan,
    this.luas_lahan,
    this.jenis_lahan,
    this.Desa,
    this.status_organik,
    this.lat,
    this.longt
  });
  factory Lahan.formJson(Map <String, dynamic> json){
    return new Lahan(
      ID_Lahan: json['ID_Lahan'].toString(),
      nama_lahan: json['nama_lahan'],
      luas_lahan: json['luas_lahan'].toString(),
      jenis_lahan: json['jenis_lahan'],
      Desa: json['Desa'],
      status_organik: json['status_organik'],
      lat: json['lat'],
      longt: json['longt']
    );
  }
}