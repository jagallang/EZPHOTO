import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:math' as math;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:gal/gal.dart';

class LocalGradientImage extends StatelessWidget {
  final String imageId;
  final BoxFit fit;
  final double? width;
  final double? height;

  const LocalGradientImage({
    super.key,
    required this.imageId,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  List<Color> _getGradientColors(String id) {
    switch (id) {
      case 'local_gradient_1':
        return [const Color(0xFF4CAF50), const Color(0xFF81C784)]; // Green
      case 'local_gradient_2':
        return [const Color(0xFF2196F3), const Color(0xFF64B5F6)]; // Blue
      case 'local_gradient_3':
        return [const Color(0xFFFF9800), const Color(0xFFFFB74D)]; // Orange
      case 'local_gradient_4':
        return [const Color(0xFFE91E63), const Color(0xFFF06292)]; // Pink
      default:
        return [Colors.grey.shade400, Colors.grey.shade600];
    }
  }

  String _getImageText(String id) {
    switch (id) {
      case 'local_gradient_1':
        return '자연 풍경';
      case 'local_gradient_2':
        return '도시 야경';
      case 'local_gradient_3':
        return '바다 전망';
      case 'local_gradient_4':
        return '음식 사진';
      default:
        return '샘플 이미지';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = _getGradientColors(imageId);
    final text = _getImageText(imageId);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image,
              size: 48,
              color: Colors.white.withValues(alpha: 0.9),
            ),
            const SizedBox(height: 12),
            Text(
              text,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 16,
                fontWeight: FontWeight.w600,
                shadows: [
                  Shadow(
                    offset: const Offset(1, 1),
                    blurRadius: 2,
                    color: Colors.black.withValues(alpha: 0.3),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RobustNetworkImage extends StatefulWidget {
  final String url;
  final BoxFit fit;
  final double? width;
  final double? height;
  final int? cacheWidth;
  final int? cacheHeight;

  const RobustNetworkImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.cacheWidth,
    this.cacheHeight,
  });

  @override
  State<RobustNetworkImage> createState() => _RobustNetworkImageState();
}

class SmartImage extends StatelessWidget {
  final String imageSource;
  final BoxFit fit;
  final double? width;
  final double? height;
  final int? cacheWidth;
  final int? cacheHeight;

  const SmartImage({
    super.key,
    required this.imageSource,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.cacheWidth,
    this.cacheHeight,
  });

  @override
  Widget build(BuildContext context) {
    // 로컬 그라데이션 이미지인지 확인
    if (imageSource.startsWith('local_gradient_')) {
      // local_gradient 이미지들을 빈 슬롯으로 처리
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.grey[300]!, width: 1),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.camera_alt, size: 40, color: Colors.grey),
              SizedBox(height: 8),
              Text(
                '사진추가',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      );
    }
    
    // Data URL (base64 인코딩된 이미지) 처리
    if (imageSource.startsWith('data:image/')) {
      try {
        final base64String = imageSource.split(',').last;
        final bytes = base64Decode(base64String);
        return Image.memory(
          bytes,
          fit: fit,
          width: width,
          height: height,
          cacheWidth: cacheWidth,
          cacheHeight: cacheHeight,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.broken_image,
                size: 50,
                color: Colors.grey,
              ),
            );
          },
        );
      } catch (e) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.error,
            size: 50,
            color: Colors.red,
          ),
        );
      }
    }
    
    // 네트워크 이미지 처리
    return RobustNetworkImage(
      url: imageSource,
      fit: fit,
      width: width,
      height: height,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }
}

class _RobustNetworkImageState extends State<RobustNetworkImage> {
  int _retryCount = 0;
  
  List<String> _getFallbackUrls(String originalUrl) {
    return [
      originalUrl,
      'https://via.placeholder.com/400x300/9E9E9E/FFFFFF?text=Loading...',
      'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNDAwIiBoZWlnaHQ9IjMwMCIgdmlld0JveD0iMCAwIDQwMCAzMDAiIGZpbGw9Im5vbmUiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CjxyZWN0IHdpZHRoPSI0MDAiIGhlaWdodD0iMzAwIiBmaWxsPSIjRjVGNUY1Ii8+Cjx0ZXh0IHg9IjIwMCIgeT0iMTUwIiB0ZXh0LWFuY2hvcj0ibWlkZGxlIiBmaWxsPSIjOTk5OTk5IiBmb250LXNpemU9IjE4Ij7sgJjslZzsnbQ8L3RleHQ+Cjwvc3ZnPgo=',
    ];
  }

