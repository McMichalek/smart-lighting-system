import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_app/models/board.dart';

class BoardsRepository {
  Future<List<Board>> fetchBoards(String userId) async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('users').doc(userId).collection('boards').get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Board(
          boardId: doc.id,
          name: data['name'] ?? '',
          room: data['room'] ?? '',
        );
      }).toList();
    } catch (e) {
      throw Exception('Błąd pobierania boardów: $e');
    }
  }

  Future<void> updateBoard(String userId, String boardId, String newName, String newRoom) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).collection('boards').doc(boardId).update({
        'name': newName,
        'room': newRoom,
      });
    } catch (e) {
      throw Exception('Error updating board: $e');
    }
  }

  Future<void> removeBoard(String userId, String boardId) async {
    try {
      final boardDoc = FirebaseFirestore.instance.collection('users').doc(userId).collection('boards').doc(boardId);

      await boardDoc.delete();
    } catch (e) {
      throw Exception('Error removing board: $e');
    }
  }

  Future<void> addBoard(String userId, String boardId, String name, String room) async {
    try {
      final boardDoc = FirebaseFirestore.instance.collection('users').doc(userId).collection('boards').doc(boardId);
      await boardDoc.set({
        'name': name,
        'room': room,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error adding board: $e');
    }
  }
}
