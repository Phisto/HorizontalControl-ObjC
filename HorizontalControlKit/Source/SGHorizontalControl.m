/*
 *  SGHorizontalControl.m
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

#import "SGHorizontalControl.h"
#import "SGHorizontalControlSegment.h"

@interface SGHorizontalControl (/* Private */)<SGHorizontalControlSegmentDelegate, UIScrollViewDelegate>

// VIEW PROPERTIES
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;

// OTHER PROPERTIES
@property (nonatomic, strong) NSArray<SGHorizontalControlSegment *> *segments;
@property (nonatomic, strong) NSLayoutConstraint *containerViewWidthConstraint;

// CONTROL PROPERTIES
@property (nonatomic, readwrite) NSInteger selectedIndex;
@property (nonatomic, readwrite) CGFloat widthPerElement;
@property (nonatomic, readwrite, getter=isScrolling) CGFloat scrolling;

@end

@implementation SGHorizontalControl
#pragma mark - Object Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        // set defaults
        _selectedIndex = 0;
        _numberOfSegmentsToDisplay = 3;
        _scrolling = NO;
        _textColor = [UIColor blackColor];
        _highlightTextColor = [UIColor redColor];
        _font = [UIFont systemFontOfSize:16.0f weight:UIFontWeightLight];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andItems:(NSArray<NSString *> *)items {
    
    self = [self initWithFrame:frame];
    if (self) {
        
        // configure segments
        [self configureWithItems:items];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        // set defaults
        _selectedIndex = 0;
        _numberOfSegmentsToDisplay = 3;
        _scrolling = NO;
        _textColor = [UIColor blackColor];
        _highlightTextColor = [UIColor redColor];
        _font = [UIFont systemFontOfSize:16.0f weight:UIFontWeightLight];
    }
    return self;
}

#pragma mark - Layout Methodes

- (void)configureWithItems:(NSArray<NSString *> *)items {
    
    // set up scroll view+constraints
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    // add to view
    [self addSubview:_scrollView];

    
    // disable translatesAutoresizingMaskIntoConstraints
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    // pin to leading/trailing and top/bottom anchor
    NSLayoutConstraint *leadingConstraint_scroll = [_scrollView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor];
    NSLayoutConstraint *trailingConstraint_scroll = [_scrollView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor];
    NSLayoutConstraint *topConstraint_scroll = [_scrollView.topAnchor constraintEqualToAnchor:self.topAnchor];
    NSLayoutConstraint *bottomConstraint_scroll = [_scrollView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor];
    // activate
    leadingConstraint_scroll.active = YES;
    trailingConstraint_scroll.active = YES;
    topConstraint_scroll.active = YES;
    bottomConstraint_scroll.active = YES;
    
    
    // set up content view
    _contentView = [[UIView alloc] initWithFrame:CGRectZero];
    // add to scroll view
    [_scrollView addSubview:_contentView];
    // disable translatesAutoresizingMaskIntoConstraints
    _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    //
    // pin to leading/trailing and top/bottom anchor
    //
    // This is important as the scrollview need this to calculate content size.
    // Trailing and bottom anchor will be "ignored" in the sense that we need to set explicit heigth and width.
    //
    NSLayoutConstraint *leadingConstraint_container = [_contentView.leadingAnchor constraintEqualToAnchor:_scrollView.leadingAnchor];
    NSLayoutConstraint *trailingConstraint_container = [_contentView.trailingAnchor constraintEqualToAnchor:_scrollView.trailingAnchor];
    NSLayoutConstraint *topConstraint_container = [_contentView.topAnchor constraintEqualToAnchor:_scrollView.topAnchor];
    NSLayoutConstraint *bottomConstraint_container = [_contentView.bottomAnchor constraintEqualToAnchor:_scrollView.bottomAnchor];
    
    // add width and height constraint
    NSLayoutConstraint *hightsConstraint_container = [_contentView.heightAnchor constraintEqualToAnchor:self.heightAnchor multiplier:1.0f];
    NSLayoutConstraint *widthConstraint_container = [_contentView.widthAnchor constraintEqualToConstant:0.0f];
    // activate
    leadingConstraint_container.active = YES;
    trailingConstraint_container.active = YES;
    topConstraint_container.active = YES;
    bottomConstraint_container.active = YES;
    // set width
    widthConstraint_container.active = YES;
    hightsConstraint_container.active = YES;
    // safe reference
    _containerViewWidthConstraint = widthConstraint_container;
    
    
    // get values
    NSInteger numberOfSegments = items.count;
    NSInteger maxNumSegments = _numberOfSegmentsToDisplay;
    CGFloat widthPerElement =  (numberOfSegments > maxNumSegments) ? self.frame.size.width/maxNumSegments : self.frame.size.width/numberOfSegments;
    
    
    // prepare segment array
    NSMutableArray *segments = [NSMutableArray array];
    NSLayoutAnchor<NSLayoutXAxisAnchor *> *leftAnchor = _contentView.leadingAnchor;
    
    // create segments
    for (int i = 0 ; i < numberOfSegments ; i++) {
        
        SGHorizontalControlSegment *cell = [[SGHorizontalControlSegment alloc] initWithFrame:CGRectZero];
        cell.delegate = self;
        [_contentView addSubview:cell];
        
        // set constraints
        // disable translatesAutoresizingMaskIntoConstraints
        cell.translatesAutoresizingMaskIntoConstraints = NO;
        // pin to leading/trailing and top/bottom anchor
        NSLayoutConstraint *leadingConstraint_cell = [cell.leadingAnchor constraintEqualToAnchor:leftAnchor];
        NSLayoutConstraint *topConstraint_cell = [cell.topAnchor constraintEqualToAnchor:_contentView.topAnchor];
        NSLayoutConstraint *bottomConstraint_cell = [cell.bottomAnchor constraintEqualToAnchor:_contentView.bottomAnchor];
        // width constraint
        NSLayoutConstraint *widthConstraint_cell = [cell.widthAnchor constraintEqualToConstant:widthPerElement];
        // activate
        leadingConstraint_cell.active = YES;
        topConstraint_cell.active = YES;
        bottomConstraint_cell.active = YES;
        widthConstraint_cell.active = YES;
        // safe reference
        cell.widthConstraint = widthConstraint_cell;
        leftAnchor = cell.trailingAnchor;
        
        
        // set appearance
        [cell setFont:self.font];
        [cell setTextColor:self.textColor];
        [cell setHighlightColor:self.highlightTextColor];
        // set content
        [cell setText:items[i]];
        [cell setSelected:(i == self.selectedIndex)];
        cell.index = i;
        
        [segments addObject:cell];
    }
    
    // set segment array
    _segments = [segments copy];
    
    // intit widht of segment
    _widthPerElement = 1.0f;
}

