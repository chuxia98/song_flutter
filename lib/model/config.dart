import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

const defaultImageName = 'assets/image.jpg';

class Config extends Equatable {
  final String background;
  final double backCoverOpacity;
  final Color backCoverColor;

  final bool isDebugColor;
  final int row;

  final double height;
  final double width;

  final int count;
  final double spacing;
  final double fontSize;
  final Alignment contentAligment;
  final TextAlign textAlign;

  final List<String> names;

  const Config({
    this.background = '',
    this.backCoverOpacity = 0.1,
    this.backCoverColor = Colors.black,
    this.count = 6,
    this.height = 375,
    this.width = 800,
    this.spacing = 0,
    this.fontSize = 14,
    this.isDebugColor = true,
    this.row = 5,
    this.names = const [],
    this.contentAligment = Alignment.centerLeft,
    this.textAlign = TextAlign.left,
  });

  Config copyWith({
    String? background,
    double? backCoverOpacity,
    Color? backCoverColor,
    bool? isDebugColor,
    int? row,
    List<String>? names,
    double? height,
    double? width,
    double? fontSize,
    Alignment? contentAligment,
    TextAlign? textAlign,
  }) =>
      Config(
        background: background ?? this.background,
        backCoverOpacity: backCoverOpacity ?? this.backCoverOpacity,
        backCoverColor: backCoverColor ?? this.backCoverColor,
        isDebugColor: isDebugColor ?? this.isDebugColor,
        row: row ?? this.row,
        names: names ?? this.names,
        height: height ?? this.height,
        width: width ?? this.width,
        fontSize: fontSize ?? this.fontSize,
        contentAligment: contentAligment ?? this.contentAligment,
        textAlign: textAlign ?? this.textAlign,
      );

  @override
  String toString() {
    return super.toString() +
        '>>>> colors RGB = (${backCoverColor.red}, ${backCoverColor.green}, ${backCoverColor.blue})';
  }

  @override
  List<Object?> get props => [
        background,
        backCoverOpacity,
        backCoverColor,
        isDebugColor,
        row,
        count,
        spacing,
        fontSize,
        names,
        height,
        width,
        contentAligment,
        textAlign,
      ];
}

const String songName =
    '''后来 春泥 成全 中毒 她说 人质 画心 勇气 像鱼 晴天 情歌 记得 云与海 有点甜 浪漫爱 爱一点 告白气球 豆浆油条 明天你好 那么骄傲 他不爱我 失落沙洲 一直很安静 拿走了什么 红色高跟鞋 当爱在靠近 可惜没如果 盛夏的果实 至少还有你 有一种悲伤 可惜不是你 爱过你这件事 这世界那么多人 今天你要嫁给我 给我一个理由忘记 你的酒馆对我打了烊''';
