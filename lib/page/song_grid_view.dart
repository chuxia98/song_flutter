import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../src.dart';

class SongGridView extends StatelessWidget {
  const SongGridView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = BlocProvider.of<ConfigBloc>(context).state as ConfigLoadSuccess;
    final config = state.config;

    // ignore: avoid_print
    print('[object] SongGridView');

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: config.row,
        childAspectRatio: 3 / 7,
      ),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Container(
          // padding: const EdgeInsets.all(10),
          alignment: config.contentAligment,
          child: Text(
            config.names[index],
            textAlign: config.textAlign,
            style: TextStyle(
              color: Colors.white,
              fontSize: config.fontSize,
            ),
          ),
          color: config.isDebugColor
              ? index % 2 == 0
                  ? Colors.red.withOpacity(0.2)
                  : Colors.green.withOpacity(0.2)
              : null,
        );
      },
      itemCount: config.names.length,
    );
  }
}
