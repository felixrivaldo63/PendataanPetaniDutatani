class DLahan{
  final String id_detail;
  final String id_lahan;
  final String lat;
  final String longt;
  final String indeks;

  DLahan({
    this.id_detail,
    this.id_lahan, 
    this.lat, 
    this.longt,
    this.indeks
  });
  factory DLahan.formJson(Map <String, dynamic> json){
    return new DLahan(
      id_detail:json['id_detail'],
      id_lahan:  json['ID_Lahan'],
      lat: json['lat'],
      longt: json['longt'],
      indeks:  json['indeks']
    );
  }

}