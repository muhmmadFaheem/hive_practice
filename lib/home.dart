import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Box mybox = Hive.box('new_box');
  final TextEditingController noteController = TextEditingController();

  void _addnote() {
    if (noteController.text.isNotEmpty) {
      mybox.add(noteController.text);
      noteController.clear();
      setState(() {});
    }
  }

  void _deletenote(int index) {
    mybox.deleteAt(index);
    setState(() {});
  }

  void _updatenote(int index, String newnote) {
    mybox.putAt(index, newnote);
    setState(() {});
  }

  void _showEditDialog(int index, String currentNote) {
    final TextEditingController editController =
        TextEditingController(text: currentNote);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Note'),
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Type Here....',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (editController.text.isNotEmpty) {
                  _updatenote(index, editController.text);
                  Navigator.pop(context);
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hive Practice '), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: noteController,
              decoration: InputDecoration(
                hintText: 'Type Here...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: _addnote, child: const Text('Add')),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: mybox.length,
                itemBuilder: (BuildContext context, int index) {
                  final note = mybox.getAt(index).toString();
                  return Card(
                    child: ListTile(
                      title: Text(note),
                      trailing: IconButton(
                        onPressed: () => _deletenote(index),
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                      // Yahan _showEditDialog ko call kiya hai:
                      leading: IconButton(
                        onPressed: () => _showEditDialog(index, note),
                        icon: const Icon(Icons.edit_document, color: Colors.blue),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
