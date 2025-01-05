import 'package:flutter/material.dart';
import 'package:new_flutter_project/widgets/type/type_card.dart';

class TypeList extends StatelessWidget {
  final List<String> types;

  const TypeList({super.key, required this.types});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: types.length,
      itemBuilder: (context, index) {
        final type = types[index];
        return TypeCard(
          type: type
        );
      },
    );
  }
}
