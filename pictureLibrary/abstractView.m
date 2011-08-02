//
//  abstractView.m
//  pictureLibrary
//
//  Created by Andrey Derevyagin on 7/27/11.
//  Copyright 2011 interMobile. All rights reserved.
//

#import "abstractView.h"
#import "picturesViewController.h"



#define SHOW_DURATION	.3
#define BORDER_DIFF		10.0


@implementation abstractView
@synthesize parent;
@synthesize showed;
@synthesize verticalAlign, horizontalAlign;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		
		showed = NO;
		verticalAlign = verticalViewAlignNone;
		horizontalAlign = horizontalViewAlignNone;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) dealloc
{
	self.parent = nil;
	
	[super dealloc];
}

#pragma mark -

- (CGSize) needSize
{
	return CGSizeZero;
}

- (void) showInView:(UIView *) _view animated:(BOOL) animated
{
	self.alpha = animated?0.0:1.0;

	[_view addSubview:self];
	if (animated)
	{
		[UIView animateWithDuration:SHOW_DURATION
						 animations:^{
							 self.alpha = 1.0;
						 }
						 completion:^(BOOL finished) {
							 showed = YES;
						 }];
	}
	else
	{
		showed = YES;
	}
}

- (void) unshowAnimated:(BOOL) animated
{
	if (animated)
	{
		[UIView animateWithDuration:SHOW_DURATION
						 animations:^{
							 self.alpha = 0.0;
						 }
						 completion:^(BOOL finished) {
							 [self removeFromSuperview];
							 showed = NO;
						 }];
	}
	else
	{
		[self removeFromSuperview];
		showed = NO;
	}
}

- (void) setViewSizeInFrame:(CGRect) frame
{
	_savedFrame = frame;
	CGSize sz = self.needSize;
	sz.height = MIN(sz.height, frame.size.height-2.0*BORDER_DIFF-2.5*(parent.barsShowed?parent.toolBar.frame.size.height:0.0));
	CGRect rct = CGRectZero;
	rct.size = sz;
	switch (self.horizontalAlign)
	{
		case horizontalViewAlignLeft:
			rct.origin.x = BORDER_DIFF;
			break;
		case horizontalViewAlignCenter:
			rct.origin.x = (frame.size.width-sz.width)/2.0;
			break;
		case horizontalViewAlignRight:
			rct.origin.x = frame.size.width-BORDER_DIFF-sz.width;
			break;
			
		default:
			break;
	}
	switch (self.verticalAlign)
	{
		case verticalViewAlignTop:
			rct.origin.y = BORDER_DIFF + (parent.barsShowed?parent.navigationController.navigationBar.frame.size.height*1.5:0.0);
			break;
		case verticalViewAlignCenter:
			rct.origin.y = (frame.size.height-sz.height)/2.0;
			break;
		case verticalViewAlignBottom :
			rct.origin.y = frame.size.height -BORDER_DIFF - sz.height - (parent.barsShowed?parent.toolBar.frame.size.height:0.0);
			break;
			
		default:
			break;
	}
/*	
	CGRectMake(frame.size.width-BORDER_DIFF-sz.width, frame.size.height-sz.height-BORDER_DIFF, sz.width, sz.height);
	if (parent.barsShowed)
	{
		rct.origin.y -= parent.toolBar.frame.size.height;
	}
*/
	self.frame = rct;
	
	[self setNeedsDisplay];
}

- (void) setVerticalAlign:(eVerticalViewAlign) _verticalAlign
{
	verticalAlign = _verticalAlign;
	
	if (showed)
	{
		[self setViewSizeInFrame:_savedFrame];
	}
}

- (void) setHorizontalAlign:(eHorizontalViewAlign) _horizontalAlign
{
	horizontalAlign = _horizontalAlign;
	
	if (showed)
	{
		[self setViewSizeInFrame:_savedFrame];
	}
}

@end
