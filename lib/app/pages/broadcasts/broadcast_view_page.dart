import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import './broadcast_view_bloc.dart';
import '../../../domain/repositories/broadcast_repository.dart';
import '../../../data/repositories/broadcast_repository.dart';
import '../../utils/pgn.dart';
import './widgets/broadcast_item.dart';
import 'package:tab_container/tab_container.dart';
import 'package:chessground/chessground.dart';
// import 'package:flutter_html/flutter_html.dart';

// rounds sidebar
class _RoundsSection extends StatelessWidget {
  final BroadcastTour tour;
  const _RoundsSection(this.tour);
  @override
  build(ctx) {
    final theme = Theme.of(ctx);
    final color = theme.colorScheme;
    return BlocBuilder<BroadcastViewBloc, BroadcastViewState>(
        builder: (ctx, state) => ListView(
            shrinkWrap: true,
            children: tour.rounds
                .map((round) => Pressable(
                    onPressed: () {
                      print('ev');
                      ctx
                          .read<BroadcastViewBloc>()
                          .add(BroadcastRoundRequested(round));
                    },
                    child: Box(
                        mix: Mix(
                          gap(20),
                          p(15),
                          bgColor(round == state.round
                              ? color.surfaceVariant
                              : color.surface),
                          animated(),
                          animationDuration(200),
                          (hover)(bgColor(color.surfaceVariant)),
                          (press)(bgColor(color.surfaceVariant.darken(.1))),
                        ),
                        child: HBox(children: [
                          Text(round.name),
                          Box(mix: Mix(expanded())),
                          if (round.finished ||
                              tour.currentRound.startsAt
                                  .isBefore(DateTime.now().toUtc()))
                            Box(
                                mix: Mix(p(5)),
                                child: (round.finished
                                    ? const Icon(
                                        Icons.done,
                                        color: Colors.green,
                                      )
                                    : Icon(Icons.circle,
                                        color: Colors.red.darken(.2),
                                        fill: 1))),
                        ]))))
                .toList()));
  }
}

// overview tab section
class _OverviewSection extends StatelessWidget {
  final BroadcastTour tour;
  const _OverviewSection(this.tour, {super.key});
  build(ctx) {
    final theme = Theme.of(ctx);
    final color = theme.colorScheme;

    return VBox(mix: Mix(align(Alignment.topLeft), gap(10), pt(20)), children: [
      Text(
        tour.name,
        style: theme.textTheme.headlineMedium,
        textAlign: TextAlign.left,
      ),
      Text(tour.markup, style: theme.textTheme.bodyMedium),
      BlocBuilder<BroadcastViewBloc, BroadcastViewState>(builder: (ctx, state) {
        int pageFrom = (state.page - 1) * state.roundsPerPage + 1;
        int pageTo = min(pageFrom + state.roundsPerPage, state.games.length);

        var nextPage = state.page == state.maxPage
            ? null
            : () {
                ctx.read<BroadcastViewBloc>().add(BroadcastRoundNextPage());
              };
        var previousPage = state.page == 1
            ? null
            : () {
                ctx.read<BroadcastViewBloc>().add(BroadcastRoundPreviousPage());
              };
        var firstPage = state.page == 1
            ? null
            : () {
                ctx.read<BroadcastViewBloc>().add(BroadcastRoundFirstPage());
              };
        var lastPage = state.page == state.maxPage
            ? null
            : () {
                ctx.read<BroadcastViewBloc>().add(BroadcastRoundLastPage());
              };

        return HBox(children: [
          IconButton(onPressed: firstPage, icon: const Icon(Icons.first_page)),
          IconButton(
              onPressed: previousPage, icon: const Icon(Icons.navigate_before)),
          Text(
              state.games.isEmpty
                  ? " - "
                  : "$pageFrom - $pageTo / ${state.games.length}",
              style: theme.textTheme.bodySmall),
          IconButton(
              onPressed: nextPage, icon: const Icon(Icons.navigate_next)),
          IconButton(onPressed: lastPage, icon: const Icon(Icons.last_page)),
        ]);
      }),
      Box(
          mix: Mix(expanded()),
          child: BlocBuilder<BroadcastViewBloc, BroadcastViewState>(
              builder: (ctx, state) => GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  childAspectRatio: .85,
                  children: state.pageGames
                      .map<Widget>((game) => VBox(children: [
                            HBox(children: [
                              Text(game.blackName),
                              Box(mix: Mix(expanded())),
                              Text(game.blackElo.toInt().toString())
                            ]),
                            LayoutBuilder(
                                builder: (ctx, constraint) => Box(
                                    mix: Mix(w(constraint.maxWidth),
                                        w(constraint.maxWidth)),
                                    child: Board(
                                      size: constraint.maxWidth,
                                      data: BoardData(
                                        interactableSide: InteractableSide.none,
                                        orientation: Side.white,
                                        fen: pgnToFen(game.pgn),
                                      ),
                                    ))),
                            HBox(children: [
                              Text(game.whiteName),
                              Box(mix: Mix(expanded())),
                              Text(game.whiteElo.toInt().toString())
                            ]),
                          ]))
                      .toList())))
    ]);
  }
}

