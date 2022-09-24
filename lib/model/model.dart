import 'dart:convert';

class MovieModel {
  final String? originalTitle;
  final String? overview;
  final String? poster;
  final String? backPoster;
  final String? voteAverage;
  final String? movieId;
  final String? releaseDate;
  String? originalLanguage;
  String? runtime;
  List<String>? genre;
  List<String>? nameCast;
  List<String>? profileCast;

  MovieModel(
      {this.originalTitle,
      this.overview,
      this.poster,
      this.backPoster,
      this.voteAverage,
      this.movieId,
      this.releaseDate,
      this.originalLanguage});

  factory MovieModel.fromJson(dynamic json) {
    if (json == null) {
      return MovieModel();
    }
    return MovieModel(
      originalTitle: json['original_title'],
      overview: json['overview'],
      poster: json['poster_path'],
      backPoster: json['backdrop_path'],
      voteAverage: json['vote_average'].toString(),
      movieId: json['id'].toString(),
      releaseDate: json['release_date'],
      originalLanguage: json['original_language'],
    );
  }
}
