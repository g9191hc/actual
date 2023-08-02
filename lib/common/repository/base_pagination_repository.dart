import '../model/cursor_pagination_model.dart';
import '../model/pagination_params.dart';


//인터페이스는 abstract로 생성
//타입을 외부로 부터 받기 위해서 제네릭 사용
abstract class IBasePaginationRepository<T>{
  Future<CursorPagination<T>> paginate({
    PaginationParams? paginationParams = const PaginationParams(),
  });
}