part of 'config_bloc.dart';

abstract class ConfigState extends Equatable {
  const ConfigState();

  @override
  List<Object?> get props => [];
}

class ConfigLoadSuccess extends ConfigState {
  final String imageName;
  final String? timestamp;
  final Config config;

  const ConfigLoadSuccess({
    this.imageName = '',
    this.timestamp,
    this.config = const Config(),
  });

  ConfigLoadSuccess copyWith({
    String? imageName,
    Config? config,
  }) =>
      ConfigLoadSuccess(
        imageName: imageName ?? this.imageName,
        config: config ?? this.config,
        timestamp: DateTime.now().toString(),
      );

  @override
  List<Object?> get props => [
        imageName,
        config,
        timestamp,
      ];
}
