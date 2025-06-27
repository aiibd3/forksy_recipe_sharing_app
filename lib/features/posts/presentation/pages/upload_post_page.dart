import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:forksy/features/auth/domain/entities/app_user.dart';

import '../../../../core/theme/app_colors.dart';
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
  String? selectedCategory;
  AppUser? currentUser;

  final List<String> categories = [
    'eastern',
    'western',
    'italian',
    'desserts',
    'asian',
  ];

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
        SnackBar(content: Text("posts.pickImage".tr())),
      );
      return;
    }

    if (textController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("posts.enterCaption".tr())),
      );
      return;
    }

    if (selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("posts.selectCategory".tr())),
      );
      return;
    }

    final newPost = Post(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: currentUser?.uid ?? "",
      userName: currentUser?.name ?? "Anonymous",
      text: textController.text,
      categories: selectedCategory!,
      // Use the selected category
      imageUrl: "null",
      timestamp: DateTime.now(),
      likes: [],
      comments: [],
      isLiked: false,
      isCommented: false,
      isSaved: false,
    );

    final postCubit = context.read<PostCubit>();
    postCubit.createPost(newPost, imagePath: imagePickedFile?.path);
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostState>(
      builder: (context, state) {
        return buildUploadPostBody(state);
      },
      listener: (context, state) {
        if (state is PostLoading || state is PostUpLoading) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("posts.uploading".tr())),
          );
        }
        if (state is PostLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("posts.uploadSuccess".tr())),
          );
          Navigator.pop(context);
        } else if (state is PostFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text("${"posts.uploadError".tr()}${state.error}")),
          );
        }
      },
    );
  }

  Widget buildUploadPostBody(PostState state) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryColor,
              AppColors.blueColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Picker Section
                Text(
                  "posts.imageSection".tr(),
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 1.h),
                GestureDetector(
                  onTap: pickImage,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[200],
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: imagePickedFile == null
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.camera_alt,
                                    size: 40, color: Colors.grey),
                                const SizedBox(height: 8),
                                Text("posts.pickImage".tr(),
                                    style: TextStyle(fontSize: 16.sp)),
                              ],
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.memory(
                              imagePickedFile!.bytes!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 200,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 2.h),
                // Description Section
                Text(
                  "posts.descriptionSection".tr(),
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 1.h),
                TextField(
                  controller: textController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: "posts.enterCaption".tr(),
                    labelText: "posts.descriptionSection".tr(),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
                SizedBox(height: 2.h),
                // Category Section
                Text(
                  "posts.categorySection".tr(),
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 1.h),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: EdgeInsets.symmetric(horizontal: 12.sp),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[100],
                  ),
                  child: DropdownButton<String>(
                    value: selectedCategory,
                    hint: Text("posts.selectCategory".tr(),
                        style: TextStyle(fontSize: 14.sp)),
                    isExpanded: true,
                    underline: const SizedBox(),
                    dropdownColor: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    elevation: 8,
                    items: categories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Row(
                          children: [
                            AnimatedRotation(
                              turns: selectedCategory == category ? 0.1 : 0,
                              duration: const Duration(milliseconds: 200),
                              child: Icon(
                                category == 'eastern'
                                    ? Icons.local_dining
                                    : category == 'western'
                                        ? Icons.fastfood
                                        : category == 'italian'
                                            ? Icons.local_pizza
                                            : category == 'desserts'
                                                ? Icons.cake
                                                : Icons.rice_bowl,
                                size: 20,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(width: 8.sp),
                            Text(category.tr(),
                                style: TextStyle(fontSize: 14.sp)),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        title: Text("posts.upload".tr(), style: TextStyle(fontSize: 20.sp)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          state is PostLoading || state is PostUpLoading
              ? Padding(
                  padding: EdgeInsets.all(12.sp),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2.sp),
                  ),
                )
              : AnimatedScale(
                  scale: 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: IconButton(
                    onPressed: uploadPost,
                    icon: const Icon(Icons.check, color: Colors.green),
                    tooltip: "posts.submit".tr(),
                  ),
                ),
        ],
      ),
    );
  }
}
