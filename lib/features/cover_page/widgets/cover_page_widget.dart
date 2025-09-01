import 'package:flutter/material.dart';

import '../models/cover_page_data.dart';
import '../../../core/constants/constants.dart';
import '../../quotation/widgets/quotation_template.dart';

/// Cover page widget for displaying various template types
/// 
/// This widget handles different templates including:
/// - Report template
/// - Proposal template
/// - Album template
/// - Document template
/// - Quotation template
/// - Photo text template
/// - Text only template
class CoverPageWidget extends StatelessWidget {
  final CoverPageData coverData;
  final bool isForExport;
  final Function(String fieldType, {int? textLineIndex})? onFieldTap;
  
  const CoverPageWidget({
    super.key,
    required this.coverData,
    this.isForExport = false,
    this.onFieldTap,
  });
  
  @override
  Widget build(BuildContext context) {
    switch (coverData.template) {
      case 'report':
        return _buildReportTemplate();
      case 'proposal':
        return _buildProposalTemplate();
      case 'album':
        return _buildAlbumTemplate();
      case 'document':
        return _buildDocumentTemplate();
      case 'quotation':
      case 'quotation_ko':
        return QuotationTemplate(
          coverData: coverData,
          isForExport: isForExport,
          onFieldTap: onFieldTap,
        );
      case 'photo_text':
        return _buildPhotoTextTemplate();
      case 'text_only':
        return _buildTextOnlyTemplate();
      default:
        return Container();
    }
  }
  
