import 'package:equatable/equatable.dart';
import 'package:movieapi_bloc/model/model.dart';

abstract class MovieStatePopular extends Equatable {}

class MovieLoadingStatePopular extends MovieStatePopular {
  @override
  List<Object?> get props => [];
}

class MovieLoadedStatePopular extends MovieStatePopular {
  MovieLoadedStatePopular(this.movies);
  final List<MovieModel> movies;

  @override
  List<Object?> get props => [movies];
}

class MovieErrordState extends MovieStatePopular {
  MovieErrordState(this.error);
  final String error;

  @override
  List<Object?> get props => [error];
}
