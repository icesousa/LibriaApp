import 'package:flutter/material.dart';

import '../models/livro.dart';

Widget customImageContainer(
    String? image,
    String titulo,
    String autor,
    BuildContext context,
    Livro livro,
    double width,
    double height,
    void Function()? onTap) {
  return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0, 2),
              blurRadius: 3,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              flex: 5,
              fit: FlexFit.loose,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                  image: image != null && Uri.parse(image).isAbsolute
                      ? DecorationImage(
                          image: NetworkImage(image),
                          fit: BoxFit.cover,
                        )
                      : DecorationImage(
                          image: AssetImage('imagens/notfound.png'),
                          fit: BoxFit.cover),
                ),
              ),
            ),
            Flexible(
              flex: 3,
              fit: FlexFit.loose,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      titulo,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                    Spacer(),
                    Text(
                      'by ${autor}',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ));
}