- (void)layoutSubviews {

    // get values
    NSUInteger offsetInNumberOfSegments = (NSUInteger)(self.scrollView.contentOffset.x/self.widthPerElement);
    CGFloat oldWidth = self.widthPerElement;
    NSInteger numberOfSegments = self.numberOfSegments;
    NSInteger maxNumSegments = self.numberOfSegmentsToDisplay;
    CGFloat widthPerElement =  self.frame.size.width/numberOfSegments;
    if (numberOfSegments > maxNumSegments) widthPerElement = self.frame.size.width/maxNumSegments;
    
    // only layout if size changed ...
    if (oldWidth != widthPerElement) {

        // manually resize scrollview
        //[self.scrollView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        
        self.containerViewWidthConstraint.constant = numberOfSegments*widthPerElement;
        self.scrollView.contentSize = CGSizeMake(numberOfSegments*widthPerElement, self.frame.size.height);
        for (SGHorizontalControlSegment *segment in self.segments) {
            
            segment.widthConstraint.constant = widthPerElement;
        }
        
        // only restore if width changed
        // restore content offset if width changed
        CGRect scrollBounds = self.scrollView.bounds;
        scrollBounds.origin = CGPointMake(offsetInNumberOfSegments*widthPerElement, 0.0f);
        self.scrollView.bounds = scrollBounds;
            
        self.widthPerElement = widthPerElement;
    }
}

- (void)updateColor {
    
    for (SGHorizontalControlSegment *cell in self.segments) {
        
        [cell setHighlightColor:self.highlightTextColor];
        [cell setTextColor:self.textColor];
    }
}

- (void)updateFont {
    
    for (SGHorizontalControlSegment *cell in self.segments) {
        
        [cell setFont:self.font];
    }
}

#pragma mark - Scroll View Delegate Methodes

