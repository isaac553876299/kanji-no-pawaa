import 'package:flutter/material.dart';
import 'kanjim.dart';

class FlashK extends StatefulWidget {
  const FlashK({
    super.key,
    required this.kdb,
  });

  final List<Kanji> kdb;

  @override
  State<FlashK> createState() => _FlashKState();
}

class _FlashKState extends State<FlashK> {
  late FixedExtentScrollController controllr;

  @override
  void initState() {
    super.initState();
    controllr = FixedExtentScrollController();
  }

  @override
  void dispose() {
    controllr.dispose();
    super.dispose();
  }

  int ci = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          padding: const EdgeInsets.all(6),
          child: Text(
            '${ci + 1}',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        Scrollbar(
          controller: controllr,
          thumbVisibility: true,
          thickness: 16,
          scrollbarOrientation: ScrollbarOrientation.left,
          child: Scrollbar(
            controller: controllr,
            thumbVisibility: true,
            thickness: 16,
            scrollbarOrientation: ScrollbarOrientation.right,
            child: ListWheelScrollView.useDelegate(
              controller: controllr,
              itemExtent: 150,
              diameterRatio: 2.0,
              magnification: 1.5,
              useMagnifier: false,
              perspective: 0.01,
              squeeze: 1.5,
              physics: const FixedExtentScrollPhysics(),
              onSelectedItemChanged: (value) => setState(() => ci = value),
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: widget.kdb.length,
                builder: (context, index) => Center(
                  child: AspectRatio(
                    aspectRatio: 2,
                    child: GestureDetector(
                      //behavior: HitTestBehavior.opaque,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('$index'),
                            duration: const Duration(milliseconds: 500),
                          ),
                        );
                        MyKard(context, index);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 50),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade900,
                                blurRadius: 5,
                                spreadRadius: 5,
                              ),
                            ]),
                        child: Center(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade800,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                '【${widget.kdb[index].K}】',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 64),
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
      ],
    );
  }

  Future<dynamic> MyKard(BuildContext context, int index) {
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade300,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        contentPadding: const EdgeInsets.all(10),
        content: SizedBox(
          width: 200,
          height: 250,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                '${widget.kdb[index].N}',
              ),
              const SizedBox.square(dimension: 10),
              Expanded(
                flex: 3,
                child: Text(
                  widget.kdb[index].Y,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  '【${widget.kdb[index].K}】',
                  style: TextStyle(color: Colors.grey.shade900, fontSize: 32),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(widget.kdb[index].I['EN']!),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
