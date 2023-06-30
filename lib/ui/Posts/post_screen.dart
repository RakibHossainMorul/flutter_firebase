import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/firestore/firestoe_list_screen.dart';
import 'package:flutter_firebase/ui/firebase_calculator.dart';
import '../../utils/utils.dart';
import '../auth/login_screen.dart';
import '../upload_screen.dart';
import 'add_post.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('Posts');
  TextEditingController searchController = TextEditingController();
  TextEditingController updateController = TextEditingController();

  Future<void> showMyDialog(String title, String id) async {
    updateController.text = title;

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Update"),
            content: TextField(
              controller: updateController,
              decoration: InputDecoration(
                  hintText: 'Enter new title',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ref.child(id).update({
                      'title': updateController.text.toLowerCase()
                    }).then((value) {
                      Utils().toastMessage("Updated Successfully");
                    }).onError((error, stackTrace) {
                      Utils().toastMessage(error.toString());
                    });
                  },
                  child: const Text(
                    "Update",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          );
        });
  }

//This is used for stream builder widget for this file
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CalculatorScreen()));
              },
              icon: const Icon(Icons.calculate)),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UploadImageScreen()));
              },
              icon: const Icon(Icons.upload_file)),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FirestoreListScreen()));
              },
              icon: const Icon(Icons.navigation)),
          IconButton(
            onPressed: () {
              auth.signOut().then((value) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              }).onError((error, stackTrace) {
                Utils().toastMessage(error.toString());
              });
            },
            icon: const Icon(Icons.logout_outlined),
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: Column(
        children: [
          TextFormField(
              onChanged: (String value) {
                setState(() {});
              },
              controller: searchController,
              decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)))),
          Expanded(
              child: Container(
            color: Colors.amber,
            child: StreamBuilder(
                stream: ref.onValue,
                builder: (BuildContext context,
                    AsyncSnapshot<DatabaseEvent> snapshot) {
                  if (snapshot.hasData) {
                    Map<dynamic, dynamic> map =
                        snapshot.data!.snapshot.value as dynamic;
                    List<dynamic> list = [];
                    list.clear();
                    list = map.values.toList();
                    return ListView.builder(
                        itemCount: snapshot.data!.snapshot.children.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(list[index]['title']),
                            subtitle: Text(list[index]['id']),
                          );
                        });
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
          )),
          Expanded(
            child: FirebaseAnimatedList(
                query: ref,
                defaultChild: const Center(child: CircularProgressIndicator()),
                itemBuilder:
                    (BuildContext context, snapshot, animation, index) {
                  final title = snapshot.child('title').value.toString();

                  if (searchController.text.isEmpty) {
                    return ListTile(
                      title: Text(snapshot.child('title').value.toString()),
                      subtitle: Text(snapshot.child('id').value.toString()),
                      trailing: PopupMenuButton(
                        icon: const Icon(Icons.more_vert),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 1,
                            child: ListTile(
                                leading: const Icon(Icons.edit),
                                onTap: () {
                                  Navigator.pop(context);
                                  showMyDialog(title,
                                      snapshot.child('id').value.toString());
                                },
                                title: const Text('Update')),
                          ),
                          PopupMenuItem(
                            value: 1,
                            child: ListTile(
                                leading: const Icon(Icons.delete),
                                onTap: () {
                                  Navigator.pop(context);
                                  ref
                                      .child(
                                          snapshot.child('id').value.toString())
                                      .remove();
                                },
                                title: const Text('Delete')),
                          ),
                        ],
                      ),
                    );
                  } else if (title.toLowerCase().contains(
                      searchController.text.toLowerCase().toLowerCase())) {
                    return ListTile(
                      title: Text(snapshot.child('title').value.toString()),
                      subtitle: Text(snapshot.child('id').value.toString()),
                    );
                  } else {
                    Container();
                  }
                  return Container();
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddPostScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
