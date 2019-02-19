/*
 *  SGHorizontalControl.h
 *
 *  Copyright © 2017 Simon Gaus <simon.cay.gaus@gmail.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software 
 * and associated documentation files (the "Software"), to deal in the Software without restriction, 
 * including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
 * and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
 * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 */

@import UIKit;

// import delegate protocol
#import "SGHorizontalControlDelegateProtocol.h"

/**
 
 An `SGHorizontalControl` object is a horizontal control made of multiple segments, each segment functioning as a button. 
 When there are more segments than could be displayed, the user can scroll through the segments via pan gesture.
 
 */

NS_ASSUME_NONNULL_BEGIN


@interface SGHorizontalControl : UIView
#pragma mark - Properties

///-----------------
/// @name Properties
///-----------------

/**
 The delegate for the `SGHorizontalControl` object.
 */
@property (weak) IBOutlet NSObject<SGHorizontalControlDelegate> *delegate;
/**
 Returns the number of segments the receiver has.
 */
@property(nonatomic, readonly) NSUInteger numberOfSegments;
/**
 The index number identifying the selected segment. Default is 0.
 */
@property(nonatomic, readonly) NSInteger selectedSegmentIndex;

#pragma mark - Methodes

///----------------------
/// @name Inititalization
///----------------------

/**
 
 Initializes and returns a segmented control with segments having the given titles.
 
 Example usage:
 
 @code
 
 SGHorizontalControl *control = [[SGHorizontalControl alloc] initWithFrame:aRect
                                                                  andItems:@[@"A", @"B", @"C"]];
    
 control.textColor = [UIColor blackColor];
 control.highlightTextColor = [UIColor redColor];
 control.font = [UIFont systemFontOfSize:16.0f weight:UIFontWeightLight];
 control.numberOfSegmentsToDisplay = 2;
 control.delegate = self;
 [self.view addSubview:control];
 
 @endcode
 
 @param frame A rectangle specifying the initial location and size of the control in its superview’s coordinates.
 
 @param items An array of NSString objects (for segment titles).
 
 @return An `SGHorizontalControl​` object or nil if there was a problem in initializing the object.

 */
- (nullable instancetype)initWithFrame:(CGRect)frame andItems:(NSArray<NSString *> *)items;
/**
 
 Configures a segment control with segments having the given titles.
 
 @discussion The method is meant to be used, when setting up the control via Interface builder. When initializing the control with -initWithFrame:andItems: you dont need to call this method.
 
 @param items An array of NSString objects (for segment titles).
 
 */
- (void)configureWithItems:(NSArray<NSString *> *)items;

///---------------
/// @name Seletion
///---------------

/**
 
 Selects a segment in the horizontal control identified by index, optionally scrolling to the segment.
 Calling this method does not cause the delegate to receive a didSelectSegmentAtIndex: message.
 
 @param index The index of the segment to select.
 
 */
- (void)selectSegmentAtIndex:(NSInteger)index;

#pragma mark - Appearance

///-----------------
/// @name Appearance
///-----------------

/**
 The number of segments displayed at the same time. Default is 3.
 */
@property(nonatomic, readwrite) NSUInteger numberOfSegmentsToDisplay;
/**
 The text color of the segment label.
 */
@property (nonatomic, strong) UIColor *textColor;
/**
 The text color of the segment label when selected.
 */
@property (nonatomic, strong) UIColor *highlightTextColor;
/**
 The font of the segment label.
 */
@property (nonatomic, strong) UIFont *font;

@end
NS_ASSUME_NONNULL_END
