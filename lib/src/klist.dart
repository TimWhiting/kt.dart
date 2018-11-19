import 'package:dart_kollection/dart_kollection.dart';
import 'package:dart_kollection/src/util/hash.dart';

part 'empty_list.dart';

KList<T> listOf<T>([Iterable<T> elements = const []]) {
  if (elements.length == 0) return emptyList();
  return _DartList(elements);
}

class _DartList<E> with KIterableExtensionsMixin<E> implements KList<E> {
  final List<E> _list;
  int _hashCode;

  _DartList([Iterable<E> iterable = const []])
      :
        // copy list to prevent external modification
        _list = List.from(iterable, growable: false),
        super();

  @override
  bool contains(E element) => _list.contains(element);

  @override
  bool containsAll(KCollection<E> elements) {
    return elements.any((it) => !_list.contains(it));
  }

  @override
  E get(int index) {
    if (index == null) throw ArgumentError("index can't be null");
    if (index < 0 || index >= size) {
      throw IndexOutOfBoundsException("index: $index, size: $size");
    }
    return _list[index];
  }

  E operator [](int index) => get(index);

  @override
  int indexOf(E element) => _list.indexOf(element);

  @override
  bool isEmpty() => _list.isEmpty;

  @override
  KIterator<E> iterator() => _DartListIterator(_list, 0);

  @override
  int lastIndexOf(E element) => _list.lastIndexOf(element);

  @override
  KListIterator<E> listIterator([int index = 0]) {
    if (index == null) throw ArgumentError("index can't be null");
    return _DartListListIterator(_list, index);
  }

  @override
  int get size => _list.length;

  @override
  KList<E> subList(int fromIndex, int toIndex) {
    if (fromIndex == null) throw ArgumentError("fromIndex can't be null");
    if (toIndex == null) throw ArgumentError("toIndex can't be null");
    if (fromIndex < 0 || toIndex > size) {
      throw IndexOutOfBoundsException("fromIndex: $fromIndex, toIndex: $toIndex, size: $size");
    }
    if (fromIndex > toIndex) {
      throw ArgumentError("fromIndex: $fromIndex > toIndex: $toIndex");
    }
    return _DartList(_list.sublist(fromIndex, toIndex));
  }

  @override
  int get hashCode {
    if (_hashCode == null) {
      _hashCode = hashObjects(_list);
    }
    return _hashCode;
  }

  @override
  bool operator ==(dynamic other) {
    if (identical(other, this)) return true;
    if (other is! KList) return false;
    if (other.size != size) return false;
    if (other.hashCode != hashCode) return false;
    for (var i = 0; i != size; ++i) {
      if (other[i] != this[i]) return false;
    }
    return true;
  }
}

class _DartListIterator<T> implements KIterator<T> {
  int cursor; // index of next element to return
  int lastRet = -1; // index of last element returned; -1 if no such
  List<T> list;

  _DartListIterator(this.list, int index) : this.cursor = index {
    if (index < 0 || index >= list.length) {
      throw IndexOutOfBoundsException("index: $index, size: $list.length");
    }
  }

  @override
  bool hasNext() {
    return cursor != list.length;
  }

  @override
  T next() {
    int i = cursor;
    if (i >= list.length) throw new NoSuchElementException();
    cursor = i + 1;
    return list[lastRet = i];
  }
}

class _DartListListIterator<T> extends _DartListIterator<T> implements KListIterator<T> {
  _DartListListIterator(List<T> list, int index) : super(list, index);

  @override
  bool hasPrevious() => cursor != 0;

  @override
  int nextIndex() => cursor;

  @override
  T previous() {
    int i = cursor - 1;
    if (i < 0) throw NoSuchElementException();
    cursor = i;
    return list[lastRet = i];
  }

  @override
  int previousIndex() => cursor - 1;
}

class IndexOutOfBoundsException implements Exception {
  final String message;

  IndexOutOfBoundsException(this.message);

  @override
  String toString() => 'IndexOutOfBoundsException: $message';
}

class NoSuchElementException implements Exception {}