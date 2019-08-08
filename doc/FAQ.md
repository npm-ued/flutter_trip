## 切分支或更新缓慢(flutter channel dev)

[Using Flutter in China](https://flutter.dev/community/china)

在`.bash_profile`中配置：

```
 export PUB_HOSTED_URL=https://pub.flutter-io.cn
 export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
```
or
```
 export PUB_HOSTED_URL=https://pub.flutter-io.cn
 export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
 git clone -b dev https://github.com/flutter/flutter.git
 export PATH="$PWD/flutter/bin:$PATH"
 cd ./flutter
 flutter doctor
```

单纯升级flutter SDK可以终端切到flutter仓库下运行：

```
git pull
```

## library not found for -lstdc++.6.0.9
### 出现场景
运行百度语音识别iOS Demo时；

### 解决办法

linked frameworks and libraries，中移除`lstdc++.6.0.9`。






## more than one file was found with OS independent path 

### 出现场景

依赖的插件中依赖了flutter，导致libflutter.so合并时产生了冲突。

### 解决办法

在app/build.gradle中添加：

```
android {
    ...
    packagingOptions {
        // 确保app与asr_plugin都依赖的libflutter.so merge时不冲突@https://github.com/card-io/card.io-Android-SDK/issues/186#issuecomment-427552552
        pickFirst 'lib/x86_64/libflutter.so'
        pickFirst 'lib/armeabi/libflutter.so'
        pickFirst 'lib/x86/libflutter.so'
        pickFirst 'lib/armeabi-v7a/libflutter.so'
        pickFirst 'lib/arm64-v8a/libflutter.so'
    }
}
```

### 参考

[https://github.com/card-io/card.io-Android-SDK/issues/186#issuecomment-427552552](https://github.com/card-io/card.io-Android-SDK/issues/186#issuecomment-427552552)

## 

```
Launching lib/main.dart on Android SDK built for x86 in debug mode...
Initializing gradle...
Resolving dependencies...
Gradle task 'assembleDebug'...

FAILURE: Build failed with an exception.

* What went wrong:
Execution failed for task ':app:transformNativeLibsWithMergeJniLibsForDebug'.
> More than one file was found with OS independent path 'lib/x86/libflutter.so'

* Try:
Run with --stacktrace option to get the stack trace. Run with --info or --debug option to get more log output. Run with --scan to get full insights.

* Get more help at https://help.gradle.org

BUILD FAILED in 11s
Finished with error: Gradle task assembleDebug failed with exit code 1

```


## cannot find symbol

### 出现场景
安装完插件后，或者安装完插件用AndroidStudio打开项目目录下的android项目运行时报`GeneratedPluginRegistrant.java`中所引入的类找不到。

### 解决办法

运行：

```
flutter packages pub cache repair //清除flutter插件的安装缓存，重新安装
```
之后在运行项目。

### 参考

[https://github.com/flutter/flutter/issues/24684#issuecomment-454138309](https://github.com/flutter/flutter/issues/24684#issuecomment-454138309)

## 点击创建一个新的Flutter项目无响应
- 关闭模拟器之后重试；
- 重启电脑后重试。

## parsing a block mapping. assets:


```
Error on line 45, column 4 of pubspec.yaml: Expected a key while parsing a block mapping.
   assets:
   ^
Unable to reload your application because "flutter packages get" failed to update package dependencies.
Exception: pub get failed (65)
```
### 出现场景
取消注释assets后。
### 解决方案，
调整assets的空格缩进和其他行对其。

### 参考
[https://stackoverflow.com/questions/50171766/flutter-pub-expected-a-key-while-parsing-a-block-mapping-path](https://stackoverflow.com/questions/50171766/flutter-pub-expected-a-key-while-parsing-a-block-mapping-path)
## Unable to launch app on ios simulator

```
Xcode build done.                                            5.2s
ProcessException: Process "/usr/bin/xcrun" exited abnormally:
"com.example.flutterApp-ctrip": -1

An error was encountered processing the command (domain=FBSOpenApplicationServiceErrorDomain, code=1):
The request to open ""com.example.flutterApp-ctrip"" failed.
The request was denied by service delegate (SBMainWorkspace) for reason: NotFound ("Application ""com.example.flutterApp-ctrip"" is unknown to FrontBoard").
Underlying error (domain=FBSOpenApplicationErrorDomain, code=4):
	The operation couldn’t be completed. Application ""com.example.flutterApp-ctrip"" is unknown to FrontBoard.
	Application ""com.example.flutterApp-ctrip"" is unknown to FrontBoard.
  Command: /usr/bin/xcrun simctl launch 3E3FA943-715F-482F-B003-D46F5902C56C "com.example.flutterApp-ctrip" --enable-dart-profiling --enable-checked-mode --observatory-port=0
Error launching application on iPhone X.

```

### 出现场景

```
flutter channel dev
flutter upgrade
flutter run
```


### 解决办法

>方案一：

打开`ios/Runner/Info.plist` 将`Bundle identifier`从 `$(PRODUCT_BUNDLE_IDENTIFIER)` 替换为固定值。

```
        <key>CFBundleIdentifier</key>
-       <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
+       <string>com.example.flutterApp</string>
```

>方案二：

用XCode运行项目代替通过Flutter ide运行

```
open ios/Runner.xcworkspace
```


>参考：[https://github.com/flutter/flutter/issues/21335#issuecomment-423969759](https://github.com/flutter/flutter/issues/21335#issuecomment-423969759)