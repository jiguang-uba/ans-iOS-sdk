# iOS SDK

## iOS SDK 使用说明

iOS SDK 适用于 iOS 原生 App，集成前请先[下载 SDK](https://github.com/analysys/ans-ios-sdk/releases)

| framework | 功能描述 | 是否必选 | 服务端版本 |
| :---: | :---: | :---: | :--- |
| AnalysysAgent.bundle | 配置文件 | 必选 | 全部 |
| AnalysysAgent.framework | 基础模块 | 必选 | 全部 |
| AnalysysVisual.framework | 可视化热图模块 | 可选 | 热图模块适用方舟V4.3.0及以上 |
| AnalysysPush.framework | 推送模块 | 可选 | 全部 |
| AnalysysEncrypt.framework | 加密模块 | 可选 | 全部 |

{% hint style="info" %}
请您根据自身业务需求来引用相关的SDK。
{% endhint %}

### 快速集成

如果您是第一次使用易观方舟产品，可以通过阅读本文快速了解此产品

#### 1. 选择集成方式

* Cocoapods
* 手动引入

#### 2. 配置 Xcode

若使用手动集成方式，需引入部分类库

#### 3. 设置初始化接口

通过初始化接口配置您的AppKey，配置Channel

#### 4. 设置上传地址

通过`setUploadURL:`接口设置您上传数据的地址。

#### 5. 设置采集页面或事件

通过手动埋点，设置需要采集的页面或事件。

#### 6. 打开Debug模式查看日志

通过设置Debug模式，开/关 log 查看日志。

通过以上6步您即可验证SDK是否已经集成成功。更多接口说明请您查看API文档。

## 集成配置

### Cocoapods集成

1. 安装CocoaPods
2. 工程目录下创建`Podfile`文件，并添加`pod 'AnalysysAgent'`，示例如下：

```objectivec
platform :ios, '8.0'
use_frameworks!

target 'YourApp' do
    pod 'AnalysysAgent'
end
```

   3. 关闭Xcode，在工程目录下执行`pod install`或`pod install --verbose --no-repo-update`，完成后打开xxx.xcworkspace工程

### 手动导入集成

1. 选择 工程 - 右键 - `Add Files to "ProjectName"`
2. 选择 `AnalysysAgent.framework`文件
3. 勾选 `Copy items if needed`、`Create groups`- `Add` 完成添加类库
4. 添加`AnalysysAgent.bundle`资源文件：`Targets`-&gt;`ProjectName` -&gt; `Build Phases` -&gt; `Copy Bundle Resources` -&gt; 添加文件

{% tabs %}
{% tab title="Xcode配置" %}
* 若使用手动集成，请添加如下依赖框架：

  选择工程 - `Targets` - “项目名称” - `Build Phase` - `Link Binary With Libraries` 依赖库如下：

| 类库 | 用途 |
| :--- | :--- |
| `AdSupport.framework` | 广告标识 |
| `CoreTelephony.framework` | 运营商信息 |
| `SystemConfiguration.framework` | 网络状态 |
| `libz.tbd` | 数据压缩（Xcode7以下:libz.dylib） |
| `libicucore.tbd` | websocket可视化连接 |
| `libsqlite3.tbd` | 数据存储 |

* 为支持SDK中category，请在`Targets` - “项目名称” - `Build Settings` - `Other Linker Flags`，添加`-ObjC`选项（注意大小写）
{% endtab %}

{% tab title="swift 集成配置" %}
若使用 `Swift` 语言工程开发集成，则除上述配置外还需要添加桥接文件，该文件可以使用以下两种方式之一创建：

* 在工程中添加 `XXX-Bridging-Header.h` 文件（`XXX`为工程名称），并在 `Build Setting` - `Objective-C Bridging Header` 中添加桥接文件路径。
* 在工程中创建 Objective-C 文件，系统会提示是否创建桥接文件，选择创建即可生成桥接文件

创建完成之后，在 `XXX-Bridging-Header.h` 文件并引入类库：

```text
#import <AnalysysAgent/AnalysysAgent.h>
```
{% endtab %}
{% endtabs %}

## 基础模块介绍

以下接口生效依赖于基础SDK模块，需集成基础SDK相关`AnalysysAgent.framework`文件，请正确集成。

### 初始化接口

* Objective-C 代码示例
* 请确保初始化SDK在- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions中主线程初始化

在Xcode工程文件`~AppDelegate.m` 中导入头文件`"#import <AnalysysAgent/AnalysysAgent.h>"`。接口如下：

```objectivec
+ (AnalysysAgent *)startWithConfig:(AnalysysAgentConfig *)config;
```

> `AnalysysAgentConfig` 类为配置信息类。参数如下：
>
> * appKey：在网站获取的 AppKey
> * channel：应用下发渠道
> * autoProfile：设置是否追踪新用户的首次属性。默认：YES
> * autoInstallation：是否开启渠道追踪功能。默认值：NO
> * encryptType：设置数据上传时的加密方式，目前只支持 AES 加密，AES 加密分为AnalysysEncryptAES（128位密钥，ECB 加密模式）和 AnalysysEncryptAESCBC128（128位密钥，CBC 加密模式）；如不设置此参数，数据上传不加密。
> * allowTimeCheck：是否允许时间校准，默认值：NO
> * autoTrackCrash：是否允许崩溃追踪，默认值：NO
> * maxDiffTimeInterval：最大允许时间误差，单位：秒，默认值：30秒

示例：

```objectivec
//  导入SDK
#import <AnalysysAgent/AnalysysAgent.h>

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //  设置key，77a52s552c892bn442v721为样例数据，请根据实际情况替换相应内容
    //  AnalysysAgent 配置信息
    AnalysysConfig.appKey = @"77a52s552c892bn442v721";
    // 设置渠道
    AnalysysConfig.channel = @"App Store";
    // 设置追踪新用户的首次属性
    AnalysysConfig.autoProfile = YES;
    // 设置上传数据使用AES加密，需添加加密模块
    //  AnalysysConfig.encryptType = AnalysysEncryptAES;
    //  设置渠道追踪
    //  AnalysysConfig.autoInstallation = YES;
    //  设置服务器时间校验
    //  AnalysysConfig.allowTimeCheck = YES;
    //  设置时间最大允许偏差为5分钟
    //  AnalysysConfig.maxDiffTimeInterval = 5 * 60;
    //  使用配置初始化SDK
    [AnalysysAgent startWithConfig:AnalysysConfig];
    
    #ifdef DEBUG
        [AnalysysAgent setDebugMode:AnalysysDebugButTrack];
    #else
        [AnalysysAgent setDebugMode:AnalysysDebugOff];
    #endif

    //  设置上传地址
    [AnalysysAgent setUploadURL:@"https://url:port"];


    return YES;
}

```

* Swift代码示例

在桥接文件中导入类库 `#import <AnalysysAgent/AnalysysAgent.h>`，并在 `~AppDelegate.m` 中配置。

示例:

```swift
import AnalysysAgent

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    //  AnalysysAgent 配置信息
        AnalysysAgentConfig.shareInstance()?.appKey = "sdktest201907"
        AnalysysAgentConfig.shareInstance()?.channel = "App Store"
        AnalysysAgentConfig.shareInstance()?.autoProfile = true
//        AnalysysAgentConfig.shareInstance()?.autoInstallation = true
//        AnalysysAgentConfig.shareInstance()?.allowTimeCheck = true
//        AnalysysAgentConfig.shareInstance()?.maxDiffTimeInterval = 5 * 60
        
        //  使用配置信息初始化SDK
        AnalysysAgent.start(with: AnalysysAgentConfig.shareInstance())
        
          #if DEBUG
        AnalysysAgent.setDebugMode(.butTrack)
    #else
        AnalysysAgent.setDebugMode(.off)
    #endif

    //  设置上传地址
    AnalysysAgent.setUploadURL("https://url:port")

}
```

注意：默认 SDK 为非调试模式，不能查看日志，若要查看日志请调用 setDebugMode: 方法设置。请在正式发布 App 时使用 AnalysysDebugOff 模式！

### App启动方式监测
<font color='red'>此接口需在SDK初始化前进行设置</font>
启动方式分为：点击图标、点击通知、唤醒、3D touch、其他方式；
接口如下：

```objectivec
+ (void)monitorAppDelegate:(id<UIApplicationDelegate>)delegate launchOptions:(NSDictionary *)launchOptions;
```

* delegate：遵循`UIApplicationDelegate`的对象，iOS默认为`AppDelegate`类
* launchOptions：启动参数

示例：

```
#import <AnalysysAgent/AnalysysAgent.h>

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    /*** 请在初始化易观SDK前调用 ***/
    //  启动方式监测
    [AnalysysAgent monitorAppDelegate:self launchOptions:launchOptions];
    
    // 易观SDK初始化代码
    // .....
    
    return YES;
}
```

Swift代码示例：

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool { 

    /*** 请在初始化易观SDK前调用 ***/
    //  启动方式监测       
    AnalysysAgent.monitorAppDelegate(self, launchOptions: launchOptions)
    // 易观SDK初始化代码
    // ....
    return true
}
```

### 设置上传地址

自定义上传地址，接口设置后，所有事件信息将上传到该地址。接口如下：

```objectivec
+ (void)setUploadURL:(NSString *)uploadURL;
```

* uploadURL：数据上传地址，格式为 `scheme://host + :port`\(不包含 `/` 后的内容\)。**scheme** 必须以 `http://` 或 `https://` 开头，**host** 只支持域名和 IP，取值长度为1-255个字符，**port** 端口号必须携带

示例：

```objectivec
//  设置自定义上传地址为`scheme://host + :port`
[AnalysysAgent setUploadURL:@"/*设置为实际地址*/"];
```

Swift示例:

```swift
AnalysysAgent.setUploadURL("/*设置为实际地址*/")
```

### Debug 接口

Debug 接口主要用于开发者测试。可以开/关日志，查看tag为`[analysys]`的Log日志。接口如下：

```objectivec
+ (void)setDebugMode:(AnalysysDebugMode)debugMode;
```

* debugMode：debug 模式，默认关闭状态。注意：发布版本时 debugMode 模式设置为 `AnalysysDebugOff`。
  * `AnalysysDebugOff`：表示关闭
  * `AnalysysDebugOnly`：表示打开 Debug 模式，但该模式下发送的数据仅用于调试，不计入平台数据统计
  * `AnalysysDebugButTrack`：表示打开 Debug 模式，该模式下发送的数据可计入平台数据统计

示例：

```objectivec
[AnalysysAgent setDebugMode:AnalysysDebugOff];
```

Swift代码示例:

```swift
AnalysysAgent.setDebugMode(.off)
```

### 统计页面接口

页面跟踪，SDK 默认设置跟踪所有页面\(继承自`UIViewController`的控制器\)，支持自定义页面信息。接口如下:

```objectivec
+ (void)pageView:(NSString *)pageName;

+ (void)pageView:(NSString *)pageName properties:(NSDictionary *)properties;
```

* pageName：页面标识，为字符串，取值长度 1 - 255 字符
* properties：页面信息，properties 最多包含 100条，且 key 以字母或 `$` 开头，只能包括字母、数字、下划线和 `$`，字母不区分大小写，`$` 开头为预置事件/属性，取值长度 1 - 99 字符

  且不支持乱码和中文；value 支持类型：`NSString`/`NSNumber`/`NSArray<NSString *>`/`NSSet<NSString *>`/`NSDate`/`NSURL`，若为字符串，取值长度为1-255个字符

示例1：

```objectivec
// 正在开展某个活动，需要统计活动页面
[AnalysysAgent pageView:@"活动页"];
```

示例2：

```objectivec
// 访问手机活动页面，活动页面内容为优惠出售iPhone手机，手机价格为5000元
NSDictionary *properties = @{@"commodityName": @"iPhone", @"commodityPrice": @5000};
[AnalysysAgent pageView:@"商品页" properties:properties];
```

Swift代码示例：

```swift
let properties = ["commodityName": "iPhone", "commodityPrice": 5000] as [String : Any]
AnalysysAgent.pageView("商品页", properties: properties)
```

#### 打开/关闭自动采集页面

自动采集页面信息开关，打开时自动记录用户访问的页面。默认为打开状态。接口如下：

```objectivec
+ (void)setAutomaticCollection:(BOOL)isAuto
```

* isAuto：开关值，默认为YES打开，设置NO为关闭

示例：

```objectivec
//  关闭页面自动采集
[AnalysysAgent setAutomaticCollection:NO];
```

Swift代码示例:

```swift
AnalysysAgent.setAutomaticCollection(false)
```

#### 忽略部分页面自动采集

开发者可以设置某些页面不被自动采集，设置后自动采集时将会忽略这些页面。接口如下:

```objectivec
+ (void)setIgnoredAutomaticCollectionControllers:(NSArray<NSString *> *)controllers;
+ (void)setPageViewBlackListByPages:(NSSet<NSString *> *)controllers;
```

* controllers：需要忽略的控制器名称，字符串数组。

示例：

```objectivec
//  忽略页面'NextViewController'自动采集
[AnalysysAgent setIgnoredAutomaticCollectionControllers:@[@"NextViewController"]];
[AnalysysAgent setPageViewBlackListByPages:[NSSet setWithObject:@"NextViewController"]];
```

Swift代码示例:

必须使用 `包名.类名`

```swift
AnalysysAgent.setIgnoredAutomaticCollectionControllers(["packageName.NextViewController"]);
AnalysysAgent.setPageViewBlackListByPages(["packageName.NextViewController"]);
```

#### 设置热图事件的黑名单
开发者可以设置某些页面上的事件不采集。接口如下：

```objectivec
+ (void)setHeatMapBlackListByPages:(NSSet<NSString *> *)controllerNames;
```

* controllerNames：需要忽略的控制器名称，字符串集合。

示例：

```objectivec
[AnalysysAgent setHeatMapBlackListByPages:[NSSet setWithObjects:@"CFHomePageController", nil]];
```

Swift代码示例:

必须使用 `包名.类名`

```swift
AnalysysAgent.setHeatMapBlackListByPages(["SwiftOnlineShopDemo.CFHomePageController"]);
```

#### 设置全埋点事件的黑名单

1.开发者可以设置全埋点事件开关。接口如下：

```objectivec
+ (void)setAutoTrackClick:(BOOL)isAuto;
```

* isAuto：开关值，默认为NO关闭，设置YES为开。

示例：

```objectivec
[AnalysysAgent setAutoTrackClick:YES];
```

Swift代码示例:

```swift
AnalysysAgent.setAutoTrackClick(true);
```

2.开发者可以设置某些页面上的事件不采集。接口如下：

```objectivec
+ (void)setAutoClickBlackListByPages:(NSSet<NSString *> *)controllerNames;
```

* controllerNames：需要忽略的控制器名称，字符串集合。

示例：

```objectivec
[AnalysysAgent setAutoClickBlackListByPages:[NSSet setWithObject:@"CFHomePageController"]];
```

Swift代码示例:

必须使用 `包名.类名`

```swift
AnalysysAgent.setAutoClickBlackListByPages(["SwiftOnlineShopDemo.CFHomePageController"]);
```

3.开发者可以设置某些类型的控件不采集。接口如下：

```objectivec
+ (void)setAutoClickBlackListByViewTypes:(NSSet<NSString *> *)viewNames;
```

* viewNames：需要忽略的控件名称，字符串集合。

示例：

```objectivec
[AnalysysAgent setAutoClickBlackListByViewTypes:[NSSet setWithObject:@"ANSButton"]];
```

Swift代码示例:

必须使用 `包名.类名`

```swift
AnalysysAgent.setAutoClickBlackListByViewTypes(["SwiftOnlineShopDemo.CFButton"]);
```

#### 自动采集添加自定义信息

若用户开启页面自动采集功能，可将自定义页面信息添加至`$pageview`事件中。SDK对外提供一个协议`<ANSAutoPageTracker>`供继承至`UIViewController`的类使用，若类遵循该协议，则须实现`registerPageProperties`方法，并将自定义参数返回，SDK会将此部分信息添加至`$pageview`事件的自定义参数中，且自定义参数优先级高于自动采集参数（即：相同key情况下，用户key会覆盖自动采集key）。

{% hint style="info" %}
* 前提：页面自动采集功能未手动关闭
* 自定义参数只能获取页面生命周期`viewDidAppear:`及之前的参数，之后参数无法获取到。如：需要添加页面标题，但标题是通过网络请求获取，但响应时间较长，晚于页面生命周期`viewDidAppear:`才返回标题信息，则该信息无法添加至自动采集的页面属性中。
{% endhint %}

```objectivec
/**
 * @protocol
 * 页面自动采集协议
 *
 * @abstract
 * 当页面开启自动采集时，追加页面自定义参数
 *
 * @discussion
 * 继承至UIViewController的子类，若遵循该协议，可将自定义页面的属性信息增加至$pageview事件中
 */
@protocol ANSAutoPageTracker <NSObject>

@optional
- (NSDictionary *)registerPageProperties;

 /** 自定义页面标识，返回信息将覆盖$url字段 */
- (NSString *)registerPageUrl;

@end

```

示例：

```objectivec
/** 若使用SDK自动采集功能，且需要添加页面自定义参数，遵循protocol <ANSAutoPageTracker>*/
@interface PageDetailViewController ()<ANSAutoPageTracker>

@end

@implementation PageDetailViewController

/**
 实现ANSAutoPageTracker协议

 @return 页面自定义参数信息
 */
- (NSDictionary *)registerPageProperties {
    //  $title为自动采集使用key，用户可覆盖
    //  增加商品标识(productID)
    return @{@"$title": @"详情页"};
}

/**
 页面$url字段，将覆盖SDK默认字段

 @return 页面标识
 */
- (NSString *)registerPageUrl {
    return @"HomePage";
}

@end
```

Swift代码示例:

```swift
class PageDetailViewController: UIViewController, ANSAutoPageTracker {
    
    func registerPageProperties() -> [AnyHashable : Any]! {
        return ["$title": "详情页", "$url": "/homepage/detailpage", "productID": "1001"]
    }
    
    func registerPageUrl() -> String! {
        return "DetailPage"
    }
}
```

### 统计事件接口

用户行为追踪，可以设置自定义属性。接口如下：

```objectivec
+ (void)track:(NSString *)event;

+ (void)track:(NSString *)event properties:(NSDictionary *)properties;
```

* event：事件ID，以字母或 `$` 开头，只能包含字母、数字、下划线和 `$`，字母不区分大小写，`$` 开头为预置事件/属性，最大长度 99字符，不支持乱码和中文
* properties：自定义属性，用于对事件描述。properties最多包含100对，且 key 以字母或 `$` 开头，只能包含字母、数字、下划线和 `$`，字母不区分大小写，`$` 开头为预置事件/属性，key长度 1 - 99 字符且不支持乱码和中文；value 支持类型：`NSString`/`NSNumber`/`NSArray<NSString *>`/`NSSet<NSString *>`/`NSDate`/`NSURL`，若为字符串，取值长度为1-255个字符

示例：

```objectivec
//  收藏事件
[AnalysysAgent track:@"collect"];

....

// 用户购买手机
NSMutableDictionary *properties = [NSMutableDictionary dictionary];
properties[@"type"] = @"Phone";
properties[@"name"] = @"iPhone XS Max";
properties[@"money"] = [NSNumber numberWithFloat:9599.0];
properties[@"count"] = @1;
[AnalysysAgent track:@"pay" properties:properties];
```

Swift代码示例:

```swift
let properties = ["type": "Phone",
                  "name": "iPhone XS Max",
                 "money": 9599.0,
                 "count": 1] as [String: Any]
AnalysysAgent.track("pay", properties: properties)
```

### 匿名ID与用户关联

用户 id 关联接口。将需要绑定的用户ID 和匿名ID进行关联，计算时会认为是一个用户的行为。接口如下：

```objectivec
+ (void)alias:(NSString *)aliasId originalId:(NSString *)originalId;
```

* aliasId：需要关联的用户ID。 取值长度为1-255个字符
* originalId ：待关联的匿名ID，可以是现在使用也可以是历史使用的匿名ID,不局限于本地正使用的匿名ID。 可以为空值，若为空时使用本地的匿名ID。取值长度 1 - 255 字符（如无特殊需求，不建议设置），支持类型：String

示例：

```objectivec
//  登陆账号时调用，只设置当前登陆账号即可和之前行为打通
[AnalysysAgent alias:@"sanbo" originalId:@""];

......

//  现在登陆账号是zhangsan，和历史上的 lisi是一个人。 此时不会关心登陆 zhangsan前的用户是谁
[AnalysysAgent alias:@"zhangsan" originalId:@"lisi"];
```

Swift代码示例：

```swift
AnalysysAgent.alias("zhangsan", originalId: "lisi")
```

### 匿名ID设置

唯一匿名ID标识设置，接口如下：

```objectivec
+ (void)identify:(NSString *)distinctId;
```

* distinctId：唯一身份标识，取值长度为1-255个字符

示例：

```objectivec
// 设置匿名ID为`fangke009901`，注意此方法需要在初始化之前调用
[AnalysysAgent identify:@"fangke009901"];
```

Swift代码示例：

```swift
AnalysysAgent.identify("fangke009901")
```

### 匿名ID获取

获取用户通过identify接口设置或自动生成的id，优先级如下： 用户设置的id &gt; 代码自动生成的id，接口如下：

```objectivec
+ (NSString *)getDistinctId;
```

示例：

```objectivec
NSString *distinctID = [AnalysysAgent getDistinctId];
```

Swift代码示例：

```swift
let distinctID = AnalysysAgent.getDistinctId() as String
```

### 用户属性设置

> 用户属性是一个标准的 K-V 结构，K 和 V 均有相应的约束条件，如不符合则丢弃该次操作。

约束条件如下：

* **属性名称**

  以字母或`$`开头，包含字母、数字、下划线和`$`，字母不区分大小写，`$`开头为预置事件/属性，取值长度 1 - 99 字符，不支持乱码和中文

* **属性值**

  支持部分类型：`NSString`/`NSNumber`/`NSArray<NSString *>`/`NSSet<NSString *>`/`NSDate`/`NSURL`； 若为字符串，取值长度为1-255个字符； 若为数组或集合，则最多包含 100条，且 key 约束条件与[属性名称](./#userPropertyKey)一致，value 取值长度为1-255个字符

#### 设置用户属性

给用户设置单个或多个属性，如果之前不存在，则新建，否则覆盖。接口如下：

```objectivec
+ (void)profileSet:(NSDictionary *)property;

+ (void)profileSet:(NSString *)propertyName value:(id)propertyValue;
```

* propertyName：属性名称，约束见[属性名称](./#userPropertyKey)
* propertyValue：属性值，约束见[属性值](./#userPropertyValue)
* property：属性列表，约束见[属性名称](./#userPropertyKey)，[属性值](./#userPropertyValue)

示例1：

```objectivec
// 设置用户的 `Job` 是 `Engineer`
[AnalysysAgent profileSet:@"Job" propertyValue:@"Engineer"];

...

// 统计用户昵称和爱好信息
NSDictionary *properties = @{@"nickName":@"小叮当",@"hobby":@[@"Singing", @"Dancing"]};
[AnalysysAgent profileSet:properties];
```

Swift代码示例：

```swift
AnalysysAgent.profileSet(["nickName": "小叮当", "hobby": ["Singing", "Dancing"]])
```

#### 设置用户固有属性

设置用户的固有属性，只在首次设置时有效的属性。 如：应用的激活时间、首次登录时间等。如果被设置的用户属性已存在，则这条记录会被忽略而不会覆盖已有数据，如果属性不存在则会自动创建。接口如下：

```objectivec
//  多个属性
+ (void)profileSetOnce:(NSDictionary *)property;

//  单个属性
+ (void)profileSetOnce:(NSString *)propertyName propertyValue:(id)propertyValue;
```

* propertyName：属性名称，约束见[`属性名称`](./#GeneralPNameLimit)
* propertyValue：属性值，约束见[`属性值`](./#GeneralPValueLimit)
* property：集合类型属性值，约束见[`属性名称`](./#GeneralPNameLimit) 、[`属性值`](./#GeneralPValueLimit)

示例1：统计用户的出生日期

```objectivec
//  单个属性设置
[AnalysysAgent profileSetOnce:@"Birthday" propertyValue:@"1995-01-01"];
```

示例2：

```objectivec
// 统计应用激活时间
[AnalysysAgent profileSetOnce:@{@"activationTime": @"1521594686781"}];
```

Swift代码示例：

```swift
AnalysysAgent.profileSetOnce("Birthday", propertyValue: "1995-01-01")

AnalysysAgent.profileSetOnce(["activationTime": "1521594686781"])
```

#### 设置用户属性相对变化值

设置用户属性的相对变化值\(相对增加，减少\)，只能对数值型属性进行操作，如果这个 Profile 之前不存在，则初始值为 0。接口如下：

```objectivec
//  多个属性
+ (void)profileIncrement:(NSDictionary *)property;

//  单个属性
+ (void)profileIncrement:(NSString *)propertyName propertyValue:(NSNumber *)propertyValue;
```

* propertyName：属性名称，约束见[`属性名称`](./#GeneralPNameLimit)
* propertyValue：属性值，约束见[`属性值`](./#GeneralPValueLimit)
* property：集合类型属性值，约束见[`属性名称`](./#GeneralPNameLimit) 、[`属性值`](./#GeneralPValueLimit)

示例1：

```objectivec
//  增加用户消费金额
[AnalysysAgent profileIncrement:@"Consume" propertyValue:@10];
```

示例2：

```objectivec
//  增加用户登录次数加1次，积分增加10分
NSDictionary *dic = @{@"UseCount": [NSNumber numberWithInt:1],@"point": [NSNumber numberWithInt:10]};
[AnalysysAgent profileIncrement:dic];
```

Swift代码示例：

```swift
AnalysysAgent.profileIncrement("Consume", propertyValue: 10)

AnalysysAgent.profileIncrement(["UseCount": 1])
```

#### 增加列表类型的属性

用户列表属性增加元素。接口如下：

```objectivec
//  增加单个属性
+ (void)profileAppend:(NSString *)propertyName value:(id)propertyValue;

//  增加多个属性
+ (void)profileAppend:(NSDictionary *)property;

//  增加多个属性
+ (void)profileAppend:(NSString *)propertyName propertyValue:(NSSet *)propertyValue;
```

* propertyName：属性名称，约束见[`属性名称`](./#GeneralPNameLimit)
* propertyValue：属性值，约束见[`属性值`](./#GeneralPValueLimit)
* property：集合类型属性值，约束见[`属性名称`](./#GeneralPNameLimit) 、[`属性值`](./#GeneralPValueLimit)

示例1：

```objectivec
//  增加用户购买书籍，属性 `Books` 为: `["西游记", "三国演义"]`，属性 `Drinks` 为：`orange juice`
[AnalysysAgent profileAppend:@{@"Books": @[@"西游记", @"三国演义"],@"Drinks": @"orange juice"}];
```

示例2：

```objectivec
//  再次设定该属性，属性 `Books` 为: `["西游记", "三国演义", "红楼梦", "水浒传"]`
[AnalysysAgent profileAppend:@"Books" propertyValue:[NSSet setWithObjects:@"红楼梦", @"水浒传", nil]];
```

Swift代码示例：

```swift
AnalysysAgent.profileAppend("Books", propertyValue: ["红楼梦", "水浒传"])
```

#### 删除设置的属性值

删除已设置的用户属性值。接口如下：

```objectivec
//  删除当前用户单个属性值
+ (void)profileUnset:(NSString *)propertyName;

//  删除当前用户所有属性值
+ (void)profileDelete;
```

* propertyName：属性名称，约束见[`属性名称`](./#GeneralPNameLimit)

示例1：

```objectivec
//  删除当前用户已设置的`hobby`用户属性值
[AnalysysAgent profileUnset:@"hobby"];
```

示例2：

```objectivec
//  删除当前用户已设置的所有用户属性
[AnalysysAgent profileDelete];
```

Swift代码示例：

```swift
AnalysysAgent.profileUnset("hobby")

AnalysysAgent.profileDelete()
```

### 通用属性

> 通用属性是每次上传事件信息都会带有的属性，通用属性是一个标准的 K-V 结构，K 和 V 均有相应的约束条件，如不符合则丢弃该次操作。

约束条件如下:

* **属性名称**

  以字母或`$`开头，只能包含字母、数字、下划线和`$`，字母不区分大小写，`$`开头为预置事件/属性，取值长度 1 - 99 字符，不支持乱码和中文

* **属性值**

  支持部分类型：`NSString`/`NSNumber`/`NSArray<NSString *>`/`NSSet<NSString *>`/`NSDate`/`NSURL`； 若为字符串，取值长度为1-255个字符； 若为数组或集合,则最多包含 100条，且 key 约束条件与[属性名称](./#GeneralPNameLimit)一致，value 取值长度为1-255个字符

#### 注册通用属性

某一个体，在固定范围内，持续拥有的属性，每次数据上传都会携带。接口如下:

```objectivec
//  注册多个通用属性
+ (void)registerSuperProperties:(NSDictionary *)superProperties;

//  注册单个通用属性
+ (void)registerSuperProperty:(NSString *)superPropertyName value:(id)superPropertyValue;
```

* superPropertyName：属性名称，约束见[`属性名称`](./#GeneralPNameLimit)
* superPropertyValue：属性值，约束见[`属性值`](./#GeneralPValueLimit)
* superProperties：集合类型属性值，满足[`属性名称`](./#GeneralPNameLimit) 和[`属性值`](./#GeneralPValueLimit)约束

示例：

```objectivec
// 在某视频平台，购买一年会员，该年内只需设置一次即可
[AnalysysAgent registerSuperProperties:@{@"member": @"VIP"}];
```

成功设置事件通用属性后，事件通用属性会被添加进每个事件中，例如：

```objectivec
//  记录用户购买商品事件
[AnalysysAgent track:@"buy" properties:@{@"product":@"iPhone"}];
```

在设置事件通用属性后，实际发送的事件中会被加入 'member' 属性，等价于如下代码：

```objectivec
//  记录用户登录事件
[AnalysysAgent track:@"buy" properties:@{@"product":@"iPhone",@"member": @"VIP"}];
```

Swift代码示例：

```swift
AnalysysAgent.registerSuperProperties(["member": "VIP"])
```

重复调用 `registerSuperProperties:` 会覆盖之前已设置的通用属性，通用属性会保存在 App 本地缓存中。

当 `superProperties` 通用属性和用户自定义属性的 `Key` 冲突时，用户自定义属性会覆盖 `superProperties` 通用属性。

#### 删除通用属性

根据属性名称，删除已设置过的通用属性。接口如下：

```objectivec
//  删除单个通用属性
+ (void)unregisterSuperProperty:(NSString *)superPropertyName;

//  清除所有通用属性
+ (void)clearSuperProperties;
```

* superPropertyName ： 属性名称，约束见[`属性名称`](./#GeneralPNameLimit) 

示例1：

```objectivec
//  删除已经设置的用户 `Birthday` 属性
[AnalysysAgent unregisterSuperProperty:@"Birthday"];
```

示例2：

```objectivec
//  清除所有已经设置的通用属性
[AnalysysAgent clearSuperProperties];
```

Swift代码示例：

```swift
AnalysysAgent.unregisterSuperProperty("Birthday")

AnalysysAgent.clearSuperProperties()
```

#### 获取通用属性

查询获取通用属性。接口如下：

```objectivec
//  获取单个通用属性
+ (id)getSuperProperty:(NSString *)superPropertyName

//  获取所有的通用属性
+ (NSDictionary *)getSuperProperties;
```

* superPropertyName：属性名称，约束见[`属性名称`](./#GeneralPNameLimit)

示例1：

```objectivec
// 查看已经设置的 `Hobby` 的通用属性
[AnalysysAgent getSuperProperty:@"Hobby"];
```

示例2：查看所有已经设置的通用属性

```objectivec
// 获取所有通用属性
[AnalysysAgent getSuperProperties]
```

Swift代码示例：

```swift
AnalysysAgent.getSuperProperty("Hobby")

AnalysysAgent.getSuperProperties()
```

### SDK 发送策略

#### 设置上传间隔时间

上传间隔时间设置，在 debug 模式关闭后生效。当事件触发间隔时间大于等于设置时间，则上传数据；默认 SDK 上传时间隔为 15s，并需要与`setMaxEventSize:`接口配套使用。接口如下：

```objectivec
+ (void)setIntervalTime:(NSInteger)flushInterval;
```

* flushInterval：间隔时间，时间单位为 秒，且最小间隔为1秒

示例：如设置上传间隔时间为10秒

```objectivec
[AnalysysAgent setIntervalTime:10];
```

Swift代码示例:

```swift
AnalysysAgent.setIntervalTime(10)
```

#### 设置事件最大上传条数

上传条数设置，在 debug 模式关闭后生效；当数据库内事件条数大于设置条数则上传数据，默认上传的条数为 10条。并需要与`setIntervalTime:`接口配套使用接口。接口如下：

```objectivec
+ (void)setMaxEventSize:(NSInteger)size;
```

* size：上传条数，size 必须值大于等于 1

示例：设置上传条数为 20条:

```objectivec
// 修改为每缓存 20 条数据，触发一次上传
[AnalysysAgent setMaxEventSize:20];
```

Swift代码示例:

```swift
AnalysysAgent.setMaxEventSize(20)
```

#### 本地缓存上限值

SDK 本地默认缓存数据的上限值为 10000条，最小值为100条，当达到此阈值值将会删除最早 10条数据。可以通过 `setMaxCacheSize` 方法来设定缓存数据的上限值（参数单位/条）。接口如下：

```objectivec
+ (void)setMaxCacheSize:(NSInteger)size;
```

* size：本地最多数据缓存条数

示例：设置本地数据缓存上限值为 2000条

```objectivec
[AnalysysAgent setMaxCacheSize:2000];
```

Swift代码示例:

```swift
AnalysysAgent.setMaxCacheSize(2000)
```

#### 手动上传

调用该接口立刻上传数据，接口如下：

```objectivec
+ (void)flush;
```

示例：如需主动刷新本地数据，可直接调用

```objectivec
[AnalysysAgent flush];
```

Swift代码示例:

```swift
AnalysysAgent.flush()
```

### 获取预置属性

获取SDK默认采集的一些预置属性信息，接口如下：

```objectivec
+ (NSDictionary *)getPresetProperties;
```

示例：

```objectivec
NSDictionary *preProperties = [AnalysysAgent getPresetProperties];
```

Swift代码示例:

```swift
let presetProperties = AnalysysAgent.getPresetProperties()
```

### 清除本地设置

清除本地现有的设置（包括id和通用属性）重新开始统计。接口如下：

```objectivec
+ (void)reset;
```

示例：清除本地现有的设置，包括id和通用属性

```objectivec
[AnalysysAgent reset];
```

Swift代码示例：

```swift
AnalysysAgent.reset()
```

## 可视化热图SDK接口介绍

以下接口生效依赖于可视化模块，需集成可视化相关`AnalysysVisual.framework`文件，请正确集成。

### 设置webSocket地址

设置服务器地址，用于可视化调试阶段连接 Websocket 服务器。接口如下：

接口如下：

```objectivec
+ (void)setVisitorDebugURL:(NSString *)visitorDebugURL;
```

* visitorDebugURL：websocket服务器地址，格式为 `scheme://host + :port`\(不包含 `/` 后的内容\)。**scheme** 必须以 `ws://` 或 `wss://` 开头，**host** 只支持域名和 IP，取值长度为1-255个字符，**port** 端口号必须携带

示例：

```objectivec
//  设置websocket服务器地址为 scheme://host + :port
[AnalysysAgent setVisitorDebugURL:@"/*设置为实际地址*/"];
```

Swift示例:

```swift
AnalysysAgent.setVisitorDebugURL("ws://growth.analysys.cn:9091")
```

### 设置请求埋点配置地址

设置服务器地址，用于可视化请求埋点配置信息。接口如下：

```objectivec
+ (void)setVisitorConfigURL:(NSString *)configURL;
```

* configURL：请求埋点配置的服务器地址，格式：`http://host:port` 或 `https://host:port`

示例：

```objectivec
//  设置请求埋点配置的服务器地址为 scheme://host + :port
[AnalysysAgent setVisitorConfigURL:@"/*设置为实际地址*/"];
```

Swift示例:

```swift
AnalysysAgent.setVisitorConfigURL("/*设置为实际地址*/")
```

### 设置热图采集

控制是否采集用户点击热图信息。接口如下：

```objectivec
+ (void)setAutomaticHeatmap:(BOOL)autoTrack;
```

* autoTrack：是否采集用户点击位置坐标，默认为NO

示例：

```objectivec
//  设置采集热图信息
[AnalysysAgent setAutomaticHeatmap:YES];
```

Swift示例:

```swift
AnalysysAgent.setAutomaticHeatmap(true)
```

## 加密模块介绍

加密模块生效依赖于加密SDK模块，需集成加密SDK相关`AnalysysEncrypt.framework`文件，请正确集成。

在初始化SDK时需设置加密方式即可：

```text
/**
 数据上传加密类型
 
 - AnalysysEncryptAES: AES ECB加密
 - AnalysysEncryptAESCBC128: AES CBC加密
 */
typedef NS_ENUM(NSInteger, AnalysysEncryptType) {
    AnalysysEncryptAES = 1,
    AnalysysEncryptAESCBC128 = 2
};
```

## 消息推送SDK接口介绍

以下接口生效依赖于推送模块，需集成推送相关`AnalysysPush.framework`文件，请正确集成。

### 简介

推送消息是一种常用的运营方法。在合适的时间把合适的内容通过合适的方式推送给合适的人群，不仅能促进用户活跃，也能极大提升用户对产品的体验。 易观推送现在支持极光、个推、百度、小米四个三方平台。支持通过易观开发者平台设置以下三种类型的推送消息内容:

* 下发通知，点击通知，打开宿主 App
* 下发通知，点击通知，打开宿主 App 的特定页面
* 下发通知，点击通知，触发打开特定的 URL 页面

首先，开发者需要在 App 中集成第三方推送系统的 SDK，并在 App 初始化过程中获取设备推送 ID，并保存在方舟分析的用户信息中。以下简要说明集成第三方推送系统的集成方式

### 设置设备推送 ID

该接口用于设置推送平台（provider）提供的设备推送ID。

```objectivec
+ (void)setPushProvider:(AnalysysPushProvider)provider pushID:(NSString *)pushID;
```

* provider 推送提供方标识，目前只 `AnalysysPushProvider` 枚举中的类型
* pushID 第三方推送标识。如：极光的 `registrationID`，个推的 `clientId`，百度的 `channelid`，小米的 `xmRegId`

调用方法，以极光为例：

```objectivec
[AnalysysAgent setPushProvider:AnalysysPushJiGuang pushID:@"191e35f7e01617e5181"];
```

Swift示例:

```swift
AnalysysAgent.setPushProvider(.jiGuang, pushID: "191e35f7e01617e5181")
```

#### 极光推送

请下载最新的极光推送 SDK，并根据[《iOS SDK 集成指南》](https://docs.jiguang.cn/jpush/client/iOS/ios_guide_new/)将SDK集成至开发者App中。并集成并初始化方舟SDK。

在 iOS App 中，首先获取 APNs 的 Device Token，然后注册极光推送，成功后极光推送会返回 `registrationID`，将此 `registrationID` 回传方舟 SDK 即可。

```objectivec
@interface AppDelegate () <JPUSHRegisterDelegate>

@end
```

```objectivec
#import <AnalysysAgent/AnalysysAgent.h>
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // 初始化极光SDK后，获取 registrationID 并回传
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            //  回传
            [AnalysysAgent setPushProvider:AnalysysPushJiGuang pushID:registrationID];
        } else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
}

//  获取 APNS Token 值
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

    //  向极光注册 deviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}
```

#### 百度推送

请下载最新的百度推送 SDK，并根据[《百度Push服务SDK用户手册（iOS版）》](http://push.baidu.com/doc/ios/api)将 SDK 集成至开发者App中。并集成并初始化方舟SDK。

在 iOS App 中，首先获取 APNs 的 Device Token，然后注册百度推送，成功后百度推送会返回 `channelid`，将此 `channelid` 回传方舟 SDK 即可。

```objectivec
@interface AppDelegate () <UIApplicationDelegate,UNUserNotificationCenterDelegate>

@end
```

```objectivec
#import <AnalysysAgent/AnalysysAgent.h>
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // 初始化百度SDK后，获取 channelid 并回传
    [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
        if (error) {
            return ;
        }
        if (result) {
            if ([result[@"error_code"]intValue]!=0) {
                return;
            }
            NSString *channelid = [BPush getChannelId];
            //  回传
            [AnalysysAgent setPushProvider:AnalysysPushBaiDu pushID:channelid];
        }
    }];
}

//  获取 APNS Token 值
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

    //  向百度注册 deviceToken
    [BPush registerDeviceToken:deviceToken];
}
```

#### 小米推送

请下载最新的小米推送 SDK，并根据[《小米推送服务iOS客户端SDK使用指南》](https://dev.mi.com/console/doc/detail?pId=98)将 SDK 集成至开发者 App 中。并集成并初始化方舟SDK。

在 iOS App 中，首先获取 APNs 的 Device Token，然后注册小米推送，成功后小米推送会返回 `regid`，将此 `regid` 回传方舟 SDK 即可。

```objectivec
@interface AppDelegate () <MiPushSDKDelegate,UNUserNotificationCenterDelegate>

@end
```

```objectivec
#import <AnalysysAgent/AnalysysAgent.h>
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 只启动APNs.
    [MiPushSDK registerMiPush:self];
}

//  获取 APNS Token 值
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

    //  向小米注册 deviceToken
    [MiPushSDK bindDeviceToken:deviceToken];
}

#pragma mark *** MiPushSDKDelegate ***
- (void)miPushRequestSuccWithSelector:(NSString *)selector data:(NSDictionary *)data {
    if ([selector isEqualToString:@"bindDeviceToken:"]) {
        NSString *xmRegId = data[@"regid"];
        //  回传
        [AnalysysAgent setPushProvider:AnalysysPushXiaoMi pushID:xmRegId];
    }
}
```

#### 个推推送

请下载最新的个推推送 SDK，并根据[《iOS端 &gt; Xcode集成》](http://docs.getui.com/getui/mobile/ios/xcode/)将 SDK 集成至开发者 App 中。并集成并初始化方舟 SDK。

在 iOS App 中，首先获取 APNs 的 Device Token，然后注册个推推送，成功后个推推送会返回 `clientId`，将此 `clientId` 回传方舟 SDK 即可。

```objectivec
@interface AppDelegate () <UIApplicationDelegate, GeTuiSdkDelegate, UNUserNotificationCenterDelegate>

@end
```

```objectivec
#import <AnalysysAgent/AnalysysAgent.h>
//  获取 APNS Token 值
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

    //  向个推注册 deviceToken
    [GeTuiSdk registerDeviceToken:token];
}

#pragma mark *** GeTuiSdkDelegate ***
/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    //  回传
    [AnalysysAgent setPushProvider:AnalysysPushGeTui pushID:clientId];
}
```

### 统计活动推广信息

追踪记录 provider 对应平台的消息推送的信息。

接口如下：

```objectivec
+ (void)trackCampaign:(id)userInfo isClick:(BOOL)isClick;

+ (void)trackCampaign:(id)userInfo isClick:(BOOL)isClick userCallback:(void(^)(id campaignInfo))userCallback;
```

* userInfo：推送携带的参数信息
* isClick：YES：用户点击通知；NO：接收到消息通知
* userCallback：将解析后的用户下发活动信息回调用户

三方推送平台 SDK 集成及示例代码

首先，开发者需要在 App 中集成第三方推送系统的 SDK，并在 App 初始化过程中获取设备推送 ID，并保存在方舟分析的用户信息中。目前易观 SDK 支持极光、百度、小米、个推四家第三方推送统计的支持。以下简要说明集成第三方推送系统的集成方式。

#### 极光推送

```objectivec
#pragma mark *** JPUSHRegisterDelegate ***

// >= iOS 10 Support , App Forground
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;

    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //  收到推送消息，追踪"App 消息推送"事件
        [AnalysysAgent trackCampaign:userInfo isClick:NO userCallback:^(id campaignInfo) {
            NSLog(@"此处可根据需要处理数据 : %@",campaignInfo);
        }];

        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support, App Background
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSDictionary *userInfo = response.notification.request.content.userInfo;

    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //  点击通知栏打开消息，记录"App 点击通知"事件
        [AnalysysAgent trackCampaign:userInfo isClick:YES userCallback:^(id campaignInfo) {
            NSLog(@"此处可根据需要处理数据 : %@",campaignInfo);
        }];

        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();
}

//  >= iOS 7 <iOS 10
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];

    completionHandler(UIBackgroundFetchResultNewData);

    [self handleRemoteNotificationWithApplication:application userInfo:userInfo];
}

// < iOS 7
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];

    [self handleRemoteNotificationWithApplication:application userInfo:userInfo];
}
```

#### 百度推送

```objectivec
#pragma mark *** UNUserNotificationCenterDelegate ***
// >= iOS 10 Support , App Forground
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;

    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [BPush handleNotification:userInfo];
        //  收到推送消息，追踪"App 消息推送"事件
        [AnalysysAgent trackCampaign:userInfo isClick:NO userCallback:^(id campaignInfo) {
            NSLog(@"此处可根据需要处理数据 : %@",campaignInfo);
        }];
    }

    // 根据APP需要，判断是否要提示用户Badge、Sound、Alert
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

// iOS 10 Support, App Background
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSDictionary *userInfo = response.notification.request.content.userInfo;

    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //  点击通知栏打开消息，记录"App 点击通知"事件
        [AnalysysAgent trackCampaign:userInfo isClick:YES userCallback:^(id campaignInfo) {
            NSLog(@"此处可根据需要处理数据 : %@",campaignInfo);
        }];

        [BPush handleNotification:userInfo];
    }
    completionHandler();
}

//  >= iOS 7 <iOS 10
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [BPush handleNotification:userInfo];

    completionHandler(UIBackgroundFetchResultNewData);

    [self handleRemoteNotificationWithApplication:application userInfo:userInfo];
}

// < iOS 7
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [BPush handleNotification:userInfo];

    [self handleRemoteNotificationWithApplication:application userInfo:userInfo];
}
```

#### 小米推送

```objectivec
#pragma mark *** UNUserNotificationCenterDelegate ***
// >= iOS 10 Support , App Forground
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;

    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [MiPushSDK handleReceiveRemoteNotification:userInfo];
        //  收到推送消息，追踪"App 消息推送"事件
        [AnalysysAgent trackCampaign:userInfo isClick:NO userCallback:^(id campaignInfo) {
            NSLog(@"此处可根据需要处理数据 : %@",campaignInfo);
        }];
    }

    // 根据APP需要，判断是否要提示用户Badge、Sound、Alert
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

// iOS 10 Support, App Background
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSDictionary *userInfo = response.notification.request.content.userInfo;

    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //  点击通知栏打开消息，记录"App 点击通知"事件
        [AnalysysAgent trackCampaign:userInfo isClick:YES userCallback:^(id campaignInfo) {
            NSLog(@"此处可根据需要处理数据 : %@",campaignInfo);
        }];

        [MiPushSDK handleReceiveRemoteNotification:userInfo];
    }
    completionHandler();
}

//  >= iOS 7 <iOS 10
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [MiPushSDK handleReceiveRemoteNotification:userInfo];

    completionHandler(UIBackgroundFetchResultNewData);

    [self handleRemoteNotificationWithApplication:application userInfo:userInfo];
}

// < iOS 7
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [MiPushSDK handleReceiveRemoteNotification:userInfo];

    [self handleRemoteNotificationWithApplication:application userInfo:userInfo];
}
```

#### 个推推送

```objectivec
// iOS 10 Support, App Background
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSDictionary *userInfo = response.notification.request.content.userInfo;

    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //  点击通知栏打开消息，记录"App 点击通知"事件
        [AnalysysAgent trackCampaign:userInfo isClick:YES userCallback:^(id campaignInfo) {
            NSLog(@"此处可根据需要处理数据 : %@",campaignInfo);
        }];

        [GeTuiSdk handleRemoteNotification:userInfo];
    }
    completionHandler();
}

//  >= iOS 7 <iOS 10
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [GeTuiSdk handleRemoteNotification:userInfo];

    completionHandler(UIBackgroundFetchResultNewData);

    [self handleRemoteNotificationWithApplication:application userInfo:userInfo];
}

#pragma mark *** GeTuiSdkDelegate ***
/** SDK收到透传消息回调 */
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    // [ GTSdk ]：汇报个推自定义事件(反馈透传消息)
    [GeTuiSdk sendFeedbackMessage:90001 andTaskId:taskId andMsgId:msgId];

    // 数据转换
    NSString *payloadMsg = nil;
    if (payloadData) {
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes length:payloadData.length encoding:NSUTF8StringEncoding];

        //  若App在前台时用户做弹框等处理，请适当调整isClick:参数（是否用户点击）
        [AnalysysAgent trackCampaign:payloadMsg isClick:NO userCallback:^(id campaignInfo) {
            NSLog(@"此处可根据需要处理数据 : %@",campaignInfo);
        }];
    }
}
```

注：iOS 10.0以下回调方法统一调用的方法：

```objectivec
//  <iOS 10 版本统一处理通知回调方法
- (void)handleRemoteNotificationWithApplication:(UIApplication *)application userInfo:(NSDictionary *)userInfo{
    if (application.applicationState == UIApplicationStateActive) {
        //  App前台 收到推送消息，追踪"App 消息推送"事件
        [AnalysysAgent trackCampaign:userInfo isClick:NO userCallback:^(id campaignInfo) {
            NSLog(@"此处可根据需要处理数据 : %@",campaignInfo);
        }];

    } else if (application.applicationState == UIApplicationStateBackground) {
        //  App后台 收到推送消息，追踪"App 消息推送"事件
        [AnalysysAgent trackCampaign:userInfo isClick:NO userCallback:^(id campaignInfo) {
            NSLog(@"此处可根据需要处理数据 : %@",campaignInfo);
        }];
    } else {
        //  App非活动状态
        //  点击通知栏打开消息，记录"App 点击通知"事件
        [AnalysysAgent trackCampaign:userInfo isClick:YES userCallback:^(id campaignInfo) {
            NSLog(@"此处可根据需要处理数据 : %@",campaignInfo);
        }];
    }
}
```

