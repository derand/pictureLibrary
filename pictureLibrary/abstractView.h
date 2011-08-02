//
//  abstractView.h
//  pictureLibrary
//
//  Created by Andrey Derevyagin on 7/27/11.
//  Copyright 2011 interMobile. All rights reserved.
//

#import <UIKit/UIKit.h>


@class picturesViewController;


typedef enum
{
	verticalViewAlignNone = 0,
	verticalViewAlignTop = 1,
	verticalViewAlignCenter = 2,
	verticalViewAlignBottom = 3,
} eVerticalViewAlign;

typedef enum
{
	horizontalViewAlignNone = 0,
	horizontalViewAlignLeft = 1,
	horizontalViewAlignCenter = 2,
	horizontalViewAlignRight = 3,
} eHorizontalViewAlign;



@interface abstractView : UIView
{
	BOOL showed;
	
	picturesViewController *parent;
	
	eVerticalViewAlign verticalAlign;
	eHorizontalViewAlign horizontalAlign;
	CGRect _savedFrame;
}

@property (nonatomic, readonly) CGSize needSize;
@property (nonatomic, retain) picturesViewController *parent;
@property (nonatomic, readonly) BOOL showed;

@property (nonatomic, assign) eVerticalViewAlign verticalAlign;
@property (nonatomic, assign) eHorizontalViewAlign horizontalAlign;


- (void) showInView:(UIView *) _view animated:(BOOL) animated;
- (void) unshowAnimated:(BOOL) animated;

- (void) setViewSizeInFrame:(CGRect) frame;

@end
