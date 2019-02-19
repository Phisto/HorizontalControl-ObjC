/*
 *  SGHorizontalControlSegment.h
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

/**
 
 The delegate of a `SGHorizontalControlSegment` object must adopt the SGHorizontalControlSegmentDelegate protocol. The delegate will be notified about selection.
 
 */

NS_ASSUME_NONNULL_BEGIN

@protocol SGHorizontalControlSegmentDelegate <NSObject>
#pragma mark - Required Delegate Methodes

///---------------------------------
/// @name Required Delegate Methodes
///---------------------------------

@required
/**
 
 Informs the delegate that a segment was selected.
 
 @param index The index of the selected Segment
 
 */
- (void)didReceiveClickAtIndex:(NSInteger)index;

@end
#pragma mark - 

/**
 
 The `SGHorizontalControlSegment` class defines the attributes and behavior of the segment that appear in `SGHorizontalControl` objects. This class includes properties and methods for setting and managing segment content, managing the segment selection and initiating of the segmente.  contents.
 
 */

@interface SGHorizontalControlSegment : UIView
#pragma mark - Properties

///-----------------
/// @name Properties
///-----------------

/**
 The index of the cell.
 */
@property (nonatomic, readwrite) NSInteger index;

/**
 The delegate of the SGHorizontalControl cell.
 */
@property (nonatomic, assign) NSObject<SGHorizontalControlSegmentDelegate> *delegate;

///----------------
/// @name Selection
///----------------

#pragma mark - Selection Methodes
/**
 Will set the segment as selcted.
 */
- (void)setSelected:(BOOL)selected;

#pragma mark - Appearance

///-----------------
/// @name Appearance
///-----------------

/**
 The text color of the segment label.
 */
@property (nonatomic, strong) UIColor *textColor;
/**
 The text color of the segment label when selected.
 */
@property (nonatomic, strong) UIColor *highlightColor;
/**
 The width constraint for the segment;
 */
@property (nonatomic, strong) NSLayoutConstraint *widthConstraint;
/**
 Will set the text of the segment label.
 */
- (void)setText:(NSString *)text;
/**
 Will set the font of the segment label.
 */
- (void)setFont:(UIFont *)font;

@end
NS_ASSUME_NONNULL_END
