import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './broadcast_bloc.dart';
//import '../../../data/repositories/broadcast_repository.dart';
import './widgets/broadcast_item.dart';
import './broadcast_view_page.dart';

// Broadcast section of the home page
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
          children: state.tours
              .map((tour) => BroadcastItem(
                    tour,
                    onClick: (tour) {
                      Navigator.push(
                          ctx,
                          MaterialPageRoute(
                              builder: (ctx) => BroadcastViewPage(tour)));
                    },
                  ))
              .toList());
    });
  }
}
