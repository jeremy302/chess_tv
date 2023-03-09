import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import './broadcasts/widgets/broadcast_item.dart';
import './broadcasts/broadcast_bloc.dart';
import '../../data/repositories/broadcast_repository.dart';
import './broadcasts/broadcast_page.dart';

// layout of the home page
class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});
  @override
  State<StatefulWidget> createState() {
    return _HomeLayoutState();
  }
}

// state of [HomeLayout]
class _HomeLayoutState extends State<HomeLayout> {
  @override
  build(ctx) {
    var tabHeaderStyle = Mix(p($large));
    var tabBodyStyle = Mix(expanded());

    return MultiBlocProvider(
        providers: [
          BlocProvider<BroadcastsBloc>(
              create: (ctx) =>
                  BroadcastsBloc(repository: BroadcastRepositoryImpl())),
        ],
        child: DefaultTabController(
            length: 3,
            initialIndex: 0,
            child: Scaffold(
                body: VBox(mix: Mix(p($large)), children: [
              Box(
                  mix: tabHeaderStyle,
                  child: SegmentedTabControl(
                    backgroundColor: Colors.grey.shade100,
                    indicatorColor:
                        Theme.of(ctx).colorScheme.primary.lighten(.35),
                    tabTextColor: Colors.black45,
                    selectedTabTextColor: Colors.white,
                    textStyle: Theme.of(ctx).textTheme.titleLarge,
                    height: 70,
                    radius: Radius.zero,
                    tabs: const [
                      SegmentTab(label: 'Broadcasts'),
                      SegmentTab(label: 'Lichess'),
                      SegmentTab(label: 'Chess.com'),
                    ],
                  )),
              Box(
                  mix: tabBodyStyle,
                  child: TabBarView(children: [
                    BroadcastPage(),
                    Text('b'),
                    Text('c'),
                  ])),
            ]))
            // VBox(children: [

            //SafeArea(child:TabBarView(children: [Text('a'), Text('b'), Text('c')]))
            // ]),
            //const TabBarView(children: [Text('a'), Text('b'), Text('c')],)
            ));
  }
}
