import 'package:flutter/material.dart';
import 'package:smart_note/database/database_helper.dart';
import 'package:smart_note/models/note_model.dart';

class NoteProvider with ChangeNotifier {
  List<Note> _notes = [];
  List<Category> _categories = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();

  List<Note> get notes => _notes;
  List<Category> get categories => _categories;

  Future<void> loadNotes() async {
    _notes = await _dbHelper.getNotes();
    notifyListeners();
  }

  Future<void> addNote(Note note) async {
    await _dbHelper.insertNote(note);
    await loadNotes();
  }

  Future<void> updateNote(Note note) async {
    await _dbHelper.updateNote(note);
    await loadNotes();
  }

  Future<void> deleteNote(int id) async {
    await _dbHelper.deleteNote(id);
    await loadNotes();
  }

  // Similar for categories and search/filter logic
}
