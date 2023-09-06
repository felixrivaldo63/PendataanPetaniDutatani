<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DB;
use Illuminate\Support\Facades\Hash;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Validator;
use Illuminate\Foundation\Auth\RegistersUsers;

class ApiController extends Controller
{
    public function register(Request $request)
    {
        $ID_User = $request->input('ID_User');
        $Password = $request->input('Password');
        $PIN = '123456';
        $jawaban = ' asal ';
        $Tingkat_Priv = '0';
        $nama = $request->input('nama');
        $jenis_kelamin = $request->input('jenis_kelamin');
        $tanggal_lahir = $request->input('tanggal_lahir');
        $alamat = $request->input('alamat');
        $provinsi = $request->input('provinsi');
        $kabupaten = 'asal ';
        $kecamatan = 'asal ';
        $kelurahan_desa = 'asal ';
        $jumlah_lahan = 'Masukkan Jumlah Lahan';
        $jumlah_tenaga = 'Masukkan Jumlah Tenaga Kerja';
        $nomor_telpon = $request->input('nomor_telpon');
        $Email = $request->input('Email');
        $foto = 'asal';
        $ID_Kategori = 'PET';
        //$hashpass=bcrypt($Password);
        // $hashpass = sha1($Password);

        $m_user = array('ID_User' => $ID_User, 'Password' => $Password, 'jawaban' => $jawaban, 'PIN' => $PIN, 'Tingkat_Priv' => $Tingkat_Priv);

        $detail = array(
            'ID_User' => $ID_User,
            'nama' => $nama,
            'jenis_kelamin' => $jenis_kelamin,
            'tanggal_lahir' => $tanggal_lahir,
            'alamat' => $alamat,
            'provinsi' => $provinsi,
            'nomor_telpon' => $nomor_telpon,
            'Email' => $Email,
            'kabupaten' => "Isi Kabupaten",
            'kecamatan' => "Isi Kecamatan",
            'kelurahan_desa' => "Isi Desa",
            'foto' => $foto
        );

        $kat = array('ID_User' => $ID_User, 'ID_kategori' => $ID_Kategori);

        $maspet = array('ID_User' => $ID_User, 'Nama_Petani' => $nama, 'Email' => $Email, 'Alamat_Petani' => $alamat, 'Provinsi' => $provinsi, 'Nomor_Telpon' => $nomor_telpon, 'Tanggal_Lahir' => $tanggal_lahir, 'jns_kelamin' => $jenis_kelamin, 'jml_lahan' => $jumlah_lahan, 'jml_tng_kerja_musiman' => $jumlah_tenaga);

        $count = DB::table('master_user')->where('ID_User', $ID_User)->count();
        $emailcount = DB::table('master_petani')->where('Email', $Email)->count();
        $namatgl = DB::table('master_petani')
            ->where('Nama_Petani', $nama)
            ->where('Tanggal_Lahir', $tanggal_lahir)
            ->count();

        if ($count > 0) {
            return response()->json([
                "message" => "Not Acceptable"
            ]);
        } elseif ($namatgl > 0) {
            return response()->json([
                "message" => "Not Acceptable"
            ]);
        } elseif ($emailcount > 0) {
            return response()->json([
                "message" => "Not Acceptable"
            ]);
        } else {
            DB::table('master_user')->insert($m_user);
            DB::table('master_detail_user')->insert($detail);
            DB::table('master_petani')->insert($maspet);
            DB::table('master_user_kat')->insert($kat);

            return response()->json([
                "message" => "student record created",
                "ID_User" => $ID_User,
                "nama" => $nama,
                "foto" => $foto
            ], 201);
        }
    }

    public function login(Request $request)
    {
        $validasi = DB::table('master_user')
            ->where('ID_User', $username = $request->input('ID_User'))
            ->get()->first;
        if ($validasi->ID_User != null) { 
            if ($request->input('Password') == $validasi->ID_User->Password) {
                $id_kat = DB::table('master_user_kat')->where('ID_User', $username)->get();
                $ambildata = DB::table('master_detail_user')->where('ID_User', $username)->get();
                $unquoted = preg_replace('/^(\'(.*)\'|"(.*)")$/', '$2$3', $ambildata);

                return response()->json([
                    "user" => $username,
                    "kategori" => $id_kat[0]->ID_Kategori,
                    "value" => 1,
                ]);
            } else {
                return response()->json([
                    "Value" => 0,
                ]
                );
            }   
        } else {
            return response()->json([
                "Value" => 0,
            ]);
        }
    }

