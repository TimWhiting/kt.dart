import 'package:dart_kollection/dart_kollection.dart';
import 'package:test/test.dart';

import '../test/assert_dart.dart';

void main() {
  group("dropLast", () {
    test("drop last 3 items", () {
      final list = listOf([1, 2, 3, 4, 5, 6, 7]);
      expect(list.dropLast(3), listOf([1, 2, 3, 4]));
    });

    test("dropping from empty list drops nothing", () {
      expect(emptyList().dropLast(3), emptyList());
    });

    test("dropping more then list contains items results in empty list", () {
      final list = listOf([1, 2]);
      expect(list.dropLast(3), emptyList());
    });

    test("drop number can't be null", () {
      final e = catchException<ArgumentError>(() => listOf().dropLast(null));
      expect(e.message, allOf(contains("n "), contains("null")));
    });
  });

  group("dropLastWhile", () {
    test("drop last 3 items", () {
      final list = listOf([1, 2, 3, 4, 5, 6, 7]);
      expect(list.dropLastWhile((i) => i >= 4), listOf([1, 2, 3, 4]));
    });

    test("dropping from empty list drops nothing", () {
      expect(emptyList().dropLastWhile((_) => true), emptyList());
    });

    test("dropping nothing, keeps list as it is", () {
      final list = listOf([1, 2, 3, 4, 5]);
      expect(list.dropLastWhile((_) => false), listOf([1, 2, 3, 4, 5]));
    });

    test("dropping more then list contains items results in empty list", () {
      final list = listOf([1, 2]);
      expect(list.dropLastWhile((_) => true), emptyList());
    });

    test("drop number can't be null", () {
      final e =
          catchException<ArgumentError>(() => listOf().dropLastWhile(null));
      expect(e.message, allOf(contains("predicate"), contains("null")));
    });
  });

  group("first", () {
    test("get first element", () {
      expect(listOf(["a", "b"]).first(), "a");
    });

    test("first throws for no elements", () {
      expect(() => emptySet().first(),
          throwsA(TypeMatcher<NoSuchElementException>()));
      expect(() => listOf().first(),
          throwsA(TypeMatcher<NoSuchElementException>()));
    });

    test("finds nothing throws", () {
      expect(() => setOf<String>(["a"]).first((it) => it == "b"),
          throwsA(TypeMatcher<NoSuchElementException>()));
      expect(() => listOf(["a"]).first((it) => it == "b"),
          throwsA(TypeMatcher<NoSuchElementException>()));
    });
  });

  group("getOrElse", () {
    test("get item", () {
      final list = listOf(["a", "b", "c"]);
      final item = list.getOrElse(1, (_) => "asdf");
      expect(item, "b");
    });
    test("get else", () {
      final list = listOf(["a", "b", "c"]);
      final item = list.getOrElse(-1, (_) => "asdf");
      expect(item, "asdf");
    });
    test("else index is correct", () {
      final list = listOf(["a", "b", "c"]);
      final item = list.getOrElse(5, (i) => "index: 5");
      expect(item, "index: 5");
    });
    test("index can't be null", () {
      final e = catchException<ArgumentError>(
          () => listOf().getOrElse(null, (_) => "asdf"));
      expect(e.message, allOf(contains("null"), contains("index")));
    });
    test("defaultValue function can't be null", () {
      final e =
          catchException<ArgumentError>(() => listOf().getOrElse(1, null));
      expect(e.message, allOf(contains("null"), contains("defaultValue")));
    });
  });
  group("getOrNull", () {
    test("get item", () {
      final list = listOf(["a", "b", "c"]);
      final item = list.getOrNull(1);
      expect(item, "b");
    });
    test("get else", () {
      final list = listOf(["a", "b", "c"]);
      final item = list.getOrNull(-1);
      expect(item, isNull);
    });
    test("index can't be null", () {
      final e = catchException<ArgumentError>(() => listOf().getOrNull(null));
      expect(e.message, allOf(contains("null"), contains("index")));
    });
  });
}
