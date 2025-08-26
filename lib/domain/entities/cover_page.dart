import 'package:flutter/material.dart';
import 'estimate_data.dart';

/// Cover page entity for document cover templates
class CoverPage {
  final CoverTemplate template;
  final String title;
  final String subtitle;
  final String author;
  final String date;
  final String organization;
  final String customerName;
  final String projectName;
  final String totalAmount;
  final List<String> textLines;
  final Color primaryColor;
  final Color secondaryColor;
  final String? backgroundImage;
  final EstimateData? estimateData;
  final String locale; // 'ko' for Korean, 'en' for English

  CoverPage({
    this.template = CoverTemplate.none,
    this.title = '',
    this.subtitle = '',
    this.author = '',
    this.date = '',
    this.organization = '',
    this.customerName = '',
    this.projectName = '',
    this.totalAmount = '',
    this.textLines = const [],
    this.primaryColor = Colors.blue,
    this.secondaryColor = Colors.white,
    this.backgroundImage,
    this.estimateData,
    this.locale = 'ko',
  });

  CoverPage copyWith({
    CoverTemplate? template,
    String? title,
    String? subtitle,
    String? author,
    String? date,
    String? organization,
    String? customerName,
    String? projectName,
    String? totalAmount,
    List<String>? textLines,
    Color? primaryColor,
    Color? secondaryColor,
    String? backgroundImage,
    EstimateData? estimateData,
    String? locale,
  }) {
    return CoverPage(
      template: template ?? this.template,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      author: author ?? this.author,
      date: date ?? this.date,
      organization: organization ?? this.organization,
      customerName: customerName ?? this.customerName,
      projectName: projectName ?? this.projectName,
      totalAmount: totalAmount ?? this.totalAmount,
      textLines: textLines ?? this.textLines,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      backgroundImage: backgroundImage ?? this.backgroundImage,
      estimateData: estimateData ?? this.estimateData,
      locale: locale ?? this.locale,
    );
  }
}

enum CoverTemplate {
  none,
  basic,
  modern,
  business,
  academic,
  proposal,
  photoText,
  textOnly,
  estimate,    // 한국어 견적서 템플릿
  estimateEn,  // 영어 견적서 템플릿
}