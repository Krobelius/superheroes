import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/pages/superhero_page.dart';
import 'package:superheroes/resources/superheroes_colors.dart';
import 'package:superheroes/resources/superheroes_images.dart';
import 'package:superheroes/widgets/action_button.dart';
import 'package:superheroes/widgets/info_with_button.dart';
import 'package:superheroes/widgets/superhero_card.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final MainBloc bloc = MainBloc();

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: bloc,
      child: const Scaffold(
          backgroundColor: SuperheroesColors.background,
          body: SafeArea(
            child: MainPageContent(),
          )),
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}

class MainPageContent extends StatelessWidget {
  const MainPageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context);
    return Stack(children: [
      const MainPageStateWidget(),
      Align(
          alignment: const Alignment(0, 0.9),
          child: ActionButton(text: "Next state", onTap: bloc.nextState)),
    ]);
  }
}

class MainPageStateWidget extends StatelessWidget {
  const MainPageStateWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context);
    return StreamBuilder<MainPageState?>(
        stream: bloc.observeMainPageState(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return const SizedBox();
          }
          final MainPageState state = snapshot.data!;
          switch (state) {
            case MainPageState.loading:
              return const LoadingIndicator();
            case MainPageState.noFavorites:
              return const NoFavoritesWidget();
            case MainPageState.minSymbols:
              return const MinSymbolsWidget();
            case MainPageState.nothingFound:
              return const NothingFoundWidget();
            case MainPageState.loadingError:
              return const LoadingErrorWidget();
            case MainPageState.searchResults:
              return const SearchResult();
            case MainPageState.favorites:
              return const FavoritesWidget();
            default:
              return Center(
                  child: Text(
                snapshot.data!.toString(),
                style: const TextStyle(color: Colors.white),
              ));
          }
        });
  }
}

class FavoritesWidget extends StatelessWidget {
  const FavoritesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 90),
        const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Your favorites",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SuperheroCard(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SuperheroPage(heroName:"Batman")));
              },
              name: "Batman",
              realName: "Bruce Wayne",
              imageUrl:
                  "https://www.superherodb.com/pictures2/portraits/10/100/639.jpg"),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SuperheroCard(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SuperheroPage(heroName:"Ironman")));
              },
              name: "Ironman",
              realName: "Tony Stark",
              imageUrl:
                  "https://www.superherodb.com/pictures2/portraits/10/100/85.jpg"),
        ),
      ],
    );
  }
}

class SearchResult extends StatelessWidget {
  const SearchResult({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 90),
        const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Search results",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SuperheroCard(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SuperheroPage(heroName:"Batman")));
              },
              name: "Batman",
              realName: "Bruce Wayne",
              imageUrl:
                  "https://www.superherodb.com/pictures2/portraits/10/100/639.jpg"),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SuperheroCard(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SuperheroPage(heroName:"Venom")));
            },
              name: "Venom",
              realName: "Eddie Brock",
              imageUrl:
                  "https://www.superherodb.com/pictures2/portraits/10/100/22.jpg"),
        ),
      ],
    );
  }
}

class NoFavoritesWidget extends StatelessWidget {
  const NoFavoritesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: InfoWithButton(
      assetImage: SuperheroesImages.ironMan,
      imageHeight: 119,
      imageWidth: 108,
      imageTopPadding: 9,
      title: "No favorites yet",
      subtitle: "search and add",
      buttonText: "search",
    ));
  }
}

class NothingFoundWidget extends StatelessWidget {
  const NothingFoundWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: InfoWithButton(
          assetImage: SuperheroesImages.hulk,
          imageHeight: 112,
          imageWidth: 84,
          imageTopPadding: 9,
          title: "Nothing found",
          subtitle: "Search for something else",
          buttonText: "search",
        ));
  }
}

class LoadingErrorWidget extends StatelessWidget {
  const LoadingErrorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: InfoWithButton(
          assetImage: SuperheroesImages.superman,
          imageHeight: 126,
          imageWidth: 106,
          imageTopPadding: 9,
          title: "Error happened",
          subtitle: "Please, try again",
          buttonText: "retry",
        ));
  }
}

class MinSymbolsWidget extends StatelessWidget {
  const MinSymbolsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(top: 110),
        child: Text(
          "Enter at least 3 symbols",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(top: 110),
        child: CircularProgressIndicator(color: SuperheroesColors.blue),
      ),
    );
  }
}