  void _retry() {
    setState(() {
      _retryCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final urls = _getFallbackUrls(widget.url);
    final currentUrl = _retryCount < urls.length ? urls[_retryCount] : urls.last;
    
    return Image.network(
      currentUrl,
      key: ValueKey('${widget.url}_$_retryCount'),
      fit: widget.fit,
      width: widget.width,
      height: widget.height,
      cacheWidth: widget.cacheWidth,
      cacheHeight: widget.cacheHeight,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          width: widget.width ?? double.infinity,
          height: widget.height ?? double.infinity,
          color: Colors.grey[200],
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
              strokeWidth: 2,
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        if (_retryCount < urls.length - 1) {
          // 다음 URL로 자동 재시도
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _retry();
          });
          return Container(
            width: widget.width ?? double.infinity,
            height: widget.height ?? double.infinity,
            color: Colors.grey[200],
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }
        
        // 모든 URL 실패시 최종 오류 UI
        return Container(
          width: widget.width ?? double.infinity,
          height: widget.height ?? double.infinity,
          color: Colors.grey[100],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.image_not_supported, size: 32, color: Colors.grey),
              const SizedBox(height: 8),
              Text(
                '이미지 로딩 실패',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              const SizedBox(height: 4),
              TextButton(
                onPressed: () {
                  setState(() {
                    _retryCount = 0;
                  });
                },
                child: const Text('다시 시도', style: TextStyle(fontSize: 10)),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ShapeOverlay {
  final String type;
  Offset position;
  double size;
  Color color;
  double rotation;
  
  ShapeOverlay({
    required this.type,
    required this.position,
    this.size = 50.0,
    this.color = Colors.red,
    this.rotation = 0.0,
  });
}

class PageData {
  String title;
  int layoutCount; // 페이지별 레이아웃 (1, 2, 3, 4장)
  Map<int, String> photoData;
  Map<int, String> photoTitles;
  Map<int, double> photoRotations;
  Map<int, Offset> photoOffsets;
  Map<int, double> photoScales;
  Map<int, int> photoZoomLevels;
  List<ShapeOverlay> shapes;
  
  PageData({
    required this.title,
    this.layoutCount = 4,
    Map<int, String>? photoData,
    Map<int, String>? photoTitles,
    Map<int, double>? photoRotations,
    Map<int, Offset>? photoOffsets,
    Map<int, double>? photoScales,
    Map<int, int>? photoZoomLevels,
    List<ShapeOverlay>? shapes,
  }) : photoData = photoData ?? {},
       photoTitles = photoTitles ?? {},
       photoRotations = photoRotations ?? {},
       photoOffsets = photoOffsets ?? {},
       photoScales = photoScales ?? {},
       photoZoomLevels = photoZoomLevels ?? {},
       shapes = shapes ?? [];
}

void main() {
  // 세로모드로 고정
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const PhotoLayoutApp());
}

class PhotoLayoutApp extends StatelessWidget {
  const PhotoLayoutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'POL Photo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const PhotoEditorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PhotoEditorScreen extends StatefulWidget {
  const PhotoEditorScreen({super.key});

  @override
  State<PhotoEditorScreen> createState() => _PhotoEditorScreenState();
}

class _PhotoEditorScreenState extends State<PhotoEditorScreen> {
  String pageTitle = '2024년 가족 여행 앨범 ✈️';
  bool isEditingTitle = false;
  final TextEditingController titleController = TextEditingController();
  final FocusNode titleFocusNode = FocusNode();
  
  int photoCount = 4;
  bool isPortrait = true;
  int? selectedSlot;
  String currentEditMode = 'select';
  
  // 멀티페이지 관련 변수들
  int currentPageIndex = 0;
  List<PageData> pages = [];
  
  // 페이지 번호 관련 변수들
  bool showPageNumbers = false;
  int startPageNumber = 1;
  
  // 스크린샷 컨트롤러
  final ScreenshotController _screenshotController = ScreenshotController();
  
  final List<ShapeOverlay> shapes = [];
  int? selectedShapeIndex;
  
  final Map<int, Offset> photoOffsets = {};
  final Map<int, double> photoScales = {};
  final Map<int, int> photoZoomLevels = {};
  
  final Map<int, String> photoData = {};
  
  final Map<int, String> photoTitles = {};
  
  final Map<int, double> photoRotations = {};

  @override
  void initState() {
    super.initState();
    titleController.text = pageTitle;
    
    // 포커스 리스너 추가
    titleFocusNode.addListener(() {
      if (!titleFocusNode.hasFocus && isEditingTitle) {
        setState(() {
          pageTitle = titleController.text;
          isEditingTitle = false;
        });
      }
    });
    
    // 샘플 사진으로 초기화
    _initializeWithSamplePhotos();
  }

  @override
  void dispose() {
    titleController.dispose();
    titleFocusNode.dispose();
    super.dispose();
  }

  // 페이지 관리 메소드들
  PageData get currentPage => pages[currentPageIndex];
  
  void _saveCurrentPageData() {
    if (pages.isNotEmpty && currentPageIndex < pages.length) {
      pages[currentPageIndex] = PageData(
        title: pageTitle,
        layoutCount: photoCount,
        photoData: Map<int, String>.from(photoData),
        photoTitles: Map<int, String>.from(photoTitles),
        photoRotations: Map<int, double>.from(photoRotations),
        photoOffsets: Map<int, Offset>.from(photoOffsets),
        photoScales: Map<int, double>.from(photoScales),
        photoZoomLevels: Map<int, int>.from(photoZoomLevels),
        shapes: List<ShapeOverlay>.from(shapes),
      );
    }
  }
  
  void _loadPageData(int pageIndex) {
    if (pageIndex < pages.length) {
      final page = pages[pageIndex];
      setState(() {
        currentPageIndex = pageIndex;
        pageTitle = page.title;
        titleController.text = page.title;
        photoCount = page.layoutCount; // 페이지별 레이아웃 로드
        photoData.clear();
        photoData.addAll(page.photoData);
        photoTitles.clear();
        photoTitles.addAll(page.photoTitles);
        photoRotations.clear();
        photoRotations.addAll(page.photoRotations);
        photoOffsets.clear();
        photoOffsets.addAll(page.photoOffsets);
        photoScales.clear();
        photoScales.addAll(page.photoScales);
        photoZoomLevels.clear();
        photoZoomLevels.addAll(page.photoZoomLevels);
        shapes.clear();
        shapes.addAll(page.shapes);
        selectedSlot = null;
        selectedShapeIndex = null;
        currentEditMode = 'select';
      });
    }
  }

  void _showMultiPhotoAddDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('📷 갤러리에서 사진 선택'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('현재 분할: $photoCount장'),
            const SizedBox(height: 16),
            const Text('갤러리에서 여러장의 사진을 선택하세요.'),
            const SizedBox(height: 8),
            const Text('선택된 사진 수에 따라 자동으로 페이지가 생성됩니다.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _pickMultipleImagesFromGallery();
            },
            child: const Text('갤러리 열기'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickMultipleImagesFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final List<XFile> images = await picker.pickMultiImage(
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );
      
      if (images.isNotEmpty) {
        final List<String> imageDataUrls = [];
        final List<String> imageNames = [];
        
        // 로딩 인디케이터 표시
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('이미지를 처리하고 있습니다...'),
              duration: Duration(seconds: 2),
            ),
          );
        }
        
        for (int i = 0; i < images.length; i++) {
          try {
            final XFile image = images[i];
            final Uint8List bytes = await image.readAsBytes();
            
            if (bytes.isNotEmpty) {
              final String base64String = base64Encode(bytes);
              final String extension = image.name.split('.').last.toLowerCase();
              final String mimeType = _getMimeType(extension);
              final String dataUrl = 'data:$mimeType;base64,$base64String';
              
              imageDataUrls.add(dataUrl);
              imageNames.add(image.name);
              
              // 이미지 처리 완료
            } else {
              // 빈 이미지 파일
            }
          } catch (imageError) {
            // 개별 이미지 처리 실패
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('이미지 "${images[i].name}" 처리 실패')),
              );
            }
          }
        }
        
        if (imageDataUrls.isNotEmpty) {
          _addMultiplePhotosFromPathsWithNames(imageDataUrls, imageNames);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${imageDataUrls.length}장의 사진이 추가되었습니다')),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('처리 가능한 이미지가 없습니다')),
            );
          }
        }
      }
    } catch (e) {
      // 갤러리 이미지 선택 오류
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('사진을 가져오는 중 오류가 발생했습니다: $e')),
        );
      }
    }
  }
  
  String _getMimeType(String extension) {
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      case 'bmp':
        return 'image/bmp';
      default:
        return 'image/jpeg'; // 기본값
    }
  }

  void _addEmptyPage() {
    // 현재 페이지 데이터 저장 (기존 페이지 보호)
    _saveCurrentPageData();
    
    // 새로운 빈 페이지 생성 - 현재 페이지의 레이아웃 사용
    final currentPageLayout = pages.isNotEmpty ? pages[currentPageIndex].layoutCount : 2;
    final newPage = PageData(
      title: '페이지 ${pages.length + 1}',
      layoutCount: currentPageLayout, // 현재 페이지의 레이아웃 사용
      photoData: {}, // 빈 사진 슬롯들
      photoTitles: {}, // 빈 제목들
      photoRotations: {}, // 기본 회전값
    );
    
    setState(() {
      // 기존 페이지들은 그대로 유지하고 새 페이지만 추가
      pages.add(newPage);
      currentPageIndex = pages.length - 1; // 새 페이지로 이동
    });
    
    // 새 페이지 데이터 로드
    _loadPageData(currentPageIndex);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$currentPageLayout분할의 빈 페이지가 추가되었습니다 (기존 페이지는 유지됨)')),
    );
  }

  void _addEmptyPhotoSlot(int slotIndex) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('📷 사진 추가'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('슬롯 ${slotIndex + 1}에 사진을 추가하시겠습니까?'),
            const SizedBox(height: 16),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _pickSingleImageForSlot(slotIndex);
            },
            child: const Text('갤러리에서 선택'),
          ),
        ],
      ),
    );
  }

  String _truncateFileName(String fileName, {int maxLength = 15}) {
    // 확장자 제거
    final nameWithoutExt = fileName.split('.').first;
    
    // 길이가 maxLength보다 길면 잘라서 표시
    if (nameWithoutExt.length > maxLength) {
      return '${nameWithoutExt.substring(0, maxLength)}...';
    }
    return nameWithoutExt;
  }

  Future<void> _pickSingleImageForSlot(int slotIndex) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 600,
        imageQuality: 80,
      );
      
      if (image != null) {
        final Uint8List bytes = await image.readAsBytes();
        final String base64String = base64Encode(bytes);
        final String dataUrl = 'data:image/${image.name.split('.').last};base64,$base64String';
        
        // 파일명을 텍스트 필드에 표시 (길이 제한)
        final String displayName = _truncateFileName(image.name);
        
        // 먼저 사진 데이터를 추가
        photoData[slotIndex] = dataUrl;
        photoTitles[slotIndex] = displayName;
        photoRotations[slotIndex] = 0;
        
        // 사진 추가 후 빈 슬롯을 자동으로 채움 (setState 포함됨)
        _reorganizePhotos();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('슬롯 ${slotIndex + 1}에 사진이 추가되었습니다')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('사진을 가져오는 중 오류가 발생했습니다: $e')),
        );
      }
    }
  }

  void _addMultiplePhotosFromPathsWithNames(List<String> imagePaths, List<String> imageNames) {
    final totalPhotos = imagePaths.length;
    
    _saveCurrentPageData();
    
    final requiredPages = (totalPhotos / photoCount).ceil();
    
    // 새로운 페이지들을 생성
    final newPages = <PageData>[];
    
    for (int pageNum = 0; pageNum < requiredPages; pageNum++) {
      final startIndex = pageNum * photoCount;
      final endIndex = math.min(startIndex + photoCount, totalPhotos);
      
      final pagePhotoData = <int, String>{};
      final pagePhotoTitles = <int, String>{};
      final pagePhotoRotations = <int, double>{};
      
      for (int i = startIndex; i < endIndex; i++) {
        final slotIndex = i - startIndex;
        pagePhotoData[slotIndex] = imagePaths[i];
        // 파일명을 텍스트로 사용 (길이 제한)
        pagePhotoTitles[slotIndex] = _truncateFileName(imageNames[i]);
        pagePhotoRotations[slotIndex] = 0;
      }
      
      newPages.add(PageData(
        title: '페이지 ${pageNum + 1}',
        layoutCount: photoCount,
        photoData: pagePhotoData,
        photoTitles: pagePhotoTitles,
        photoRotations: pagePhotoRotations,
      ));
    }
    
    setState(() {
      pages.clear();
      pages.addAll(newPages);
      currentPageIndex = 0;
    });
    
    _loadPageData(0);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$totalPhotos장의 사진으로 $requiredPages개 페이지를 생성했습니다')),
    );
  }



  void selectSlot(int index) {
    print('selectSlot called: index=$index, currentEditMode=$currentEditMode, hasPhoto=${photoData.containsKey(index)}');
    
    // 빈 슬롯인 경우 선택 상태 변경 없이 바로 사진 추가 다이얼로그 표시
    if (!photoData.containsKey(index)) {
      print('Opening photo add dialog for empty slot $index');
      _addEmptyPhotoSlot(index);
      return; // 선택 상태 변경 없이 리턴
    }
    
    // 사진이 있는 슬롯인 경우에만 선택 상태 변경
    setState(() {
      selectedSlot = index;
      if (currentEditMode == 'photo') {
        addPhotoToSlot(index);
      } else {
        print('Slot $index selected');
      }
    });
  }

  void _resetPhotoPosition(int index) {
    setState(() {
      photoOffsets.remove(index);
      photoScales.remove(index);
      photoZoomLevels.remove(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('사진 ${index + 1}이 원본 위치로 복원되었습니다')),
    );
  }

  void _zoomPhoto(int index) {
    setState(() {
      final currentLevel = photoZoomLevels[index] ?? 0;
      if (currentLevel < 5) {
        photoZoomLevels[index] = currentLevel + 1;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('사진 ${index + 1} - ${currentLevel + 1}단계 확대')),
        );
      } else {
        photoZoomLevels[index] = 0;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('사진 ${index + 1} - 원본 크기로 복원')),
        );
      }
    });
  }

  double _getScaleFromZoomLevel(int zoomLevel) {
    switch (zoomLevel) {
      case 0: return 1.0;   // 원본
      case 1: return 1.2;   // 1단계
      case 2: return 1.4;   // 2단계  
      case 3: return 1.6;   // 3단계
      case 4: return 1.8;   // 4단계
      case 5: return 2.0;   // 5단계
      default: return 1.0;
    }
  }

  void addPhotoToSlot(int index) {
    setState(() {
      if (!photoData.containsKey(index)) {
        photoData[index] = 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=300&h=200&fit=crop';
        photoRotations[index] = 0;
      }
    });
  }

  void removePhoto(int index) {
    setState(() {
      photoData.remove(index);
      photoRotations[index] = 0;
      photoTitles.remove(index);
    });
  }

  void rotatePhoto(int index) {
    setState(() {
      photoRotations[index] = ((photoRotations[index] ?? 0) + 90) % 360;
    });
  }

  void setEditMode(String mode) {
    setState(() {
      if (mode == 'select' && currentEditMode == 'select') {
        // 이미 선택 모드인 상태에서 다시 선택 버튼을 누르면 모든 선택 해제하고 선택 모드도 비활성화
        selectedSlot = null;
        selectedShapeIndex = null;
        currentEditMode = '';  // 선택 모드 비활성화
      } else {
        currentEditMode = mode;
        if (mode == 'select') {
          // 선택 모드로 전환시 모든 선택 해제
          selectedSlot = null;
          selectedShapeIndex = null;
        } else if (mode != 'select') {
          selectedSlot = null;
        }
      }
    });
  }

  void showZoomModal(int slotIndex) {
    if (!photoData.containsKey(slotIndex)) return;
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.blue,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '📷 사진 확대 보기',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.grey[100],
                  padding: const EdgeInsets.all(20),
                  child: Transform.rotate(
                    angle: (photoRotations[slotIndex] ?? 0) * 3.14159 / 180,
                    child: SmartImage(
                      imageSource: photoData[slotIndex]!,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.rotate_right),
                      label: const Text('회전'),
                      onPressed: () {
                        rotatePhoto(slotIndex);
                        Navigator.pop(context);
                        showZoomModal(slotIndex);
                      },
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.edit),
                      label: const Text('제목 수정'),
                      onPressed: () {
                        Navigator.pop(context);
                        editPhotoTitle(slotIndex);
                      },
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.delete),
                      label: const Text('삭제'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                      ),
                      onPressed: () {
                        removePhoto(slotIndex);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void editPhotoTitle(int index) {
    final controller = TextEditingController(text: photoTitles[index] ?? '');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('사진 제목 수정'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: '사진 제목을 입력하세요',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                photoTitles[index] = controller.text;
              });
              Navigator.pop(context);
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }



  void _editPhotoTitleInline(int index) {
    final controller = TextEditingController(text: photoTitles[index] ?? '');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('사진 ${index + 1} 제목 편집'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: '사진 제목을 입력하세요',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                photoTitles[index] = controller.text;
              });
              Navigator.pop(context);
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _showLayoutChangeWarning(int newPhotoCount) {
    if (_hasAnyContent()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('⚠️ 분할 변경 경고'),
          content: const Text(
            '⚠️ 현재 페이지의 분할을 변경합니다.\n\n• 현재 페이지만 새로운 분할로 변경됩니다\n• 현재 페이지의 편집 내용(회전, 확대/축소, 도형)이 삭제됩니다\n• 현재 페이지의 사진들이 새 레이아웃에 맞게 재배치됩니다\n• 다른 페이지들은 영향을 받지 않습니다\n\n계속하시겠습니까?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _changeLayoutForCurrentPage(newPhotoCount);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('확인'),
            ),
          ],
        ),
      );
    } else {
      setState(() {
        photoCount = newPhotoCount;
        _saveCurrentPageData(); // 레이아웃 변경 저장
      });
    }
  }

  void _showOrientationChangeWarning(bool newIsPortrait) {
    if (_hasAnyContent()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('⚠️ 방향 변경 경고'),
          content: const Text(
            '방향을 변경하면 현재 편집 중인 모든 사진, 도형, 텍스트가 삭제됩니다.\n\n계속하시겠습니까?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _resetAllContent();
                setState(() {
                  isPortrait = newIsPortrait;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('방향이 ${newIsPortrait ? "세로" : "가로"}로 변경되고 모든 내용이 초기화되었습니다')),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('확인'),
            ),
          ],
        ),
      );
    } else {
      setState(() {
        isPortrait = newIsPortrait;
      });
    }
  }

  bool _hasAnyContent() {
    return photoData.isNotEmpty || shapes.isNotEmpty || pageTitle != '2024년 가족 여행 앨범 ✈️';
  }

  // 빈 슬롯을 자동으로 채우는 함수
  void _reorganizePhotos() {
    final currentPhotos = Map<int, String>.from(photoData);
    final currentPhotoTitles = Map<int, String>.from(photoTitles);
    final currentPhotoRotations = Map<int, double>.from(photoRotations);
    
    // 빈 슬롯 제거하고 순서대로 재배치
    final redistributedPhotos = <int, String>{};
    final redistributedTitles = <int, String>{};
    final redistributedRotations = <int, double>{};
    
    int newSlotIndex = 0;
    
    // 기존 순서대로 사진들을 앞쪽 슬롯부터 채움
    for (int i = 0; i < photoCount; i++) {
      if (currentPhotos.containsKey(i)) {
        redistributedPhotos[newSlotIndex] = currentPhotos[i]!;
        redistributedTitles[newSlotIndex] = currentPhotoTitles[i] ?? '사진 ${newSlotIndex + 1}';
        redistributedRotations[newSlotIndex] = currentPhotoRotations[i] ?? 0.0;
        newSlotIndex++;
      }
    }
    
    // 데이터 업데이트
    setState(() {
      photoData.clear();
      photoData.addAll(redistributedPhotos);
      photoTitles.clear();
      photoTitles.addAll(redistributedTitles);
      photoRotations.clear();
      photoRotations.addAll(redistributedRotations);
    });
    
    _saveCurrentPageData();
  }

  void _changeLayoutForCurrentPage(int newPhotoCount) {
    // 현재 페이지 데이터 저장
    _saveCurrentPageData();
    
    // 현재 페이지의 사진들만 수집
    List<Map<String, String>> currentPagePhotos = [];
    
    final currentPage = pages[currentPageIndex];
    for (int i = 0; i < currentPage.layoutCount; i++) {
      if (currentPage.photoData.containsKey(i) && currentPage.photoData[i]!.isNotEmpty) {
        currentPagePhotos.add({
          'data': currentPage.photoData[i]!,
          'title': currentPage.photoTitles[i] ?? '사진${currentPagePhotos.length + 1}',
        });
      }
    }
    
    // 현재 페이지만 새 레이아웃으로 초기화
    final newPageData = <int, String>{};
    final newPageTitles = <int, String>{};
    final newPageRotations = <int, double>{};
    
    // 기존 사진들을 새 레이아웃에 맞게 재배치 (넘치는 사진은 제외)
    for (int i = 0; i < currentPagePhotos.length && i < newPhotoCount; i++) {
      newPageData[i] = currentPagePhotos[i]['data']!;
      newPageTitles[i] = currentPagePhotos[i]['title']!;
      newPageRotations[i] = 0.0;
    }
    
    // 현재 페이지만 업데이트
    pages[currentPageIndex] = PageData(
      title: currentPage.title,
      layoutCount: newPhotoCount,
      photoData: newPageData,
      photoTitles: newPageTitles,
      photoRotations: newPageRotations,
      photoOffsets: {},
      photoScales: {},
      photoZoomLevels: {},
      shapes: [],
    );
    
    setState(() {
      // 현재 페이지의 photoCount를 업데이트하고 UI를 새로고침
      _loadPageData(currentPageIndex);
      
      // 현재 페이지의 편집 상태만 초기화
      selectedSlot = -1;
      selectedShapeIndex = -1;
      currentEditMode = 'select';
      shapes.clear();
      photoOffsets.clear();
      photoScales.clear();
      photoZoomLevels.clear();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('현재 페이지가 $newPhotoCount분할로 변경되었습니다.'))
    );
  }


  void _resetAllContent() {
    setState(() {
      photoData.clear();
      photoTitles.clear();
      photoRotations.clear();
      photoOffsets.clear();
      photoScales.clear();
      photoZoomLevels.clear();
      shapes.clear();
      selectedSlot = null;
      selectedShapeIndex = null;
      currentEditMode = 'select';
      pageTitle = '2024년 가족 여행 앨범 ✈️';
      titleController.text = pageTitle;
      
      // 페이지도 초기화
      pages.clear();
      pages.add(PageData(title: pageTitle));
      currentPageIndex = 0;
    });
  }

  void _showPageNumberDialog() {
    final TextEditingController pageNumberController = TextEditingController(text: '1');
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('페이지 번호 설정'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('현재 페이지의 시작 번호를 입력하세요'),
              const SizedBox(height: 16),
              TextField(
                controller: pageNumberController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '시작 페이지 번호',
                  hintText: '예: 5',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.format_list_numbered),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                '예시: 5를 입력하면 현재 페이지가 5번이 되고,\n다음 페이지들은 6, 7, 8... 순서로 번호가 매겨집니다.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('취소'),
            ),
            ElevatedButton(
              onPressed: () {
                final inputText = pageNumberController.text.trim();
                final pageNumber = int.tryParse(inputText);
                
                if (pageNumber != null && pageNumber > 0) {
                  Navigator.of(context).pop();
                  _applyPageNumbers(pageNumber);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('올바른 숫자를 입력해주세요 (1 이상)')),
                  );
                }
              },
              child: const Text('적용'),
            ),
          ],
        );
      },
    );
  }

  void _applyPageNumbers(int startNumber) {
    setState(() {
      showPageNumbers = true;
      // 현재 페이지가 입력한 번호가 되도록 startPageNumber를 계산
      startPageNumber = startNumber - currentPageIndex;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('현재 페이지가 $startNumber번으로 설정되었습니다')),
    );
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning, color: Colors.orange),
              SizedBox(width: 8),
              Text('초기화 확인'),
            ],
          ),
          content: const Text('모든 데이터가 삭제되고 처음 상태로 초기화됩니다.\n정말로 초기화하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('취소'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _resetToInitialState();
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  void _resetToInitialState() {
    setState(() {
      // 모든 데이터 초기화
      photoData.clear();
      photoTitles.clear();
      photoRotations.clear();
      photoOffsets.clear();
      photoScales.clear();
      photoZoomLevels.clear();
      shapes.clear();
      
      // 페이지 관련 초기화
      pages.clear();
      currentPageIndex = 0;
      
      // 편집 모드 초기화
      selectedSlot = null;
      selectedShapeIndex = null;
      currentEditMode = 'select';
      
      // 페이지 번호 초기화
      showPageNumbers = false;
      startPageNumber = 1;
      
      // 제목 편집 모드 초기화
      isEditingTitle = false;
    });
    
    // 샘플 사진으로 초기화
    _initializeWithSamplePhotos();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('모든 데이터가 초기화되었습니다')),
    );
  }

  void _initializeWithSamplePhotos() {
    // 로컬 색상 기반 샘플 이미지 (네트워크 불필요)
    final sampleImages = [
      'local_gradient_1',
      'local_gradient_2',
      'local_gradient_3',
      'local_gradient_4',
    ];

    final sampleNames = [
      '자연풍경.jpg',
      '도시야경.jpg', 
      '바다전망.jpg',
      '음식사진.jpg',
    ];

    final pagePhotoData = <int, String>{};
    final pagePhotoTitles = <int, String>{};
    final pagePhotoRotations = <int, double>{};

    for (int i = 0; i < sampleImages.length; i++) {
      pagePhotoData[i] = sampleImages[i];
      pagePhotoTitles[i] = _truncateFileName(sampleNames[i]);
      pagePhotoRotations[i] = 0;
    }

    setState(() {
      pages.add(PageData(
        title: '페이지 1',
        layoutCount: 4,
        photoData: pagePhotoData,
        photoTitles: pagePhotoTitles,
        photoRotations: pagePhotoRotations,
      ));
    });

    _loadPageData(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  // 왼쪽: 앱 이름 (모바일에 맞게 축소)
                  const Text(
                    '📸 EZPhoto',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      letterSpacing: 0.8,
                    ),
                  ),
                  
                  // 중앙: 페이지 네비게이션
                  Expanded(
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            padding: const EdgeInsets.all(8),
                            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                            icon: const Icon(Icons.chevron_left, color: Colors.white, size: 24),
                            onPressed: currentPageIndex > 0 ? () {
                              _saveCurrentPageData();
                              _loadPageData(currentPageIndex - 1);
                            } : null,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              '${currentPageIndex + 1}/${pages.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          IconButton(
                            padding: const EdgeInsets.all(8),
                            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                            icon: const Icon(Icons.chevron_right, color: Colors.white, size: 24),
                            onPressed: currentPageIndex < pages.length - 1 ? () {
                              _saveCurrentPageData();
                              _loadPageData(currentPageIndex + 1);
                            } : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // 오른쪽: 기능 버튼들 (배경 제거, 깔끔한 디자인)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          minimumSize: const Size(40, 40),
                        ),
                        onPressed: () {
                          _showMultiPhotoAddDialog();
                        },
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add_a_photo, color: Colors.white, size: 20),
                            SizedBox(height: 2),
                            Text(
                              '추가',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          minimumSize: const Size(40, 40),
                        ),
                        onPressed: () {
                          _showSaveConfirmationDialog();
                        },
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.save, color: Colors.white, size: 20),
                            SizedBox(height: 2),
                            Text(
                              '저장',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                const Text('분할:', style: TextStyle(fontSize: 12)),
                const SizedBox(width: 4),
                DropdownButton<int>(
                  value: photoCount,
                  items: [1, 2, 3, 4].map((count) => DropdownMenuItem(
                    value: count,
                    child: Text('$count장'),
                  )).toList(),
                  onChanged: (value) {
                    if (value != null && value != photoCount) {
                      _showLayoutChangeWarning(value);
                    }
                  },
                ),
                const SizedBox(width: 12),
                const Text('방향:', style: TextStyle(fontSize: 12)),
                const SizedBox(width: 4),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                          ),
                          onTap: () {
                            if (!isPortrait) {
                              _showOrientationChangeWarning(true);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            decoration: BoxDecoration(
                              color: isPortrait ? Colors.blue : Colors.transparent,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                              ),
                            ),
                            child: Icon(
                              Icons.smartphone,
                              size: 20,
                              color: isPortrait ? Colors.white : Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                      Container(width: 1, height: 32, color: Colors.grey[300]),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                          onTap: () {
                            if (isPortrait) {
                              _showOrientationChangeWarning(false);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            decoration: BoxDecoration(
                              color: !isPortrait ? Colors.blue : Colors.transparent,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                            ),
                            child: Icon(
                              Icons.stay_current_landscape,
                              size: 20,
                              color: !isPortrait ? Colors.white : Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        if (showPageNumbers) {
                          setState(() {
                            showPageNumbers = false;
                          });
                        } else {
                          _showPageNumberDialog();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: showPageNumbers ? Colors.blue.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: showPageNumbers ? Colors.blue.withValues(alpha: 0.3) : Colors.grey.withValues(alpha: 0.3)),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              showPageNumbers ? Icons.check_box : Icons.check_box_outline_blank,
                              color: showPageNumbers ? Colors.blue : Colors.grey[600],
                              size: 24,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '쪽번호',
                              style: TextStyle(
                                color: showPageNumbers ? Colors.blue : Colors.grey[600],
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        _addEmptyPage();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
                        ),
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add_box, color: Colors.blue, size: 24),
                            SizedBox(height: 2),
                            Text(
                              '페이지',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // 화면 크기에 완전히 반응하는 동적 계산
                  final screenWidth = constraints.maxWidth;
                  final screenHeight = constraints.maxHeight;
                  
                  // 여백을 화면 크기에 비례하여 설정 - 좌우 여백 늘림
                  final horizontalMargin = (screenWidth * 0.08).clamp(16.0, 40.0);
                  final verticalMargin = (screenHeight * 0.01).clamp(4.0, 12.0);
                  
                  // 최소 사용 가능한 공간 보장
                  final availableWidth = (screenWidth - (horizontalMargin * 2)).clamp(200.0, double.infinity);
                  final availableHeight = (screenHeight - (verticalMargin * 2)).clamp(200.0, double.infinity);
                  
                  double containerWidth, containerHeight;
                  
                  // A4 용지 비율 기반 최적화 (1:1.414)
                  const double a4Ratio = 1.414; // A4 세로/가로 비율
                  
                  if (screenWidth < 600) {
                    // 모바일 (소형 화면)
                    if (isPortrait) {
                      // 세로 모드: 세로가 더 긴 A4 (width × 1.414 = height) - 폭 축소
                      containerWidth = availableWidth * 0.85;
                      final minHeight = containerWidth * 1.2;
                      final maxHeight = availableHeight * 0.95;
                      final idealHeight = containerWidth * a4Ratio;
                      
                      if (minHeight <= maxHeight) {
                        containerHeight = idealHeight.clamp(minHeight, maxHeight);
                      } else {
                        // 제약이 모순되는 경우 이상적인 높이 사용
                        containerHeight = idealHeight;
                      }
                    } else {
                      // 가로 모드: 가로가 더 긴 A4
                      // 가용 공간에 맞춰 안전하게 계산
                      final maxPossibleHeight = availableHeight * 0.85;
                      final maxPossibleWidth = availableWidth * 0.80;
                      final idealWidth = maxPossibleHeight * a4Ratio;
                      
                      if (idealWidth <= maxPossibleWidth) {
                        // 이상적인 A4 비율 적용 가능
                        containerHeight = maxPossibleHeight;
                        containerWidth = idealWidth;
                      } else {
                        // 화면 너비에 맞춰 조정
                        containerWidth = maxPossibleWidth;
                        containerHeight = containerWidth / a4Ratio;
                      }
                    }
                  } else {
                    // 태블릿/데스크톱 (대형 화면)
                    if (isPortrait) {
                      // 세로 모드: 세로가 더 긴 A4 (width × 1.414 = height)
                      containerWidth = availableWidth.clamp(350.0, 500.0);
                      final minHeight = 500.0;
                      final maxHeight = availableHeight * 0.95;
                      final idealHeight = containerWidth * a4Ratio;
                      
                      if (minHeight <= maxHeight) {
                        containerHeight = idealHeight.clamp(minHeight, maxHeight);
                      } else {
                        containerHeight = idealHeight;
                      }
                    } else {
                      // 가로 모드: 가로가 더 긴 A4
                      // 가용 공간에 맞춰 안전하게 계산
                      final maxPossibleHeight = availableHeight * 0.8;
                      final maxPossibleWidth = availableWidth * 0.9;
                      final idealWidth = maxPossibleHeight * a4Ratio;
                      
                      if (idealWidth <= maxPossibleWidth) {
                        // 이상적인 A4 비율 적용 가능
                        containerHeight = maxPossibleHeight;
                        containerWidth = idealWidth;
                      } else {
                        // 화면 너비에 맞춰 조정
                        containerWidth = maxPossibleWidth;
                        containerHeight = containerWidth / a4Ratio;
                      }
                    }
                  }
                  
                  return Screenshot(
                    controller: _screenshotController,
                    child: Container(
                      width: containerWidth.clamp(100.0, double.infinity),
                      height: containerHeight.clamp(100.0, double.infinity),
                      margin: EdgeInsets.symmetric(
                        horizontal: horizontalMargin,
                        vertical: verticalMargin,
                      ),
                      padding: EdgeInsets.all((horizontalMargin * 0.8).clamp(8.0, 16.0)),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                child: Stack(
                  children: [
                    Column(
                      children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isEditingTitle = true;
                        });
                        // 다음 프레임에서 포커스 요청
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          titleFocusNode.requestFocus();
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: isEditingTitle
                            ? TextField(
                                controller: titleController,
                                focusNode: titleFocusNode,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '페이지 제목을 입력하세요',
                                ),
                                onSubmitted: (value) {
                                  setState(() {
                                    pageTitle = value;
                                    isEditingTitle = false;
                                  });
                                },
                                onTapOutside: (event) {
                                  setState(() {
                                    pageTitle = titleController.text;
                                    isEditingTitle = false;
                                  });
                                },
                                onEditingComplete: () {
                                  setState(() {
                                    pageTitle = titleController.text;
                                    isEditingTitle = false;
                                  });
                                },
                              )
                            : Text(
                                pageTitle,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 5), // 제목과 사진 사이 간격 더 축소
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 40), // 하단 여백 더 확보
                        child: GestureDetector(
                        onTapDown: (details) => _handleCanvasTap(details.localPosition),
                        child: Stack(
                          children: [
                            _buildPhotoLayout(),
                            ..._buildShapeOverlays(),
                          ],
                        ),
                        ),
                      ),
                    ),
                      ],
                    ),
                    // 페이지 번호 표시
                    if (showPageNumbers)
                      Positioned(
                        bottom: 5,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Text(
                            '${startPageNumber + currentPageIndex}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFF8F9FA)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, -4),
              spreadRadius: 2,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, -1),
            ),
          ],
          border: const Border(
            top: BorderSide(color: Color(0xFFE0E0E0), width: 0.5),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavButton(
                icon: Icons.touch_app,
                label: '선택',
                isActive: currentEditMode == 'select',
                onTap: () => setEditMode('select'),
              ),
              _buildNavButton(
                icon: Icons.zoom_in,
                label: '확대',
                onTap: () {
                  if (selectedSlot != null && photoData.containsKey(selectedSlot)) {
                    _zoomPhoto(selectedSlot!);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('확대할 사진을 먼저 선택해주세요')),
                    );
                  }
                },
              ),
              _buildNavButton(
                icon: Icons.center_focus_strong,
                label: '원본',
                onTap: () {
                  if (selectedSlot != null && photoData.containsKey(selectedSlot)) {
                    _resetPhotoPosition(selectedSlot!);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('사진을 먼저 선택해주세요')),
                    );
                  }
                },
              ),
              Container(width: 1, height: 40, color: Colors.grey[300], margin: const EdgeInsets.symmetric(horizontal: 6)),
              _buildNavButton(
                icon: Icons.circle_outlined,
                label: '원',
                isActive: currentEditMode == 'circle',
                onTap: () => setEditMode('circle'),
              ),
              _buildNavButton(
                icon: Icons.crop_square,
                label: '네모',
                isActive: currentEditMode == 'rectangle',
                onTap: () => setEditMode('rectangle'),
              ),
              _buildNavButton(
                icon: Icons.arrow_upward,
                label: '화살',
                isActive: currentEditMode == 'arrow',
                onTap: () => setEditMode('arrow'),
              ),
              Container(width: 1, height: 40, color: Colors.grey[300], margin: const EdgeInsets.symmetric(horizontal: 6)),
              _buildNavButton(
                icon: Icons.rotate_right,
                label: '회전',
                onTap: () {
                  if (selectedShapeIndex != null) {
                    // 선택된 도형(화살표 포함) 회전
                    setState(() {
                      shapes[selectedShapeIndex!].rotation += 90;
                      shapes[selectedShapeIndex!].rotation = shapes[selectedShapeIndex!].rotation % 360;
                    });
                  } else if (selectedSlot != null && photoData.containsKey(selectedSlot)) {
                    // 선택된 사진 회전
                    rotatePhoto(selectedSlot!);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('회전할 사진이나 도형을 먼저 선택해주세요')),
                    );
                  }
                },
              ),
              _buildNavButton(
                icon: Icons.delete,
                label: '지우기',
                onTap: () {
                  if (selectedShapeIndex != null) {
                    setState(() {
                      shapes.removeAt(selectedShapeIndex!);
                      selectedShapeIndex = null;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('도형이 삭제되었습니다')),
                    );
                  } else if (selectedSlot != null && photoData.containsKey(selectedSlot)) {
                    removePhoto(selectedSlot!);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('삭제할 사진이나 도형을 먼저 선택해주세요')),
                    );
                  }
                },
              ),
              _buildNavButton(
                icon: Icons.refresh,
                label: '초기화',
                onTap: () {
                  _showResetDialog();
                },
              ),
            ],
          ),
          ),
        ),
        ),
      ),
    );
  }

  Widget _buildPhotoLayout() {
    switch (photoCount) {
      case 1:
        return _buildSinglePhotoLayout();
      case 2:
        return _buildTwoPhotoLayout();
      case 3:
        return _buildThreePhotoLayout();
      case 4:
      default:
        return _buildFourPhotoLayout();
    }
  }

  Widget _buildSinglePhotoLayout() {
    return _buildPhotoSlot(0);
  }

  Widget _buildTwoPhotoLayout() {
    if (isPortrait) {
      // 세로 모드: 위아래로 배치
      return Column(
        children: [
          Expanded(child: _buildPhotoSlot(0)),
          const SizedBox(height: 8),
          Expanded(child: _buildPhotoSlot(1)),
        ],
      );
    } else {
      // 가로 모드: 좌우로 배치 (세로 모드를 90도 회전한 효과)
      return Row(
        children: [
          Expanded(child: _buildPhotoSlot(0)),
          const SizedBox(width: 8),
          Expanded(child: _buildPhotoSlot(1)),
        ],
      );
    }
  }

  Widget _buildThreePhotoLayout() {
    if (isPortrait) {
      // 세로 모드: 위에 큰 사진, 아래에 작은 사진 2개
      return Column(
        children: [
          Expanded(
            flex: 3,
            child: _buildPhotoSlot(0),
          ),
          const SizedBox(height: 8),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(child: _buildPhotoSlot(1)),
                const SizedBox(width: 8),
                Expanded(child: _buildPhotoSlot(2)),
              ],
            ),
          ),
        ],
      );
    } else {
      // 가로 모드: 왼쪽에 큰 사진, 오른쪽에 작은 사진 2개 (세로 모드를 90도 회전한 효과)
      return Row(
        children: [
          Expanded(
            flex: 3,
            child: _buildPhotoSlot(0),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Expanded(child: _buildPhotoSlot(1)),
                const SizedBox(height: 8),
                Expanded(child: _buildPhotoSlot(2)),
              ],
            ),
          ),
        ],
      );
    }
  }

  Widget _buildFourPhotoLayout() {
    // 세로/가로 모드 모두 2x2 격자 (동일하지만 가로모드에서 공간 활용 개선)
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildPhotoSlot(0)),
              const SizedBox(width: 8),
              Expanded(child: _buildPhotoSlot(1)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildPhotoSlot(2)),
              const SizedBox(width: 8),
              Expanded(child: _buildPhotoSlot(3)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoSlot(int index) {
    final hasPhoto = photoData.containsKey(index);
    final isSelected = selectedSlot == index;
    final offset = photoOffsets[index] ?? Offset.zero;
    final zoomLevel = photoZoomLevels[index] ?? 0;
    final scale = _getScaleFromZoomLevel(zoomLevel);
    
    return GestureDetector(
      onTap: () => selectSlot(index),
      onLongPress: () {
        if (hasPhoto) {
          showZoomModal(index);
        }
      },
      onPanUpdate: currentEditMode == 'select' && hasPhoto && isSelected
          ? (details) {
              setState(() {
                // 자유로운 드래그 이동 - 제한 없음
                final newOffset = offset + details.delta;
                photoOffsets[index] = newOffset;
              });
            }
          : null,
      child: Container(
        constraints: const BoxConstraints(
          minHeight: 100, // 최소 높이 보장
          minWidth: 100,  // 최소 너비 보장
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? Colors.red
                : Colors.black, // 모든 슬롯에 검은 테두리
            width: isSelected ? 3 : 1, // 선택된 경우 더 두껍게
            style: BorderStyle.solid, // 항상 테두리 표시
          ),
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[50],
        ),
        child: Stack(
          children: [
            if (hasPhoto)
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Transform.translate(
                          offset: offset,
                          child: Transform.scale(
                            scale: scale,
                            child: Transform.rotate(
                              angle: (photoRotations[index] ?? 0) * 3.14159 / 180,
                              child: Center(
                                child: SmartImage(
                                  imageSource: photoData[index]!,
                                  fit: BoxFit.contain, // 가로세로 비율 유지
                                  width: double.infinity,
                                  height: double.infinity,
                                  cacheWidth: 800,
                                  cacheHeight: 600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt, size: 40, color: Colors.grey),
                    SizedBox(height: 8),
                    Text(
                      '사진추가',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            if (hasPhoto)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => _editPhotoTitleInline(index),
                  child: Container(
                    height: 20, // 텍스트 영역 최대 높이 제한
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.95),
                      border: const Border(
                        top: BorderSide(color: Colors.black, width: 1), // 상단 구분선
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(6),
                        bottomRight: Radius.circular(6),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // 슬롯 크기에 따라 폰트 크기 동적 조정
                        double fontSize = 9;
                        if (constraints.maxWidth < 80) {
                          fontSize = 7; // 매우 작은 슬롯
                        } else if (constraints.maxWidth < 120) {
                          fontSize = 8; // 작은 슬롯
                        }
                        
                        return Text(
                          photoTitles[index] ?? '사진제목',
                          style: TextStyle(
                            fontSize: fontSize,
                            color: (photoTitles[index] == null || photoTitles[index]!.isEmpty) 
                                ? Colors.grey 
                                : Colors.black,
                            fontStyle: (photoTitles[index] == null || photoTitles[index]!.isEmpty) 
                                ? FontStyle.italic 
                                : FontStyle.normal,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: false,
                        );
                      },
                    ),
                  ),
                ),
              ),
            if (zoomLevel > 0 && hasPhoto && isSelected)
              Positioned(
                top: 5,
                left: 5,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '확대 $zoomLevel단계',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            if (currentEditMode == 'select' && hasPhoto && isSelected)
              Positioned(
                top: 5,
                left: 5,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    '드래그하여 이동',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _handleCanvasTap(Offset position) {
    if (currentEditMode == 'circle' || currentEditMode == 'rectangle' || currentEditMode == 'arrow') {
      setState(() {
        shapes.add(ShapeOverlay(
          type: currentEditMode,
          position: position,
        ));
        // 도형 추가 후 선택 모드로 자동 전환
        currentEditMode = 'select';
      });
    }
  }

  List<Widget> _buildShapeOverlays() {
    return shapes.asMap().entries.map((entry) {
      final index = entry.key;
      final shape = entry.value;
      final isSelected = selectedShapeIndex == index;
      
      return Positioned(
        left: shape.position.dx - shape.size / 2,
        top: shape.position.dy - shape.size / 2,
        child: GestureDetector(
          onTap: () {
            // 단일 탭은 무시 (더블탭만 처리)
          },
          onDoubleTap: () {
            setState(() {
              selectedShapeIndex = isSelected ? null : index;
              selectedSlot = null; // 도형 선택시 사진 선택 해제
            });
          },
          onPanUpdate: isSelected ? (details) {
            setState(() {
              shape.position = Offset(
                shape.position.dx + details.delta.dx,
                shape.position.dy + details.delta.dy,
              );
            });
          } : null,
          child: Transform.rotate(
            angle: shape.rotation * 3.14159 / 180,
            child: Container(
              width: shape.size,
              height: shape.size,
              decoration: shape.type == 'arrow' 
                  ? null
                  : BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        color: isSelected ? Colors.red : shape.color,
                        width: 2,
                      ),
                      shape: shape.type == 'circle' ? BoxShape.circle : BoxShape.rectangle,
                    ),
              child: shape.type == 'arrow'
                  ? Stack(
                      children: [
                        Icon(
                          Icons.arrow_upward,
                          size: shape.size,
                          color: isSelected ? Colors.red : shape.color,
                        ),
                        if (isSelected) ...[
                          // 크기 조절 핸들
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: GestureDetector(
                              onPanUpdate: (details) {
                                setState(() {
                                  shape.size += details.delta.dx;
                                  if (shape.size < 20) shape.size = 20;
                                  if (shape.size > 200) shape.size = 200;
                                });
                              },
                              child: Container(
                                width: 16,
                                height: 16,
                                decoration: const BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.zoom_in,
                                  size: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    )
                  : isSelected
                      ? Stack(
                          children: [
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: GestureDetector(
                                onPanUpdate: (details) {
                                  setState(() {
                                    shape.size += details.delta.dx;
                                    if (shape.size < 20) shape.size = 20;
                                    if (shape.size > 200) shape.size = 200;
                                  });
                                },
                                child: Container(
                                  width: 16,
                                  height: 16,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.drag_indicator,
                                    size: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : null,
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildNavButton({
    required IconData icon,
    required String label,
    bool isActive = false,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            gradient: isActive 
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
                )
              : null,
            color: isActive ? null : Colors.grey[50],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isActive ? Colors.transparent : const Color(0xFFE0E0E0),
              width: 1,
            ),
            boxShadow: isActive 
              ? [
                  BoxShadow(
                    color: Colors.blue.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 22,
                color: isActive ? Colors.white : const Color(0xFF424242),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.white : const Color(0xFF424242),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  void _showSaveConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('💾 갤러리에 저장'),
          content: Text('${pages.length}개의 페이지를 모두 갤러리에 저장하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('취소'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _exportPagesToGallery();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('저장'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _exportPagesToGallery() async {
    try {
      // 권한 확인 및 요청
      if (!kIsWeb) {
        if (!await Gal.hasAccess()) {
          await Gal.requestAccess();
          if (!await Gal.hasAccess()) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('갤러리 저장을 위해 권한이 필요합니다.')),
              );
            }
            return;
          }
        }
      }

      _saveCurrentPageData(); // 현재 페이지 저장
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('페이지를 갤러리에 저장하는 중...')),
        );
      }
      
      int savedCount = 0;
      
      for (int pageIndex = 0; pageIndex < pages.length; pageIndex++) {
        // 페이지 로드
        _loadPageData(pageIndex);
        
        // UI 업데이트를 위한 대기
        await Future.delayed(const Duration(milliseconds: 500));
        
        // 스크린샷 캡처
        final Uint8List? imageBytes = await _screenshotController.capture(
          delay: const Duration(milliseconds: 200),
        );
        
        if (imageBytes != null) {
          if (kIsWeb) {
            // 웹에서는 기존 방식 유지
            savedCount++;
          } else {
            // 모바일에서 갤러리에 저장
            try {
              await Gal.putImageBytes(
                imageBytes,
                name: 'EZPHOTO_Page_${pageIndex + 1}_${DateTime.now().millisecondsSinceEpoch}',
              );
              
              savedCount++;
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('페이지 ${pageIndex + 1} 저장 완료'),
                    duration: const Duration(milliseconds: 600),
                  ),
                );
              }
            } catch (saveError) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('페이지 ${pageIndex + 1} 저장 실패: $saveError'),
                    duration: const Duration(milliseconds: 600),
                  ),
                );
              }
            }
          }
        }
        
        // 다음 페이지 처리 전 짧은 대기
        if (pageIndex < pages.length - 1) {
          await Future.delayed(const Duration(milliseconds: 300));
        }
      }
      
      // 최종 결과 메시지
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ $savedCount개 페이지가 갤러리에 저장되었습니다!'),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('갤러리 저장 중 오류가 발생했습니다: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}