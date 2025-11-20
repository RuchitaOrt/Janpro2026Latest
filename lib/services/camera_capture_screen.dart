import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class CameraCaptureScreen extends StatefulWidget {
  final Function(String imagePath) onImageCaptured;
  const CameraCaptureScreen({Key? key, required this.onImageCaptured})
      : super(key: key);

  @override
  State<CameraCaptureScreen> createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<CameraCaptureScreen>
    with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  int _selectedCameraIndex = 0;
  bool _isCameraInitialized = false;
  FlashMode _flashMode = FlashMode.auto;
  // double _currentZoom = 1.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    if (_cameras.isEmpty) return;

    _controller = CameraController(
      _cameras[_selectedCameraIndex],
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _controller!.initialize();

    // Set default flash mode
    await _controller!.setFlashMode(_flashMode);

    if (!mounted) return;
    setState(() => _isCameraInitialized = true);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Pause/resume camera when app lifecycle changes
    if (!_controller!.value.isInitialized) return;

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  Future<void> _switchCamera() async {
    if (_cameras.length < 2) return;

    setState(() => _isCameraInitialized = false);
    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras.length;
    await _controller?.dispose();

    _controller = CameraController(
      _cameras[_selectedCameraIndex],
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _controller!.initialize();
    await _controller!.setFlashMode(_flashMode);

    if (!mounted) return;
    setState(() => _isCameraInitialized = true);
  }

  Future<void> _captureImage() async {
    if (!_controller!.value.isInitialized) return;
    final image = await _controller!.takePicture();

    final directory = await getApplicationDocumentsDirectory();
    final filePath = path.join(directory.path, path.basename(image.path));
    await image.saveTo(filePath);

    widget.onImageCaptured(filePath);
    Navigator.pop(context);
  }

  void _toggleFlash() {
    setState(() {
      if (_flashMode == FlashMode.auto) {
        _flashMode = FlashMode.always;
      } else if (_flashMode == FlashMode.always) {
        _flashMode = FlashMode.off;
      } else {
        _flashMode = FlashMode.auto;
      }
      _controller?.setFlashMode(_flashMode);
    });
  }

  double _currentZoom = 1.0;
  double _baseZoom = 1.0;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isCameraInitialized
          ? Stack(
              children: [
                // Fullscreen preview with proper aspect ratio
                Positioned.fill(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller!.value.previewSize!.height,
                      height: _controller!.value.previewSize!.width,
                      child: CameraPreview(
                        _controller!,
                        child: GestureDetector(
                          onScaleStart: (details) {
                            _baseZoom =
                                _currentZoom; // store zoom when pinch starts
                          },
                          onScaleUpdate: (details) async {
                            if (_controller == null) return;

                            final minZoom =
                                await _controller!.getMinZoomLevel();
                            final maxZoom =
                                await _controller!.getMaxZoomLevel();

                            double zoom = (_baseZoom * details.scale)
                                .toDouble(); // use base zoom
                            zoom = zoom.clamp(minZoom, maxZoom);

                            _currentZoom = zoom;
                            await _controller!.setZoomLevel(_currentZoom);
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                // Flash toggle button
                Positioned(
                  top: 50,
                  left: 20,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        _flashMode == FlashMode.auto
                            ? Icons.flash_auto
                            : _flashMode == FlashMode.always
                                ? Icons.flash_on
                                : Icons.flash_off,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: _toggleFlash,
                    ),
                  ),
                ),

                // Switch camera button
                Positioned(
                  top: 50,
                  right: 20,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.flip_camera_android,
                          color: Colors.white, size: 28),
                      onPressed: _switchCamera,
                    ),
                  ),
                ),

                // Capture button
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 25),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: _captureImage,
                        child: const Icon(Icons.camera_alt,
                            size: 40, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator(color: Colors.white)),
    );
  }
}
