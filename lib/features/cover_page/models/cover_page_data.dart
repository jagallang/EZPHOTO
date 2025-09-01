import 'dart:ui';

/// 커버 페이지 데이터 모델
class CoverPageData {
  String template; // 'report', 'proposal', 'album', 'document', 'quotation', 'photo_text', 'text_only', 'none'
  String title;
  String subtitle;
  String author;
  String date;
  String? description;
  String? organization;
  String? additionalInfo;
  String? customerName; // 견적서용
  Color primaryColor;
  Color secondaryColor;
  
  // 사진 및 텍스트 관련 필드
  String? photoPath;
  List<String> textLines;
  
  // 견적서용 필드
  String? logoImage; // Base64 encoded
  String? estNo;
  String? supplierCompany;
  String? supplierContact;
  String? supplierTel;
  String? supplierEmail;
  String? customerCompany;
  String? customerAddress;
  String? customerTel;
  String? customerEmail;
  String? projectName;
  String? totalAmount;
  Map<String, String> tableData; // 테이블 데이터 저장용
  
  // 인보이스용 결제 안내사항 (3줄)
  List<String>? paymentNoticeLines;
  
  CoverPageData({
    this.template = 'none',
    this.title = '',
    this.subtitle = '',
    this.author = '',
    this.date = '',
    this.description,
    this.organization,
    this.additionalInfo,
    this.customerName,
    this.primaryColor = const Color(0xFF2196F3),
    this.secondaryColor = const Color(0xFF1976D2),
    this.photoPath,
    List<String>? textLines,
    this.logoImage,
    this.estNo,
    this.supplierCompany,
    this.supplierContact,
    this.supplierTel,
    this.supplierEmail,
    this.customerCompany,
    this.customerAddress,
    this.customerTel,
    this.customerEmail,
    this.projectName,
    this.totalAmount,
    Map<String, String>? tableData,
    this.paymentNoticeLines,
  }) : textLines = textLines ?? List.filled(10, ''),
       tableData = tableData ?? {};
}