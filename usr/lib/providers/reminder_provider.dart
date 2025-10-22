import 'package:flutter/material.dart';
import 'package:smart_note/database/database_helper.dart';
import 'package:smart_note/models/note_model.dart';

class ReminderProvider with ChangeNotifier {
  List<Reminder> _reminders = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();

  List<Reminder> get reminders => _reminders;

  Future<void> loadReminders() async {
    // Implement similar to loadNotes
    _reminders = await _dbHelper.getReminders(); // Assuming method exists in DB
    notifyListeners();
  }

  Future<void> addReminder(Reminder reminder) async {
    await _dbHelper.insertReminder(reminder); // Assuming method exists
    await loadReminders();
  }

  Future<void> updateReminder(Reminder reminder) async {
    await _dbHelper.updateReminder(reminder);
    await loadReminders();
  }

  Future<void> deleteReminder(int id) async {
    await _dbHelper.deleteReminder(id);
    await loadReminders();
  }
}
