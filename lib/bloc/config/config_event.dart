part of 'config_bloc.dart';

abstract class ConfigEvent extends Equatable {
  const ConfigEvent();

  @override
  List<Object> get props => [];
}

class ChangeImageStarted extends ConfigEvent {
  final String name;

  const ChangeImageStarted({
    required this.name,
  });

  @override
  List<Object> get props => [
        name,
      ];
}

class ConfigUpdateStarted extends ConfigEvent {
  final Config config;

  const ConfigUpdateStarted({
    required this.config,
  });

  @override
  List<Object> get props => [
        config,
      ];
}

class ConfigLoadStarted extends ConfigEvent {
  const ConfigLoadStarted();
}

class ConfigNamesUpdated extends ConfigEvent {
  final List<String> items;

  const ConfigNamesUpdated({this.items = const []});

  @override
  List<Object> get props => [
        items,
      ];
}
