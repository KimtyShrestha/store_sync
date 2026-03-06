import '../entities/daily_record_entity.dart';
import '../repositories/records_repository.dart';

class GetTodayRecordUseCase {
  final RecordsRepository repository;

  GetTodayRecordUseCase(this.repository);

  Future<DailyRecordEntity?> call() async {
    return await repository.getTodayRecord();
  }
}