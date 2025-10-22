import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:smart_note/models/note_model.dart';
import 'package:smart_note/providers/note_provider.dart';
import 'package:provider/provider.dart';

class NoteEditorScreen extends StatefulWidget {
  final Note? note;

  const NoteEditorScreen({super.key, this.note});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  late QuillController _controller;
  late TextEditingController _titleController;
  String? _selectedCategory;
  List<String> _tags = [];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _controller = QuillController(
      document: widget.note != null ? Document.fromJson(jsonDecode(widget.note!.content)) : Document(),
      selection: const TextSelection.collapsed(offset: 0),
    );
    _selectedCategory = widget.note?.category;
    _tags = widget.note?.tags ?? [];
  }

  void _saveNote() {
    final note = Note(
      id: widget.note?.id,
      title: _titleController.text,
      content: jsonEncode(_controller.document.toDelta().toJson()),
      category: _selectedCategory,
      tags: _tags,
      createdAt: widget.note?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );
    if (widget.note == null) {
      context.read<NoteProvider>().addNote(note);
    } else {
      context.read<NoteProvider>().updateNote(note);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'New Note' : 'Edit Note'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(hintText: 'Note Title'),
            ),
            const SizedBox(height: 16),
            QuillToolbar.simple(configurations: QuillSimpleToolbarConfigurations(
              controller: _controller,
              sharedConfigurations: const QuillSharedConfigurations(
                locale: Locale('en'),
              ),
            )),
            Expanded(
              child: QuillEditor.basic(
                configurations: QuillEditorConfigurations(
                  controller: _controller,
                ),
              ),
            ),
            // Add category and tag selection widgets here
          ],
        ),
      ),
    );
  }
}