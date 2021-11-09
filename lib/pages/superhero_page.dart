import 'package:flutter/material.dart';
import 'package:superheroes/resources/superheroes_colors.dart';
import 'package:superheroes/widgets/action_button.dart';

class SuperheroPage extends StatelessWidget {
  final String heroName;

  const SuperheroPage({Key? key, required this.heroName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SuperheroesColors.background,
      body: SafeArea(
          child: Stack(
        children: [
          Center(
            child: Text(heroName,style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white
            ),),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ActionButton(text: "Back",onTap: () {
                Navigator.of(context).pop();
              },
              ),
            ),
          )
        ],
      )),
    );
  }
}
