//
//  ViewController.h
//  FlutterHybridiOS
//
//  Created by jph on 2019/2/25.
//  Copyright © 2019 devio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
- (IBAction)onSwitch:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *switchLable;
@property (weak, nonatomic) IBOutlet UILabel *showLabel;
- (IBAction)onBack:(id)sender;
- (IBAction)editChange:(id)sender;


@end

