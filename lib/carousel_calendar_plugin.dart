import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CarouselCalendarPlugin {
  static const MethodChannel _channel =
      const MethodChannel('carousel_calendar_plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}

class CalendarCarouselWidget extends StatefulWidget {
  CalendarCarouselWidget(
      {Key key,
      this.dataSource,
      this.initPageIndex,
      this.viewportFraction,
      this.currentIndex,
      @required this.itemBuilder})
      : super(key: key);

  /// 视图数据
  final List dataSource;

  /// 初始化显示哪个页面
  final int initPageIndex;

  /// 显示宽度
  /// 为屏幕宽度的 * 0.2这种
  final double viewportFraction;

  /// 自定义item
  IndexedWidgetBuilder itemBuilder;

  ///  返回当前index
  ValueChanged currentIndex;

  @override
  _CalendarCarouselWidgetState createState() => _CalendarCarouselWidgetState();
}

class _CalendarCarouselWidgetState extends State<CalendarCarouselWidget> {
  PageController _pageController;

  String _lastDate = ""; // 存储上次page的索引
  int _lastRetuenIndex = 0; // 存储上次返回的pageIndex数据
  int _currentPageIndex = 0; // 存储当前pageIndex
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController(
        viewportFraction: widget.viewportFraction,
        initialPage: widget.initPageIndex ?? 0);
  }

  _pageChange(index) {
    _lastDate = widget.dataSource[index]['date'];
    _currentPageIndex = index;
  }

  @override
  Widget build(BuildContext context) {
    if (_pageController != null && _lastDate.length > 0) {
      int index = widget.dataSource
          .lastIndexWhere((element) => element['date'] == _lastDate);
      print("跳转到----$index \n ");
      _pageController.jumpToPage(index);
    }
    return Stack(children: [
      NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollStartNotification) {
            // print("滚动开始▶️");
          } else if (scrollNotification is ScrollUpdateNotification) {
            // print("滚动更新");
          } else if (scrollNotification is ScrollEndNotification) {
            // print("滚动停止⏹");
            // 停止滚动的时候进行判断，是否与上次的返回数据一样，一样的话就不用重复返回了
            // 重复的话就返回数据
            if (_lastRetuenIndex != _currentPageIndex) {
              if (widget.currentIndex != null) {
                widget.currentIndex(_currentPageIndex);
                _lastRetuenIndex = _currentPageIndex;
              }
            }
          }
          return false;
        },
        child: PageView.builder(
          onPageChanged: _pageChange,
          controller: _pageController,
          itemBuilder: (context, index) {
            return widget.itemBuilder(context, index);
          },
          itemCount: widget.dataSource.length,
        ),
      ),
      Positioned(
        bottom: -10,
        left: 0,
        right: 0,
        child: Icon(
          Icons.arrow_drop_up_outlined,
          color: Colors.white,
        ),
      )
    ]);
  }
}
