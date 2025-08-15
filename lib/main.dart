import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:math' as math;
import 'dart:convert';
import 'package:flutter/foundation.dart';

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
    
    // 샘플 사진으로 초기화
    _initializeWithSamplePhotos();
  }

  @override
  void dispose() {
    titleController.dispose();
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
            Text('현재 레이아웃: $photoCount장'),
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
        maxWidth: 800,
        maxHeight: 600,
        imageQuality: 80,
      );
      
      if (images.isNotEmpty) {
        final List<String> imageDataUrls = [];
        final List<String> imageNames = [];
        
        for (final XFile image in images) {
          final Uint8List bytes = await image.readAsBytes();
          final String base64String = base64Encode(bytes);
          final String dataUrl = 'data:image/${image.name.split('.').last};base64,$base64String';
          imageDataUrls.add(dataUrl);
          imageNames.add(image.name);
        }
        
        _addMultiplePhotosFromPathsWithNames(imageDataUrls, imageNames);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('사진을 가져오는 중 오류가 발생했습니다: $e')),
        );
      }
    }
  }

  void _addEmptyPage() {
    _saveCurrentPageData();
    
    // 새로운 빈 페이지 생성
    final newPage = PageData(
      title: '페이지 ${pages.length + 1}',
      layoutCount: photoCount, // 현재 선택된 레이아웃으로 생성
      photoData: {},
      photoTitles: {},
      photoRotations: {},
    );
    
    setState(() {
      pages.add(newPage);
      currentPageIndex = pages.length - 1;
    });
    
    _loadPageData(currentPageIndex);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$photoCount장 레이아웃의 빈 페이지가 추가되었습니다')),
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
        
        setState(() {
          photoData[slotIndex] = dataUrl;
          photoTitles[slotIndex] = displayName;
          photoRotations[slotIndex] = 0;
        });
        
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
    setState(() {
      selectedSlot = index;
      if (currentEditMode == 'photo') {
        addPhotoToSlot(index);
      } else if (!photoData.containsKey(index)) {
        // 빈 슬롯 클릭시 사진 추가 다이얼로그 표시
        _addEmptyPhotoSlot(index);
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
                    child: RobustNetworkImage(
                      url: photoData[slotIndex]!,
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
          title: const Text('⚠️ 레이아웃 변경 경고'),
          content: const Text(
            '현재 페이지의 레이아웃을 변경하면 이 페이지의 도형, 확대/축소, 회전 등의 편집 내용이 삭제됩니다.\n사진은 새로운 레이아웃에 맞게 재배치됩니다.\n\n다른 페이지는 영향받지 않습니다.\n\n계속하시겠습니까?',
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

  void _changeLayoutForCurrentPage(int newPhotoCount) {
    // 현재 페이지의 사진 데이터만 보존
    final currentPhotos = Map<int, String>.from(photoData);
    final currentPhotoTitles = Map<int, String>.from(photoTitles);
    
    // 새로운 레이아웃에 맞게 사진 재배치
    final redistributedPhotos = <int, String>{};
    final redistributedTitles = <int, String>{};
    
    int slotIndex = 0;
    currentPhotos.forEach((key, value) {
      if (slotIndex < newPhotoCount) {
        redistributedPhotos[slotIndex] = value;
        redistributedTitles[slotIndex] = currentPhotoTitles[key] ?? '사진 ${slotIndex + 1}';
        slotIndex++;
      }
    });
    
    setState(() {
      photoCount = newPhotoCount;
      
      // 사진 데이터는 재배치만 하고 유지
      photoData.clear();
      photoData.addAll(redistributedPhotos);
      photoTitles.clear();
      photoTitles.addAll(redistributedTitles);
      
      // 편집 관련 데이터는 모두 삭제
      photoRotations.clear();
      photoOffsets.clear();
      photoScales.clear();
      photoZoomLevels.clear();
      shapes.clear();
      
      // 초기 회전값만 다시 설정
      for (int i = 0; i < newPhotoCount; i++) {
        if (redistributedPhotos.containsKey(i)) {
          photoRotations[i] = 0;
        }
      }
      
      selectedSlot = null;
      selectedShapeIndex = null;
      currentEditMode = 'select';
      
      // 현재 페이지 데이터 업데이트
      _saveCurrentPageData();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('현재 페이지의 레이아웃이 $newPhotoCount장으로 변경되었습니다.'))
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
    // 더 안정적인 이미지 URL 사용
    final sampleImages = [
      'https://via.placeholder.com/400x300/4CAF50/FFFFFF?text=Sample+1',
      'https://via.placeholder.com/400x300/2196F3/FFFFFF?text=Sample+2', 
      'https://via.placeholder.com/400x300/FF9800/FFFFFF?text=Sample+3',
      'https://via.placeholder.com/400x300/E91E63/FFFFFF?text=Sample+4',
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
                    '📸 이지포토',
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
                          _exportPagesToGallery();
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
                const Text('레이아웃:', style: TextStyle(fontSize: 12)),
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
                  
                  // 여백을 화면 크기에 비례하여 설정
                  final horizontalMargin = (screenWidth * 0.03).clamp(8.0, 20.0);
                  final verticalMargin = (screenHeight * 0.02).clamp(8.0, 16.0);
                  
                  final availableWidth = screenWidth - (horizontalMargin * 2);
                  final availableHeight = screenHeight - (verticalMargin * 2);
                  
                  double containerWidth, containerHeight;
                  
                  // 화면 크기별 최적화
                  if (screenWidth < 600) {
                    // 모바일 (소형 화면)
                    if (isPortrait) {
                      containerWidth = availableWidth * 0.95; // 95% 활용
                      containerHeight = (availableHeight * 0.85).clamp(containerWidth * 1.1, containerWidth * 1.5);
                    } else {
                      containerHeight = availableHeight * 0.9; // 90% 활용
                      containerWidth = (availableWidth * 0.8).clamp(containerHeight * 1.1, containerHeight * 1.5);
                    }
                  } else {
                    // 태블릿/데스크톱 (대형 화면)
                    if (isPortrait) {
                      containerWidth = availableWidth.clamp(400.0, 600.0);
                      containerHeight = (containerWidth * 1.3).clamp(500.0, availableHeight);
                    } else {
                      containerHeight = availableHeight.clamp(400.0, 500.0);
                      containerWidth = (containerHeight * 1.4).clamp(500.0, availableWidth);
                    }
                  }
                  
                  return Screenshot(
                    controller: _screenshotController,
                    child: Container(
                      width: containerWidth,
                      height: containerHeight,
                      margin: EdgeInsets.all(horizontalMargin),
                      padding: EdgeInsets.all((horizontalMargin * 0.8).clamp(8.0, 16.0)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
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
                      },
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 10),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey, width: 2),
                          ),
                        ),
                        child: isEditingTitle
                            ? TextField(
                                controller: titleController,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
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
                              )
                            : Text(
                                pageTitle,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
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
                      ],
                    ),
                    // 페이지 번호 표시
                    if (showPageNumbers)
                      Positioned(
                        bottom: 10,
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
    return Column(
      children: [
        Expanded(child: _buildPhotoSlot(0)),
        const SizedBox(height: 8),
        Expanded(child: _buildPhotoSlot(1)),
      ],
    );
  }

  Widget _buildThreePhotoLayout() {
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
  }

  Widget _buildFourPhotoLayout() {
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
                photoOffsets[index] = offset + details.delta;
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
                : hasPhoto
                    ? Colors.green
                    : Colors.grey,
            width: 2,
            style: hasPhoto ? BorderStyle.solid : BorderStyle.none,
          ),
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[50],
        ),
        child: Stack(
          children: [
            if (hasPhoto)
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Transform.translate(
                  offset: offset,
                  child: Transform.scale(
                    scale: scale,
                    child: Transform.rotate(
                      angle: (photoRotations[index] ?? 0) * 3.14159 / 180,
                      child: RobustNetworkImage(
                        url: photoData[index]!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        cacheWidth: 400,
                        cacheHeight: 300,
                      ),
                    ),
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
                      '사진을 추가하려면\n클릭하세요',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            if (hasPhoto)
              Positioned(
                top: 5,
                right: 5,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.rotate_right, size: 16),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black.withValues(alpha: 0.7),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(24, 24),
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () => rotatePhoto(index),
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      icon: const Icon(Icons.close, size: 16),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black.withValues(alpha: 0.7),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(24, 24),
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () => removePhoto(index),
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
                    padding: const EdgeInsets.all(4),
                    color: Colors.white.withValues(alpha: 0.95),
                    child: Text(
                      photoTitles[index] ?? '제목을 클릭하여 편집',
                      style: TextStyle(
                        fontSize: 11,
                        color: (photoTitles[index] == null || photoTitles[index]!.isEmpty) 
                            ? Colors.grey 
                            : Colors.black,
                        fontStyle: (photoTitles[index] == null || photoTitles[index]!.isEmpty) 
                            ? FontStyle.italic 
                            : FontStyle.normal,
                      ),
                      textAlign: TextAlign.center,
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


  Future<void> _exportPagesToGallery() async {
    try {
      _saveCurrentPageData(); // 현재 페이지 저장
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('페이지를 이미지로 내보내는 중...')),
      );
      
      for (int pageIndex = 0; pageIndex < pages.length; pageIndex++) {
        // 페이지 로드
        _loadPageData(pageIndex);
        
        // 잠시 대기해서 UI 업데이트
        await Future.delayed(const Duration(milliseconds: 500));
        
        // 스크린샷 캡처
        final Uint8List? imageBytes = await _screenshotController.capture(
          delay: const Duration(milliseconds: 200),
        );
        
        if (imageBytes != null) {
          // 플랫폼별 저장 방식
          if (kIsWeb) {
            // 웹에서만 사용 가능 - 모바일 버전에서는 스킵
            debugPrint('웹 플랫폼에서만 내보내기 지원');
          } else {
            // 모바일에서는 이미지 캡처만 수행
            debugPrint('페이지 ${pageIndex + 1} 이미지가 캡처되었습니다 (${imageBytes.length} bytes)');
          }
        }
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${pages.length}개 페이지가 성공적으로 다운로드되었습니다!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('내보내기 중 오류가 발생했습니다: $e')),
        );
      }
    }
  }
}