// page to open a broadcast and watch games
class BroadcastViewPage extends StatefulWidget {
  final BroadcastTour tour;
  const BroadcastViewPage(this.tour, {super.key});
  @override
  State<StatefulWidget> createState() {
    return BroadcastViewPageState();
  }
}

// state of [BroadcastViewPage]
class BroadcastViewPageState extends State<BroadcastViewPage> {
  late final BroadcastTour tour;

  @override
  void initState() {
    super.initState();
    tour = widget.tour;
    // context
    //     .read<BroadcastViewBloc>()
    //     .add(BroadcastRoundRequested(tour.currentRound));
    // print('requested round');
  }

  @override
  build(ctx) {
    final theme = Theme.of(ctx);
    final color = theme.colorScheme;

    return MultiBlocProvider(
        providers: [
          BlocProvider<BroadcastViewBloc>(
              create: (ctx) => BroadcastViewBloc(
                  repository: BroadcastRepositoryImpl(), tour: tour)),
        ],
        child: DefaultTabController(
            length: 2,
            initialIndex: 0,
            child: Scaffold(
                body: HBox(
                    mix: Mix(
                      p($large),
                      gap(20),
                      crossAxis(CrossAxisAlignment.start),
                    ),
                    children: [
                  Box(mix: Mix(w(200)), child: _RoundsSection(tour)),
                  DefaultTabController(
                      length: 2,
                      initialIndex: 0,
                      child: VBox(
                          mix: Mix(
                            expanded(),
                            align(Alignment.topLeft),
                            gap(10),
                          ),
                          children: [
                            SegmentedTabControl(
                              backgroundColor: Colors.grey.shade100,
                              indicatorColor: Theme.of(ctx)
                                  .colorScheme
                                  .primary
                                  .lighten(.35),
                              tabTextColor: Colors.black45,
                              selectedTabTextColor: Colors.white,
                              textStyle: Theme.of(ctx).textTheme.titleSmall,
                              height: 50,
                              radius: Radius.zero,
                              tabs: const [
                                SegmentTab(label: 'Overview'),
                                SegmentTab(label: 'Games'),
                              ],
                            ),
                            Expanded(child: _OverviewSection(tour)),
                          ]))
                ]))));
  }
}
// MultiBlocProvider(
//         providers: [
//           BlocProvider<BroadcastViewBloc>(
//               create: (ctx) => BroadcastViewBloc(
//                   repository: BroadcastRepositoryImpl(), tour: tour)),
//         ],
//         child: DefaultTabController(
//             length: 2,
//             initialIndex: 0,
//             child: Scaffold(
//                 body: HBox(
//                     mix: Mix(
//                       p($large),
//                       gap(20),
//                       crossAxis(CrossAxisAlignment.start),
//                     ),
//                     children: [
//                   Box(
//                       mix: Mix(w(200)),
//                       child: ListView(
//                           shrinkWrap: true,
//                           children: tour.rounds
//                               .map((round) => Pressable(
//                                   onPressed: () {},
//                                   child: Box(
//                                       mix: Mix(
//                                         gap(20),
//                                         p(15),
//                                         bgColor(color.surface),
//                                         animated(),
//                                         animationDuration(200),
//                                         (hover)(bgColor(color.surfaceVariant)),
//                                         (press)(bgColor(
//                                             color.surfaceVariant.darken(.1))),
//                                       ),
//                                       child: HBox(children: [
//                                         Text(round.name),
//                                         Box(mix: Mix(expanded())),
//                                         if (round.finished ||
//                                             tour.currentRound.startsAt.isBefore(
//                                                 DateTime.now().toUtc()))
//                                           Box(
//                                               mix: Mix(p(5)),
//                                               child: (round.finished
//                                                   ? const Icon(
//                                                       Icons.done,
//                                                       color: Colors.green,
//                                                     )
//                                                   : Icon(Icons.circle,
//                                                       color:
//                                                           Colors.red.darken(.2),
//                                                       fill: 1))),
//                                       ]))))
//                               .toList())),
//                   DefaultTabController(
//                       length: 2,
//                       initialIndex: 0,
//                       child: VBox(
//                           mix: Mix(
//                             expanded(),
//                             align(Alignment.topLeft),
//                             gap(10),
//                           ),
//                           children: [
//                             SegmentedTabControl(
//                               backgroundColor: Colors.grey.shade100,
//                               indicatorColor: Theme.of(ctx)
//                                   .colorScheme
//                                   .primary
//                                   .lighten(.35),
//                               tabTextColor: Colors.black45,
//                               selectedTabTextColor: Colors.white,
//                               textStyle: Theme.of(ctx).textTheme.titleSmall,
//                               height: 50,
//                               radius: Radius.zero,
//                               tabs: const [
//                                 SegmentTab(label: 'Overview'),
//                                 SegmentTab(label: 'Games'),
//                               ],
//                             ),
//                             Text(
//                               tour.name,
//                               style: theme.textTheme.headlineMedium,
//                               textAlign: TextAlign.left,
//                             ),
//                             Text(tour.markup,
//                                 style: theme.textTheme.bodyMedium),
//                             HBox(children: [
//                               IconButton(
//                                   onPressed: () {},
//                                   icon: const Icon(Icons.first_page)),
//                               IconButton(
//                                   onPressed: () {},
//                                   icon: const Icon(Icons.navigate_before)),
//                               Text("1 - 9 / 30",
//                                   style: theme.textTheme.bodySmall),
//                               IconButton(
//                                   onPressed: () {},
//                                   icon: const Icon(Icons.navigate_next)),
//                               IconButton(
//                                   onPressed: () {},
//                                   icon: const Icon(Icons.last_page)),
//                             ]),
//                             Box(
//                                 mix: Mix(expanded()),
//                                 child: BlocBuilder<BroadcastViewBloc,
//                                         BroadcastViewState>(
//                                     builder: (ctx, state) => GridView.count(
//                                         crossAxisCount: 3,
//                                         children: state.games
//                                             .map<Widget>((game) =>
//                                                 LayoutBuilder(
//                                                     builder:
//                                                         (ctx, constraint) =>
//                                                             Board(
//                                                               size: constraint
//                                                                   .maxWidth,
//                                                               data: BoardData(
//                                                                 interactableSide:
//                                                                     InteractableSide
//                                                                         .none,
//                                                                 orientation:
//                                                                     Side.white,
//                                                                 fen: pgnToFen(
//                                                                     game.pgn),
//                                                               ),
//                                                             )))
//                                             .toList()))),
//                           ]))
//                 ]))))

