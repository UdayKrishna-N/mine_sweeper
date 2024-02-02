import 'package:flutter/material.dart';
import 'package:minesweeper/main_screen.dart';
import 'package:minesweeper/widgets/mine_area_button.dart';
import 'dart:math' as math;

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 180,
            width: 180,
            child: DecoratedBox(
              decoration: const BoxDecoration(color: Colors.white),
              child: GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                children: [
                  _renderGridChild(),
                  _renderGridChild(count: 1, isSelected: true),
                  _renderGridChild(),
                  _renderGridChild(
                      isSelected: true,
                      activeMine: true,
                      color: Colors.red.shade700),
                  _renderGridChild(),
                  _renderGridChild(count: 1, isSelected: true),
                  _renderGridChild(count: 2, isSelected: true),
                  _renderGridChild(isSelected: true, activeMine: true),
                  _renderGridChild(),
                ],
              ),
            ),
          ),
          Center(
            child: _renderStartButton(() {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MainScreen()));
            }),
          ),
        ],
      )),
    );
  }

  Widget _renderGridChild(
      {bool isSelected = false,
      bool activeMine = false,
      double sideLength = 60,
      int count = 0,
      Color color = Colors.black}) {
    return SizedBox(
      height: sideLength,
      width: sideLength,
      child: DecoratedBox(
        decoration: BoxDecoration(
            color: Colors.grey[100],
            border: isSelected ? Border.all(color: Colors.black26) : null),
        child: isSelected
            ? !activeMine
                ? Center(
                    child: count != 0
                        ? Text(
                            count.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: count > 4
                                  ? Colors.red
                                  : count > 2
                                      ? Colors.green
                                      : Colors.blue,
                            ),
                          )
                        : const SizedBox(),
                  )
                : _renderMineButton(sideLength, color: color)
            : _renderBlockButton(sideLength),
      ),
    );
  }

  Widget _renderMineButton(double sideLength, {Color color = Colors.black}) {
    return Stack(
      children: [
        _renderBlockButton(sideLength),
        Center(
          child: SizedBox(
            height: sideLength * 0.6,
            width: sideLength * 0.6,
            child: DecoratedBox(
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: color)),
          ),
        ),
        Center(
          child: SizedBox(
            height: sideLength * 0.7,
            width: 5,
            child: DecoratedBox(
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                    color: color)),
          ),
        ),
        Center(
          child: Transform.rotate(
            angle: math.pi / 4,
            child: SizedBox(
              height: sideLength * 0.7,
              width: 5,
              child: DecoratedBox(
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10),
                      color: color)),
            ),
          ),
        ),
        Center(
          child: Transform.rotate(
            angle: -math.pi / 4,
            child: SizedBox(
              height: sideLength * 0.7,
              width: 5,
              child: DecoratedBox(
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10),
                      color: color)),
            ),
          ),
        )
      ],
    );
  }

  Widget _renderBlockButton(double sideLength) {
    return Stack(
      children: [
        ClipPath(
          clipper: MyClipper(),
          child: Container(
            height: sideLength,
            width: sideLength,
            decoration: BoxDecoration(
              color: Colors.grey[600],
            ),
          ),
        ),
        Center(
          child: SizedBox(
            height: sideLength * 0.8,
            width: sideLength * 0.8,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.grey[300],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _renderStartButton(VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 60,
        width: 180,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.grey[100],
          ),
          child: Stack(
            children: [
              ClipPath(
                clipper: MyClipper(),
                child: Container(
                  height: 60,
                  width: 180,
                  decoration: BoxDecoration(
                    color: Colors.grey[600],
                  ),
                ),
              ),
              Center(
                child: SizedBox(
                  height: 60 * 0.9,
                  width: 180 * 0.9,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                    ),
                    child: const Center(
                      child: Text(
                        'START',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5),
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
}
