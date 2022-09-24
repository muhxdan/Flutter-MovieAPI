import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapi_bloc/blocs/movies_popular/app_events.dart';
import 'package:movieapi_bloc/blocs/movies_popular/app_states.dart';
import 'package:movieapi_bloc/repository/repository.dart';

class MovieBlocPopular extends Bloc<MovieEvent, MovieStatePopular> {
  final MovieRepository _movieRepository;

  MovieBlocPopular(this._movieRepository) : super(MovieLoadingStatePopular()) {
    on<LoadMovieEventPopular>(
      (event, emit) async {
        emit(MovieLoadingStatePopular());
        try {
          final movies = await _movieRepository.getMoviesPopular();
          emit(MovieLoadedStatePopular(movies));
        } on HttpException catch (e) {
          print(e.toString());
        }
      },
    );
  }
}
