import 'package:flutter/material.dart';
import 'package:story_app/data/model/modelstory.dart';
import 'package:transparent_image/transparent_image.dart';

class ListStoryItem extends StatelessWidget {
  final Function(String id) onitemtap;
  final DetailStory data;
  const ListStoryItem({super.key, required this.data, required this.onitemtap});

  @override
  Widget build(BuildContext context) {
    final font = Theme.of(context).textTheme;
    return InkWell(
      onTap: () {
        onitemtap(data.id);
      },
      child: Card(
        elevation: 20,
        margin: EdgeInsets.all(20),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 400, maxHeight: 500),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 6,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: FadeInImage.memoryNetwork(
                      imageErrorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.error),
                      placeholder: kTransparentImage,
                      image: data.photoUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Flexible(
                        child: Text(
                          data.name,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          style: font.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          data.description,
                          style: font.bodyMedium,
                          maxLines: 3,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
