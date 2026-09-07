import 'package:flutter/widgets.dart' show StringCharacters;

import 'resume_layout_probe.dart';
import 'template_registry.dart';

/// Packs successive records using the selected template's actual A4 layout.
class ResumePageData {
  ResumePageData._();

  static const _sidebarTemplateIds = {
    'otago',
    'berkeley',
    'stanford',
    'monaco',
  };

  static List<Map<String, dynamic>> split(Map<String, dynamic> source) {
    final working = Map<String, dynamic>.from(source);
    final templateId = (working['templateId'] ?? '').toString();
    final usesSidebar = _sidebarTemplateIds.contains(templateId);
    final skills = _list(working['skills']);
    final languages = _list(working['languages'])
        .map(_withoutAutomaticLanguageLevel)
        .toList();
    final pages = <Map<String, dynamic>>[];
    Map<String, dynamic> createPage() => <String, dynamic>{
          ...working,
          'summary': '',
          'workExperiences': <Map<String, dynamic>>[],
          'educationList': <Map<String, dynamic>>[],
          'projects': <Map<String, dynamic>>[],
          'skills': <Map<String, dynamic>>[],
          'languages': <Map<String, dynamic>>[],
          '_sidebarSkills': <Map<String, dynamic>>[],
          '_sidebarLanguages': <Map<String, dynamic>>[],
          '_pageIndex': pages.length,
          '_isFirstPage': pages.isEmpty,
        };
    final probe = ResumeLayoutProbe(TemplateRegistry.getTemplate(templateId));
    final paginator = _MeasuredPaginator(pages, createPage, probe.fits);
    try {
      final pendingSkills = <Map<String, dynamic>>[];
      final pendingLanguages = <Map<String, dynamic>>[];
      for (final section
          in {'skills': skills, 'languages': languages}.entries) {
        final pending =
            section.key == 'skills' ? pendingSkills : pendingLanguages;
        for (final item in section.value) {
          if (templateId == 'lisbon') {
            // Lisbon has an independent aside only on page one. Fill it now,
            // then let any remainder flow into the full-width later pages.
            final aside = paginator.current[section.key] as List;
            aside.add(item);
            if (probe.fits(paginator.current)) continue;
            aside.removeLast();
          }
          pending.add(item);
        }
      }
      paginator.addSummary((working['summary'] ?? '').toString());
      for (final key in ['workExperiences', 'educationList', 'projects']) {
        for (final item in _list(working[key])) {
          paginator.addItem(key, item);
        }
      }
      if (!usesSidebar) {
        for (final skill in pendingSkills) {
          paginator.addItem('skills', skill);
        }
        for (final language in pendingLanguages) {
          paginator.addItem('languages', language);
        }
      }
      paginator.finish();
      if (usesSidebar) {
        // The two fixed-width columns flow independently, then share pages.
        // A long skills list must not push the main column onto a blank page.
        final sidebarPages = <Map<String, dynamic>>[];
        final sidebar = _MeasuredPaginator(
            sidebarPages,
            () => {
                  ...createPage(),
                  '_pageIndex': sidebarPages.length,
                  '_isFirstPage': sidebarPages.isEmpty,
                },
            probe.fits);
        for (final skill in skills) {
          sidebar.addItem('_sidebarSkills', skill);
        }
        for (final language in languages) {
          sidebar.addItem('_sidebarLanguages', language);
        }
        sidebar.finish();
        while (pages.length < sidebarPages.length) {
          pages.add(createPage());
        }
        for (var i = 0; i < sidebarPages.length; i++) {
          pages[i]['_sidebarSkills'] = sidebarPages[i]['_sidebarSkills'];
          pages[i]['_sidebarLanguages'] = sidebarPages[i]['_sidebarLanguages'];
        }
      }
    } finally {
      probe.dispose();
    }
    for (var index = 0; index < pages.length; index++) {
      pages[index]['_pageIndex'] = index;
      pages[index]['_pageCount'] = pages.length;
      pages[index]['_isFirstPage'] = index == 0;
    }
    return pages;
  }

