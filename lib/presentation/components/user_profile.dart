import 'dart:io';

import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key, this.avatarUrl, this.name, this.subtitle});

  final String? avatarUrl;
  final String? name;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Row(
      children: [
        CircleAvatar(
          maxRadius: 18,
          backgroundImage:
              avatarUrl != null ? FileImage(File(avatarUrl!)) : null,
          backgroundColor: theme.canvasColor,
          child: avatarUrl == null
              ? Icon(
                  Icons.person,
                  size: 18,
                )
              : null,
        ),
        if (name != null || subtitle != null)
          SizedBox(
            width: 8,
          ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (name != null) Text(name!, style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),),
            if (subtitle != null) Text(subtitle!, style: theme.textTheme.labelSmall?.copyWith(
                fontStyle: FontStyle.italic
            ),)
          ],
        )
      ],
    );
  }
}
