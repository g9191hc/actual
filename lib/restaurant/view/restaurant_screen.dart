import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:actual/restaurant/view/restaurant_card.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../common/const/data.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  Future<List> paginateRestaurant() async {
    final dio = Dio();

    //secureStorage에 저장된 accessToken 가져오기
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    final resp = await dio.get(
      'http://$ip/restaurant',
      options: Options(
        headers: {
          "authorization": 'Bearer $accessToken',
        },
      ),
    );

    return resp.data['data'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: FutureBuilder<List>(
            future: paginateRestaurant(),
            builder: (context, AsyncSnapshot<List> snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }

              final List lst = [];

              return ListView.separated(
                itemCount: 20,
                itemBuilder: (_, index) {
                  final item = snapshot.data![index];

                  final pItem = RestaurantModel(
                    id: item['id'],
                    name: item['name'],
                    thumbUrl: 'http://$ip${item['thumbUrl']}',
                    tags: List<String>.from(item['tags']),
                    priceRange: RestaurantPriceRange.values.firstWhere((e) => e.name==item['priceRange']),
                    ratings: item['ratings'],
                    ratingsCount: item['ratingsCount'],
                    deliveryTime: item['deliveryTime'],
                    deliveryFee: item['deliveryFee'],
                  );

                  return RestaurantCard(
                    image: Image.network(
                      pItem.thumbUrl,
                      fit: BoxFit.cover,
                    ),
                    name: pItem.name,
                    tags: pItem.tags,
                    ratingsCount: pItem.ratingsCount,
                    deliveryTime: pItem.deliveryFee,
                    deliveryFee: pItem.deliveryTime,
                    ratings: pItem.ratings,
                  );
                },
                separatorBuilder: (_, index) => const SizedBox(height: 16.0),
              );
            },
          ),
        ),
      ),
    );
  }
}
