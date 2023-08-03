import 'package:actual/common/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import '../model/rating_model.dart';

class RatingCard extends StatelessWidget {
  //계정 아바타이미지
  final ImageProvider avatarImage;

  //후기 첨부 이미지들
  final List<Image> images;

  //별점
  final int rating;

  //이메일
  final String email;

  //리뷰내용
  final String content;

  const RatingCard({
    super.key,
    required this.avatarImage,
    required this.images,
    required this.rating,
    required this.email,
    required this.content,
  });

  factory RatingCard.fromModel({
    required RatingModel model,
  }){
    return RatingCard(avatarImage: NetworkImage(model.user.imageUrl),
      images: model.imgUrls.map((e) => Image.network(e)).toList(),
      rating: model.rating,
      email: model.user.id,
      content: model.content,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Header(
          avatarImage: avatarImage,
          email: email,
          rating: rating,
        ),
        const SizedBox(
          height: 8.0,
        ),
        _Body(
          content: content,
        ),
        if (images.isNotEmpty)
          _Images(
            images: images,
          ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final ImageProvider avatarImage;
  final String email;
  final int rating;

  const _Header({
    super.key,
    required this.avatarImage,
    required this.email,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 12.0,
          backgroundImage: avatarImage,
        ),
        const SizedBox(
          width: 8.0,
        ),
        Expanded(
          child: Text(
            email,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ...List.generate(
          5,
              (index) =>
              Icon(
                index < rating ? Icons.star : Icons.star_border_outlined,
                color: PRIMARY_COLOR,
              ),
        ),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  final String content;

  const _Body({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text(
            content,
            style: TextStyle(
              color: BODY_TEXT_COLOR,
              fontSize: 14.0,
            ),
          ),
        ),
      ],
    );
  }
}

class _Images extends StatelessWidget {
  final List<Image> images;

  const _Images({
    super.key,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: SizedBox(
        height: 100,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: images
              .mapIndexed(
                (index, e) =>
                Padding(
                  padding: EdgeInsets.only(
                      right: index == images.length - 1 ? 0.0 : 16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: e,
                  ),
                ),
          )
              .toList(),
        ),
      ),
    );
  }
}
