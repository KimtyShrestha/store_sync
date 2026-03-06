import '../entities/daily_record_entity.dart';
import '../repositories/records_repository.dart';

class CreateOrUpdateTodayRecordUseCase {
  final RecordsRepository repository;

  CreateOrUpdateTodayRecordUseCase(this.repository);

  Future<void> call(DailyRecordEntity record) async {
    if (record.salesItems.isEmpty &&
        record.expenseItems.isEmpty &&
        record.purchaseItems.isEmpty) {
      throw Exception("At least one item must be added");
    }

    return await repository.createOrUpdateTodayRecord(record);
  }
}