//
//  ViewController.m
//  HorizontalControl-ObjC
//
//  Created by Simon Gaus on 22.06.17.
//  Copyright © 2017 Simon Gaus. All rights reserved.
//

#import "ViewController.h"

#import "SGHorizontalControl.h"

@interface ViewController (/* Private */) <SGHorizontalControlDelegate>

@property (nonatomic, strong) IBOutlet SGHorizontalControl *control;

@end

@implementation ViewController
#pragma mark - View Controller Methodes


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // set up control
    [self.control configureWithItems:@[@"A", @"B", @"C", @"D", @"E"]];
    self.control.delegate = self;
    
    // configure appearance
    self.control.backgroundColor = [UIColor blackColor];
    self.control.textColor = [UIColor whiteColor];
    self.control.highlightTextColor = [UIColor redColor];
    self.control.font = [UIFont systemFontOfSize:16.0f weight:UIFontWeightLight];
    self.control.numberOfSegmentsToDisplay = 3;
    
    // default segment is 0
    //[self.control selectSegmentAtIndex:1];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Horizontal Control Delegate Methodes

- (void)didSelectSegmentAtIndex:(NSInteger)index {
    NSLog(@"didSelectSegmentAtIndex:%lu", index);
}

#pragma mark -
@end
