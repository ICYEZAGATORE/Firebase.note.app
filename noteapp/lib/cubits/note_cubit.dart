import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/note_model.dart';
import '../services/note_repository.dart';

part 'note_state.dart';

class NoteCubit extends Cubit<NoteState> {
  final NoteRepository noteRepository;

  NoteCubit(this.noteRepository) : super(NoteLoading());

  Future<void> fetchNotes() async {
    emit(NoteLoading());
    try {
      final notes = await noteRepository.fetchNotes();
      emit(NoteLoaded(notes));
    } catch (e) {
      emit(NoteError('Failed to fetch notes: $e'));
    }
  }

  Future<void> addNote(String text) async {
    try {
      await noteRepository.addNote(text);
      await fetchNotes();
    } catch (e) {
      emit(NoteError('Failed to add note: $e'));
    }
  }

  Future<void> updateNote(String id, String text) async {
    try {
      await noteRepository.updateNote(id, text);
      await fetchNotes();
    } catch (e) {
      emit(NoteError('Failed to update note: $e'));
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      await noteRepository.deleteNote(id);
      await fetchNotes();
    } catch (e) {
      emit(NoteError('Failed to delete note: $e'));
    }
  }
}
