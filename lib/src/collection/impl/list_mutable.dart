import "package:kt_dart/collection.dart";
import "package:kt_dart/src/collection/impl/iterator.dart";
import "package:kt_dart/src/util/hash.dart";

/// [KtList] based on a dart [List]
class DartMutableList<T> extends Object implements KtMutableList<T> {
  DartMutableList([Iterable<T> iterable = const []])
      :
        // copy list to prevent external modification
        _list = List.from(iterable),
        super();

  const DartMutableList.noCopy(List<T> list)
      : _list = list,
        super();

  final List<T> _list;

  @override
  Iterable<T> get iter => _list;

  @override
  List<T> get list => _list;

  @override
  List<T> asList() => _list;

  @override
  bool contains(T element) => _list.contains(element);

  @override
  bool containsAll(KtCollection<T> elements) {
    return elements.all(_list.contains);
  }

  @override
  T get(int index) {
    if (index < 0 || index >= size) {
      throw IndexOutOfBoundsException(
          "List doesn't contain element at index: $index, size: $size");
    }
    return _list[index];
  }

  @override
  T operator [](int index) => get(index);

  @override
  int indexOf(T element) => _list.indexOf(element);

  @override
  bool isEmpty() => _list.isEmpty;

  @override
  KtMutableIterator<T> iterator() => InterOpKtListIterator(_list, 0);

  @override
  int lastIndexOf(T element) => _list.lastIndexOf(element);

  @override
  KtMutableListIterator<T> listIterator([int index = 0]) {
    return InterOpKtListIterator(_list, index);
  }

  @override
  int get size => _list.length;

  @override
  bool add(T element) {
    _list.add(element);
    return true;
  }

  @override
  bool addAll(KtIterable<T> elements) {
    _list.addAll(elements.iter);
    return true;
  }

  @override
  bool addAllAt(int index, KtCollection<T> elements) {
    _list.insertAll(index, elements.iter);
    return true;
  }

  @override
  void addAt(int index, T element) {
    _list.insert(index, element);
  }

  @override
  void clear() => _list.clear();

  @override
  bool remove(T element) => _list.remove(element);

  @override
  T removeAt(int index) {
    if (index < 0 || index >= size) {
      throw IndexOutOfBoundsException("index: $index, size: $size");
    }
    return _list.removeAt(index);
  }

  @override
  T set(int index, T element) {
    final old = _list[index];
    _list[index] = element;
    return old;
  }

  @override
  void operator []=(int index, T element) => set(index, element);

  @override
  T removeFirst() {
    if (_list.isNotEmpty) {
      final firstElement = _list.first;
      _list.removeAt(0);
      return firstElement;
    }
    throw const NoSuchElementException('List is empty.');
  }

  @override
  T removeLast() {
    if (_list.isNotEmpty) {
      final lastElement = _list.last;
      _list.removeLast();
      return lastElement;
    }
    throw const NoSuchElementException('List is empty.');
  }

  @override
  bool removeAll(KtIterable<T> elements) {
    var changed = false;
    for (final value in elements.iter) {
      final removed = _list.remove(value);
      changed = changed || removed;
    }
    return changed;
  }

  @override
  bool retainAll(KtIterable<T> elements) {
    _list.removeWhere((it) => !elements.contains(it));
    return true;
  }

  @override
  KtMutableList<T> subList(int fromIndex, int toIndex) {
    assert(() {
      if (fromIndex > toIndex) {
        throw ArgumentError("fromIndex: $fromIndex > toIndex: $toIndex");
      }
      return true;
    }());
    if (fromIndex < 0 || toIndex > size) {
      throw IndexOutOfBoundsException(
          "fromIndex: $fromIndex, toIndex: $toIndex, size: $size");
    }
    return DartMutableList(_list.sublist(fromIndex, toIndex));
  }

  @override
  int get hashCode => 1 + hashObjects(_list);

  @override
  bool operator ==(dynamic other) {
    if (identical(other, this)) return true;
    if (other is! KtList) return false;
    if (other.size != size) return false;
    if (other.hashCode != hashCode) return false;
    for (var i = 0; i != size; ++i) {
      if (other[i] != this[i]) return false;
    }
    return true;
  }

  @override
  String toString() {
    return joinToString(
      separator: ", ",
      prefix: "[",
      postfix: "]",
      transform: (it) =>
          identical(it, this) ? "(this Collection)" : it.toString(),
    );
  }
}
