import 'package:flutter/material.dart';
import 'package:minesweeper/model/mine_area.dart';
import 'package:minesweeper/provider/area_provider.dart';
import 'dart:math' as math;

class MineAreaButton extends StatelessWidget {
  const MineAreaButton({
    super.key,
    required this.sideLength,
    required this.mineArea,
    required this.onTap,
    required this.manager,
  });

  final double sideLength;
  final VoidCallback onTap;
  final MineArea mineArea;
  final AreaManager manager;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: sideLength,
        width: sideLength,
        child: DecoratedBox(
          decoration: BoxDecoration(
              color: Colors.grey[100],
              border: mineArea.isSelected
                  ? Border.all(color: Colors.black26)
                  : null),
          child: mineArea.isSelected
              ? !mineArea.activeMine
                  ? Center(
                      child: mineArea.count != 0
                          ? Text(
                              mineArea.count.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: mineArea.count > 4
                                    ? Colors.red
                                    : mineArea.count > 2
                                        ? Colors.green
                                        : Colors.blue,
                              ),
                            )
                          : const SizedBox(),
                    )
                  : _renderMineButton(color: Colors.red.shade700)
              : mineArea.activeMine && manager.mineTriggered
                  ? _renderMineButton()
                  : _renderBlockButton(),
        ),
      ),
    );
  }

  Widget _renderMineButton({Color color = Colors.black}) {
    return Stack(
      children: [
        _renderBlockButton(),
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

  Widget _renderBlockButton() {
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
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