-(void)scrollViewDidScroll:(UIScrollView *)sender {

    self.scrolling = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    //ensure that the end of scroll is fired.
    [self performSelector:@selector(scrollViewDidEndScrollingAnimation:) withObject:sender afterDelay:0.3];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    if (fmodf(scrollView.contentOffset.x, self.widthPerElement) < self.widthPerElement/2.0f) {
        
        [scrollView setContentOffset:CGPointMake((scrollView.contentOffset.x-fmodf(scrollView.contentOffset.x, self.widthPerElement)), 0) animated:YES];
    }
    else {
        
        [scrollView setContentOffset:CGPointMake((scrollView.contentOffset.x+(self.widthPerElement-fmodf(scrollView.contentOffset.x, self.widthPerElement))), 0) animated:YES];
    }
    
    self.scrolling = NO;
}

#pragma mark - Horizontal Control Delegate Methodes

- (void)didReceiveClickAtIndex:(NSInteger)index {
    
    if (!self.isScrolling) [self didReceiveClickAtIndex:index withDelegateCall:YES];
}

#pragma mark - Selection Methodes

- (void)selectSegmentAtIndex:(NSInteger)index {

    [self didReceiveClickAtIndex:index withDelegateCall:NO];
}

- (void)didReceiveClickAtIndex:(NSInteger)index withDelegateCall:(BOOL)callDelegate {

    if (index != self.selectedIndex) {
        
        // we may need to do some scrolling
        if (self.segments.count > self.numberOfSegmentsToDisplay) {
            
            CGFloat currentOffset = self.scrollView.contentOffset.x;
            CGFloat offsetOfSegment = [self offsetForSegmentAtIndex:index];
            BOOL needToScroll = NO;
            
            // segment is leftmoste segement
            if (AFIsOffsetNearlyEqualToOffset(currentOffset, offsetOfSegment)) {
                
                // if its not the first segment scroll one segment to the right
                if (index != 0) {
                    
                    currentOffset = currentOffset - self.widthPerElement;
                    needToScroll = YES;
                }
            }
            // segment is rightmost segement
            else if (AFIsOffsetNearlyEqualToOffset(currentOffset+(self.widthPerElement*(self.numberOfSegmentsToDisplay-1)), offsetOfSegment)) {
                
                // if its not the last segment scroll one segment to the left
                if (index != self.numberOfSegments-1) {
                    
                    currentOffset = currentOffset + self.widthPerElement;
                    needToScroll = YES;
                }
            }
            
            // if currentOffset changed scroll
            if (needToScroll) {
                
                [UIView animateWithDuration:0.2f animations:^{
                    
                    CGRect scrollBounds = self.scrollView.bounds;
                    scrollBounds.origin = CGPointMake(currentOffset, 0.0f);
                    self.scrollView.bounds = scrollBounds;
                    
                }];
            }
        }
        
        SGHorizontalControlSegment *currentCell = self.segments[self.selectedIndex];
        [currentCell setSelected:NO];
        
        SGHorizontalControlSegment *newCell = self.segments[index];
        [newCell setSelected:YES];
        
        // set new index
        self.selectedIndex = index;
    }
    
    // if callback
    if (callDelegate && [self.delegate respondsToSelector:@selector(didSelectSegmentAtIndex:)]) [self.delegate didSelectSegmentAtIndex:index];
}

#pragma mark - Lazy/Getter Methodes

- (NSUInteger)numberOfSegments {
    
    return self.segments.count;
}

#pragma mark - Apperance Methodes

- (void)setTextColor:(UIColor *)textColor {
    
    _textColor = textColor;
    [self updateColor];
}

- (void)setHighlightTextColor:(UIColor *)highlightTextColor {
    
    _highlightTextColor = highlightTextColor;
    [self updateColor];
}

- (void)setFont:(UIFont *)font {
    
    _font = font;
    [self updateFont];
}

#pragma mark - Helper/Calulate Methodes

- (CGFloat)offsetForSegmentAtIndex:(NSInteger)index {
    
    return self.widthPerElement*index;
}

#pragma mark - Funktions

///!!!: This is to prevent rounding errors when comparing two offsets ...
static inline BOOL AFIsOffsetNearlyEqualToOffset(CGFloat firstOffset, CGFloat secondOffset) {
    
    return (firstOffset < secondOffset) ? ((secondOffset-firstOffset) < 2.0f) : ((firstOffset-secondOffset) < 2.0f);
}

#pragma mark -
@end
