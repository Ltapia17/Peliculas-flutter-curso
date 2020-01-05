import 'dart:async';
import 'dart:convert';

import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:http/http.dart' as http;
class PeliculaProvider{
  

  String _apiKey = '45816511a3eae10f985123600c55a8fa';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

  int _populasresPage = 0;
  bool _cargando = false;

  List<Pelicula> _populares = new List();

  final _popularesSteamController = StreamController<List<Pelicula>>.broadcast();


  Function(List<Pelicula>) get popularesSynk => _popularesSteamController.sink.add; 

  Stream<List<Pelicula>> get popularesStream => _popularesSteamController.stream;

  


  void disposeStreams(){
    _popularesSteamController?.close();
  }

  
  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
    final resp = await http.get(url);
    final decodeData = json.decode(resp.body);

    final peliculas = new Peliculas.fromJsonList(decodeData['results']);

    return peliculas.items;
  }

  Future<List<Pelicula>> getEnCines() async {

    final url = Uri.https(_url, '3/movie/now_playing',{
      'api_key' : _apiKey,
      'Language': _language,

    });

    return await _procesarRespuesta(url);

  }

  
  Future<List<Pelicula>> getPopulares() async {
    if(_cargando) return [];

    _cargando = true;

    _populasresPage++;
    

    final url = Uri.https(_url, '3/movie/popular',{
      'api_key' : _apiKey,
      'Language': _language,
      'page': _populasresPage.toString()

    });

    final resp =await _procesarRespuesta(url);

    _populares.addAll(resp);

    popularesSynk(_populares);

    _cargando = false;

    return resp;
 

  }

  Future<List<Actor>>getCast(String peliId) async {

    final url = Uri.https(_url, '3/movie/$peliId/credits',{
        'api_key': _apiKey,
        'Language': _language
    });

    final resp = await http.get(url);
    final decodeData = json.decode(resp.body); 

    final cast = new Cast.fromJsonList(decodeData['cast']);

    return cast.actores;
  }

  Future<List<Pelicula>> buscarPelicula(String query) async {

    final url = Uri.https(_url, '3/search/movie',{
      'api_key' : _apiKey,
      'Language': _language,
      'query':query

    });

    return await _procesarRespuesta(url);

  }

}