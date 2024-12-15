import 'package:flutter/material.dart';

class TypeCard extends StatelessWidget {
  final String type;

  const TypeCard({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        splashColor: Colors.red[50],
        onTap: () => {
          Navigator.pushNamed(context, '/jokes', arguments: type)
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            type,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
