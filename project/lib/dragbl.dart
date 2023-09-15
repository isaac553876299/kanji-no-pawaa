import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: AspectRatio(
            aspectRatio: 0.5,
            child: Column(
              children: [
                Expanded(child: Placeholder()),
                Expanded(child: FittedBox(child: MyDragabl())),
                Expanded(child: Placeholder()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyDragabl extends StatefulWidget {
  const MyDragabl({super.key});
  @override
  State<MyDragabl> createState() => _MyDragablState();
}

class _MyDragablState extends State<MyDragabl> {
  int sel = 0;
  void myDrag(Offset pos) {
    var temp = (pos.dx - 0) ~/ 100;
    if (sel != temp) setState(() => sel = temp);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //onPanDown: (_) => myDrag(_.localPosition),
      onPanUpdate: (_) => myDrag(_.localPosition),
      child: Stack(
        alignment: Alignment.center,
        children: [
          for (var i = 0; i < 6; ++i)
            Center(
              child: Transform.translate(
                offset: Offset((i - 3) * 100, 0),
                child: Transform.scale(
                  scale: i == sel ? 0.9 : 1.0,
                  child: GestureDetector(
                    onTap: () => setState(() => sel = i),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        border: Border.all(color: Colors.amber),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.insert_link,
                          color: Colors.white,
                          size: 64,
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
