import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:song_flutter/src.dart';

import 'page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConfigBloc, ConfigState>(
      builder: (context, state) {
        final config = (state as ConfigLoadSuccess).config;
        return Scaffold(
          appBar: AppBar(
            title: Text('HOME'),
            actions: [
              MaterialButton(
                child: Text('生成图片'),
                onPressed: () {
                  print('[object]');
                  renderImage();
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RepaintBoundary(
                  key: globalKey,
                  child: Container(
                    color: Colors.red,
                    alignment: Alignment.center,
                    width: config.width,
                    height: config.height,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Background(),
                        Container(
                          padding: const EdgeInsets.all(30),
                          child: SongGridView(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: buildFloatingButton(),
        );
      },
    );
  }

  Widget buildFloatingButton() {
    return FloatingActionButton(
      child: const Icon(Icons.settings),
      onPressed: () async {
        final state = BlocProvider.of<ConfigBloc>(context).state as ConfigLoadSuccess;

        final value = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SettingPage(config: state.config),
            ));

        if (value is Config) {
          BlocProvider.of<ConfigBloc>(context).add(ConfigUpdateStarted(
            config: value,
          ));
        }
      },
    );
  }

  void renderImage() async {
    try {
      final boundary = globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      final pixelRatio = ui.window.devicePixelRatio;
      final image = await boundary?.toImage(pixelRatio: pixelRatio);
      if (image == null) {
        print('[cx] image error');
        return;
      }
      var status1 = await Permission.camera.status;
      print('[cx] $status1');

      late PermissionStatus status;
      if (Platform.isIOS) {
        status = await Permission.photos.request();
      } else if (kIsWeb) {
        // status = Permission.photos.request();
      } else {
        status = await Permission.storage.request();
      }
      if (status.isDenied) {
        AppToast('权限被拒绝', context);
        return;
      }
      // PermissionStatus.permanentlyDenied;

      print('[cx] $status');
      if (status.isGranted) {
        final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        final pngBytes = byteData?.buffer.asUint8List();
        final result = await ImageGallerySaver.saveImage(pngBytes!, quality: 80);

        if (result["isSuccess"]) {
          AppToast('Save success', context);
        } else {
          AppToast('Save failure', context);
        }
      }
    } catch (e) {
      print('[error] $e');
    }
  }
}