    public function edit_profile(Request $request)
    {
        $nama = $request->input('nama');
        $ID_User = $request->input('ID_User');
        $jenis_kelamin = $request->input('jenis_kelamin');
        $tanggal_lahir = $request->input('tanggal_lahir');
        $alamat = $request->input('alamat');
        $provinsi = $request->input('provinsi');
        $kabupaten = $request->input('kabupaten');
        $kecamatan = $request->input('kecamatan');
        $kelurahan_desa = $request->input('kelurahan_desa');
        $nomor_telpon = $request->input('nomor_telpon');
        $Email = $request->input('Email');
        $foto = ' ';
        $jml_tng_kerja_musiman = $request->input('jml_tng_kerja_musiman');
        $jml_lahan = $request->input('jml_lahan');
        $Pendidikan_Terakhir = ' ';
        $Jumlah_Tanggungan = ' ';
        $Agama = ' ';
        $Status = ' ';
        $nama_istri = ' ';
        $Deskripsi_Keahlian = ' ';

        // $nama_foto = $request->input('nama_foto');
        // // menyimpan data file yang diupload ke variabel $file* 
        // $file = $request->file('foto');
        // $tujuan_upload = 'materipengajar';
        // $extension = $request->file('foto')->extension();
        // $file->move($tujuan_upload,$request->input('nama_foto'). '-' .$nama. '-' . date("Y-m-d") .$extension);
        // $nama_file = $request->input('nama_foto'). '-' .$nama. '-' . date("Y-m-d") .$extension;

        $update_profile = array(
            'nama' => $nama, 'jenis_kelamin' => $jenis_kelamin, 
            'tanggal_lahir' => $tanggal_lahir, 'alamat' => $alamat, 'provinsi' => $provinsi, 'nomor_telpon' => $nomor_telpon, 'Email' => $Email,
            'kabupaten' => $kabupaten, 'kecamatan' => $kecamatan, 'kelurahan_desa' => $kelurahan_desa, 
            // 'foto' => $nama_file
        );
        $maspet = array('Nama_Petani'=> $nama, 'Email'=>$Email, 'Alamat_Petani'=>$alamat,'Nomor_Telpon'=>$nomor_telpon, 'provinsi' => $provinsi, 'kabupaten' => $kabupaten, 'kecamatan' => $kecamatan,'Desa_Kelurahan' => $kelurahan_desa,'Tanggal_Lahir'=>$tanggal_lahir,'Pendidikan_Terakhir'=>$Pendidikan_Terakhir, 'Jumlah_Tanggungan'=>$Jumlah_Tanggungan, 'Agama'=>$Agama, 'Deskripsi_Keahlian'=>$Deskripsi_Keahlian, 'Status'=>$Status, 'nama_istri'=> $nama_istri, 'jml_tng_kerja_musiman'=>$jml_tng_kerja_musiman, 'jml_lahan'=>$jml_lahan, 
        // 'foto' => $nama_file
    );

        // DB::table('master_user')->insert($m_user);
        DB::table('master_detail_user')->where('ID_User', $ID_User)->update($update_profile);
        DB::table('master_petani')->where('ID_User', $ID_User)->update($maspet);
        // DB::table('master_user_kat')->insert($kat);
        return response()->json([
            "Result" =>
            [
                "ResultCode" => 1,
                "ResultMessage" => "Success Update Data Profile"
            ],
            "update_profile" => $update_profile,
            "Update_profile" => $maspet
        ], 201);
        // return redirect(' ')->with('status','Selamat Anda berhasil Mendaftar Tunggu Konfirmasi Dari Admin ');         
        // } 

    }

    public function data_dashboard()
    {
        $materi = DB::table('master_upload_materi')
        ->join('master_detail_user', function($join){
            $join->on('master_detail_user.ID_User', '=', 'master_upload_materi.ID_User');
            })
        ->join('master_user', function($join){
            $join->on('master_user.ID_User', '=', 'master_upload_materi.ID_User');
            })
        ->count();
        $lahan = DB::table('master_peta_lahan')->count();
        $petani = DB::table('master_petani')->count();
        $berita = DB::table('master_berita_informasi')->count();
        return response()->json([
            "materi" => $materi,
            "lahan" => $lahan,
            "petani" => $petani,
            "berita" => $berita,
        ]);
    }

    public function getDafPet()
    {
        // $daf = DB::table('master_detail_user')->get();
        // $pet = DB::table('master_petani')->where->get();
        $daf = DB::table('master_detail_user')
            ->join('master_petani', 'master_detail_user.ID_User', '=', 'master_petani.ID_User')->distinct()->get();
        return response()->json(
            $daf);
    }

