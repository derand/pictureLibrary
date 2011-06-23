//
//  imageBackgroundView.m
//  pictureLibrary
//
//  Created by maliy on 6/7/11.
//

#import "imageBackgroundView.h"


@implementation imageBackgroundView
@synthesize image;
@synthesize scale;
@synthesize delegate;
@synthesize parent;


- (id) initWithFrame:(CGRect) frame
{
    self = [super initWithFrame:frame];
    if (self)
	{
        // Initialization code
		self.clearsContextBeforeDrawing = YES;
		scale = 1.0;
		image = nil;
    }
    return self;
}

- (void) drawRect:(CGRect) rct
{
	if (!image)
		return ;
	
//	NSLog(@"reDraw: %fx%f, %fx%f", rct.origin.x, rct.origin.y, rct.size.width, rct.size.height);
	
	[image drawInRect:[self imageRect]];
}

- (void) dealloc
{
	self.image = nil;
    [super dealloc];
}

#pragma mark -

- (CGRect) imageRect
{
	CGRect rv = CGRectZero;
	if (!image)
		return rv;
	
	CGSize sz = image.size;
	rv = self.bounds;
	if (fabs(sz.width)>.5 && fabs(sz.height)>.5)
	{
		CGFloat aspectImg = sz.width/sz.height;
		CGFloat aspectScreen = rv.size.width/rv.size.height;
		if (aspectImg>aspectScreen)
		{
			sz = CGSizeMake(rv.size.width, sz.height*rv.size.width/sz.width);
		}
		else
		{
			sz = CGSizeMake(sz.width*rv.size.height/sz.height, rv.size.height);
		}
		rv.origin = CGPointMake((rv.size.width-sz.width)/2.0, (rv.size.height-sz.height)/2.0);
		rv.size = sz;
	}
	return rv;
}


- (void) setFrame:(CGRect)frame
{
	BOOL needRedraw = fabs(self.frame.size.width-frame.size.width)>.5 || fabs(self.frame.size.height-frame.size.height)>.5;
	[super setFrame:frame];
	if (needRedraw)
	{
		[self setNeedsDisplayInRect:self.bounds];
//		[self setNeedsDisplayInRect:CGRectMake(0.0, 0.0, 50.0, 50.0)];
	}
}

- (void) setImage:(UIImage *) _image
{
	[image release];
	image = [_image retain];
	
	[self setNeedsDisplay];
}


#pragma mark touches

- (void) touchesBegan:(NSSet *) touches withEvent:(UIEvent *) event
{
	move = NO;
}

- (void) touchesEnded:(NSSet *) touches withEvent:(UIEvent *) event
{
	if (!move)
	{
		if (delegate)
		{
			[delegate imageBackgroundViewSingleTouch:self];
		}
	}
}

- (void) touchesMoved:(NSSet *) touches withEvent:(UIEvent *) event
{
	move = YES;
}	


#pragma mark transform

- (void) setTransformWithoutScaling:(CGAffineTransform) newTransform
{
    [super setTransform:newTransform];
}

- (void) setTransform:(CGAffineTransform) newValue
{
    [super setTransform:CGAffineTransformScale(newValue, 1.0 / scale, 1.0 / scale)];
}

@end
