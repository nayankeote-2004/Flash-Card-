// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../screens/add_edit_flashcard_screen.dart';
// import '../models/flashcard.dart';
// import 'dart:math' show pi;
//
// class FlashcardListScreen extends StatefulWidget {
//   final String userId;
//   const FlashcardListScreen({Key? key, required this.userId}) : super(key: key);
//
//   @override
//   _FlashcardListScreenState createState() => _FlashcardListScreenState();
// }
//
// class _FlashcardListScreenState extends State<FlashcardListScreen> with SingleTickerProviderStateMixin {
//   int _currentIndex = 0;
//   bool _showAnswer = false;
//   AnimationController? _animationController;
//   Animation<double>? _flipAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeAnimations();
//   }
//
//   void _initializeAnimations() {
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );
//
//     _flipAnimation = Tween<double>(begin: 0, end: pi).animate(
//       CurvedAnimation(
//         parent: _animationController!,
//         curve: Curves.easeInOut,
//       ),
//     );
//
//     _flipAnimation?.addListener(() {
//       setState(() {});
//     });
//   }
//
//   void _toggleCard() {
//     setState(() {
//       _showAnswer = !_showAnswer;
//       if (_showAnswer) {
//         _animationController?.forward();
//       } else {
//         _animationController?.reverse();
//       }
//     });
//   }
//
//   void _nextCard(int totalCards) {
//     setState(() {
//       _currentIndex = (_currentIndex + 1) % totalCards;
//       _showAnswer = false;
//     });
//     _animationController?.reset();
//   }
//
//   void _previousCard(int totalCards) {
//     setState(() {
//       _currentIndex = (_currentIndex - 1 + totalCards) % totalCards;
//       _showAnswer = false;
//     });
//     _animationController?.reset();
//   }
//
//   @override
//   void dispose() {
//     _animationController?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         title: const Text('Flashcards', style: TextStyle(color: Colors.black)),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [Colors.blue.shade100, Colors.indigo.shade100],
//           ),
//         ),
//         child: StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance
//               .collection('users')
//               .doc(widget.userId)
//               .collection('flashcards')
//               .snapshots(),
//           builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//             if (!snapshot.hasData) {
//               return const Center(child: CircularProgressIndicator());
//             }
//
//             final flashcards = snapshot.data!.docs.map((doc) {
//               return Flashcard.fromMap(doc.id, doc.data() as Map<String, dynamic>);
//             }).toList();
//
//             if (flashcards.isEmpty) {
//               return const Center(
//                 child: Text(
//                   'No flashcards yet!\nTap + to add one.',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 18),
//                 ),
//               );
//             }
//
//             return Column(
//               children: [
//                 Expanded(
//                   child: Center(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 20),
//                       child: _buildFlippableCard(flashcards[_currentIndex]),
//                     ),
//                   ),
//                 ),
//                 _buildControlBar(flashcards.length),
//               ],
//             );
//           },
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: const Icon(Icons.add),
//         backgroundColor: Colors.blue,
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => AddEditFlashcardScreen(userId: widget.userId)),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildFlippableCard(Flashcard flashcard) {
//     final angle = (_flipAnimation?.value ?? 0);
//     final isBack = angle >= pi / 2;
//
//     return GestureDetector(
//       onTap: _toggleCard,
//       onLongPress: () => _showEditDeleteOptions(context, flashcard),
//       child: TweenAnimationBuilder(
//         tween: Tween<double>(begin: 0, end: angle),
//         duration: const Duration(milliseconds: 500),
//         builder: (BuildContext context, double value, Widget? child) {
//           return Transform(
//             alignment: Alignment.center,
//             transform: Matrix4.identity()
//               ..setEntry(3, 2, 0.001)
//               ..rotateY(value),
//             child: value >= pi / 2
//                 ? Transform(
//               alignment: Alignment.center,
//               transform: Matrix4.identity()..rotateY(pi),
//               child: _buildCardSide(flashcard, true),
//             )
//                 : _buildCardSide(flashcard, false),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildCardSide(Flashcard flashcard, bool isAnswer) {
//     return Card(
//       elevation: 8,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: Container(
//         width: MediaQuery.of(context).size.width * 0.85,
//         height: MediaQuery.of(context).size.width * 1.2,
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(15),
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: isAnswer
//                 ? [Colors.indigo.shade50, Colors.blue.shade100]
//                 : [Colors.white, Colors.blue.shade50],
//           ),
//         ),
//         child: Column(
//           children: [
//             /*Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.edit, color: Colors.blue),
//                   onPressed: () => _navigateToEdit(flashcard),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.delete, color: Colors.red),
//                   onPressed: () => _confirmDelete(context, widget.userId, flashcard.id),
//                 ),
//               ],
//             ),*/
//             Expanded(
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       isAnswer ? 'Answer' : 'Question',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.grey.shade700,
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     Text(
//                       isAnswer ? flashcard.answer : flashcard.question,
//                       style: const TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black87,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             if (!isAnswer)
//               Align(
//                 alignment: Alignment.bottomCenter,
//                 child: Text(
//                   'Tap to flip',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey.shade600,
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildControlBar(int totalCards) {
//     return Padding(
//       padding: const EdgeInsets.all(20),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           IconButton(
//             icon: const Icon(Icons.arrow_back_ios),
//             onPressed: () => _previousCard(totalCards),
//             color: Colors.blue,
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             decoration: BoxDecoration(
//               color: Colors.blue.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Text(
//               '${_currentIndex + 1} / $totalCards',
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.blue,
//               ),
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.arrow_forward_ios),
//             onPressed: () => _nextCard(totalCards),
//             color: Colors.blue,
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _navigateToEdit(Flashcard flashcard) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => AddEditFlashcardScreen(
//           userId: widget.userId,
//           flashcard: flashcard,
//         ),
//       ),
//     );
//   }
//
//   void _showEditDeleteOptions(BuildContext context, Flashcard flashcard) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//         title: const Text('Edit or Delete'),
//         content: const Text('Choose an option:'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               _navigateToEdit(flashcard);
//             },
//             child: const Text('Edit'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               _confirmDelete(context, widget.userId, flashcard.id);
//             },
//             child: const Text('Delete', style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _confirmDelete(BuildContext context, String userId, String flashcardId) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//         title: const Text('Delete Flashcard'),
//         content: const Text('Are you sure you want to delete this flashcard?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               FirebaseFirestore.instance
//                   .collection('users')
//                   .doc(userId)
//                   .collection('flashcards')
//                   .doc(flashcardId)
//                   .delete();
//               Navigator.pop(context);
//             },
//             child: const Text('Delete', style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//   }
// }
