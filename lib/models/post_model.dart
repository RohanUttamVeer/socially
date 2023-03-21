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
  final String rePostedBy;
  final String repliedTo;
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
    required this.rePostedBy,
    required this.repliedTo,
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
    String? rePostedBy,
    String? repliedTo,
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
      rePostedBy: rePostedBy ?? this.rePostedBy,
      repliedTo: repliedTo ?? this.repliedTo,
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
      'rePostedBy': rePostedBy,
      'repliedTo': repliedTo,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      text: map['text'] as String,
      hashtags: List<String>.from((map['hashtags'])),
      link: map['link'] as String,
      imageLinks: List<String>.from((map['imageLinks'])),
      uid: map['uid'] as String,
      postType: (map['postType'] as String).toPostTypeEnum(),
      postedAt: DateTime.fromMillisecondsSinceEpoch(map['postedAt'] as int),
      likes: List<String>.from((map['likes'])),
      commentId: List<String>.from((map['commentId'])),
      id: map['\$id'] as String,
      reshareCount: map['reshareCount'] as int,
      rePostedBy: map['rePostedBy'] as String,
      repliedTo: map['repliedTo'] as String,
    );
  }

  @override
  String toString() {
    return 'Post(text: $text, hashtags: $hashtags, link: $link, imageLinks: $imageLinks, uid: $uid, postType: $postType, postedAt: $postedAt, likes: $likes, commentId: $commentId, id: $id, reshareCount: $reshareCount, rePostedBy: $rePostedBy, repliedTo: $repliedTo)';
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
        other.reshareCount == reshareCount &&
        other.rePostedBy == rePostedBy &&
        other.repliedTo == repliedTo;
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
        reshareCount.hashCode ^
        rePostedBy.hashCode ^
        repliedTo.hashCode;
  }
}
