import 'package:flutter/material.dart';
import 'package:song_flutter/src.dart';

// import 'helper.dart';

enum NameSort {
  lengthUp,
  lengthDown,
  chinese,
}

NameSort _sort = NameSort.lengthUp;

String _sortString(NameSort sort) {
  switch (sort) {
    case NameSort.lengthUp:
      return '长度递增排序';
    case NameSort.lengthDown:
      return '长度递减排序';
    case NameSort.chinese:
    default:
      return '字母排序';
  }
}

class SongNamePage extends StatefulWidget {
  final String title;
  final List<String> items;

  const SongNamePage({
    Key? key,
    required this.title,
    this.items = const [],
  }) : super(key: key);

  @override
  State<SongNamePage> createState() => _SongNamePageState();
}

class _SongNamePageState extends State<SongNamePage> {
  late ValueNotifier<List<String>> notifier;

  @override
  void initState() {
    super.initState();
    notifier = ValueNotifier(widget.items);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('编辑' + widget.title),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.pop(context, notifier.value);
              AppToast('Save Success', context);
            },
            child: Text('Save'),
          )
        ],
      ),
      body: buildListView(),
      floatingActionButton: buildFloatingButton(context),
    );
  }

  void sort(List<String> sources) {
    if (_sort == NameSort.lengthUp) {
      sources.sort((a, b) {
        return a.length - b.length;
      });
    } else if (_sort == NameSort.lengthDown) {
      sources.sort((a, b) {
        return b.length - a.length;
      });
    } else if (_sort == NameSort.chinese) {
      sources.sort((a, b) {
        final a1 = a;
        // PinyinHelper.getFirstWordPinyin(a);
        final b1 = b;
        // PinyinHelper.getFirstWordPinyin(b);
        return a1.length - b1.length;
      });
    }
    notifier.value = sources;
  }

  Widget buildFloatingButton(BuildContext context) {
    return Container(
      height: 150,
      margin: EdgeInsets.only(top: 20),
      // color: Colors.red,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: UniqueKey(),
            child: Icon(Icons.settings),
            onPressed: () => _showSortPop(context, onClose: (type) {
              _sort = type;
              sort(notifier.value);
            }),
          ),
          SizedBox(height: 20),
          FloatingActionButton(
            heroTag: UniqueKey(),
            child: Icon(Icons.add),
            onPressed: () async {
              final value = await context.onPushTextEditPage('增加歌名');
              if (value is String && value.isNotEmpty) {
                final sources = [...notifier.value];
                sources.add(value);
                sort(sources);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildListView() {
    return ValueListenableBuilder<List<String>>(
        valueListenable: notifier,
        builder: (context, value, _) {
          return Column(
            key: UniqueKey(),
            children: [
              Container(
                padding: EdgeInsets.all(16),
                alignment: Alignment.centerLeft,
                color: Colors.red.withOpacity(0.3),
                child: Text(
                  '当前排序方式: ${_sortString(_sort)}',
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return AppDismissible(
                      slidableKey: ValueKey(value[index]),
                      listItem: ListTile(
                        key: UniqueKey(),
                        title: Text(value[index]),
                      ),
                      removeAction: ActionConfiguration(
                        label: 'Remove',
                        performAction: () {
                          final source = [...value];
                          source.removeAt(index);
                          notifier.value = source;
                        },
                      ),
                    );
                  },
                  itemCount: value.length,
                ),
              ),
            ],
          );
        });
  }
}

void _showSortPop(
  BuildContext context, {
  Function(NameSort)? onClose,
}) {
  showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: SizedBox(
            height: 150,
            child: ListView.builder(
              itemCount: NameSort.values.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    _sortString(NameSort.values[index]),
                  ),
                  onTap: () {
                    onClose?.call(NameSort.values[index]);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      });
}
