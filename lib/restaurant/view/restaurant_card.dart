import 'package:actual/common/const/colors.dart';
import 'package:actual/restaurant/model/restaurant_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../model/restaurant_model.dart';

class RestaurantCard extends StatelessWidget {
  //이미지
  final Widget image;

  //레스토랑 이름
  final String name;

  //태그들
  final List<String> tags;

  //평점 갯수
  final int ratingsCount;

  //배송소요시간
  final int deliveryTime;

  //배송비용
  final int deliveryFee;

  //평균평점
  final double ratings;

  //상세카드 여부
  final bool isDetail;

  //상세 내용
  final String? detail;

  //HeroKey
  final String? heroKey;

  const RestaurantCard({
    super.key,
    required this.image,
    required this.name,
    required this.tags,
    required this.ratingsCount,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.ratings,
    this.isDetail = false,
    this.detail,
    this.heroKey,
  });

  factory RestaurantCard.fromModel({
    required RestaurantModel model,
    bool isDetail = false,
  }) {
    return RestaurantCard(
      image: Image.network(
        model.thumbUrl,
        fit: BoxFit.cover,
      ),
      heroKey: model.id,
      name: model.name,
      tags: model.tags,
      ratingsCount: model.ratingsCount,
      deliveryTime: model.deliveryFee,
      deliveryFee: model.deliveryTime,
      ratings: model.ratings,
      isDetail: isDetail,
      detail: model is RestaurantDetailModel ? model.detail : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (heroKey != null)
          Hero(
            tag: ObjectKey(heroKey),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(isDetail ? 0.0 : 16.0),
              child: image,
            ),
          ),
        if (heroKey == null)
          ClipRRect(
            borderRadius: BorderRadius.circular(isDetail ? 0.0 : 16.0),
            child: image,
          ),
        const SizedBox(height: 16.0),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isDetail ? 16.0 : 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                tags.join(' · '),
                style: TextStyle(
                  color: BODY_TEXT_COLOR,
                  fontSize: 14.0,
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  _IconText(icon: Icons.star, label: ratings.toString()),
                  renderDot(),
                  _IconText(
                      icon: Icons.receipt, label: ratingsCount.toString()),
                  renderDot(),
                  _IconText(
                      icon: Icons.timelapse_outlined, label: '$deliveryTime분'),
                  renderDot(),
                  _IconText(
                      icon: Icons.monetization_on,
                      label: deliveryFee == 0 ? '무료' : deliveryFee.toString()),
                ],
              ),
              if (detail != null && isDetail)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(detail!),
                ),
            ],
          ),
        )
      ],
    );
  }

  Widget renderDot() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        '·',
        style: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _IconText extends StatelessWidget {
  final IconData icon;
  final String label;

  const _IconText({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: PRIMARY_COLOR,
          size: 14.0,
        ),
        const SizedBox(
          width: 8.0,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.0,
          ),
        ),
      ],
    );
  }
}
