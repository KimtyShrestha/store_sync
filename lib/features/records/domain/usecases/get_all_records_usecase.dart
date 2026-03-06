import 'package:store_sync/features/records/domain/entities/daily_record_entity.dart';
import 'package:store_sync/features/records/domain/repositories/records_repository.dart';

class GetAllRecordsUseCase {
  final RecordsRepository repository;

  GetAllRecordsUseCase(this.repository);

  Future<List<DailyRecordEntity>> call() {
    return repository.getAllRecords();
  }
}