import 'package:equatable/equatable.dart';
import 'package:movieapi_bloc/blocs/movies_now_playing/app_events.dart';

abstract class MovieEvent extends Equatable {
  const MovieEvent();
}

class LoadMovieEventPopular extends MovieEvent {
  @override
  List<Object?> get props => [];
}
