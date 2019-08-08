//
//  ViewController.m
//  FlutterHybridiOS
//
//  Created by jph on 2019/2/25.
//  Copyright © 2019 devio. All rights reserved.
//

#import <Flutter/Flutter.h>
#import "AppDelegate.h"
#import "ViewController.h"
@interface ViewController()
@property(nonatomic,assign) BOOL useEventChannel;
@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMessage:) name:@"showMessage" object:nil];
}
- (void)showMessage:(NSNotification*)notification{
    id params = notification.object;
    self.showLabel.text = [NSString stringWithFormat:@"来自Dart：%@",params];
}
- (IBAction)onSwitch:(id)sender {
    UISwitch *uiswitch = ((UISwitch*)sender);
    if (uiswitch.isOn) {
        self.useEventChannel = true;
    } else {
        self.useEventChannel = false;
    }
}

- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)editChange:(id)sender {
    NSString * text=((UITextField*)sender).text;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sendMessage" object:@{@"message": text,@"useEventChannel":self.useEventChannel? @"true":@"false"}];
}
- (void)handleButtonAction {
    //以一个完整页面打开Flutter模块
    FlutterViewController *flutterViewController = [FlutterViewController new];
    
    [flutterViewController setInitialRoute:@"{name:'devio',dataList:['aa','bb',''cc]}"];
    
    [self presentViewController:flutterViewController animated:true completion:nil];
    self.view=flutterViewController.view;
}
@end
