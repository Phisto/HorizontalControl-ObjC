# SGHorizontalControl
A horizontal control made of multiple segments, each segment functioning as a button.  When there are more segments than could be displayed, the user can scroll through the segments via pan gesture.



![Example Video](http://simonsapps.de/horizontal-usage-opt.gif)



### Usage
Add the source files to your project and you are good to go.

###### Programmatically:
```objc
// set up control
SGHorizontalControl *control = [[SGHorizontalControl alloc] initWithFrame:aRect
                                                                 andItems:@[@"A", @"B", @"C"]];
control.delegate = self;

// configure appearance
control.backgroundColor = [UIColor ...];
control.textColor = [UIColor ...];
control.highlightTextColor = [UIColor ...];
control.font = [UIFont systemFontOfSize:16.0f weight:UIFontWeightLight];
control.numberOfSegmentsToDisplay = 2;

// add to view
[self.view addSubview:control];

// default segment is 0
[control selectSegmentAtIndex:1];
```
###### Interface Builder:
```objc
@property (nonatomic, strong) IBOutlet SGHorizontalControl *control;
 
 .
 .
 .

// set up control
[self.control configureWithItems:@[@"A", @"B", @"C"]];
self.control.delegate = self;

// configure appearance
self.control.backgroundColor = [UIColor ...];
self.control.textColor = [UIColor ...];
self.control.highlightTextColor = [UIColor ...];
self.control.font = [UIFont systemFontOfSize:16.0f weight:UIFontWeightLight];
self.control.numberOfSegmentsToDisplay = 2;

// default segment is 0
[self.control selectSegmentAtIndex:1];
```
###### Receive selection changes:
```objc
- (void)didSelectSegmentAtIndex:(NSInteger)index {
    NSLog(@"didSelectSegmentAtIndex:%lu", index);
}
```

### Technical Notes

* SGHorizontalControl uses Autolayout to resize its content and won't work if Autolayout is disabled.
* Be aware that SGHorizontalControl don't use any caching mechanism for it's segments.

### Lizense
SGHorizontalControl is released under [MIT License](https://github.com/Phisto/SGHorizontalControl/blob/master/LICENSE "MIT License")
