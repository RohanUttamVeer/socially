enum NotificationType {
  like('like'),
  reply('reply'),
  follow('follow'),
  repost('repost');

  final String type;
  const NotificationType(this.type);
}

extension ConvertPost on String {
  NotificationType toNotificationTypeEnum() {
    switch (this) {
      case 'like':
        return NotificationType.like;
      case 'reply':
        return NotificationType.reply;
      case 'follow':
        return NotificationType.follow;
      case 'repost':
        return NotificationType.repost;
      default:
        return NotificationType.like;
    }
  }
}
