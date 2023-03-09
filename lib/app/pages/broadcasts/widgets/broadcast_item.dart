import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import '../../../../domain/repositories/broadcast_repository.dart';


// item showcasing a [BroadcastTour]
class BroadcastItem extends StatelessWidget {
  final BroadcastTour tour;
  final Function(BroadcastTour)? onClick;
  const BroadcastItem(this.tour, {super.key, this.onClick});

  @override
  build(ctx) {
    final theme = Theme.of(ctx);
    final color = theme.colorScheme;
    var style = Mix(
      border(
          color: Colors.grey.shade50,
          width: 5,
          asBorder:
              Border(left: BorderSide(width: 5, color: color.surfaceVariant))),
      m(5),
    );
    return Box(
      mix: style,
      child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Pressable(
              onPressed: () {
                onClick?.call(tour);
              },
              child: HBox(
                mix: Mix(
                  gap(20),
                  p(15),
                  bgColor(color.surface),
                  animated(),
                  animationDuration(200),
                  (hover)(bgColor(color.surfaceVariant)),
                  (press)(bgColor(color.surfaceVariant.darken(.1))),
                ),
                children: [
                  Box(
                    mix: Mix(
                      rounded(100),
                      p(20),
                      // animated(),
                      border(
                        color: Colors.grey.shade200,
                        width: 5,
                      ),
                      //(hover)(border(color: color.primary.lighten(.3))),
                    ),
                    child: IconMix(
                      Icons.cell_tower_rounded,
                      mix: Mix(
                        iconSize(60),
                        // animated(),
                        // animationDuration(300),
                        iconColor(color.primary.lighten(.3)),
                        // (hover)(iconColor(Colors.grey.shade200))
                      ),
                    ),
                  ),
                  VBox(
                      mix: Mix(expanded(), gap(2), align(Alignment.topLeft),
                          crossAxis(CrossAxisAlignment.start)),
                      children: [
                        TextMix(
                          tour.currentRound.name,
                          mix: Mix(
                            align(Alignment.topLeft),
                            textStyle(theme.textTheme.labelSmall
                                ?.apply(color: color.secondary)),
                          ),
                        ),
                        Text(tour.name, style: theme.textTheme.headlineSmall),
                        Text(tour.description,
                            style: theme.textTheme.bodyMedium),
                      ]),
                ],
              ))),
    );
  }
}
