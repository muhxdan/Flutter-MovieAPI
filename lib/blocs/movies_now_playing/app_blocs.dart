import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapi_bloc/blocs/movies_now_playing/app_events.dart';
import 'package:movieapi_bloc/blocs/movies_now_playing/app_states.dart';
import 'package:movieapi_bloc/repository/repository.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieRepository _movieRepository;

  MovieBloc(this._movieRepository) : super(MovieLoadingState()) {
    on<LoadMovieEvent>(
      (event, emit) async {
        emit(MovieLoadingState());
        try {
          final movies = await _movieRepository.getMoviesNowPlaying();
          emit(MovieLoadedState(movies));
        } on HttpException catch (e) {
          print(e.toString());
        }
      },
    );
  }
}
