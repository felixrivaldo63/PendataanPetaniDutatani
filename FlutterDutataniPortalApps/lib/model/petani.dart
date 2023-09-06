

class Petani{
  final String ID_User;
  final String Nama_Petani;
  final String jml_lahan;
  final String jml_tercatat;
  final String bisa;

  Petani({
    this.ID_User, 
    this.Nama_Petani, 
    this.jml_lahan, 
    this.jml_tercatat,
    this.bisa});
  factory Petani.formJson(Map <String, dynamic> json){
    return new Petani(
      ID_User: json['ID_User'],
      Nama_Petani: json['Nama_Petani'],    
      jml_lahan: json['jml_lahan'].toString(),
      jml_tercatat: json['jml_tercatat'].toString(),
      bisa: json['bisa'].toString(),
    );
  }
}
