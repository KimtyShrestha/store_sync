import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/entities/branch_info_entity.dart';


// =============================
// STATE
// =============================
class DashboardState {
  final bool isLoading;
  final BranchInfoEntity? branchInfo;
  final List<dynamic> history;
  final String? error;

  const DashboardState({
    this.isLoading = false,
    this.branchInfo,
    this.history = const [],
    this.error,
  });

  DashboardState copyWith({
    bool? isLoading,
    BranchInfoEntity? branchInfo,
    List<dynamic>? history,
    String? error,
  }) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      branchInfo: branchInfo ?? this.branchInfo,
      history: history ?? this.history,
      error: error,
    );
  }
}


// =============================
// NOTIFIER
// =============================
class DashboardNotifier extends StateNotifier<DashboardState> {

  final DashboardRepositoryImpl repository;

  DashboardNotifier(this.repository)
      : super(const DashboardState());

  // -----------------------------
  // Load Branch Info
  // -----------------------------
  Future<void> loadBranchInfo() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final info = await repository.getMyBranchInfo();

      state = state.copyWith(
        branchInfo: info,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // -----------------------------
  // Load History
  // -----------------------------
  Future<void> loadHistory() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final history = await repository.getHistory();

      state = state.copyWith(
        history: history,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }
}


// =============================
// PROVIDER
// =============================
final dashboardProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  return DashboardNotifier(DashboardRepositoryImpl());
});