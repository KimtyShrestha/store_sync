import '../entities/daily_record_entity.dart';

abstract class RecordsRepository {
  /// Create or update today's daily record
  Future<void> createOrUpdateTodayRecord(
    DailyRecordEntity record,
  );

  /// Get today's record (if exists)
  Future<DailyRecordEntity?> getTodayRecord();
  Future<List<DailyRecordEntity>> getAllRecords();
}