import 'package:equatable/equatable.dart';

class PaginatedResponse<T> extends Equatable {
  final Iterable<T> data;
  final int total;
  final int skip;
  final int limit;

  const PaginatedResponse({
    required this.data,
    required this.total,
    required this.skip,
    required this.limit,
  });

  @override
  List<Object?> get props => [data, total, skip, limit];
}
