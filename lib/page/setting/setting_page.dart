import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:song_flutter/src.dart';

enum SettingType {
  idle,
  coverColor,
  background,
  debugColor,
  row,
  songSort,
  height,
  width,
  fontSize,
  nameAlign,
  contentAlign,
}

class SettingModel extends Equatable {
  final String text;
  final SettingType type;

  const SettingModel({
    this.text = '',
    this.type = SettingType.idle,
  });

  @override
  List<Object?> get props => [
        text,
        type,
      ];
}

class SettingPage extends StatefulWidget {
  final Config config;

  const SettingPage({
    Key? key,
    required this.config,
  }) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final List<SettingModel> items = [
    const SettingModel(text: '修改背景图'),
    const SettingModel(text: '背景遮罩图透明度'),
    const SettingModel(text: '背景图遮罩透颜色', type: SettingType.coverColor),
    const SettingModel(text: '最终图片高度', type: SettingType.height),
    const SettingModel(text: '最终图片宽度', type: SettingType.width),
    const SettingModel(text: '行数', type: SettingType.row),
    const SettingModel(text: '调试背景色', type: SettingType.debugColor),
    const SettingModel(text: '歌名排序', type: SettingType.songSort),
    const SettingModel(text: '字体大小', type: SettingType.fontSize),
    const SettingModel(text: '文字对齐方式', type: SettingType.nameAlign),
    const SettingModel(text: '内容对齐方式', type: SettingType.contentAlign),
  ];

  Config get config => notifier.value;

  late ValueNotifier<Config> notifier;

  @override
  void initState() {
    super.initState();

    notifier = ValueNotifier<Config>(widget.config);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
        actions: [
          MaterialButton(
            child: Text('保存'),
            onPressed: () {
              Navigator.pop(context, config);
              AppToast('Save Success', context);
              print('[cx] $config');
            },
          ),
        ],
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return ValueListenableBuilder<Config>(
        valueListenable: notifier,
        builder: (context, value, _) {
          return ListView.builder(
            itemBuilder: (context, index) {
              final model = items[index];
              return ListTile(
                tileColor: config.isDebugColor ? (index % 2 == 0 ? Colors.orange : Colors.red).withOpacity(0.3) : null,
                title: Text(model.text),
                trailing: buildTrailing(context, index, model),
                onTap: () async {
                  if (index == 0) {
                    chooseImage(context);
                  } else if (index == 1) {
                    onChangeBackCoverOpacity(context);
                  } else if (index == 2) {
                    onChangeBackCoverColor(context);
                  } else if (model.type == SettingType.height) {
                    final value = await context.onPushTextEditPage(model.text);
                    if (value is String) {
                      final height = double.tryParse(value) ?? 0;
                      if (height < 300) {
                        AppToast('宽度/高度不能低于 300', context);
                        return;
                      }
                      notifier.value = config.copyWith(height: height);
                    }
                  } else if (model.type == SettingType.width) {
                    final value = await context.onPushTextEditPage(model.text);
                    if (value is String) {
                      final width = double.tryParse(value) ?? 0;
                      if (width < 300) {
                        AppToast('宽度/高度不能低于 300', context);
                        return;
                      }
                      notifier.value = config.copyWith(width: width);
                    }
                  } else if (model.type == SettingType.row) {
                    final value = await context.onPushTextEditPage(model.text);
                    if (value is String) {
                      final row = int.tryParse(value);
                      if (row == 0) {
                        AppToast('行数不能为 0', context);
                        return;
                      }
                      notifier.value = config.copyWith(row: row);
                    }
                  } else if (model.type == SettingType.songSort) {
                    final page = SongNamePage(
                      title: model.text,
                      items: config.names,
                    );
                    final value = await Navigator.push(context, MaterialPageRoute(builder: (_) => page));
                    if (value is List<String>) {
                      notifier.value = config.copyWith(names: value);
                    }
                  } else if (model.type == SettingType.fontSize) {
                    final value = await context.onPushTextEditPage(model.text);
                    if (value is String) {
                      final fontSize = double.tryParse(value) ?? 0;
                      if (fontSize < 10) {
                        AppToast('字体大小不能小于 10', context);
                        return;
                      }
                      notifier.value = config.copyWith(fontSize: fontSize);
                    }
                  }
                },
              );
            },
            itemCount: items.length,
          );
        });
  }

  Widget? buildTrailing(BuildContext context, int index, SettingModel model) {
    if (index == 0) {
      if (config.background.isEmpty) {
        return Image.asset(
          defaultImageName,
          width: 70,
          height: 50,
          fit: BoxFit.cover,
        );
      }
      if (kIsWeb) {
        return Image.network(
          config.background,
          width: 70,
          height: 50,
          fit: BoxFit.cover,
        );
      }
      return Image.file(
        File(config.background),
        width: 70,
        height: 50,
        fit: BoxFit.cover,
      );
    } else if (index == 1) {
      return Text('${config.backCoverOpacity}');
    } else if (model.type == SettingType.coverColor) {
      return Container(
        color: config.backCoverColor,
        width: 70,
        height: 50,
      );
    } else if (model.type == SettingType.height) {
      return Text('${config.height}');
    } else if (model.type == SettingType.width) {
      return Text('${config.width}');
    } else if (index == 5) {
      return Text('${config.row}');
    } else if (model.type == SettingType.fontSize) {
      return Text('${config.fontSize}');
    } else if (model.type == SettingType.debugColor) {
      return CupertinoSwitch(
          value: config.isDebugColor,
          onChanged: (value) {
            notifier.value = config.copyWith(isDebugColor: value);
          });
    } else if (model.type == SettingType.nameAlign) {
      return Text('${config.textAlign}');
    } else if (model.type == SettingType.contentAlign) {
      return Text('${config.contentAligment}');
    }
    return null;
  }

  void chooseImage(BuildContext context) async {
    try {
      final source = await ImagePicker().pickImage(source: ImageSource.gallery);
      final name = source?.path;

      if (name != null) {
        notifier.value = config.copyWith(background: name);
      }
    } catch (_) {}
  }

  void onChangeBackCoverOpacity(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
            child: Container(
              height: 200,
              alignment: Alignment.center,
              color: Colors.green,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      '$index',
                      textAlign: TextAlign.center,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      notifier.value = config.copyWith(backCoverOpacity: index * 0.1);
                    },
                  );
                },
                itemCount: 10,
              ),
            ),
          );
        });
  }

  void onChangeBackCoverColor(BuildContext context) {
    final colors = <Color>[
      Colors.black,
      Colors.red,
      Colors.green,
      Colors.pink,
      Colors.pinkAccent,
      Colors.yellow,
    ];
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
            child: Container(
              height: 200,
              alignment: Alignment.center,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return ListTile(
                    tileColor: colors[index],
                    title: Container(
                      height: 44,
                      color: colors[index],
                      width: double.infinity,
                      // child: Text('1'),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      notifier.value = config.copyWith(backCoverColor: colors[index]);
                    },
                  );
                },
                itemCount: colors.length,
              ),
            ),
          );
        });
  }
}
