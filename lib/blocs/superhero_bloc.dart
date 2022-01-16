import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:superheroes/exception/api_exception.dart';
import 'package:superheroes/favorite_superheroes_storage.dart';
import 'package:superheroes/model/superhero.dart';

class SuperheroBloc {
  final String id;
  http.Client? client;

  final superheroStateSubject = BehaviorSubject<SuperheroPageState>();
  final superheroSubject = BehaviorSubject<Superhero>();

  SuperheroBloc({required this.id, this.client}) {
    getFromFavorites();
  }

  StreamSubscription? requestSubscription;
  StreamSubscription? getFromFavoritesSubscription;
  StreamSubscription? addToFavoriteSubscription;
  StreamSubscription? removeFromFavoriteSubscription;

  void requestSuperhero(final bool isInFavorites) {
    requestSubscription?.cancel();
    requestSubscription = request().asStream().listen((superhero) {
      final previousSuperhero = superheroSubject.valueOrNull;
      if (previousSuperhero == null || !(superhero == previousSuperhero)) {
        superheroStateSubject.add(SuperheroPageState.loaded);
        superheroSubject.add(superhero);
      }
    }, onError: (error, stackTrace) {
      if(!isInFavorites) {
        superheroStateSubject.add(SuperheroPageState.error);
      }
      print("Error happened in requestSuperhero: $error, $stackTrace");
    });
  }

  void getFromFavorites() {
    getFromFavoritesSubscription?.cancel();
    getFromFavoritesSubscription = FavoriteSuperheroesStorage.getInstance()
        .getSuperhero(id)
        .asStream()
        .listen((superhero) {
      if (superhero != null) {
        superheroStateSubject.add(SuperheroPageState.loaded);
        superheroSubject.add(superhero);
      } else {
        superheroStateSubject.add(SuperheroPageState.loading);
      }
      requestSuperhero(superhero != null);
    },
        onError: (error, stackTrace) =>
           superheroStateSubject.add(SuperheroPageState.error));
  }


  void addToFavorite() {
    final superhero = superheroSubject.valueOrNull;

    if (superhero == null) {
      print("ERROR: SUPERHERO IS NULL");
      return;
    }

    addToFavoriteSubscription?.cancel();
    addToFavoriteSubscription = FavoriteSuperheroesStorage.getInstance()
        .addToFavorites(superhero)
        .asStream()
        .listen((event) {
      print('Added to favorites: $event');
    },
        onError: (error, stackTrace) =>
            print("ERROR HAPPENED IN addToFavorite: $error $stackTrace"));
  }



  void removeFromFavorites() {
    final superhero = superheroSubject.valueOrNull;

    if (superhero == null) {
      print("ERROR: SUPERHERO IS NULL");
      return;
    }

    removeFromFavoriteSubscription?.cancel();
    removeFromFavoriteSubscription = FavoriteSuperheroesStorage.getInstance()
        .removeFromFavorites(superhero.id)
        .asStream()
        .listen((event) {
      print('Removed from favorites: $event');
    },
        onError: (error, stackTrace) =>
            print(
                "ERROR HAPPENED IN removeFromFavorites: $error $stackTrace"));
  }

  Stream<bool> observeIsFavorite() =>
      FavoriteSuperheroesStorage.getInstance().observeIsFavorite(id);

  Future<Superhero> request() async {
    final token = dotenv.env['SUPERHERO_TOKEN'];
    final response = await (client ??= http.Client())
        .get(Uri.parse("https://superheroapi.com/api/$token/$id"));
    final decoded = json.decode(response.body);
    if (response.statusCode >= 500 && response.statusCode <= 599) {
      throw ApiException("Server error happened");
    } else if (response.statusCode >= 400 && response.statusCode <= 499) {
      throw ApiException("Client error happened");
    }
    if (decoded['response'] == 'success') {
      final actualSuperhero =  Superhero.fromJson(decoded);
      FavoriteSuperheroesStorage.getInstance().updateSuperhero(actualSuperhero);
      return actualSuperhero;
    } else if (decoded['response'] == 'error') {
      throw ApiException("Client error happened");
    }
    throw Exception("Unknown error happened");
  }


  void retry() async {
    superheroStateSubject.add(SuperheroPageState.loading);
    try{
      final retriedSuperhero = await request();
      superheroStateSubject.add(SuperheroPageState.loaded);
      superheroSubject.add(retriedSuperhero);
    } catch(ex) {
      superheroStateSubject.add(SuperheroPageState.error);
    }
  }

  Stream<Superhero> observeSuperhero() {
    return superheroSubject;
  }
  Stream<SuperheroPageState> observeSuperheroPageState() {
    return superheroStateSubject.distinct();
  }

  void dispose() {
    client?.close();
    superheroStateSubject.close();
    superheroSubject.close();
    getFromFavoritesSubscription?.cancel();
    requestSubscription?.cancel();
    addToFavoriteSubscription?.cancel();
    removeFromFavoriteSubscription?.cancel();
  }

}

enum SuperheroPageState{
  loading,
  loaded,
  error
}