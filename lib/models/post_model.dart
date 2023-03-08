// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import '../core/enums/post_type_enum.dart';

@immutable
class Post {
  final String text;
  final List<String> hashtags;
  final String link;
  final List<String> imageLinks;
  final String uid;
  final PostType postType;
  final DateTime postedAt;
  final List<String> likes;
  final List<String> commentId;
  final String id;
  final int reshareCount;
  const Post({
    required this.text,
    required this.hashtags,
    required this.link,
    required this.imageLinks,
    required this.uid,
    required this.postType,
    required this.postedAt,
    required this.likes,
    required this.commentId,
    required this.id,
    required this.reshareCount,
  });

  Post copyWith({
    String? text,
    List<String>? hashtags,
    String? link,
    List<String>? imageLinks,
    String? uid,
    PostType? postType,
    DateTime? postedAt,
    List<String>? likes,
    List<String>? commentId,
    String? id,
    int? reshareCount,
  }) {
    return Post(
      text: text ?? this.text,
      hashtags: hashtags ?? this.hashtags,
      link: link ?? this.link,
      imageLinks: imageLinks ?? this.imageLinks,
      uid: uid ?? this.uid,
      postType: postType ?? this.postType,
      postedAt: postedAt ?? this.postedAt,
      likes: likes ?? this.likes,
      commentId: commentId ?? this.commentId,
      id: id ?? this.id,
      reshareCount: reshareCount ?? this.reshareCount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'hashtags': hashtags,
      'link': link,
      'imageLinks': imageLinks,
      'uid': uid,
      'postType': postType.type,
      'postedAt': postedAt.millisecondsSinceEpoch,
      'likes': likes,
      'commentId': commentId,
      'reshareCount': reshareCount,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      text: map['text'] as String,
      hashtags: List<String>.from((map['hashtags'] as List<String>)),
      link: map['link'] as String,
      imageLinks: List<String>.from((map['imageLinks'] as List<String>)),
      uid: map['uid'] as String,
      postType: (map['postType'] as String).toPostTypeEnum(),
      postedAt: DateTime.fromMillisecondsSinceEpoch(map['postedAt'] as int),
      likes: List<String>.from((map['likes'] as List<String>)),
      commentId: List<String>.from((map['commentId'] as List<String>)),
      id: map['\$id'] as String,
      reshareCount: map['reshareCount'] as int,
    );
  }

  @override
  String toString() {
    return 'Post(text: $text, hashtags: $hashtags, link: $link, imageLinks: $imageLinks, uid: $uid, postType: $postType, postedAt: $postedAt, likes: $likes, commentId: $commentId, id: $id, reshareCount: $reshareCount)';
  }

  @override
  bool operator ==(covariant Post other) {
    if (identical(this, other)) return true;

    return other.text == text &&
        listEquals(other.hashtags, hashtags) &&
        other.link == link &&
        listEquals(other.imageLinks, imageLinks) &&
        other.uid == uid &&
        other.postType == postType &&
        other.postedAt == postedAt &&
        listEquals(other.likes, likes) &&
        listEquals(other.commentId, commentId) &&
        other.id == id &&
        other.reshareCount == reshareCount;
  }

  @override
  int get hashCode {
    return text.hashCode ^
        hashtags.hashCode ^
        link.hashCode ^
        imageLinks.hashCode ^
        uid.hashCode ^
        postType.hashCode ^
        postedAt.hashCode ^
        likes.hashCode ^
        commentId.hashCode ^
        id.hashCode ^
        reshareCount.hashCode;
  }
}
