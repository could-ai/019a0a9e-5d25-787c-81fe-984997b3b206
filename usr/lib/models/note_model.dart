import 'dart:convert';
import 'package:flutter/material.dart';

class Note {
  final int? id;
  final String title;
  final String content; // JSON string for Quill Delta
  final String? category;
  final List<String>? tags;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isEncrypted;

  Note({
    this.id,
    required this.title,
    required this.content,
    this.category,
    this.tags,
    required this.createdAt,
    required this.updatedAt,
    this.isEncrypted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category,
      'tags': tags != null ? jsonEncode(tags) : null,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_encrypted': isEncrypted ? 1 : 0,
    };
  }

  static Note fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      category: map['category'],
      tags: map['tags'] != null ? List<String>.from(jsonDecode(map['tags'])) : null,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      isEncrypted: map['is_encrypted'] == 1,
    );
  }
}

class Category {
  final int? id;
  final String name;
  final Color color;

  Category({this.id, required this.name, required this.color});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'color': color.value,
    };
  }

  static Category fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      color: Color(map['color']),
    );
  }
}

class Reminder {
  final int? id;
  final String title;
  final String? description;
  final DateTime dateTime;
  final bool isActive;

  Reminder({
    this.id,
    required this.title,
    this.description,
    required this.dateTime,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date_time': dateTime.toIso8601String(),
      'is_active': isActive ? 1 : 0,
    };
  }

  static Reminder fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dateTime: DateTime.parse(map['date_time']),
      isActive: map['is_active'] == 1,
    );
  }
}
