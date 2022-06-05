import 'package:flutter/material.dart';
import 'package:song_flutter/src.dart';

class TextEditPage extends StatelessWidget {
  final String title;
  final TextEditingController controller = TextEditingController();

  TextEditPage({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('编辑' + title),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.pop(context, controller.text);
              AppToast('Edit Success', context);
            },
            child: Text('Save'),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: '请输入$title',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
