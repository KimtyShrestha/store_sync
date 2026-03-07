import 'package:flutter_test/flutter_test.dart';

class DashboardState {
  final bool isLoading;
  final String? error;

  DashboardState({this.isLoading = false, this.error});

  DashboardState copyWith({bool? isLoading, String? error}) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

void main() {

  test("initial state not loading", () {
    final state = DashboardState();
    expect(state.isLoading, false);
  });

  test("loading state works", () {
    final state = DashboardState();
    final updated = state.copyWith(isLoading: true);

    expect(updated.isLoading, true);
  });

  test("error state updates", () {
    final state = DashboardState();
    final updated = state.copyWith(error: "error");

    expect(updated.error, "error");
  });

  test("copyWith keeps previous values", () {
    final state = DashboardState(isLoading: true);
    final updated = state.copyWith();

    expect(updated.isLoading, true);
  });

  test("error overwritten", () {
    final state = DashboardState(error: "old");
    final updated = state.copyWith(error: "new");

    expect(updated.error, "new");
  });

  test("loading reset works", () {
    final state = DashboardState(isLoading: true);
    final updated = state.copyWith(isLoading: false);

    expect(updated.isLoading, false);
  });

  test("multiple updates work", () {
    final state = DashboardState();
    final updated = state.copyWith(isLoading: true, error: "fail");

    expect(updated.isLoading, true);
    expect(updated.error, "fail");
  });

  test("state remains immutable", () {
    final state = DashboardState();
    final _ = state.copyWith(isLoading: true);

    expect(state.isLoading, false);
  });

  test("error null by default", () {
    final state = DashboardState();
    expect(state.error, null);
  });

  test("copyWith handles null safely", () {
    final state = DashboardState();
    final updated = state.copyWith(error: null);

    expect(updated.error, null);
  });


  test("copyWith does not modify original state", () {
  final state = DashboardState(isLoading: false);
  final _ = state.copyWith(isLoading: true);

  expect(state.isLoading, false);
});

test("copyWith keeps error when loading changes", () {
  final state = DashboardState(error: "fail");
  final updated = state.copyWith(isLoading: true);

  expect(updated.error, "fail");
});

test("copyWith keeps loading when error changes", () {
  final state = DashboardState(isLoading: true);
  final updated = state.copyWith(error: "error");

  expect(updated.isLoading, true);
});

test("multiple copyWith operations work", () {
  final state = DashboardState();
  final updated = state.copyWith(isLoading: true).copyWith(error: "fail");

  expect(updated.error, "fail");
});

test("state equality behaves correctly", () {
  final state1 = DashboardState();
  final state2 = DashboardState();

  expect(state1.isLoading, state2.isLoading);
});

}