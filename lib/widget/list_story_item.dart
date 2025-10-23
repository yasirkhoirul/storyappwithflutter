import 'package:flutter/material.dart';

class ListStoryItem extends  StatelessWidget{
  const ListStoryItem({super.key});

  @override
  Widget build(BuildContext context) {
    final font = Theme.of(context).textTheme;
    return Card(
      elevation: 20,
      margin: EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 400,
          maxHeight: 500
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 6,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    color: Colors.red,
                  ),
                ),
              ),
              SizedBox(height: 12,),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text("Judul",style: font.titleLarge!.copyWith(fontWeight: FontWeight.bold),textAlign: TextAlign.start,),
                  Text("deskripsi",style: font.bodyMedium,)
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
