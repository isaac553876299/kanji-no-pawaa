import 'package:flutter/material.dart';
import 'dart:math';

import 'kanjim.dart';

class TestK extends StatefulWidget {
  const TestK({
    super.key,
    required this.kdb,
    required this.lang,
    required this.filter,
    required this.animate,
  });

  final List<Kanji> kdb;
  final String lang;
  final int filter;
  final void Function(int code) animate;
  @override
  State<TestK> createState() => _TestKState();
}

class _TestKState extends State<TestK> {
  late dynamic xd;
  late String lang;

  List<Kanji> H = [];
  int sel = 5;
  List<int> lOr = [];
  int? correct;

  bool waitingNext = true;
  bool showMeanings = false;

  var lvls = [0, 80, 240, 440, 640, 825, 1006, 2136];
  int filter = 0;
  List<Kanji> temp = [];
  @override
  initState() {
    super.initState();
    lang = widget.lang;
    filter = widget.filter;
    next();
  }

  void next() {
    setState(() {
      if (temp.isEmpty) {
        //temp.clear();
        for (int i = 0; i < 7; ++i) {
          if (filter & (1 << i) == 1 || filter == 0) {
            for (int j = lvls[i]; j < lvls[i + 1]; ++j) {
              temp.add(widget.kdb[j]);
            }
          }
        }
      }
      if (waitingNext) {
        if (correct != null) {
          temp.removeAt(lOr[correct!]);
        }
        lOr = List<int>.generate(2, (_) => Random().nextInt(temp.length));
        correct = Random().nextInt(2);

        waitingNext = false;
        showMeanings = false;
      }
      //
      widget.animate(0);
    });
  }

  void check(int choice) {
    if (!waitingNext) {
      setState(() {
        waitingNext = true;
        if (choice != correct) {
          H.add(temp[lOr[correct!]]);
          //
          widget.animate(Random().nextInt(3) + 4);
          if (H.length == 6) {
            //temp.clear();
            for (int i = 0; i < H.length; ++i) {
              temp.add(H[i]);
            }
            H.clear();
            xxd();
            //
            widget.animate(10);
          }
        } else {
          H.remove(temp[lOr[correct!]]);
          //temp.removeAt(lOr[correct!]);
          //
          widget.animate(Random().nextInt(3) + 1);
        }
      });
    }
  }

  void xxd() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade300,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        contentPadding: const EdgeInsets.only(top: 10),
        content: AspectRatio(
          aspectRatio: 1,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: FittedBox(
                    child: Text(
                      " 頑張れ！",
                      style: TextStyle(color: Colors.grey.shade800),
                    ),
                  ),
                ),
              ),
              const Divider(thickness: 1, indent: 30, endIndent: 30),
              Expanded(
                flex: 2,
                child: SizedBox(
                  width: 200,
                  height: 250,
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: ListWheelScrollView.useDelegate(
                        controller: FixedExtentScrollController(),
                        itemExtent: 100,
                        diameterRatio: 10.0,
                        magnification: 1.2,
                        useMagnifier: false,
                        perspective: 0.001,
                        squeeze: 1.5,
                        physics: const FixedExtentScrollPhysics(),
                        onSelectedItemChanged: (value) =>
                            setState(() => sel = value),
                        childDelegate: ListWheelChildBuilderDelegate(
                          childCount: 6,
                          builder: (context, index) => RotatedBox(
                            quarterTurns: -1,
                            child: Center(
                              child: AspectRatio(
                                aspectRatio: 0.7,
                                child: Transform.scale(
                                  scale: index == sel ? 1.0 : 1.0,
                                  child: FittedBox(
                                    child: GestureDetector(
                                      onTap: () => setState(() => sel = index),
                                      child: Container(
                                        margin: const EdgeInsets.all(2),
                                        padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade800,
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.shade900,
                                                blurRadius: 1,
                                                spreadRadius: 2,
                                              ),
                                            ]),
                                        child: FittedBox(
                                          child: Text(
                                            temp[index].K,
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(30))),
                  child: InkWell(
                    focusColor: Colors.white,
                    hoverColor: Colors.white,
                    splashColor: Colors.white,
                    highlightColor: Colors.white,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(30)),
                    child: const FittedBox(
                      child: Text(
                        "【々】",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => next(),
      //onDoubleTap: () => xxd(),
      child: Column(
        children: [
          Flexible(
            fit: FlexFit.tight,
            flex: 5,
            child: AspectRatio(
              aspectRatio: 1,
              child: GestureDetector(
                onTap: () => setState(() => showMeanings ^= true),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: FittedBox(
                    child: Text(
                      !showMeanings
                          ? temp[lOr[correct!]].K
                          : temp[lOr[correct!]].I[lang]!.replaceAll(', ', '\n'),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: FittedBox(
              child: Text(
                '${H.length}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List<Widget>.generate(
                2,
                (index) => GestureDetector(
                  onTap: () => check(index),
                  child: AspectRatio(
                    aspectRatio: 0.666666,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: !waitingNext
                            ? Colors.grey.shade300
                            : index == correct
                                ? Colors.white
                                : Colors.grey.shade700,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: FittedBox(
                        child: Text(
                          temp[lOr[index]].Y.replaceAll('、', '\n'),
                          style: TextStyle(
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
