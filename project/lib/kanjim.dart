import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class Kanji {
  int N;
  String K;
  String Y;
  Map<String, String> I;
  Kanji({
    required this.N,
    required this.K,
    required this.Y,
    required this.I,
  });
}

Future<List<Kanji>> loadKustom() async {
  final contents = await rootBundle.loadString("assets/kdb.json");
  final translation0 = await rootBundle.loadString("assets/locals/EN.json");
  final translation1 = await rootBundle.loadString("assets/locals/ES.json");
  final entries = List<String>.from(json.decode(contents));
  final t_entries0 = List<String>.from(json.decode(translation0));
  final t_entries1 = List<String>.from(json.decode(translation1));
  final result = <Kanji>[];
  for (var e in entries) {
    var index = int.parse(RegExp(r'#(\d{1,4})【').firstMatch(e)!.group(1)!);
    var kanji = RegExp(r'【(.)】').firstMatch(e)!.group(1)!;
    var yomi = RegExp(r'】「(.*?)」').firstMatch(e)!.group(1)!;
    var imi = <String, String>{};
    //imi['EN'] = 'xd';
    imi['EN'] = RegExp(r'「(.*?)」').firstMatch(t_entries0[index - 1])!.group(1)!;
    imi['ES'] = RegExp(r'「(.*?)」').firstMatch(t_entries1[index - 1])!.group(1)!;
    result.add(
      Kanji(N: index, K: kanji, Y: yomi, I: imi),
    );
  }
  return result;
}
