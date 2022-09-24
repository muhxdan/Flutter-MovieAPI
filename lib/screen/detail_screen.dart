import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailMovie extends StatelessWidget {
  final movie;
  const DetailMovie({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          imageView('https://image.tmdb.org/t/p/original/${movie.backPoster}',
              0, double.infinity, 220),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
              ),
              GestureDetector(
                onTap: () async {
                  final response = await get(Uri.parse(
                      'https://api.themoviedb.org/3/movie/${movie.movieId}/videos?api_key=4393638fcade1a550e870da3fb7f9937'));
                  var youtubeId =
                      jsonDecode(response.body)['results'][0]['key'];
                  final youtubeUrl =
                      'https://www.youtube.com/embed/${youtubeId}';
                  launchUrl(Uri.parse(youtubeUrl));
                },
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.play_circle_outline,
                        size: 60,
                        color: Colors.white,
                      ),
                      Text(
                        "Play Trailler",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned.fill(
            top: 210,
            left: 0,
            right: 0,
            child: SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              nameInfo(movie.originalTitle),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Color(0xffFFC319),
                                    ),
                                    Text(
                                      '${movie.voteAverage.toString()}/10 IMDb',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.bookmark_border,
                            size: 27,
                          )
                        ],
                      ),
                      Row(
                        children: List.generate(
                          movie.genre.length,
                          (index) {
                            return Container(
                              margin: const EdgeInsets.only(top: 15, right: 10),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Color(0xffFD841F),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                movie.genre[index],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Row(
                          children: [
                            infoMovie(
                                "Release Date", movie.releaseDate.toString()),
                            infoMovie("Runtime", movie.runtime.toString()),
                            infoMovie(
                                "Language", movie.originalLanguage.toString()),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            nameInfo("Overview"),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                movie.overview,
                                style: TextStyle(height: 1.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 10),
                        child: nameInfo("Cast"),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          movie.nameCast.length,
                          (index) {
                            return Container(
                              width: 70,
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: imageView(
                                        'https://image.tmdb.org/t/p/original/${movie.profileCast[index]}',
                                        index,
                                        70,
                                        70),
                                  ),
                                  Text(
                                    movie.nameCast[index],
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  CachedNetworkImage imageView(
      String imageUrl, int index, double width, double height) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      width: width,
      height: height,
      placeholder: (context, url) => const CupertinoActivityIndicator(),
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

  Text nameInfo(name) {
    return Text(
      name,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Padding infoMovie(infoName, infoData) {
    return Padding(
      padding: EdgeInsets.only(right: 20),
      child: Column(
        children: [
          Text(infoName),
          SizedBox(
            height: 5,
          ),
          Text(
            infoData,
            style: TextStyle(),
          ),
        ],
      ),
    );
  }
}
