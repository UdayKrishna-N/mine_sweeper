import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:minesweeper/model/mine_area.dart';

class AreaManager extends ChangeNotifier {
  final BoxConstraints constraints;

  double _sideLength = 0;

  int _rowCount = 0;
  int _columnCount = 0;
  bool _isLoading = true;
  int _totalMineCount = 0;
  bool _mineTriggered = false;

  double _horizontalPadding = 0;
  double _verticalPadding = 0;
  Set<int> _mineList = {};

  List<MineArea> _arenaData = [];

  // getter
  int get rowCount => _rowCount;
  int get columnCount => _columnCount;
  double get sidelength => _sideLength;
  bool get isLoading => _isLoading;
  double get horizontalPadding => _horizontalPadding;
  double get verticalPadding => _verticalPadding;
  int get itemCount => _rowCount * _columnCount;
  List<MineArea> get arenaData => _arenaData;
  int get totalMineCount => _totalMineCount;
  bool get mineTriggered => _mineTriggered;

  // setter
  setLoading(bool value) {
    _isLoading = value;
  }

  setTrigger(bool value) {
    _mineTriggered = value;
  }

  setMineCount(int value) {
    _totalMineCount = value;
  }

  setCount(int row, int column) {
    _rowCount = row;
    _columnCount = column;
  }

  setPadding(double horz, double vert) {
    _horizontalPadding = horz;
    _verticalPadding = vert;
  }

  setArenaData(List<MineArea> value) {
    _arenaData = value;
  }

  setSideLength() {
    _sideLength = kIsWeb ? 60 : 40;
  }

  notify() {
    notifyListeners();
  }

  // constuctor
  AreaManager(this.constraints) {
    setSideLength();
    calculateMatrixValues();
    createArenaData();
    updateCounts();
    setLoading(false);
    notify();
  }

  calculateMatrixValues() {
    var crossCount = constraints.maxWidth / _sideLength;
    var vertCount = constraints.maxHeight / _sideLength;
    setCount(
      vertCount.floor(),
      crossCount.floor(),
    );
    var crossPad = constraints.maxWidth % _sideLength;
    var vertPad = constraints.maxHeight % _sideLength;
    setPadding(crossPad, vertPad);
  }

  createArenaData() {
    List<MineArea> data = [];
    for (var i = 0; i < rowCount; i++) {
      for (var j = 0; j < columnCount; j++) {
        MineArea area = MineArea()
          ..rowPosition = i
          ..columnPosition = j;
        data = [...data, area];
      }
    }

    var mineCount = (itemCount * 0.15).floor();
    setMineCount(mineCount);
    Set<int> mineList = {};
    while (mineCount != 0) {
      var random = Random().nextInt(itemCount);
      if (!mineList.contains(random)) {
        mineList.add(random);
        data[random].activeMine = true;
        mineCount--;
      }
    }
    _mineList = mineList;

    setArenaData(data);
  }

  updateCounts() {
    for (var i in _mineList) {
      updateNearMineAreaCount(arenaData[i]);
    }
  }

  updateNearMineAreaCount(MineArea area) {
    var row = area.rowPosition!;
    var column = area.columnPosition!;
    updateAreaCount(row: row - 1, column: column - 1);
    updateAreaCount(row: row - 1, column: column);
    updateAreaCount(row: row - 1, column: column + 1);
    updateAreaCount(row: row, column: column - 1);
    updateAreaCount(row: row, column: column + 1);
    updateAreaCount(row: row + 1, column: column - 1);
    updateAreaCount(row: row + 1, column: column);
    updateAreaCount(row: row + 1, column: column + 1);
  }

  updateAreaCount({required int row, required int column}) {
    if (row >= 0 && row < rowCount && column >= 0 && column < columnCount) {
      var index = (row * columnCount) + column;
      _arenaData[index].count = _arenaData[index].count + 1;
    }
  }

  onMineAreaTap(MineArea area) {
    var index = (area.rowPosition! * columnCount) + area.columnPosition!;
    if (_arenaData[index].activeMine) {
      _arenaData[index].isSelected = true;
      setTrigger(true);
    } else {
      _arenaData[index].isSelected = true;
      if (_arenaData[index].count == 0) {
        selectNearMineArea(_arenaData[index]);
      }
    }
    notify();
  }

  selectNearMineArea(MineArea area) {
    var row = area.rowPosition!;
    var column = area.columnPosition!;
    selectMineArea(row - 1, column - 1);
    selectMineArea(row - 1, column);
    selectMineArea(row - 1, column + 1);
    selectMineArea(row, column - 1);
    selectMineArea(row, column + 1);
    selectMineArea(row + 1, column - 1);
    selectMineArea(row + 1, column);
    selectMineArea(row + 1, column + 1);
  }

  selectMineArea(int row, int column) {
    if (row >= 0 && row < rowCount && column >= 0 && column < columnCount) {
      var index = (row * columnCount) + column;
      if (!_arenaData[index].activeMine && !_arenaData[index].isSelected) {
        _arenaData[index].isSelected = true;
        if (_arenaData[index].count == 0) {
          selectNearMineArea(_arenaData[index]);
        }
      }
    }
  }
}
