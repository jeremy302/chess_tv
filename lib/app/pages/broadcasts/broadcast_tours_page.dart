import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './broadcast_bloc.dart';
import '../../../data/repositories/broadcast_repository.dart';
import './widgets/broadcast_item.dart';

class BroadcastPage extends StatefulWidget {
  const BroadcastPage({super.key});
  @override
  State<StatefulWidget> createState() {
    return _BroadcastPageState();
  }
}

class _BroadcastPageState extends State<BroadcastPage> {
  @override
  initState() {
    super.initState();
    context.read<BroadcastsBloc>().add(BroadcastListRequested());
  }

  @override
  build(ctx) {
    return BlocBuilder<BroadcastsBloc, BroadcastsState>(builder: (ctx, state) {
      return ListView(
          // padding: EdgeInsets.symmetric(vertical: 20),
          children: [
            // Box(
            //   mix: Mix(px(12), pt(10), pb(40)),
            //   child: TextField(
            //       decoration: InputDecoration(
            //     border: OutlineInputBorder(),
            //     hintText: 'Enter a search term',
            //   )),
            // ),
            // OutlinedButton(
            //   child: Text('refresh'),
            //   onPressed: () {
            //     ctx.read<BroadcastsBloc>().add(BroadcastListRequested());
            //   },
            // ),
            ...state.tours.map((tour) => BroadcastItem(tour)).toList()
          ]);
    });
  }
}
