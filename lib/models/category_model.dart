import 'package:flutter/material.dart';

class Category {
  final String name;
  final dynamic icon; // String (emoji) or IconData

  Category(this.name, this.icon);
}

final List<Category> categories = [
  Category('Trip', '✈️'),
  Category('Family', '👨‍👩‍👧‍👦'),
  Category('Couple', '💑'),
  Category('Event', Icons.event),
  Category('Project', Icons.work),
  Category('Other', Icons.more_horiz),
];