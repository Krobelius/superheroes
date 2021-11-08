import 'package:flutter/material.dart';
import 'package:superheroes/resources/superheroes_images.dart';
import 'package:superheroes/widgets/info_with_button.dart';

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
          buttonText: "search",)
        );
  }
}