    public function getDataPetani($pet)
    {
        // mengambil data dari table books
        $user = DB::table('master_detail_user')->where('ID_User', $pet)->get();
        $petani = DB::table('master_petani')->where('ID_User', $pet)->get();
        // mengirim data books ke view books
        return response()->json([
            "nama" => $user[0]->nama,
            "jenis_kelamin" => $user[0]->jenis_kelamin,
            "tanggal_lahir" => $user[0]->tanggal_lahir,
            "alamat" => $user[0]->alamat,
            "provinsi" => $user[0]->provinsi,
            "nomor_telpon" => $user[0]->nomor_telpon,
            "Email" => $user[0]->Email,
            "provinsi" => $user[0]->provinsi,
            "kabupaten" => $user[0]->kabupaten,
            "kecamatan" => $user[0]->kecamatan,
            "kelurahan_desa" => $user[0]->kelurahan_desa,
            "jml_tng_kerja_musiman" => $petani[0]->jml_tng_kerja_musiman,
            "jml_lahan" => $petani[0]->jml_lahan,
        ], 200);
    }

    public function delPet($ID_User)
    {
        // $ID_User = $request->input('ID_User');
        $detUser = DB::table('master_detail_user')->where('ID_User', $ID_User)->delete();
        $masPet = DB::table('master_petani')->where('ID_User', $ID_User)->delete();
        $user = DB::table('master_user')->where('ID_User', $ID_User)->delete();
        return response()->json([
            "Result" =>
            [
                "ResultCode" => 1,
                "ResultMessage" => "Data Berhasil Di Hapus"
            ],
            "delete1" => $detUser,
            "delete2" => $masPet,
            "delete3" => $user,
        ], 201);
    }

    public function getKabupaten()
    {
        // mengambil data dari table books
        $kab = DB::table('kabupaten')->distinct()->pluck('Nama_Kabupaten');
        // mengirim data books ke view books
        return response()->json([
            $kab,
        ], 200);
    }    
    
    public function getKecamatan($kab)
    {
        // mengambil data dari table books
        $kec = DB::table('kecamatan')->where('Nama_Kabupaten', $kab)->distinct()->get();
        // mengirim data books ke view books
        return response()->json([
            "kecamatan" => $kec->Nama_Kecamatan,
        ], 200);
    }

    public function pesertapilihmateri(request $request)
    {
        $ID_Materi = $request->input('ID_Materi');
        $ID_User_Siswa = $request->input('ID_User_Siswa');
        $ID_User = $request->input('ID_User');

        $input = array('ID_Materi' => $ID_Materi, 'ID_User_Siswa' => $ID_User_Siswa, 'ID_User' => $ID_User);
        DB::table('master_peserta_pilih_materi')->insert($input);
        return response()->json([
            "Result" =>
            [
                "ResultCode" => 1,
                "ResultMessage" => "Success Data Masuk Ke Database"
            ],
            "ID_Materi" => $ID_Materi,
            "ID_User_Siswa" => $ID_User_Siswa,
            "ID_User" => $ID_Materi
        ], 201);
    }

    public function kategori()
    {
        $kategori = DB::table('master_kategori')
            ->join('master_gambar', 'master_kategori.ID_Kategori', '=', 'master_gambar.id_ref')
            ->where('id_ref', 'like', 'KL%')
            ->get();

        return response()->json([
            "Result" =>
            [
                "ResultCode" => 1,
                "ResultMessage" => "Success Ambil Data"
            ],
            "ListKategori" => $kategori,
        ], 200);
    }
    public function topik($kategori)
    {


        $topik = DB::table('master_topik')->where('ID_Kategori', $kategori)
            ->get();

        return response()->json([
            "Result" =>
            [
                "ResultCode" => 1,
                "ResultMessage" => "Success Ambil Data"
            ],
            "ListTopik" => $topik

        ], 200);
    }
    public function getmateri($ID_Topik)
    {
        // $getuser = $request->session()->get('ID_User');
        // mengambil data dari table 

        $showmateri = DB::table('master_upload_materi')
            ->where('ID_Topik', $ID_Topik)
            ->get();
        // mengirim data books ke view books
        return response()->json([
            "Result" =>
            [
                "ResultCode" => 1,
                "ResultMessage" => "Success Ambil Data"
            ],
            "ListMateri" => $showmateri

        ], 200);
    }
    public function pengajar($user)
    {
        // mengambil data dari table books
        $pengajar = DB::table('master_user_kat')
            ->join('master_detail_user', 'master_user_kat.ID_User', '=', 'master_detail_user.ID_User')
            ->where('master_user_kat.ID_User', $user)
            ->get();
        // mengirim data books ke view books
        return response()->json([
            "Result" =>
            [
                "ResultCode" => 1,
                "ResultMessage" => "Success"
            ],
            "User" => $pengajar
        ], 200);
    }

