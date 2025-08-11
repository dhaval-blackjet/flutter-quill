import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

import '../../common/utils/widgets.dart';
import '../../document/attributes/font_weight_attribute.dart';
import '../base_button/base_value_button.dart';
import '../config/buttons/font_weight_options.dart';

/// A dropdown button for selecting font weights in the Quill toolbar

class QuillToolbarFontWeightButton extends QuillToolbarBaseButton<
    QuillToolbarFontWeightButtonOptions,
    QuillToolbarFontWeightButtonExtraOptions> {
  QuillToolbarFontWeightButton({
    required super.controller,
    super.options = const QuillToolbarFontWeightButtonOptions(),
    super.baseOptions,
    super.key,
  });

  @override
  QuillToolbarFontWeightButtonState createState() =>
      QuillToolbarFontWeightButtonState();
}

class QuillToolbarFontWeightButtonState extends QuillToolbarBaseButtonState<
    QuillToolbarFontWeightButton,
    QuillToolbarFontWeightButtonOptions,
    QuillToolbarFontWeightButtonExtraOptions,
    int> {
  final _menuController = MenuController();

  @override
  String get defaultTooltip => 'Font Weight';

  @override
  IconData get defaultIconData => Icons.format_bold;

  String get _defaultDisplayText {
    return options.defaultDisplayText ?? 'w400';
  }

  @override
  int get currentStateValue {
    final attribute = controller.getSelectionStyle().attributes[options.attribute.key];
    if (attribute is FontWeightAttribute || attribute is Attribute || attribute != null) {
      if(currentFontWeight != attribute?.value ||  attribute != null) {
        currentFontWeight = attribute?.value;
        currentFontWeightStreamControllerSink.add(currentFontWeight);
      }
      return attribute?.value ?? currentFontWeight;
    }else if(currentFontWeight != 400) {
      currentFontWeight = 400;
      currentFontWeightStreamControllerSink.add(400);
      return currentFontWeight;
    }
    return currentFontWeight; // Default to normal weight if not set
  }

  void _onDropdownButtonPressed() {
    if (_menuController.isOpen) {
      _menuController.close();
    } else {
      _menuController.open();
    }
    afterButtonPressed?.call();
  }

  int currentFontWeight = 400;
  final _currentFontWeightStreamController = StreamController<int>.broadcast();
  StreamSink<int> get currentFontWeightStreamControllerSink => _currentFontWeightStreamController.sink;
  Stream<int> get currentFontWeightStreamControllerStream => _currentFontWeightStreamController.stream;


  @override
  Widget build(BuildContext context) {
    final childBuilder = this.childBuilder;
    if (childBuilder != null) {
      return childBuilder(
        options,
        QuillToolbarFontWeightButtonExtraOptions(
          controller: controller,
          currentValue: currentValue,
          defaultDisplayText: options.defaultDisplayText ?? 'w400',
          context: context,
          onPressed: _onDropdownButtonPressed,
        ),
      );
    }

    final tooltip = options.tooltip ?? defaultTooltip;

    final theme = Theme.of(context);
    final isSelected = currentValue != 400; // Bold if not normal weight

    return MenuAnchor(
      controller: _menuController,
      menuChildren: options.items.entries.map((entry) {
        final weight = entry.value;
        return MenuItemButton(
          onPressed: () {
            setState(() {
              if (weight == 400) {
                // Clear the font weight if normal (400) is selected
                controller.formatSelection(
                  Attribute.fromKeyValue(Attribute.fontWeight.key, null),
                );
              } else {
                controller.formatSelection(FontWeightAttribute(weight));
              }
              options.onSelected?.call(weight);
              _menuController.close();
            });
          },
          child: Text(
            'w$weight',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: weight == currentStateValue
                  ? Theme.of(context).colorScheme.primary
                  : null,
            ),
          ),
        );
      }).toList(),
      builder: (context, controller, child) {
        final isMaterial3 = Theme.of(context).useMaterial3;
        if (!isMaterial3) {
          return RawMaterialButton(
            onPressed: _onDropdownButtonPressed,
            child: _buildContent(context),
          );
        }
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: IconButton(
            tooltip: tooltip,
            icon: _buildContent(context),
            onPressed: _onDropdownButtonPressed,
            iconSize: 18.0,
            padding: const EdgeInsets.all(4.0),
            constraints: const BoxConstraints(
              minWidth: 32.0,
              minHeight: 32.0,
            ),
            color:
                isSelected ? theme.colorScheme.primary : theme.iconTheme.color,
          ),
        );
      },
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
            child: StreamBuilder<int>(
              stream: currentFontWeightStreamControllerStream,
              builder: (context, snapshot) {
                debugPrint("currentStateValue : ${snapshot.data}");
                return Text(
                  'w$currentStateValue',
                  overflow: options.labelOverflow,
                  style: options.style ??
                      TextStyle(
                        fontSize: 16, // Default icon size
                      ),
                );
              }
            ),
          ),
          Icon(
            Icons.arrow_drop_down,
            size: 16, // Default icon size
          ),
        ],
      ),
    );
  }
}
