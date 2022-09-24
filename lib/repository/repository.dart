import 'dart:convert';

import 'package:http/http.dart';

import '../model/model.dart';

class MovieRepository {
  Future<List<MovieModel>> getMoviesNowPlaying() async {
    Response response = await get(Uri.parse('https://api.themoviedb.org/3/movie/now_playing?api_key=4393638fcade1a550e870da3fb7f9937'));
    if (response.statusCode == 200) {
      final List result = jsonDecode(response.body)["results"];
      return result.map((e) => MovieModel.fromJson(e)).toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<List<MovieModel>> getMoviesPopular() async {
    Response response = await get(Uri.parse('https://api.themoviedb.org/3/movie/popular?api_key=4393638fcade1a550e870da3fb7f9937'));
    if (response.statusCode == 200) {
      final List result = jsonDecode(response.body)["results"];
      return result.map((e) => MovieModel.fromJson(e)).toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }


}
