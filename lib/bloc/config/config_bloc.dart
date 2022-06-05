import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:song_flutter/model/config.dart';

part 'config_event.dart';
part 'config_state.dart';

class ConfigBloc extends Bloc<ConfigEvent, ConfigState> {
  ConfigBloc() : super(ConfigLoadSuccess()) {
    on<ConfigEvent>((event, emit) {
      final currentState = state as ConfigLoadSuccess;
      if (event is ChangeImageStarted) {
        emit(currentState.copyWith(
          imageName: event.name,
        ));
      } else if (event is ConfigUpdateStarted) {
        emit(currentState.copyWith(
          config: event.config,
        ));
      } else if (event is ConfigLoadStarted) {
        final items = songName.split(' ');
        final config = Config(names: items);
        emit(currentState.copyWith(config: config));
      }
    });
  }
}
