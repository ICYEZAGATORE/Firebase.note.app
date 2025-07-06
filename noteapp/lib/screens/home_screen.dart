import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../cubits/note_cubit.dart';
import '../models/note_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NoteCubit>().fetchNotes();
  }

  void _showNoteDialog({Note? note}) {
    final controller = TextEditingController(text: note?.text ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(note == null ? 'Add Note' : 'Edit Note'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter note text'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isEmpty) return;

              if (note == null) {
                context.read<NoteCubit>().addNote(text);
              } else {
                context.read<NoteCubit>().updateNote(note.id, text);
              }

              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text("My Notes (${user?.email})"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<NoteCubit, NoteState>(
        builder: (context, state) {
          if (state is NoteLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NoteLoaded) {
            final notes = state.notes;
            if (notes.isEmpty) {
              return const Center(
                child: Text(
                  'Nothing here yet—tap ➕ to add a note.',
                  style: TextStyle(fontSize: 16),
                ),
              );
            }
            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (_, index) {
                final note = notes[index];
                return ListTile(
                  title: Text(note.text),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showNoteDialog(note: note),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () =>
                            context.read<NoteCubit>().deleteNote(note.id),
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (state is NoteError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNoteDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
