/// Small helper used across screens that look up a mock record by id.
extension FirstOrNullX<T> on Iterable<T> {
  T? get firstOrNull {
    final Iterator<T> it = iterator;
    return it.moveNext() ? it.current : null;
  }
}
