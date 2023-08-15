import 'package:actual/common/const/colors.dart';
import 'package:actual/common/layout/default_layout.dart';
import 'package:actual/common/utils/pagination_utils.dart';
import 'package:actual/product/component/product_card.dart';
import 'package:actual/product/model/product_model.dart';
import 'package:actual/restaurant/provider/restaurant_provider.dart';
import 'package:actual/restaurant/provider/restaurant_rating_provider.dart';
import 'package:actual/restaurant/repository/restaurant_repository.dart';
import 'package:actual/restaurant/component/restaurant_card.dart';
import 'package:actual/restaurant/view/basket_screen.dart';
import 'package:actual/user/provider/basket_provider.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletons/skeletons.dart';
import '../../common/model/cursor_pagination_model.dart';
import '../../rating/component/rating_card.dart';
import '../../rating/model/rating_model.dart';
import '../../user/model/basket_item_model.dart';
import '../model/restaurant_detail_model.dart';
import '../model/restaurant_model.dart';

class RestaurantDetailScreen extends ConsumerStatefulWidget {
  static String get routeName => 'restaurantDetail';

  final String id;

  const RestaurantDetailScreen({
    super.key,
    required this.id,
  });

  @override
  ConsumerState<RestaurantDetailScreen> createState() =>
      _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState
    extends ConsumerState<RestaurantDetailScreen> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.addListener(listner);
    ref.read(restaurantProvider.notifier).getDetail(id: widget.id);
  }

  @override
  void dispose() {
    super.dispose();
    controller.removeListener(listner);
    controller.dispose();
  }

  void listner() {
    PaginationUtils.paginate(
      controller: controller,
      provider: ref.read(restaurantRatingProvider(widget.id).notifier),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(restaurantDetailProvider(widget.id));
    final ratingsState = ref.watch(restaurantRatingProvider(widget.id));
    final basket = ref.watch(basketProvider);

    if (state == null) {
      return const DefaultLayout(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return DefaultLayout(
      floatingActtionButton: _FloatingActionButton(basket: basket,),
      title: state.name,
      child: CustomScrollView(
        controller: controller,
        slivers: [
          _renderTop(model: state),
          if (state is RestaurantDetailModel) _renderLabel(),
          if (state is RestaurantDetailModel)
            _renderProducts(products: state.products, restaurant: state),
          if (state is! RestaurantDetailModel) _renderLoading(),
          if (ratingsState is CursorPagination<RatingModel>)
            renderRatings(models: ratingsState.data),
        ],
      ),
    );
  }

  SliverPadding renderRatings({
    required List<RatingModel> models,
  }) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: RatingCard.fromModel(
              model: models[index],
            ),
          ),
          childCount: models.length,
        ),
      ),
    );
  }

  _renderTop({
    required RestaurantModel model,
  }) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          RestaurantCard.fromModel(
            model: model,
            isDetail: true,
          )
        ],
      ),
    );
  }

  _renderProducts({
    required List<RestaurantProductModel> products,
    required RestaurantModel restaurant,
  }) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final model = products[index];

            return InkWell(
              onTap: () {
                //누르면 장바구니에 추가(추가되면 basketProvider를 watch하고 있는 모든 위젯이 리빌드됨)
                ref.read(basketProvider.notifier).addToBasket(
                        product: ProductModel(
                      id: model.id,
                      name: model.name,
                      imgUrl: model.imgUrl,
                      detail: model.detail,
                      price: model.price,
                      restaurant: restaurant,
                    ));
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ProductCard.fromRestaurantProductModel(model: model),
              ),
            );
          },
          childCount: products.length,
        ),
      ),
    );
  }

  _renderLabel() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverToBoxAdapter(
        child: Text(
          '메뉴',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  _renderLoading() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          List.generate(
            3,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: SkeletonParagraph(
                style: SkeletonParagraphStyle(
                  lines: 5,
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FloatingActionButton extends StatelessWidget {
  final List<BasketItemModel> basket;

  const _FloatingActionButton({super.key, required this.basket});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        backgroundColor: PRIMARY_COLOR,
        onPressed: ()=>context.pushNamed(BasketScreen.routeName),
        child: Badge(
          badgeStyle: BadgeStyle(badgeColor: Colors.white),
          showBadge: basket.isNotEmpty,
          badgeContent: Text(
            style: TextStyle(
              color: PRIMARY_COLOR,
            ),
            basket
                .fold<int>(0, (previous, current) => previous + current.count)
                .toString(),
          ),
          child: Icon(Icons.shopping_basket_outlined),
        ));
  }
}
