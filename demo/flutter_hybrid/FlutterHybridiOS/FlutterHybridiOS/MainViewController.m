//
//  ViewController+MianViewController.m
//  FlutterHybridiOS
//
//  Created by jph on 2019/2/27.
//  Copyright © 2019 devio. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "MainViewController.h"
@interface MainViewController ()<FlutterStreamHandler>
@property (nonatomic) FlutterViewController* flutterViewController;
@property (nonatomic) FlutterBasicMessageChannel* messageChannel;
@property (nonatomic) FlutterEventChannel* eventChannel;
@property (nonatomic) FlutterMethodChannel* methodChannel;
@property (nonatomic) FlutterEventSink eventSink;
@end
@implementation MainViewController
- (void)viewDidLoad{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendMessage:) name:@"sendMessage" object:nil];
    [super viewDidLoad];
}
#pragma mark - naviagor
- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender {
    
    if ([segue.destinationViewController isKindOfClass:[FlutterViewController class]]) {
        self.flutterViewController = segue.destinationViewController;
        [self.flutterViewController setInitialRoute:self.inputParams];
        [self initChannel];
    }
}
#pragma mark - sendMessage
- (void)sendMessage:(NSNotification*)notification{
    NSString* mesage = [notification.object valueForKey:@"message"];
    if ([@"true" isEqual:[notification.object valueForKey:@"useEventChannel"]]) {
        //用EventChannel传递数据
        if (self.eventSink != nil) {
            self.eventSink(mesage);
        }
    } else {
        //用MessageChannel传递数据
        [self.messageChannel sendMessage: mesage reply:^(id  _Nullable reply) {
            if (reply != nil) {
                [self sendShow:reply];
            }
        }];
    }
}
#pragma mark - init Channel
- (void)initChannel{
    [self initMessageChannel];
    [self initEventChannel];
    [self initMethodChannel];
}
- (void)initMessageChannel{
    self.messageChannel = [FlutterBasicMessageChannel messageChannelWithName:@"BasicMessageChannelPlugin" binaryMessenger:self.flutterViewController codec:[FlutterStringCodec sharedInstance]];
    MainViewController*  __weak weakSelf = self;
    //设置消息处理器，处理来自Dart的消息
    [self.messageChannel setMessageHandler:^(NSString* message, FlutterReply reply) {
        reply([NSString stringWithFormat:@"BasicMessageChannel收到：%@",message]);
        [weakSelf sendShow:message];
    }];
}
- (void)initEventChannel{
    self.eventChannel = [FlutterEventChannel eventChannelWithName:@"EventChannelPlugin" binaryMessenger:self.flutterViewController];
    
    //设置消息处理器，处理来自Dart的消息
    [self.eventChannel setStreamHandler:self];
}
- (void)initMethodChannel{
    self.methodChannel = [FlutterMethodChannel methodChannelWithName:@"MethodChannelPlugin" binaryMessenger:self.flutterViewController];
    MainViewController*  __weak weakSelf = self;
    [self.methodChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        if ([@"send" isEqualToString:call.method]) {
            result([NSString stringWithFormat:@"MethodChannelPlugin收到：%@",call.arguments]);//返回结果给Dart);
            [weakSelf sendShow:call.arguments];
        }
    }];
}
- (void)sendShow:(NSString*) message{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showMessage" object:message];
}
#pragma mark - <FlutterStreamHandler>
//这个onListen是Flutter端开始监听这个channel时的回调，第二个参数 EventSink是用来传数据的载体
- (FlutterError* _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(FlutterEventSink)eventSink {
    // arguments flutter给native的参数
    // 回调给flutter， 建议使用实例指向，因为该block可以使用多次
    self.eventSink = eventSink;
    return nil;
}

/// flutter不再接收
- (FlutterError* _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    // arguments flutter给native的参数
    self.eventSink = nil;
    return nil;
}

@end
