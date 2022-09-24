import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:movieapi_bloc/blocs/movies_now_playing/app_blocs.dart';
import 'package:movieapi_bloc/blocs/movies_now_playing/app_events.dart';
import 'package:movieapi_bloc/blocs/movies_now_playing/app_states.dart';
import 'package:movieapi_bloc/blocs/movies_popular/app_blocs.dart';
import 'package:movieapi_bloc/blocs/movies_popular/app_events.dart';
import 'package:movieapi_bloc/blocs/movies_popular/app_states.dart';
import 'package:movieapi_bloc/model/model.dart';
import 'package:movieapi_bloc/repository/repository.dart';
import 'package:movieapi_bloc/screen/detail_screen.dart';

class Home extends StatelessWidget {
  const Home({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              MovieBloc(RepositoryProvider.of<MovieRepository>(context))
                ..add(LoadMovieEvent()),
        ),
        BlocProvider(
          create: (context) =>
              MovieBlocPopular(RepositoryProvider.of<MovieRepository>(context))
                ..add(LoadMovieEventPopular()),
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: const Icon(
            Icons.menu,
            color: Colors.black,
          ),
          title: const Text(
            "Movie",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      categoryMovies("Now Showing"),
                      carouselUi(),
                      categoryMovies("Popular"),
                      moviesPopular(),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  BlocBuilder moviesPopular() {
    return BlocBuilder<MovieBlocPopular, MovieStatePopular>(
      builder: (context, state) {
        if (state is MovieLoadingStatePopular) {
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        }
        if (state is MovieLoadedStatePopular) {
          List<MovieModel> movieList = state.movies;
          return Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                var movie = movieList[index];
                return GestureDetector(
                  onTap: () async {
                    await getInfoMovie(movie);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailMovie(movie: movie),
                      ),
                    );
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: imageView(
                            movie,
                            context,
                            'https://image.tmdb.org/t/p/original/${movie.poster}',
                            110,
                            150),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: Text(
                                movie.originalTitle.toString(),
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Column(
                                children: [
                                  Text(
                                    movie.overview.toString(),
                                    style: TextStyle(),
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Color(0xffFFC319),
                                        ),
                                        Text(movie.voteAverage.toString()),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(),
              itemCount: movieList.length,
            ),
          );
        }
        return Container();
      },
    );
  }

  Container categoryMovies(name) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text("See More"),
        ],
      ),
    );
  }

  BlocBuilder carouselUi() {
    return BlocBuilder<MovieBloc, MovieState>(
      builder: (context, state) {
        if (state is MovieLoadingState) {
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        }
        if (state is MovieLoadedState) {
          List<MovieModel> movieList = state.movies;
          return CarouselSlider.builder(
            itemCount: movieList.length,
            itemBuilder: (BuildContext context, int index, int realIndex) {
              var movie = movieList[index];
              return GestureDetector(
                onTap: () async {
                  await getInfoMovie(movie);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailMovie(movie: movie),
                      ));
                },
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: imageView(
                          movie,
                          context,
                          'https://image.tmdb.org/t/p/original/${movie.backPoster}',
                          double.infinity,
                          MediaQuery.of(context).size.height / 3),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        movie.originalTitle.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                      ),
                    )
                  ],
                ),
              );
            },
            options: CarouselOptions(
              aspectRatio: 16 / 7,
              enableInfiniteScroll: true,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              pauseAutoPlayOnTouch: true,
              viewportFraction: 0.75,
              enlargeCenterPage: true,
            ),
          );
        }
        return Container();
      },
    );
  }

  CachedNetworkImage imageView(MovieModel movie, BuildContext context,
      String posterUrl, double width, double height) {
    return CachedNetworkImage(
      imageUrl: posterUrl,
      fit: BoxFit.cover,
      width: width,
      height: height,
      placeholder: (context, url) => CupertinoActivityIndicator(),
      errorWidget: (context, url, error) => Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/img_not_found.jpg',
            ),
          ),
        ),
      ),
    );
  }

  getInfoMovie(movie) async {
    final response = await get(Uri.parse(
        'https://api.themoviedb.org/3/movie/${movie.movieId}?api_key=4393638fcade1a550e870da3fb7f9937'));
    final responseLanguage = await get(Uri.parse(
        "https://api.themoviedb.org/3/configuration/languages?api_key=4393638fcade1a550e870da3fb7f9937"));
    final responseCast = await get(Uri.parse(
        "https://api.themoviedb.org/3/movie/${movie.movieId}/credits?api_key=4393638fcade1a550e870da3fb7f9937"));

    final infoRuntime = jsonDecode(response.body)["runtime"];
    final infoGenre = jsonDecode(response.body)["genres"];
    final infoLanguage = jsonDecode(responseLanguage.body);
    final infoCast = jsonDecode(responseCast.body)["cast"];
    final List<String> genre = [];
    final List<String> nameCast = [];
    final List<String> profileCast = [];

    for (var g in infoGenre) {
      genre.add(g['name']);
    }

    for (var x in infoLanguage) {
      if (movie.originalLanguage == x['iso_639_1']) {
        movie.originalLanguage = x['english_name'].toString();
      }
    }

    for (int x = 0; x < 4; x++) {
      nameCast.add(infoCast[x]["name"]);
      profileCast.add(infoCast[x]["profile_path"]);
    }
    movie.runtime = infoRuntime.toString();
    movie.genre = genre;
    movie.nameCast = nameCast;
    movie.profileCast = profileCast;
  }
}
