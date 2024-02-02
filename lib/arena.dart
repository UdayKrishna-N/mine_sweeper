import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minesweeper/provider/area_provider.dart';
import 'package:minesweeper/widgets/mine_area_button.dart';
import 'dart:math' as math;

class Arena extends ConsumerStatefulWidget {
  const Arena({super.key, required this.constraints});

  final BoxConstraints constraints;

  @override
  ConsumerState<Arena> createState() => _ArenaState();
}

class _ArenaState extends ConsumerState<Arena> {
  late ChangeNotifierProvider<AreaManager> manager;

  @override
  void initState() {
    super.initState();
    manager = ChangeNotifierProvider((ref) => AreaManager(BoxConstraints(
        maxHeight: widget.constraints.maxHeight - 100,
        maxWidth: widget.constraints.maxWidth)));
  }

  @override
  Widget build(BuildContext context) {
    var prov = ref.watch(manager);
    return Column(
      children: [
        SizedBox(
          height: 60,
          width: double.infinity,
          child: !prov.isLoading
              ? Center(
                  child: SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _renderMine(sideLength: 40),
                        const SizedBox(width: 10),
                        Text(
                          prov.totalMineCount.toString(),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
        Expanded(
          child: prov.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : GridView.builder(
                  padding: EdgeInsets.symmetric(
                      horizontal: prov.horizontalPadding / 2,
                      vertical: prov.verticalPadding / 2),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: prov.columnCount),
                  itemCount: prov.itemCount,
                  itemBuilder: (context, index) {
                    var area = prov.arenaData[index];
                    debugPrint(area.toString());
                    return MineAreaButton(
                        sideLength: prov.sidelength,
                        mineArea: area,
                        manager: prov,
                        onTap: () => prov.mineTriggered
                            ? null
                            : prov.onMineAreaTap(area));
                  }),
        ),
      ],
    );
  }

  Widget _renderMine({required double sideLength, Color color = Colors.black}) {
    return SizedBox(
      height: sideLength,
      width: sideLength,
      child: Stack(
        children: [
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
      ),
    );
  }
}
