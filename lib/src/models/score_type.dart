//enum ScoreType {
//  ones,
//  twos,
//  threes,
//  fours,
//  fives,
//  sixes,
//  threeOfAKind,
//  fourOfAKind,
//  fullHouse,
//  fiveOfAKind,
//  smallStraight,
//  largeStraight,
//  chance,
//}

import 'dice.dart';

class ScoreType {
  static final ones = ScoreType(
    score: (dices) => _sumOfDicesWhere(dices, Dice.one),
  );
  static final twos = ScoreType(
    score: (dices) => _sumOfDicesWhere(dices, Dice.two),
  );
  static final threes = ScoreType(
    score: (dices) => _sumOfDicesWhere(dices, Dice.three),
  );
  static final fours = ScoreType(
    score: (dices) => _sumOfDicesWhere(dices, Dice.four),
  );
  static final fives = ScoreType(
    score: (dices) => _sumOfDicesWhere(dices, Dice.five),
  );
  static final sixes = ScoreType(
    score: (dices) => _sumOfDicesWhere(dices, Dice.six),
  );
  static final threeOfAKind = ScoreType(
    score: (dices) => _checkForDiceGroup(dices, 3) ? _sumOf(dices) : 0,
  );
  static final fourOfAKind = ScoreType(
    score: (dices) => _checkForDiceGroup(dices, 4) ? _sumOf(dices) : 0,
  );
  static final fullHouse = ScoreType(
    score: (dices) => _checkForFullHouse(dices) ? 25 : 0,
  );
  static final smallStraight = ScoreType(
    score: (dices) => _checkForSmallStraights(dices) ? 30 : 0,
  );
  static final largeStraight = ScoreType(
    score: (dices) => _checkForLargeStraights(dices) ? 40 : 0,
  );
  static final fiveOfAKind = ScoreType(
    score: (dices) => _checkForDiceGroup(dices, 5) ? 50 : 0,
  );
  static final chance = ScoreType(
    score: (dices) => _sumOf(dices),
  );

  final int Function(List<Dice> dices) score;

  ScoreType({this.score});

  static int _sumOfDicesWhere(List<Dice> dices, Dice dice) {
    return dices.where((d) => d == dice).length * dice.value;
  }

  // For three-of-a-kind and above
  static bool _checkForDiceGroup(List<Dice> dices, int count) {
    final group = _groupDiceByValue(dices);
    return group.values.any((c) => c >= count);
  }

  // Because full houses require three of a number and two of the other.
  static bool _checkForFullHouse(List<Dice> dices) {
    final group = _groupDiceByValue(dices);
    return group.values.any((c) => c == 2) && group.values.any((c) => c == 3);
  }

  static final _smallStraightPattern = [
    Dice.from([1, 2, 3, 4]),
    Dice.from([2, 3, 4, 5]),
    Dice.from([3, 4, 5, 6]),
  ];

  static bool _checkForSmallStraights(List<Dice> dices) {
    final sorted = Set<Dice>.of(dices..sort((a, b) => a.value - b.value));
    for (var pattern in _smallStraightPattern) {
      if (sorted.containsAll(pattern)) return true;
    }
    return false;
  }

  static final _largeStraightPattern = [
    Dice.from([1, 2, 3, 4, 5]),
    Dice.from([2, 3, 4, 5, 6]),
  ];

  static bool _checkForLargeStraights(List<Dice> dices) {
    final sorted = Set<Dice>.of(dices..sort((a, b) => a.value - b.value));
    for (var pattern in _largeStraightPattern) {
      if (sorted.containsAll(pattern)) return true;
    }
    return false;
  }

  static Map<Dice, int> _groupDiceByValue(List<Dice> dices) {
    return {
      for (var dice in Dice.values) dice: dices.where((d) => d == dice).length,
    };
  }

  static int _sumOf(List<Dice> dices) {
    return dices.fold(0, (sum, d) => sum + d.value);
  }
}

final upperBoundScores = [
  ScoreType.ones,
  ScoreType.twos,
  ScoreType.threes,
  ScoreType.fours,
  ScoreType.fives,
  ScoreType.sixes,
];

final lowerBoundScores = [
  ScoreType.threeOfAKind,
  ScoreType.fourOfAKind,
  ScoreType.fullHouse,
  ScoreType.smallStraight,
  ScoreType.largeStraight,
  ScoreType.fiveOfAKind,
  ScoreType.chance,
];
