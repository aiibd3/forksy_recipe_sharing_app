import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forksy/features/auth/domain/entities/app_user.dart';

import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../domain/entities/post.dart';
import '../cubit/post_cubit.dart';

class UploadPostPage extends StatefulWidget {
  const UploadPostPage({super.key});

  @override
  State<UploadPostPage> createState() => _UploadPostPageState();
}

class _UploadPostPageState extends State<UploadPostPage> {
  PlatformFile? imagePickedFile;

  final textController = TextEditingController();

  AppUser? currentUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
  }

  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );

    if (result != null) {
      setState(() {
        imagePickedFile = result.files.first;
      });
    }
  }

  void uploadPost() {
    if (imagePickedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an image!")),
      );
      return;
    }

    if (textController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter some text!")),
      );
      return;
    }

    final newPost = Post(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: currentUser?.uid ?? "",
      userName: currentUser?.name ?? "Anonymous",
      text: textController.text,
      imageUrl: "null", // This will be added after upload
      timestamp: DateTime.now(),
    );

    final postCubit = context.read<PostCubit>();
    postCubit.createPost(newPost, imagePath: imagePickedFile!.path);
  }

  @override
  dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostState>(
      listener: (context, state) {
        if (state is PostLoading) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Uploading post...")),
          );
        } else if (state is PostLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Post uploaded successfully!")),
          );
          Navigator.pop(context);
        } else if (state is PostFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: ${state.error}")),
          );
        }
      },
      builder: (context, state) {
        return buildUploadPostBody();
      },
    );
  }

  Widget buildUploadPostBody() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Post"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: uploadPost,
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: pickImage,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[200],
                  ),
                  child: imagePickedFile == null
                      ? const Center(
                    child: Icon(
                      Icons.camera_alt,
                      size: 40,
                    ),
                  )
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.memory(
                      imagePickedFile!.bytes!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: textController,
                maxLines: 3,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Write something...",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
