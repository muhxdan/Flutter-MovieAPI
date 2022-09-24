import 'package:equatable/equatable.dart';
import 'package:movieapi_bloc/model/model.dart';

abstract class MovieState extends Equatable {}

class MovieLoadingState extends MovieState {
  @override
  List<Object?> get props => [];
}

class MovieLoadedState extends MovieState {
  MovieLoadedState(this.movies);
  final List<MovieModel> movies;

  @override
  List<Object?> get props => [movies];
}

class MovieErrordState extends MovieState {
  MovieErrordState(this.error);
  final String error;

  @override
  List<Object?> get props => [error];
}
