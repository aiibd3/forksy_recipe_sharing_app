import 'package:flutter/material.dart';
import 'package:forksy/core/theme/app_colors.dart';

class CustomLoadingButton extends StatefulWidget {
  final String title;
  final bool isLoading;
  final VoidCallback onPressed;

  const CustomLoadingButton({
    super.key,
    required this.title,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  CustomLoadingButtonState createState() => CustomLoadingButtonState();
}

class CustomLoadingButtonState extends State<CustomLoadingButton>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(_controller!);
  }

  @override
  void didUpdateWidget(CustomLoadingButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading != oldWidget.isLoading) {
      if (widget.isLoading) {
        if (mounted && _controller != null) {
          _controller!.forward();
        }
      } else {
        if (mounted && _controller != null) {
          _controller!.reverse();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.isLoading ? null : widget.onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
      child: widget.isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: AppColors.whiteColor,
                strokeWidth: 2,
              ),
            )
          : Text(
              widget.title,
              style: const TextStyle(
                color: AppColors.whiteColor,
                fontSize: 16,
              ),
            ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