  static Map<String, dynamic> thumbnail(Map<String, dynamic> source) {
    // Cards do not need to paginate an entire CV just to show a small sample.
    final page = Map<String, dynamic>.from(source)
      ..['_isFirstPage'] = true
      ..['_pageIndex'] = 0
      ..['_pageCount'] = 1
      ..['_sidebarSkills'] = source['skills']
      ..['_sidebarLanguages'] = source['languages'];
    page['summary'] = _shorten((page['summary'] ?? '').toString(), 150);
    page['workExperiences'] = _thumbnailItems(
      _list(page['workExperiences']),
      maxItems: 1,
      maxTextLength: 78,
      maxBullets: 1,
    );
    page['educationList'] = _thumbnailItems(
      _list(page['educationList']),
      maxItems: 1,
      maxTextLength: 64,
    );
    page['projects'] = _thumbnailItems(
      _list(page['projects']),
      maxItems: 1,
      maxTextLength: 64,
    );
    page['skills'] = _thumbnailItems(
      _list(page['skills']),
      maxItems: 3,
      maxTextLength: 24,
    );
    page['languages'] = _thumbnailItems(
      _list(page['languages']),
      maxItems: 2,
      maxTextLength: 24,
    );
    page['_sidebarSkills'] = _thumbnailItems(
      _list(page['_sidebarSkills']),
      maxItems: 3,
      maxTextLength: 24,
    );
    page['_sidebarLanguages'] = _thumbnailItems(
      _list(page['_sidebarLanguages']),
      maxItems: 2,
      maxTextLength: 24,
    );
    return page;
  }

  static List<Map<String, dynamic>> _list(dynamic value) {
    if (value is! List) return const [];
    return value.map(_asMap).whereType<Map<String, dynamic>>().toList();
  }

  static Map<String, dynamic>? _asMap(dynamic value) {
    if (value is Map) {
      return value.map((key, item) => MapEntry('$key', item));
    }
    try {
      final json = (value as dynamic).toJson();
      if (json is Map) {
        return json.map((key, item) => MapEntry('$key', item));
      }
    } catch (_) {
      // Unsupported values are ignored instead of dropping the full page.
    }
    return null;
  }

  static Map<String, dynamic> _withoutAutomaticLanguageLevel(
    Map<String, dynamic> item,
  ) {
    final proficiency = (item['proficiency'] ?? '').toString().trim();
    if (proficiency.toLowerCase() != 'intermediate') return item;

    return Map<String, dynamic>.from(item)..['proficiency'] = '';
  }

  static List<Map<String, dynamic>> _thumbnailItems(
    List<Map<String, dynamic>> items, {
    required int maxItems,
    required int maxTextLength,
    int? maxBullets,
  }) =>
      items.take(maxItems).map((item) {
        final compact = <String, dynamic>{};
        for (final entry in item.entries) {
          if (entry.key == 'bulletPoints' && entry.value is List) {
            compact[entry.key] = (entry.value as List)
                .take(maxBullets ?? 0)
                .map((bullet) => _shorten('$bullet', maxTextLength))
                .toList();
          } else if (entry.value is String) {
            compact[entry.key] = _shorten(entry.value as String, maxTextLength);
          } else {
            compact[entry.key] = entry.value;
          }
        }
        return compact;
      }).toList();

  static String _shorten(String value, int limit) {
    final trimmed = value.trim();
    if (trimmed.length <= limit) return trimmed;
    return '${trimmed.substring(0, limit - 1).trimRight()}...';
  }
}

class _MeasuredPaginator {
  _MeasuredPaginator(this.pages, this.createPage, this.fits) {
    current = createPage();
  }

  final List<Map<String, dynamic>> pages;
  final Map<String, dynamic> Function() createPage;
  final bool Function(Map<String, dynamic>) fits;
  late Map<String, dynamic> current;

