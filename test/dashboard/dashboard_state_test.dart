import 'package:flutter_test/flutter_test.dart';
import 'package:store_sync/features/dashboard/presentation/providers/dashboard_provider.dart';

void main() {

  test("initial state has empty history", () {
    const state = DashboardState();

    expect(state.history.length, 0);
  });

  test("loading state works", () {
    const state = DashboardState();

    final updated = state.copyWith(isLoading: true);

    expect(updated.isLoading, true);
  });

  test("error state updates", () {
    const state = DashboardState();

    final updated = state.copyWith(error: "error");

    expect(updated.error, "error");
  });

  test("history copy works", () {
    const state = DashboardState();

    final updated = state.copyWith(history: [1,2,3]);

    expect(updated.history.length, 3);
  });

}