    // ADMIN
    public function pertanyaan(request $request)
    {
        $ID_Penanya = $request->input('ID_Penanya');
        $pertanyaan_isi = $request->input('pertanyaan_isi');
        $ID_Penjawab = $request->input('ID_Penjawab');
        $tipe = $request->input('tipe');
        $created_at = DB::raw('now()');
        $updated_at = DB::raw('now()');

        if ($request->hasFile('gambar_pertanyaan')) {
            // Get File Name w/ Ext
            $filenameWithExt = $request->file('gambar_pertanyaan')->getClientOriginalName();
            // Get Just File Name
            $filename = pathinfo($filenameWithExt, PATHINFO_FILENAME);
            // Get Just Ext
            $extension = $request->file('gambar_pertanyaan')->getClientOriginalExtension();
            // File Name To Store
            $fileNameToStore = $ID_Penanya . '_' . $filename . '_' . time() . '.' . $extension;
            // Upload Image
            $store_location = 'gambar_pertanyaan';
            $file = $request->file('gambar_pertanyaan');
            $file->move($store_location, $fileNameToStore);
        } else {
            $fileNameToStore = 'NoImage.jpg';
        }

        $input = array(
            'ID_Penanya' => $ID_Penanya,
            'ID_Penjawab' => $ID_Penjawab,
            'pertanyaan_isi' => $pertanyaan_isi,
            'created_at' => $created_at,
            'updated_at' => $updated_at,
            'gambar_pertanyaan' => $fileNameToStore,
            'tipe' => $tipe
        );

        DB::table('pertanyaans')->insert($input);
        return response()->json([
            "Result" =>
            [
                "ResultCode" => 1,
                "ResultMessage" => "Success Data Masuk Ke Database"
            ],
            "ID_Penanya" => $ID_Penanya,
            "ID_Penjawab" => $ID_Penjawab,
            "pertanyaan_isi" => $pertanyaan_isi,
            "gambar_pertanyaan" => $fileNameToStore,
            "tipe" => $tipe
        ], 201);
    }

    public function getPertanyaan($id)
    {

        $pertanyaan = DB::table('pertanyaans')
            ->where('pertanyaan_id', $id)
            ->get();

        return response()->json([
            "Result" =>
            [
                "ResultCode" => 1,
                "ResultMessage" => "Success Ambil Data"
            ],
            "pertanyaan" => $pertanyaan
        ], 200);
    }

    public function getIndexPertanyaan($id)
    {
        $pertanyaan = DB::table('pertanyaans')
            ->where('ID_Penanya', $id)
            ->get();

        return response()->json([
            "Result" =>
            [
                "ResultCode" => 1,
                "ResultMessage" => "Success Ambil Data"
            ],
            "pertanyaan" => $pertanyaan
        ], 200);
    }
    public function history(Request $request)
    {
        $ID_Materi = $request->input('ID_Materi');
        $ID_Pengajar = $request->input('ID_Pengajar');
        $ID_User = $request->input('ID_User');
        $nama_materi = $request->input('nama_materi');
        $ID_Topik = $request->input('ID_Topik');

        $inputhistory = array(
            'ID_Materi' => $ID_Materi,
            'ID_Pengajar' => $ID_Pengajar,
            'ID_User' => $ID_User,
            'ID_Pengajar' => $ID_Pengajar,
            'nama_materi' => $nama_materi,
            'ID_Topik' => $ID_Topik
        );
        DB::table('history')->insert($inputhistory);
        return response()->json([
            "message" => "History Baru dari user",
            "ID_User" => $ID_User,
            "nama_materi" => $nama_materi,
            "ID_materi" => $ID_Materi,
            "nama_materi" => $nama_materi

        ], 201);
    }
    public function showhistory($ID)
    {
        $showhistory = DB::table('history')
            ->join('master_upload_materi', 'history.ID_Materi', '=', 'master_upload_materi.ID')
            ->where('history.ID_User', $ID)
            ->get();
        return response()->json([
            "Result" =>
            [
                "ResultCode" => 1,
                "ResultMessage" => "Success Ambil Data"
            ],
            "showhistory" => $showhistory
        ], 200);
    }


}
