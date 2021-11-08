import 'package:flutter/material.dart';
import 'package:superheroes/widgets/superhero_card.dart';

class FavoritesWidget extends StatelessWidget {
  const FavoritesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SizedBox(height: 90),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Your favorites",
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white),
            ),
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: SuperheroCard(name: "Batman", realName: "Bruce Wayne", imageUrl: "https://www.superherodb.com/pictures2/portraits/10/100/639.jpg"),
        ),
        SizedBox(height: 8),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: SuperheroCard(name: "Ironman", realName: "Tony Stark", imageUrl: "https://www.superherodb.com/pictures2/portraits/10/100/85.jpg"),
        ),
      ],
    );
  }
}
