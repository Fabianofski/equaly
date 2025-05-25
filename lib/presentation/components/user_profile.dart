import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserProfile extends StatelessWidget {
  const UserProfile(
      {super.key,
      this.avatarUrl,
      this.name,
      this.subtitle,
      this.checked = false});

  final String? avatarUrl;
  final String? name;
  final String? subtitle;
  final bool checked;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            CircleAvatar(
              maxRadius: 18,
              backgroundImage: avatarUrl!.startsWith("file") ? FileImage(File(avatarUrl!)) : NetworkImage(avatarUrl!),
              backgroundColor: theme.canvasColor,
              child: avatarUrl == null
                  ? Icon(
                      Icons.person,
                      size: 18,
                    )
                  : null,
            ),
            if (checked)
              CircleAvatar(
                maxRadius: 18,
                backgroundColor: Color(0x88FFFFFF),
                child: Center(
                  child: Icon(FontAwesomeIcons.check, color: Colors.black,),
                ),
              ),
          ],
        ),
        if (name != null || subtitle != null)
          SizedBox(
            width: 8,
          ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (name != null)
              Text(
                name!,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            if (subtitle != null)
              Text(
                subtitle!,
                style: theme.textTheme.labelSmall
                    ?.copyWith(fontStyle: FontStyle.italic),
              )
          ],
        )
      ],
    );
  }
}
