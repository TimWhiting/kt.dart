import 'package:dart_kollection/dart_kollection.dart';
import 'package:dart_kollection/src/k_iterable.dart';

abstract class KIterableExtensionsMixin<T> implements KIterableExtension<T>, KIterable<T> {
  @override
  bool any([bool Function(T element) predicate = null]) {
    if (predicate == null) {
      if (this is KCollection) return !(this as KCollection).isEmpty();
      return iterator().hasNext();
    }
    if (this is KCollection && (this as KCollection).isEmpty()) return false;
    for (var element in iter) {
      if (predicate(element)) return true;
    }
    return false;
  }

  @override
  bool all([bool Function(T element) predicate]) {
    if (this is KCollection && (this as KCollection).isEmpty()) return true;
    for (var element in iter) {
      if (!predicate(element)) {
        return false;
      }
    }
    return true;
  }

  @override
  KIterable<T> asIterable() => this;

  @override
  KMap<K, V> associate<K, V>(KPair<K, V> Function(T) transform) {
    return associateTo(linkedMapOf<K, V>(), transform);
  }

  @override
  KMap<K, V> associateBy<K, V>(K Function(T) keySelector, [V Function(T) valueTransform]) {
    return associateByTo(linkedMapOf<K, V>(), keySelector, valueTransform);
  }

  @override
  M associateByTo<K, V, M extends KMutableMap<K, V>>(M destination, K Function(T) keySelector,
      [V Function(T) valueTransform]) {
    for (var element in iter) {
      var key = keySelector(element);
      var value = valueTransform == null ? element : valueTransform(element);
      destination.put(key, value);
    }
    return destination;
  }

  @override
  M associateTo<K, V, M extends KMutableMap<K, V>>(M destination, KPair<K, V> Function(T) transform) {
    for (var element in iter) {
      var pair = transform(element);
      destination.put(pair.first, pair.second);
    }
    return destination;
  }

  @override
  KMap<T, V> associateWith<V>(V Function(T) valueSelector) {
    return associateWithTo(linkedMapOf<T, V>(), valueSelector);
  }

  @override
  M associateWithTo<V, M extends KMutableMap<T, V>>(M destination, V Function(T) valueSelector) {
    for (var element in iter) {
      destination.put(element, valueSelector(element));
    }
    return destination;
  }

  @override
  bool contains(T element) {
    if (this is KCollection) return (this as KCollection).contains(element);
    return indexOf(element) >= 0;
  }

  @override
  T elementAt(int index) {
    if (this is KList) {
      return (this as KList).get(index);
    }
    return elementAtOrElse(index, (int index) {
      throw IndexOutOfBoundsException("Collection doesn't contain element at index $index.");
    });
  }

  @override
  T elementAtOrElse(int index, T Function(int) defaultValue) {
    if (this is KList) {
      return (this as KList).getOrElse(index, defaultValue);
    }
    if (index < 0) {
      return defaultValue(index);
    }
    final i = iterator();
    int count = 0;
    while (i.hasNext()) {
      final element = i.next();
      if (index == count++) {
        return element;
      }
    }
    return defaultValue(index);
  }

  @override
  T elementAtOrNull(int index) {
    if (this is KList) {
      return (this as KList).getOrNull(index);
    }
    if (index < 0) {
      return null;
    }
    final i = iterator();
    int count = 0;
    while (i.hasNext()) {
      final element = i.next();
      if (index == count++) {
        return element;
      }
    }
    return null;
  }

  @override
  T find(bool Function(T) predicate) => firstOrNull(predicate);

  @override
  T findLast(bool Function(T) predicate) => lastOrNull(predicate);

  @override
  T first([bool Function(T) predicate]) {
    if (predicate == null) {
      if (this is KList) return (this as KList).first();
      final i = iterator();
      if (!i.hasNext()) {
        throw NoSuchElementException("Collection is empty");
      }
      return i.next();
    } else {
      for (var element in iter) {
        if (predicate(element)) return element;
      }
      throw NoSuchElementException("Collection contains no element matching the predicate.");
    }
  }

  @override
  T firstOrNull([bool Function(T) predicate]) {
    if (predicate == null) {
      if (this is KList) {
        var list = (this as KList);
        if (list.isEmpty()) {
          return null;
        } else {
          return list[0];
        }
      }
      final i = iterator();
      if (!i.hasNext()) {
        throw NoSuchElementException("Collection is empty");
      }
      return i.next();
    } else {
      for (var element in iter) {
        if (predicate(element)) return element;
      }
      return null;
    }
  }

  @override
  KList<R> flatMap<R>(KIterable<R> Function(T) transform) {
    final list = flatMapTo(mutableListOf<R>(), transform);
    // making a temp variable here, it helps dart to get types right ¯\_(ツ)_/¯
    // TODO ping dort-lang/sdk team to check that bug
    return list;
  }

  @override
  C flatMapTo<R, C extends KMutableCollection<R>>(C destination, KIterable<R> Function(T) transform) {
    for (var element in iter) {
      final list = transform(element);
      destination.addAll(list);
    }
    return destination;
  }

  @override
  void forEach(void action(T element)) {
    var i = iterator();
    while (i.hasNext()) {
      var element = i.next();
      action(element);
    }
  }

  @override
  int indexOf(T element) {
    if (this is KList) return (this as KList).indexOf(element);
    var index = 0;
    for (var item in iter) {
      if (element == item) return index;
      index++;
    }
    return -1;
  }

  @override
  int indexOfFirst([bool Function(T) predicate]) {
    var index = 0;
    for (var item in iter) {
      if (predicate(item)) {
        return index;
      }
      index++;
    }
    return -1;
  }

  int indexOfLast([bool Function(T) predicate]) {
    var lastIndex = -1;
    var index = 0;
    for (var item in iter) {
      if (predicate(item)) {
        lastIndex = index;
      }
      index++;
    }
    return lastIndex;
  }

  @override
  T lastOrNull([bool Function(T) predicate]) {
    if (predicate == null) {
      if (this is KList) {
        var list = (this as KList);
        return list.isEmpty() ? null : list.get(0);
      } else {
        final i = iterator();
        if (!i.hasNext()) {
          return null;
        }
        var last = i.next();
        while (i.hasNext()) {
          last = i.next();
        }
        return last;
      }
    } else {
      T last = null;
      for (var element in iter) {
        if (predicate(element)) {
          last = element;
        }
      }
      return last;
    }
  }

  @override
  KIterable<R> map<R>(R Function(T) transform) {
    final KMutableList<R> list = mutableListOf<R>();
    return mapTo(list, transform);
  }

  @override
  C mapTo<R, C extends KMutableCollection<R>>(C destination, R Function(T) transform) {
    for (var item in iter) {
      destination.add(transform(item));
    }
    return destination;
  }

  @override
  String joinToString(
      {String separator = ", ",
      String prefix = "",
      String postfix = "",
      int limit = -1,
      String truncated = "...",
      String Function(T) transform}) {
    var buffer = StringBuffer();
    buffer.write(prefix);
    var count = 0;
    for (var element in iter) {
      if (++count > 1) buffer.write(separator);
      if (limit >= 0 && count > limit) {
        break;
      } else {
        if (transform == null) {
          buffer.write(element);
        } else {
          buffer.write(transform(element));
        }
      }
    }
    if (limit >= 0 && count > limit) {
      buffer.write(truncated);
    }
    buffer.write(postfix);
    return buffer.toString();
  }
}