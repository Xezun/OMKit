# XZKit

[![Build](https://img.shields.io/badge/build-pass-brightgreen.svg)](https://cocoapods.org/pods/XZKit)
[![Version](https://img.shields.io/badge/Version-3.0.8-blue.svg?style=flat)](http://cocoapods.org/pods/XZKit)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](http://cocoapods.org/pods/XZKit)
[![Platform](https://img.shields.io/badge/Platform-iOS-yellow.svg)](http://cocoapods.org/pods/XZKit)

## 环境需求

iOS 8.0, Swift 4.2/Objective-C.

## 安装集成

推荐使用 [CocoaPods](http://cocoapods.org) 快速集成到项目中。

```ruby
pod "XZKit"
```

## 组件

- [UICollectionView 自定义流布局：CollectionViewFlowLayout](./Documentation/CollectionViewFlowLayout)

  <img src="./Documentation/CollectionViewFlowLayout/CollectionViewFlowLayout.gif" alt="CollectionViewFlowLayout" width="320"></img>

- [UIView 内容状态视图：ContentStatusRepresentable](./Documentation/ContentStatusRepresentable)
- [自定义导航条、全屏手势导航控制器：NavigationController](./Documentation/NavigationController)
- [网络层框架：Networking](./Documentation/Networking)
- [控制重定向：AppRedirection](./Documentation/AppRedirection)
- [App 应用内语言切换：AppLanguage](./Documentation/AppLanguage)
- [缓存管理：CacheManager](./Documentation/CacheManager)
- [轮播视图及轮播图：CarouselView](./Documentation/CarouselView)
- [类型拓展：Castable](./Documentation/Castable)
- [常用拓展：Category](./Documentation/Category)
- [框架公共部分：Constant](./Documentation/Constant)
- [数据加密：DataCryptor](./Documentation/DataCryptor)
- [数据摘要：DataDigester](./Documentation/DataDigester)
- [安全列队：DispatchQueue](./Documentation/DispatchQueue)
- [进度视图：ProgressView](./Documentation/ProgressView)
- [文本图片视图：TitledImageView](./Documentation/TitledImageView)

## 更新日志

- 2018.09.17

    网络框架现在支持限制请求的总时长，避免在弱网情况下，即使设置响应超时，也可能无法有效控制请求时长，而导致的页面长时间处于加载状态。

## 联系作者

[mlibai@163.com](mailto://mlibai@163.com)

## License

XZKit is available under the MIT license. See the LICENSE file for more info.
