import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
    return Stack(children: const [
      MainPageStateWidget(),
      Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 12),
        child: SearchWidget(),
      )
    ]);
  }
}

class SearchWidget extends StatefulWidget {
  const SearchWidget({Key? key}) : super(key: key);

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController controller = TextEditingController();
  final FocusNode fNode = FocusNode();
  BorderSide side = const BorderSide(color: Colors.white24);

  @override
  void initState() {
    super.initState();
    fNode.addListener(() {
      setState(() {
        side = (!fNode.hasFocus && controller.text.isNotEmpty) ? const BorderSide(color: Colors.white, width: 2) : const BorderSide(color: Colors.white24);
      });
    });
    SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
      final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);
      controller.addListener(() => bloc.updateText(controller.text));
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: fNode,
      cursorColor: Colors.white,
      textInputAction: TextInputAction.search,
      textCapitalization: TextCapitalization.words,
      controller: controller,
      decoration: InputDecoration(
        prefix: const Icon(Icons.search, color: Colors.white54, size: 24),
        filled: true,
        fillColor: SuperheroesColors.indigo75,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.white, width: 2)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: side),
        border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: side),
        isDense: true,
        suffix: GestureDetector(
          onTap: () {
            controller.clear();
          },
          child: const Icon(Icons.clear, color: Colors.white),
        ),
      ),
      style: const TextStyle(
          fontWeight: FontWeight.w400, fontSize: 20, color: Colors.white),
    );
  }
}

class MainPageStateWidget extends StatelessWidget {
  const MainPageStateWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);
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
              return SuperheroesList(
                title: "Search results",
                stream: bloc.observeSearchedSuperheroes(),
              );
            case MainPageState.favorites:
              return SuperheroesList(
                title: "Your favorites",
                stream: bloc.observeFavoriteSuperheroes(),
              );
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

class SuperheroesList extends StatelessWidget {
  final String title;
  final Stream<List<SuperheroInfo>> stream;

  const SuperheroesList({Key? key, required this.title, required this.stream})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<SuperheroInfo>>(
        stream: stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return const SizedBox.shrink();
          }
          final List<SuperheroInfo> superheroes = snapshot.data!;
          return ListView.separated(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            itemCount: superheroes.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 90, bottom: 20),
                  child: Text(
                    title,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.white),
                  ),
                );
              }
              final SuperheroInfo item = superheroes[index - 1];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SuperheroCard(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            SuperheroPage(heroName: item.name)));
                  },
                  superheroInfo: item,
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(
                height: 8,
              );
            },
          );
        });
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
      subtitle: "Search and add",
      buttonText: "Search",
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
      imageTopPadding: 16,
      title: "Nothing found",
      subtitle: "Search for something else",
      buttonText: "Search",
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
      imageHeight: 106,
      imageWidth: 126,
      imageTopPadding: 22,
      title: "Error happened",
      subtitle: "Please, try again",
      buttonText: "Retry",
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
