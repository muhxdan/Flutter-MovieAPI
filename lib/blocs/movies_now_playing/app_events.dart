import 'package:equatable/equatable.dart';

abstract class MovieEvent extends Equatable {
  const MovieEvent();
}

class LoadMovieEvent extends MovieEvent {
  @override
  List<Object?> get props => [];
}
