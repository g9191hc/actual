import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cursor_pagination_model.g.dart';

//모든 상태의 기본
abstract class CursorPaginationBase {}

//에러
class CursorPaginationError extends CursorPaginationBase {
  final String errMessage;

  CursorPaginationError({
    required this.errMessage,
  });
}

//로딩중
class CursorPaginationLoading extends CursorPaginationBase {}

//데이터가 있는 상태의 기본(이 클래스를 직접 상속받으면, 데이터가 있느 상태로 가정)
@JsonSerializable(
  genericArgumentFactories: true,
)
class CursorPagination<T> extends CursorPaginationBase {
  final CursorPaginationMeta meta;
  final List<T> data;

  CursorPagination({
    required this.meta,
    required this.data,
  });

  factory CursorPagination.fromJson(
      Map<String, dynamic> json, T Function(Object? json) fromJsonT) {
    return _$CursorPaginationFromJson(json, fromJsonT);
  }

  CursorPagination<T> copyWith({
    CursorPaginationMeta? meta,
    List<T>? data,
  }) {
    return CursorPagination(
      meta: meta ?? this.meta,
      data: data ?? this.data,
    );
  }
}

@JsonSerializable()
class CursorPaginationMeta {
  final int count;
  final bool hasMore;

  CursorPaginationMeta({
    required this.count,
    required this.hasMore,
  });

  factory CursorPaginationMeta.fromJson(Map<String, dynamic> json) {
    return _$CursorPaginationMetaFromJson(json);
  }

  CursorPaginationMeta copyWith({
    int? count,
    bool? hasMore,
  }) {
    return CursorPaginationMeta(
      count: count ?? this.count,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

//새로고침(맨 위에서 아래로 당김)
class CursorPaginationRefetching<T> extends CursorPagination<T> {
  CursorPaginationRefetching({
    required super.meta,
    required super.data,
  });
}

//리스트 더 가져오는 중(맨 아래에서 추가 요청하는 중(Loading))
class CursorPaginationFetchingMore<T> extends CursorPagination<T> {
  CursorPaginationFetchingMore({
    required super.meta,
    required super.data,
  });
}
