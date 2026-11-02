/// Rotates the seating order without changing or shuffling the saved list.
List<T> chameleonPlayerOrder<T>(List<T> players, {required int startIndex}) {
  if (players.isEmpty) return [];
  RangeError.checkValidIndex(startIndex, players, 'startIndex');
  return [...players.skip(startIndex), ...players.take(startIndex)];
}
