import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:superheroes/pages/main_page.dart';

class MainBloc {
  final BehaviorSubject<MainPageState> stateSubject = BehaviorSubject();
  StreamSubscription<MainPageState>? stateSubscription;

  Stream<MainPageState> observeMainPageState() => stateSubject;

  MainBloc() {
    stateSubject.add(MainPageState.noFavorites);
  }

  void nextState() {
    final currentState = stateSubject.value;
    final nextState = MainPageState.values[
        (MainPageState.values.indexOf(currentState) + 1) %
            MainPageState.values.length];
    stateSubject.add(nextState);
  }

  void dispose() {
    stateSubject.close();
    stateSubscription?.cancel();
  }
}

enum MainPageState {
  noFavorites,
  minSymbols,
  loading,
  nothingFound,
  loadingError,
  searchResults,
  favorites,
}
