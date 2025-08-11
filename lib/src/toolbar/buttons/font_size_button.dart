import 'package:flutter/material.dart';

import '../../common/utils/font.dart';
import '../../common/utils/widgets.dart';
import '../../document/attribute.dart';
import '../../l10n/extensions/localizations_ext.dart';
import '../base_button/base_value_button.dart';
import '../simple_toolbar.dart';

class QuillToolbarFontSizeButton extends QuillToolbarBaseButton<
    QuillToolbarFontSizeButtonOptions, QuillToolbarFontSizeButtonExtraOptions> {
  QuillToolbarFontSizeButton({
    required super.controller,
    super.options = const QuillToolbarFontSizeButtonOptions(),

    /// Shares common options between all buttons, prefer the [options]
    /// over the [baseOptions].
    super.baseOptions,
    super.key,
  })  : assert(options.items?.isNotEmpty ?? true),
        assert(options.initialValue == null ||
            (options.initialValue?.isNotEmpty ?? true));

  @override
  QuillToolbarFontSizeButtonState createState() =>
      QuillToolbarFontSizeButtonState();
}

class QuillToolbarFontSizeButtonState extends QuillToolbarBaseButtonState<
    QuillToolbarFontSizeButton,
    QuillToolbarFontSizeButtonOptions,
    QuillToolbarFontSizeButtonExtraOptions,
    String> with TickerProviderStateMixin {
  final _menuController = MenuController();
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Map<String, String> get _items {
    final fontSizes = options.items ??
        {
          '10': '10',
          '12': '12',
          '14': '14',
          '16': '16',
          '18': '18',
          '20': '20',
          '22': '22',
          '24': '24',
          '26': '26',
          '28': '28',
          '30': '30',
          '32': '32',
          '34': '34',
          '36': '36',
          context.loc.clear: '0'
        };
    return fontSizes;
  }

  String? getLabel(String? currentValue) {
    return currentValue;
  }

  String get _defaultDisplayText {
    return options.initialValue ??
        widget.options.defaultDisplayText ??
        '16'; // Default to 16px
  }

  @override
  String get currentStateValue {
    final attribute =
        controller.getSelectionStyle().attributes[options.attribute.key];
    return attribute == null
        ? _defaultDisplayText
        : (_getKeyName(attribute.value) ?? _defaultDisplayText);
  }

  String? _getKeyName(dynamic value) {
    for (final entry in _items.entries) {
      if (getFontSize(entry.value) == getFontSize(value)) {
        return entry.key;
      }
    }
    return null;
  }

  @override
  String get defaultTooltip => context.loc.fontSize;

  @override
  IconData get defaultIconData => Icons.format_size_outlined;

  void _onDropdownButtonPressed() {
    if (_menuController.isOpen) {
      _menuController.close();
    } else {
      _menuController.open();
    }
    afterButtonPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final childBuilder = this.childBuilder;
    if (childBuilder != null) {
      return childBuilder(
        options,
        QuillToolbarFontSizeButtonExtraOptions(
          controller: controller,
          currentValue: currentValue,
          defaultDisplayText: _defaultDisplayText,
          context: context,
          onPressed: _onDropdownButtonPressed,
        ),
      );
    }
    return MenuAnchor(
      controller: _menuController,
      menuChildren: [
        ConstrainedBox(
          constraints: const BoxConstraints(
              maxHeight: 200), // Set a max height for the menu
          child: RawScrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            thickness: 6.0,
            radius: const Radius.circular(3.0),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: _items.entries.map((fontSize) {
                  return MenuItemButton(
                    key: ValueKey(fontSize.key),
                    onPressed: () {
                      final newValue = fontSize.value;

                      final keyName = _getKeyName(newValue);
                      setState(() {
                        if (keyName != context.loc.clear) {
                          currentValue = keyName ?? _defaultDisplayText;
                        } else {
                          currentValue = _defaultDisplayText;
                        }
                        if (keyName != null) {
                          controller.formatSelection(
                            Attribute.fromKeyValue(
                              Attribute.size.key,
                              newValue == '0' ? null : getFontSize(newValue),
                            ),
                          );
                          options.onSelected?.call(newValue);
                        }
                      });
                      _menuController.close();
                    },
                    child: Text(
                      '${fontSize.key}${fontSize.value == '0' ? '' : 'px'}',
                      style: TextStyle(
                        color: fontSize.value == '0'
                            ? options.defaultItemColor
                            : null,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
      child: Builder(
        builder: (context) {
          final isMaterial3 = Theme.of(context).useMaterial3;
          if (!isMaterial3) {
            return RawMaterialButton(
              onPressed: _onDropdownButtonPressed,
              child: _buildContent(context),
            );
          }
          return QuillToolbarIconButton(
            tooltip: tooltip,
            isSelected: false,
            iconTheme: iconTheme,
            onPressed: _onDropdownButtonPressed,
            icon: _buildContent(context),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final hasFinalWidth = options.width != null;
    return Padding(
      padding: options.padding ?? const EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: Row(
        mainAxisSize: !hasFinalWidth ? MainAxisSize.min : MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          UtilityWidgets.maybeWidget(
            enabled: hasFinalWidth,
            wrapper: (child) => Expanded(child: child),
            child: Text(
              '${getLabel(currentValue) ?? 16}px',
              overflow: options.labelOverflow,
              style: options.style ??
                  TextStyle(
                    fontSize: iconSize / 1.15,
                  ),
            ),
          ),
          Icon(
            Icons.arrow_drop_down,
            size: iconSize * iconButtonFactor,
          )
        ],
      ),
    );
  }
}
