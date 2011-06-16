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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
	{
        // Initialization code
//		self.clearsContextBeforeDrawing = YES;
		scale = 1.0;
		image = nil;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
//	NSLog(@"%s %fx%f %fx%f", __FUNCTION__, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
/*	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetLineWidth(context, 1);
	
	CGMutablePathRef path;
	path = CGPathCreateMutable();
	CGPathMoveToPoint(path, NULL, rect.origin.x, rect.origin.y);
	CGPathAddLineToPoint(path, NULL, rect.origin.x+rect.size.width, rect.origin.y+rect.size.height);
	CGPathMoveToPoint(path, NULL, rect.origin.x, rect.origin.y+rect.size.height);
	CGPathAddLineToPoint(path, NULL, rect.origin.x+rect.size.width, rect.origin.y);
	CGContextAddPath(context, path);
	CGContextSetFillColorWithColor(context, [UIColor colorWithRed:102.0/256.0 green:5.0/256.0 blue:90.0/256 alpha:.95].CGColor);
	CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
	CGContextDrawPath(context, kCGPathFillStroke);
	CGPathRelease(path);

	
	return ;
*/	
	if (!image)
		return ;
		
	CGSize sz = image.size;
	CGRect rct = self.bounds;
	if (fabs(sz.width)>.5 && fabs(sz.height)>.5)
	{
		CGFloat aspectImg = sz.width/sz.height;
		CGFloat aspectScreen = rct.size.width/rct.size.height;
		if (aspectImg>aspectScreen)
		{
			sz = CGSizeMake(rct.size.width, sz.height*rct.size.width/sz.width);
		}
		else
		{
			sz = CGSizeMake(sz.width*rct.size.height/sz.height, rct.size.height);
		}
		rct.origin = CGPointMake((rct.size.width-sz.width)/2.0, (rct.size.height-sz.height)/2.0);
		rct.size = sz;
	}
	
	[image drawInRect:rct];
}

- (void)dealloc
{
	self.image = nil;
    [super dealloc];
}

#pragma mark -

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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	move = NO;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (!move)
	{
		if (delegate)
		{
			[delegate imageBackgroundViewSingleTouch:self];
		}
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	move = YES;
}	


#pragma mark transform

- (void)setTransformWithoutScaling:(CGAffineTransform)newTransform
{
    [super setTransform:newTransform];
}


- (void)setTransform:(CGAffineTransform)newValue
{
    [super setTransform:CGAffineTransformScale(newValue, 1.0 / scale, 1.0 / scale)];
}

@end
