//
//  cPageSelectView.m
//  pictureLibrary
//
//  Created by Andrey Derevyagin on 8/1/11.
//  Copyright 2011 interMobile. All rights reserved.
//

#import "cPageSelectView.h"



@implementation cPageSelectView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
	{
        // Initialization code
		self.backgroundColor = [UIColor clearColor];
		self.verticalAlign = verticalViewAlignTop;
		self.horizontalAlign = horizontalViewAlignCenter;
		
		pv = [[UIPickerView alloc] initWithFrame:CGRectZero];
		pv.showsSelectionIndicator = YES;
		pv.delegate = self;
		pv.dataSource = self;
//		[self addSubview:pv];

        mdvc = [[MultiDialViewController alloc] init];
		mdvc.delegate = self;
//		mdvc.view.frame = CGRectOffset(mdvc.view.frame, 0.0, 340.0);
		[self addSubview:mdvc.view];
	}
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
	CGRect rct = self.bounds;
	
	CGFloat minx = CGRectGetMinX(rct), midx = CGRectGetMidX(rct), maxx = CGRectGetMaxX(rct);
	CGFloat miny = CGRectGetMinY(rct), midy = CGRectGetMidY(rct), maxy = CGRectGetMaxY(rct);
	CGFloat cornerRadius = 10.0;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetLineWidth(context, 1);
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, NULL, minx + 0.5f, midy + 0.5f);
	CGPathAddArcToPoint(path, NULL, minx + 0.5f, miny + 0.5f, midx + 0.5f, miny + 0.5f, cornerRadius);
	CGPathAddArcToPoint(path, NULL, maxx + 0.5f, miny + 0.5f, maxx + 0.5f, midy + 0.5f, cornerRadius);
	CGPathAddArcToPoint(path, NULL, maxx + 0.5f, maxy + 0.5f, midx + 0.5f, maxy + 0.5f, cornerRadius);
	CGPathAddArcToPoint(path, NULL, minx + 0.5f, maxy + 0.5f, minx + 0.5f, midy + 0.5f, cornerRadius);
	CGPathAddArcToPoint(path, NULL, minx + 0.5f, midy + 0.5f, minx + 0.5f, midy + 0.5f, cornerRadius);
	CGContextAddPath(context, path);
	CGContextSetFillColorWithColor(context, [UIColor colorWithWhite:.1 alpha:.5].CGColor);
	CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:.1 alpha:0.65].CGColor);
	CGContextDrawPath(context, kCGPathFillStroke);
	CGPathRelease(path);
}

- (void) dealloc
{
	[pv release];
	
	[super dealloc];
}

#pragma mark -

- (void) setFrame:(CGRect)frame
{
	[super setFrame:frame];
	
	pv.frame = self.bounds;
	mdvc.view.frame = self.bounds;
	
	[self setNeedsDisplay];
}

- (CGSize) needSize
{
	return CGSizeMake(60.0*4+10.0*2, 120.0);
}

- (void) setPage:(NSInteger) page
{
	if (mdvc.number!=page)
	{
		mdvc.number = page;
	}
}

- (NSInteger) page
{
	return mdvc.number;
}

#pragma mark PickerDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	return [NSString stringWithFormat:@"%d", row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 4;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return -1;
}

#pragma mark -

- (void) changeNumber
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(changeNumber) object:nil];
	
	if (mdvc.isContentMoving)
	{
		[self performSelector:@selector(changeNumber) withObject:nil afterDelay:1.0];
	}
	else
	{
		if (delegate)
		{
			[delegate pageSelectView:self didSelectPage:mdvc.number];
		}
	}
}

#pragma mark MultiDialViewControllerDelegate methods

- (void) multiDialViewControllerStartScroll:(MultiDialViewController *)controller
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(changeNumber) object:nil];
}

- (void)multiDialViewController:(MultiDialViewController *)controller didSelectString:(NSString *)string
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(changeNumber) object:nil];

	[self performSelector:@selector(changeNumber) withObject:nil afterDelay:1.0];
/*	
	if (delegate)
	{
		[delegate pageSelectView:self didSelectPage:controller.number];
	}
*/
}

@end
