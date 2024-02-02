class MineArea {
  // row position
  int? rowPosition;

  // column position
  int? columnPosition;

  // isSelected
  bool isSelected = false;

  // active mine
  bool activeMine = false;

  // near mine count
  int count = 0;

  // constructor
  MineArea();

  @override
  toString() {
    return 'MineArea ::: rowPosition -> $rowPosition :: columnPosition -> $columnPosition :: isSelected -> $isSelected :: activeMine -> $activeMine :: count -> $count';
  }
}
