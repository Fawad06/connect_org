import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/message_model.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    Key? key,
    required this.message,
    required this.organizationImageUrl,
  }) : super(key: key);
  final Message message;
  final String organizationImageUrl;
  final cornerRadius = const Radius.circular(10);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!message.isMe) ...[
          CircleAvatar(
            radius: 12,
            backgroundImage: CachedNetworkImageProvider(organizationImageUrl),
          ),
          const SizedBox(width: 10),
        ],
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: cornerRadius,
              bottomRight: cornerRadius,
              topLeft: !message.isMe ? Radius.zero : cornerRadius,
              topRight: message.isMe ? Radius.zero : cornerRadius,
            ),
            color: Theme.of(context)
                .primaryColor
                .withOpacity(message.isMe ? 1 : 0.2),
          ),
          child: Text(
            message.text,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  fontSize: 16,
                  color: message.isMe
                      ? Colors.white
                      : Theme.of(context).textTheme.bodyText1?.color,
                ),
          ),
        ),
      ],
    );
  }
}
