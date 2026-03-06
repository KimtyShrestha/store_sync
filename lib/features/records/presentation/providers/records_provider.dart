import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/records_repository_impl.dart';
import '../../domain/entities/daily_record_entity.dart';
import '../../domain/usecases/create_or_update_today_record_usecase.dart';
import '../../domain/usecases/get_today_record_usecase.dart';
import '../../domain/usecases/get_all_records_usecase.dart';

// =============================
// STATE
// =============================
class RecordsState {
  final bool isLoading;
  final DailyRecordEntity? record;
  final List<DailyRecordEntity> allRecords;
  final String? error;
  final bool isSuccess;
  final bool hasUnsavedChanges;

  const RecordsState({
    this.isLoading = false,
    this.record,
    this.allRecords = const [],
    this.error,
    this.isSuccess = false,
    this.hasUnsavedChanges = false,
  });

  RecordsState copyWith({
    bool? isLoading,
    DailyRecordEntity? record,
    List<DailyRecordEntity>? allRecords,
    String? error,
    bool? isSuccess,
    bool? hasUnsavedChanges,
  }) {
    return RecordsState(
      isLoading: isLoading ?? this.isLoading,
      record: record ?? this.record,
      allRecords: allRecords ?? this.allRecords,
      error: error,
      isSuccess: isSuccess ?? this.isSuccess,
      hasUnsavedChanges:
          hasUnsavedChanges ?? this.hasUnsavedChanges,
    );
  }
}

// =============================
// NOTIFIER
// =============================
class RecordsNotifier extends StateNotifier<RecordsState> {
  final CreateOrUpdateTodayRecordUseCase createUseCase;
  final GetTodayRecordUseCase getUseCase;
  final GetAllRecordsUseCase getAllUseCase;

  RecordsNotifier(
    this.createUseCase,
    this.getUseCase,
    this.getAllUseCase,
  ) : super(const RecordsState());

  // =============================
  // LOAD TODAY RECORD
  // =============================
  Future<void> loadTodayRecord() async {
    state = state.copyWith(
      isLoading: true,
      error: null,
    );

    try {
      final record = await getUseCase();

      state = state.copyWith(
        record: record,
        isLoading: false,
        hasUnsavedChanges: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  // =============================
  // LOAD ALL RECORDS (HISTORY)
  // =============================
  Future<void> loadAllRecords() async {
    state = state.copyWith(
      isLoading: true,
      error: null,
    );

    try {
      final records = await getAllUseCase();

      state = state.copyWith(
        allRecords: records,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  // =============================
  // MARK UNSAVED CHANGES
  // =============================
  void markUnsavedChanges() {
    state = state.copyWith(hasUnsavedChanges: true);
  }

  // =============================
  // SUBMIT RECORD
  // =============================
  Future<void> submitRecord(DailyRecordEntity record) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      isSuccess: false,
    );

    try {
      await createUseCase(record);

      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
        hasUnsavedChanges: false,
      );

      await loadTodayRecord();

    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        isSuccess: false,
      );
    }
  }

  // =============================
  // RESET SUCCESS (Prevents repeated snackbar)
  // =============================
  void resetSuccess() {
    state = state.copyWith(isSuccess: false);
  }
}

// =============================
// PROVIDER
// =============================
final recordsProvider =
    StateNotifierProvider<RecordsNotifier, RecordsState>((ref) {

  final repository = RecordsRepositoryImpl();

  return RecordsNotifier(
    CreateOrUpdateTodayRecordUseCase(repository),
    GetTodayRecordUseCase(repository),
    GetAllRecordsUseCase(repository),
  );
});