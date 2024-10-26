import 'package:flutter/material.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key, required this.selectedListId});

  final String selectedListId;

  @override
  Widget build(BuildContext context) {
    return Text("List: $selectedListId");
  }
}

