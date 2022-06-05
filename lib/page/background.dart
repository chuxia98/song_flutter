import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:song_flutter/src.dart';

class Background extends StatelessWidget {
  const Background({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = BlocProvider.of<ConfigBloc>(context).state as ConfigLoadSuccess;
    final config = state.config;
    // ignore: avoid_print
    print('[object] Background');

    late Widget body;
    if (config.background.isNotEmpty) {
      if (kIsWeb) {
        body = Image.network(
          config.background,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        );
      } else {
        body = Image.file(
          File(config.background),
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        );
      }
    } else {
      body = Image.asset(
        defaultImageName,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      );
    }
    return Stack(
      children: [
        body,
        Container(
          color: config.backCoverColor.withOpacity(config.backCoverOpacity),
        )
      ],
    );
  }
}
