import 'package:flutter/material.dart';

class AlphabetIndex extends StatelessWidget {
  const AlphabetIndex({
    super.key,
  });

  @override
  Widget build(final BuildContext context) {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

    return Positioned(
      right: 6,
      top: 0,
      bottom: 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: letters
            .split('')
            .map((final letter) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    letter,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.white38,
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
