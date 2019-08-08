//
//  FirstViewController.m
//  FlutterHybridiOS
//
//  Created by jph on 2019/2/27.
//  Copyright © 2019 devio. All rights reserved.
//

#import "FirstViewController.h"
#import "MainViewController.h"
@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[MainViewController class]]) {
        ((MainViewController*)segue.destinationViewController
         ).inputParams=self.inputParams.text;
    }
}

- (IBAction)onBack:(id)sender {
}
@end
