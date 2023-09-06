<?php

use Illuminate\Http\Request;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::middleware('auth:api')->get('/user', function (Request $request) {
    return $request->user();
});
Route::post('/register','ApiController@register');
Route::post('/login','ApiController@login');

Route::post('/pilihmateri','ApiController@pesertapilihmateri');
Route::delete('/delPet/{id}','ApiController@delPet');
Route::get('/kategori','ApiController@kategori');
Route::get('/dataDashboard','ApiController@data_dashboard');
Route::get('/dataPetani/{id}','ApiController@getDataPetani');
Route::get('/dataKabupaten','ApiController@getKabupaten');
Route::get('/dafPetani','ApiController@getDafPet');
Route::get('/dataKecamatan/{id}','ApiController@getKecamatan');
Route::get('/topik/{id}','ApiController@topik');
Route::get('/materi/{ID_Topik}','ApiController@getmateri');
Route::get('/pengajar/{id}','ApiController@pengajar');
Route::post('/admin/pertanyaan','ApiController@pertanyaan'); 
Route::get('/admin/pertanyaan/{id}','ApiController@getPertanyaan'); 
Route::get('/admin/pertanyaan/index/{id}','ApiController@getIndexPertanyaan');
Route::post('/history','ApiController@history');
Route::get('/history/{id}','ApiController@showhistory');
Route::post('/profile/editprofile','ApiController@edit_profile');   