  Widget _buildReportTemplate() {
    return Container(
      color: AppColors.white,
      height: isForExport ? AppDimensions.a4Height : null, // A4 height for export, flexible height for preview
      child: Stack(
        children: [
          // 상단 색상 바
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: isForExport ? 80 : 60,
              width: double.infinity,
              color: coverData.primaryColor,
            ),
          ),
          // 중앙 콘텐츠
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingXL, 
                vertical: isForExport ? AppDimensions.coverPagePadding * 2.5 : AppDimensions.paddingLG
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 제목
                  GestureDetector(
                    onTap: isForExport ? null : () => onFieldTap?.call('title'),
                    child: Container(
                      padding: const EdgeInsets.all(AppDimensions.paddingSM),
                      decoration: BoxDecoration(
                        border: isForExport ? null : Border.all(
                          color: AppColors.transparent,
                          width: AppDimensions.borderWidthNormal,
                        ),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
                      ),
                      child: Text(
                        coverData.title.isEmpty ? '제목을 터치하여 편집' : coverData.title,
                        style: TextStyle(
                          fontSize: isForExport ? AppDimensions.fontSizeLarge : AppDimensions.fontSizeTitle,
                          fontWeight: FontWeight.bold,
                          color: coverData.title.isEmpty ? AppColors.textHint : AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingSM),
                  // 부제목
                  GestureDetector(
                    onTap: isForExport ? null : () => onFieldTap?.call('subtitle'),
                    child: Container(
                      padding: const EdgeInsets.all(AppDimensions.paddingSM),
                      child: Text(
                        coverData.subtitle.isEmpty ? '부제목을 터치하여 편집' : coverData.subtitle,
                        style: TextStyle(
                          fontSize: isForExport ? AppDimensions.fontSizeXXL : AppDimensions.fontSizeLG,
                          color: coverData.subtitle.isEmpty ? AppColors.textHint : AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // 하단 정보
                  Column(
                    children: [
                      GestureDetector(
                        onTap: isForExport ? null : () => onFieldTap?.call('organization'),
                        child: Container(
                          padding: const EdgeInsets.all(AppDimensions.paddingSM),
                          child: Text(
                            (coverData.organization?.isEmpty ?? true) ? '조직/기관을 터치하여 편집' : coverData.organization!,
                            style: TextStyle(
                              fontSize: isForExport ? AppDimensions.fontSizeLG : AppDimensions.fontSizeMD,
                              fontWeight: FontWeight.w500,
                              color: (coverData.organization?.isEmpty ?? true) ? AppColors.textHint : AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacingSM),
                      GestureDetector(
                        onTap: isForExport ? null : () => onFieldTap?.call('author'),
                        child: Container(
                          padding: const EdgeInsets.all(AppDimensions.paddingSM),
                          child: Text(
                            coverData.author.isEmpty ? '작성자를 터치하여 편집' : coverData.author,
                            style: TextStyle(
                              fontSize: isForExport ? AppDimensions.fontSizeMD : AppDimensions.fontSizeSM,
                              color: coverData.author.isEmpty ? AppColors.textHint : AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacingSM),
                      GestureDetector(
                        onTap: isForExport ? null : () => onFieldTap?.call('date'),
                        child: Container(
                          padding: const EdgeInsets.all(AppDimensions.paddingSM),
                          child: Text(
                            coverData.date.isEmpty ? '날짜를 터치하여 편집' : coverData.date,
                            style: TextStyle(
                              fontSize: isForExport ? AppDimensions.fontSizeSM : AppDimensions.fontSizeXS,
                              color: coverData.date.isEmpty ? AppColors.textHint : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // 하단 색상 바
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: isForExport ? 50 : 40,
              width: double.infinity,
              color: coverData.primaryColor.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildProposalTemplate() {
    return Container(
      height: isForExport ? AppDimensions.a4Height : null, // A4 height for export, flexible height for preview
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            coverData.primaryColor.withValues(alpha: 0.1),
            AppColors.white,
          ],
        ),
      ),
      child: Stack(
        children: [
          // 장식 요소
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: coverData.primaryColor.withValues(alpha: 0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -30,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: coverData.primaryColor.withValues(alpha: 0.08),
              ),
            ),
          ),
          // 내용
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingXL, 
                vertical: isForExport ? AppDimensions.coverPagePadding * 2.5 : AppDimensions.paddingLG
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                // 제목
                Container(
                  padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingXS * 2.5),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: coverData.primaryColor,
                        width: AppDimensions.borderWidthExtra,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: AppDimensions.paddingLG - 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: isForExport ? null : () => onFieldTap?.call('title'),
                          child: Container(
                            padding: const EdgeInsets.all(AppDimensions.paddingSM),
                            child: Text(
                              coverData.title.isEmpty ? '제목을 터치하여 편집' : coverData.title,
                              style: TextStyle(
                                fontSize: isForExport ? AppDimensions.fontSizeLarge : 26,
                                fontWeight: FontWeight.bold,
                                color: coverData.title.isEmpty ? AppColors.textHint : coverData.primaryColor,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spacingXS * 2.5),
                        GestureDetector(
                          onTap: isForExport ? null : () => onFieldTap?.call('subtitle'),
                          child: Container(
                            padding: const EdgeInsets.all(AppDimensions.paddingSM),
                            child: Text(
                              coverData.subtitle.isEmpty ? '부제목을 터치하여 편집' : coverData.subtitle,
                              style: TextStyle(
                                fontSize: isForExport ? AppDimensions.fontSizeXXL : AppDimensions.fontSizeXL,
                                color: coverData.subtitle.isEmpty ? AppColors.textHint : AppColors.textSecondary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // 하단 정보
                Align(
                  alignment: Alignment.bottomRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: isForExport ? null : () => onFieldTap?.call('organization'),
                        child: Container(
                          padding: const EdgeInsets.all(AppDimensions.paddingSM),
                          child: Text(
                            (coverData.organization?.isEmpty ?? true) ? '조직/기관을 터치하여 편집' : coverData.organization!,
                            style: TextStyle(
                              fontSize: isForExport ? AppDimensions.fontSizeLG : AppDimensions.fontSizeMD,
                              fontWeight: FontWeight.w600,
                              color: (coverData.organization?.isEmpty ?? true) ? AppColors.textHint : coverData.primaryColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacingSM),
                      GestureDetector(
                        onTap: isForExport ? null : () => onFieldTap?.call('author'),
                        child: Container(
                          padding: const EdgeInsets.all(AppDimensions.paddingSM),
                          child: Text(
                            coverData.author.isEmpty ? '작성자를 터치하여 편집' : coverData.author,
                            style: TextStyle(
                              fontSize: isForExport ? AppDimensions.fontSizeMD : AppDimensions.fontSizeSM,
                              color: coverData.author.isEmpty ? AppColors.textHint : AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacingXS),
                      GestureDetector(
                        onTap: isForExport ? null : () => onFieldTap?.call('date'),
                        child: Container(
                          padding: const EdgeInsets.all(AppDimensions.paddingSM),
                          child: Text(
                            coverData.date.isEmpty ? '날짜를 터치하여 편집' : coverData.date,
                            style: TextStyle(
                              fontSize: isForExport ? AppDimensions.fontSizeSM : AppDimensions.fontSizeXS,
                              color: coverData.date.isEmpty ? AppColors.textHint : AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAlbumTemplate() {
    return Container(
      height: isForExport ? AppDimensions.a4Height : null, // A4 height for export, flexible height for preview
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            coverData.primaryColor.withValues(alpha: 0.3),
            coverData.primaryColor.withValues(alpha: 0.1),
          ],
        ),
      ),
      child: Stack(
        children: [
          // 중앙 콘텐츠
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingXL, 
                vertical: isForExport ? AppDimensions.coverPagePadding * 2.5 : AppDimensions.paddingLG
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 장식 프레임
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(AppDimensions.paddingLG),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: coverData.primaryColor,
                          width: AppDimensions.borderWidthBold,
                        ),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.photo_album,
                            size: isForExport ? AppDimensions.iconXXL + 16 : AppDimensions.iconXL + 12,
                            color: coverData.primaryColor,
                          ),
                          const SizedBox(height: AppDimensions.spacingLG + 6),
                          GestureDetector(
                            onTap: isForExport ? null : () => onFieldTap?.call('title'),
                            child: Container(
                              padding: const EdgeInsets.all(AppDimensions.paddingSM),
                              child: Text(
                                coverData.title.isEmpty ? '제목을 터치하여 편집' : coverData.title,
                                style: TextStyle(
                                  fontSize: isForExport ? AppDimensions.fontSizeLarge : 26,
                                  fontWeight: FontWeight.bold,
                                  color: coverData.title.isEmpty ? AppColors.textHint : coverData.primaryColor,
                                  fontFamily: 'serif',
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppDimensions.spacingMD - 1),
                          GestureDetector(
                            onTap: isForExport ? null : () => onFieldTap?.call('subtitle'),
                            child: Container(
                              padding: const EdgeInsets.all(AppDimensions.paddingSM),
                              child: Text(
                                coverData.subtitle.isEmpty ? '부제목을 터치하여 편집' : coverData.subtitle,
                                style: TextStyle(
                                  fontSize: isForExport ? AppDimensions.fontSizeXL : AppDimensions.fontSizeLG,
                                  color: coverData.subtitle.isEmpty ? AppColors.textHint : AppColors.textSecondary,
                                  fontStyle: FontStyle.italic,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingLG + 6),
                  // 작성자와 날짜
                  Column(
                    children: [
                      GestureDetector(
                        onTap: isForExport ? null : () => onFieldTap?.call('author'),
                        child: Container(
                          padding: const EdgeInsets.all(AppDimensions.paddingSM),
                          child: Text(
                            coverData.author.isEmpty ? '작성자를 터치하여 편집' : coverData.author,
                            style: TextStyle(
                              fontSize: isForExport ? AppDimensions.fontSizeLG : AppDimensions.fontSizeMD,
                              fontWeight: FontWeight.w500,
                              color: coverData.author.isEmpty ? AppColors.textHint : AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacingSM),
                      GestureDetector(
                        onTap: isForExport ? null : () => onFieldTap?.call('date'),
                        child: Container(
                          padding: const EdgeInsets.all(AppDimensions.paddingSM),
                          child: Text(
                            coverData.date.isEmpty ? '날짜를 터치하여 편집' : coverData.date,
                            style: TextStyle(
                              fontSize: isForExport ? AppDimensions.fontSizeMD : AppDimensions.fontSizeSM,
                              color: coverData.date.isEmpty ? AppColors.textHint : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDocumentTemplate() {
    return Container(
      color: AppColors.grey50,
      height: isForExport ? AppDimensions.a4Height : null, // A4 height for export, flexible height for preview
      child: Stack(
        children: [
          // 상단 헤더
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.paddingLG),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    coverData.primaryColor,
                    coverData.primaryColor.withValues(alpha: 0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.description,
                    color: AppColors.white,
                    size: isForExport ? AppDimensions.iconXL + 8 : AppDimensions.iconLG + 8,
                  ),
                  const SizedBox(width: AppDimensions.spacingLG),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PHOTO REPORT',
                          style: TextStyle(
                            color: AppColors.white.withValues(alpha: 0.9),
                            fontSize: isForExport ? AppDimensions.fontSizeMD : AppDimensions.fontSizeSM,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spacingXS + 1),
                        GestureDetector(
                          onTap: isForExport ? null : () => onFieldTap?.call('title'),
                          child: Container(
                            padding: const EdgeInsets.all(AppDimensions.paddingSM),
                            child: Text(
                              coverData.title.isEmpty ? '제목을 터치하여 편집' : coverData.title,
                              style: TextStyle(
                                color: coverData.title.isEmpty ? AppColors.white.withValues(alpha: 0.7) : AppColors.white,
                                fontSize: isForExport ? AppDimensions.fontSizeHeading : AppDimensions.fontSizeTitle,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 중앙 콘텐츠
          Positioned.fill(
            top: isForExport ? 120 : 120,
            bottom: isForExport ? 120 : 120,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: isForExport ? null : () => onFieldTap?.call('subtitle'),
                    child: Container(
                      padding: const EdgeInsets.all(AppDimensions.paddingLG),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusXS * 5),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadowLight,
                            spreadRadius: AppDimensions.shadowSpreadRadius,
                            blurRadius: AppDimensions.shadowBlurRadius / 2,
                          ),
                        ],
                      ),
                      child: Text(
                        coverData.subtitle.isEmpty ? '부제목을 터치하여 편집' : coverData.subtitle,
                        style: TextStyle(
                          fontSize: isForExport ? AppDimensions.fontSizeXXL : AppDimensions.fontSizeXL,
                          color: coverData.subtitle.isEmpty ? AppColors.textHint : AppColors.grey800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 하단 정보
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.paddingLG + 6),
              color: AppColors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: isForExport ? null : () => onFieldTap?.call('organization'),
                        child: Container(
                          padding: const EdgeInsets.all(AppDimensions.paddingSM),
                          child: Text(
                            (coverData.organization?.isEmpty ?? true) ? '조직/기관을 터치하여 편집' : coverData.organization!,
                            style: TextStyle(
                              fontSize: isForExport ? AppDimensions.fontSizeLG : AppDimensions.fontSizeMD,
                              fontWeight: FontWeight.w600,
                              color: (coverData.organization?.isEmpty ?? true) ? AppColors.textHint : coverData.primaryColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacingXS),
                      GestureDetector(
                        onTap: isForExport ? null : () => onFieldTap?.call('author'),
                        child: Container(
                          padding: const EdgeInsets.all(AppDimensions.paddingSM),
                          child: Text(
                            coverData.author.isEmpty ? '작성자를 터치하여 편집' : coverData.author,
                            style: TextStyle(
                              fontSize: isForExport ? AppDimensions.fontSizeMD : AppDimensions.fontSizeSM,
                              color: coverData.author.isEmpty ? AppColors.textHint : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Date',
                        style: TextStyle(
                          fontSize: isForExport ? AppDimensions.fontSizeSM : AppDimensions.fontSizeXS,
                          color: AppColors.grey500,
                        ),
                      ),
                      GestureDetector(
                        onTap: isForExport ? null : () => onFieldTap?.call('date'),
                        child: Container(
                          padding: const EdgeInsets.all(AppDimensions.paddingSM),
                          child: Text(
                            coverData.date.isEmpty ? '날짜를 터치하여 편집' : coverData.date,
                            style: TextStyle(
                              fontSize: isForExport ? AppDimensions.fontSizeMD : AppDimensions.fontSizeSM,
                              fontWeight: FontWeight.w500,
                              color: coverData.date.isEmpty ? AppColors.textHint : AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPhotoTextTemplate() {
    return Container(
      color: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLG),
        child: Column(
          children: [
            // 제목
            GestureDetector(
              onTap: isForExport ? null : () => onFieldTap?.call('title'),
              child: Container(
                padding: const EdgeInsets.all(AppDimensions.paddingSM),
                child: Text(
                  coverData.title.isEmpty ? '제목을 터치하여 편집' : coverData.title,
                  style: TextStyle(
                    fontSize: isForExport ? AppDimensions.fontSizeTitle : AppDimensions.fontSizeXXL,
                    fontWeight: FontWeight.bold,
                    color: coverData.title.isEmpty ? AppColors.textHint : coverData.primaryColor,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.spacingLG),
            // 사진 영역
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.grey100,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXS * 5),
                  border: Border.all(color: AppColors.grey300),
                ),
                child: coverData.photoPath != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusXS * 5),
                        child: Image.network(
                          coverData.photoPath!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildPhotoPlaceholder();
                          },
                        ),
                      )
                    : _buildPhotoPlaceholder(),
              ),
            ),
            const SizedBox(height: AppDimensions.spacingLG),
            // 텍스트 영역
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppDimensions.paddingLG),
                decoration: BoxDecoration(
                  color: AppColors.grey50,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXS * 5),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...coverData.textLines
                          .asMap()
                          .entries
                          .map((entry) {
                            final index = entry.key;
                            final line = entry.value;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: AppDimensions.spacingSM),
                              child: GestureDetector(
                                onTap: isForExport ? null : () => onFieldTap?.call('textLine', textLineIndex: index),
                                child: Container(
                                  padding: const EdgeInsets.all(AppDimensions.paddingSM),
                                  child: Text(
                                    line.trim().isEmpty ? '텍스트를 터치하여 편집' : line,
                                    style: TextStyle(
                                      fontSize: isForExport ? AppDimensions.fontSizeMD : AppDimensions.fontSizeSM,
                                      height: 1.4,
                                      color: line.trim().isEmpty ? AppColors.textHint : AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                      // Add more lines if needed
                      if (coverData.textLines.length < 10)
                        ...List.generate(10 - coverData.textLines.length, (index) {
                          final actualIndex = coverData.textLines.length + index;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: AppDimensions.spacingSM),
                            child: GestureDetector(
                              onTap: isForExport ? null : () => onFieldTap?.call('textLine', textLineIndex: actualIndex),
                              child: Container(
                                padding: const EdgeInsets.all(AppDimensions.paddingSM),
                                child: Text(
                                  '텍스트를 터치하여 편집',
                                  style: TextStyle(
                                    fontSize: isForExport ? AppDimensions.fontSizeMD : AppDimensions.fontSizeSM,
                                    height: 1.4,
                                    color: AppColors.textHint,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTextOnlyTemplate() {
    return Container(
      color: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingXL + 6),
        child: Column(
          children: [
            // 제목
            GestureDetector(
              onTap: isForExport ? null : () => onFieldTap?.call('title'),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingLG),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: coverData.primaryColor,
                      width: AppDimensions.borderWidthBold,
                    ),
                  ),
                ),
                child: Text(
                  coverData.title.isEmpty ? '제목을 터치하여 편집' : coverData.title,
                  style: TextStyle(
                    fontSize: isForExport ? AppDimensions.fontSizeHeading : AppDimensions.fontSizeTitle,
                    fontWeight: FontWeight.bold,
                    color: coverData.title.isEmpty ? AppColors.textHint : coverData.primaryColor,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.spacingLG + 6),
            // 텍스트 내용
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...coverData.textLines
                        .asMap()
                        .entries
                        .map((entry) {
                          final index = entry.key;
                          final line = entry.value;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: AppDimensions.spacingMD),
                            child: GestureDetector(
                              onTap: isForExport ? null : () => onFieldTap?.call('textLine', textLineIndex: index),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(AppDimensions.paddingSM + 4),
                                decoration: BoxDecoration(
                                  color: coverData.primaryColor.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                                  border: Border.all(
                                    color: coverData.primaryColor.withValues(alpha: 0.2),
                                  ),
                                ),
                                child: Text(
                                  line.trim().isEmpty ? '텍스트를 터치하여 편집' : line,
                                  style: TextStyle(
                                    fontSize: isForExport ? AppDimensions.fontSizeLG : AppDimensions.fontSizeMD,
                                    height: 1.5,
                                    color: line.trim().isEmpty ? AppColors.textHint : AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                    // Add more lines if needed
                    if (coverData.textLines.length < 10)
                      ...List.generate(10 - coverData.textLines.length, (index) {
                        final actualIndex = coverData.textLines.length + index;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppDimensions.spacingMD),
                          child: GestureDetector(
                            onTap: isForExport ? null : () => onFieldTap?.call('textLine', textLineIndex: actualIndex),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(AppDimensions.paddingSM + 4),
                              decoration: BoxDecoration(
                                color: coverData.primaryColor.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                                border: Border.all(
                                  color: coverData.primaryColor.withValues(alpha: 0.2),
                                ),
                              ),
                              child: Text(
                                '텍스트를 터치하여 편집',
                                style: TextStyle(
                                  fontSize: isForExport ? AppDimensions.fontSizeLG : AppDimensions.fontSizeMD,
                                  height: 1.5,
                                  color: AppColors.textHint,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPhotoPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.add_photo_alternate,
          size: isForExport ? AppDimensions.iconXL + 12 : AppDimensions.iconLG + 10,
          color: AppColors.textHint,
        ),
        const SizedBox(height: AppDimensions.spacingXS * 2.5),
        Text(
          '사진을 추가하세요',
          style: TextStyle(
            color: AppColors.grey500,
            fontSize: isForExport ? AppDimensions.fontSizeLG : AppDimensions.fontSizeMD,
          ),
        ),
      ],
    );
  }
}