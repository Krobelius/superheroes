import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/resources/superheroes_colors.dart';
import 'package:superheroes/resources/superheroes_images.dart';

class SuperheroCard extends StatelessWidget {
  final SuperheroInfo superheroInfo;
  final VoidCallback onTap;

  const SuperheroCard(
      {Key? key, required this.superheroInfo, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 70,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: SuperheroesColors.card),
        child: Row(
          children: [
            Container(
                width: 70,
                height: 70,
                color: Colors.white24,
                child: CachedNetworkImage(
                  errorWidget: (context, url, error) {
                    return Center(
                      child: Image.asset(
                        SuperheroesImages.unknown,
                        width: 20,
                        height: 62,
                      ),
                    );
                  },
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      SizedBox(
                          width: 24,
                          height: 24,
                          child: Center(
                              child: CircularProgressIndicator(
                                  value: downloadProgress.progress))),
                  imageUrl: superheroInfo.imageUrl,
                  height: 70,
                  width: 70,
                  fit: BoxFit.cover,
                )),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    superheroInfo.name.toUpperCase(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(superheroInfo.realName,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