  bool get hasContent =>
      (current['summary'] as String).isNotEmpty ||
      [
        'workExperiences',
        'educationList',
        'projects',
        'skills',
        'languages',
        '_sidebarSkills',
        '_sidebarLanguages'
      ].any((key) => (current[key] as List).isNotEmpty);

  void nextPage() {
    pages.add(current);
    current = createPage();
  }

  void addSummary(String text) {
    var remaining = text.trim();
    while (remaining.isNotEmpty) {
      final count = _textPrefix(remaining, (prefix) {
        current['summary'] = prefix;
        return fits(current);
      });
      if (count == 0) {
        current['summary'] = '';
        _makeRoom('summary');
        continue;
      }
      current['summary'] = remaining.substring(0, count);
      remaining = remaining.substring(count);
      if (remaining.isNotEmpty) nextPage();
    }
  }

  void addItem(String key, Map<String, dynamic> item) {
    var remaining = item;
    while (true) {
      final items = current[key] as List<Map<String, dynamic>>;
      items.add(remaining);
      if (fits(current)) return;
      items.removeLast();

      // Keep ordinary records together, but split a record larger than a
      // whole page instead of creating blank pages or silently clipping it.
      final empty = createPage()..['_isFirstPage'] = false;
      (empty[key] as List<Map<String, dynamic>>).add(remaining);
      if (fits(empty)) {
        _makeRoom(key);
        continue;
      }
      final field = switch (key) {
        'workExperiences' => 'bulletPoints',
        'educationList' => 'highlights',
        'projects' => 'description',
        _ => '',
      };
      final value = remaining[field];
      final parts =
          value is List ? value.map((v) => '$v').toList() : ['$value'];
      var consumed = 0;
      var splitAt = 0;
      final accepted = <String>[];
      Map<String, dynamic> fragment(List<String> content) => {
            ...remaining,
            field: value is List ? content : content.join(),
          };
      if (field.isNotEmpty && value != null) {
        for (final part in parts) {
          splitAt = _textPrefix(part, (prefix) {
            items.add(fragment([...accepted, prefix]));
            final result = fits(current);
            items.removeLast();
            return result;
          });
          if (splitAt > 0) accepted.add(part.substring(0, splitAt));
          if (splitAt < part.length) break;
          consumed++;
        }
      }
      if (accepted.isEmpty) {
        _makeRoom(key);
        continue;
      }
      items.add(fragment(accepted));
      final rest = [
        if (consumed < parts.length) parts[consumed].substring(splitAt),
        ...parts.skip(consumed + 1),
      ];
      if (rest.isEmpty) return;
      remaining = fragment(rest)..['_continued'] = true;
      nextPage();
    }
  }

  void _makeRoom(String section) {
    if (!hasContent && current['_isFirstPage'] != true) {
      throw StateError('Resume $section cannot fit on an empty page.');
    }
    nextPage();
  }

  void finish() {
    if (hasContent || pages.isEmpty) pages.add(current);
  }

  // Binary search real layouts at word boundaries, preserving all whitespace.
  static int _textPrefix(String text, bool Function(String) accepts) {
    if (accepts(text)) return text.length;
    final ends = RegExp(r'\S+\s*').allMatches(text).map((m) => m.end).toList();
    final wordEnd = _fittingEnd(text, ends, accepts);
    if (wordEnd > 0) return wordEnd;
    // An unbroken pasted paragraph may itself exceed a page. Split only at
    // grapheme boundaries, never inside a Turkish combining mark or emoji.
    var offset = 0;
    final characterEnds = text.characters.map((character) {
      offset += character.length;
      return offset;
    }).toList();
    return _fittingEnd(text, characterEnds, accepts);
  }

  static int _fittingEnd(
      String text, List<int> ends, bool Function(String) accepts) {
    var low = 0;
    var high = ends.length;
    while (low < high) {
      final middle = (low + high + 1) ~/ 2;
      if (accepts(text.substring(0, ends[middle - 1]))) {
        low = middle;
      } else {
        high = middle - 1;
      }
    }
    return low == 0 ? 0 : ends[low - 1];
  }
}
