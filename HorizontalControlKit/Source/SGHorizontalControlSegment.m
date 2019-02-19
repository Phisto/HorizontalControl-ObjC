/*
 *  SGHorizontalControlSegment.m
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

#import "SGHorizontalControlSegment.h"

@interface SGHorizontalControlSegment (/* Private */)

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, readwrite) BOOL selected;

@end

@implementation SGHorizontalControlSegment
#pragma mark - Object Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpSubviews];
        [self setUpGestureRecognizer];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        [self setUpSubviews];
        [self setUpGestureRecognizer];
    }
    return self;
}

#pragma mark - Layout

- (void)setUpSubviews {

    // LABEL CONSTRAINTS
    // disable translatesAutoresizingMaskIntoConstraints
    self.label.translatesAutoresizingMaskIntoConstraints = NO;
    // pin to leading/trailing anchor
    NSLayoutConstraint *leadingConstraint_label = [self.label.leadingAnchor constraintEqualToAnchor:self.leadingAnchor];
    NSLayoutConstraint *trailingConstraint_label = [self.label.trailingAnchor constraintEqualToAnchor:self.trailingAnchor];
    // pin to top/bottom anchor
    NSLayoutConstraint *topConstraint_label = [self.label.topAnchor constraintEqualToAnchor:self.topAnchor];
    NSLayoutConstraint *bottomConstraint_label = [self.label.bottomAnchor constraintEqualToAnchor:self.bottomAnchor];
    
    //NSLayoutConstraint *hightsConstraint_label = [self.label.heightAnchor constraintEqualToAnchor:self.heightAnchor multiplier:1];
    
    
    // set constant heigth anchor
    
    // activate
    leadingConstraint_label.active = YES;
    trailingConstraint_label.active = YES;
    topConstraint_label.active = YES;
    bottomConstraint_label.active = YES;
    
    //hightsConstraint_label.active = YES;
}

- (void)setColors {
    
    [self.label setTextColor:self.selected ? self.highlightColor : self.textColor];
}

#pragma mark - Tap Gesture Recognizer Methodes

- (void)setUpGestureRecognizer {
    
    [self addGestureRecognizer:self.tapGestureRecognizer];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    
    [self.delegate didReceiveClickAtIndex:self.index];
}

#pragma mark - Setter Methodes

- (void)setSelected:(BOOL)selected {
    
    _selected = selected;
    [self setColors];
}

- (void)setText:(NSString *)text {
 
    [self.label setText:text];
}

- (void)setFont:(UIFont *)font {
    
    [self.label setFont:font];
}

- (void)setTextColor:(UIColor *)textColor {
    
    
    if (textColor) _textColor = textColor;
    [self setColors];
}

- (void)setHighlightColor:(UIColor *)highlightColor {
    
    if (highlightColor) _highlightColor = highlightColor;
    [self setColors];
}

#pragma mark - Lazy/Getter Methodes 

- (UILabel *)label {
    
    if (!_label) {
        
        _label = [[UILabel alloc] initWithFrame:CGRectZero];
        _label.font = [UIFont systemFontOfSize:17.0f weight:UIFontWeightLight];
        _label.numberOfLines = 0;
        _label.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_label];
    }
    return _label;
}

- (UITapGestureRecognizer *)tapGestureRecognizer {
    
    if (!_tapGestureRecognizer) {
        
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(handleSingleTap:)];
    }
    return _tapGestureRecognizer;
}

#pragma mark -
@end
