//
//  tagsView.m
//  Amagami
//
//  Created by Andrey Derevyagin on 7/1/11.
//  Copyright 2011 interMobile. All rights reserved.
//

#import "cTagsView.h"
#import "cTagTableCell.h"



@interface cTag : NSObject
@property (nonatomic, retain) NSString *tag;
@end



@interface cTagsView ()
@property (nonatomic, retain) UITableView *tv;
@end


@implementation cTagsView
@synthesize tv;
@synthesize tags;

#pragma mark lifeCycle
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
	{
		self.backgroundColor = [UIColor clearColor];
		self.verticalAlign = verticalViewAlignBottom;
		self.horizontalAlign = horizontalViewAlignRight;
		
		tv = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
		tv.backgroundColor = [UIColor clearColor];
		tv.delegate = self;
		tv.dataSource = self;
		tv.autoresizesSubviews = YES;
		tv.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		tv.separatorStyle = UITableViewCellSeparatorStyleNone;
		[self addSubview:tv];
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
	self.tv = nil;
	self.tags = nil;
	
	[super dealloc];
}

#pragma mark -

- (void) setTags:(NSArray *) _tags
{
//	tags = [[_info objectForKey:@"tags"] componentsSeparatedByString:@" "];
	[tags release];
	tags = [_tags retain];
	
	if (tv)
	{
		[tv reloadData];
	}
	[self setViewSizeInFrame:self.superview.bounds animated:YES];
}

- (CGSize) needSize
{
	CGSize rv = CGSizeZero;
	CGSize tmpSz;
	for (id<NSObject> tmp in tags)
	{
		NSString *tag = (NSString *)tmp;
		if ([tmp isKindOfClass:[cTag class]])
		{
			tag = ((cTag *)tmp).tag;
		}

		tmpSz = [cTagTableCell sizeForTag:tag];
		rv.width = MAX(tmpSz.width, rv.width);
		rv.height += tmpSz.height;
	}
	rv.width += 15.0;
	rv.height += 7.0;
	return rv;
}

#pragma mark tableView delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return [tags count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	cTagTableCell *rv = nil;
	
	static NSString *cellID = @"tagCell_ID";
	rv = [tableView dequeueReusableCellWithIdentifier:cellID];
	if (rv == nil)
	{
		rv = [[[cTagTableCell alloc] initWithReuseIdentifier:cellID] autorelease];
	}
	id<NSObject> tmp = [tags objectAtIndex:indexPath.row];
	NSString *tag = (NSString *)tmp;
	if ([tmp isKindOfClass:[cTag class]])
	{
		tag = ((cTag *)tmp).tag;
	}
	rv.tagName = tag;
	
	return rv;
}

- (void) deselect
{
	[tv deselectRowAtIndexPath:[tv indexPathForSelectedRow] animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self performSelector:@selector(deselect) withObject:nil afterDelay:.5];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat rv;// = tableView.rowHeight;
	id<NSObject> tmp = [tags objectAtIndex:indexPath.row];
	NSString *tag = (NSString *)tmp;
	if ([tmp isKindOfClass:[cTag class]])
	{
		tag = ((cTag *)tmp).tag;
	}
	rv = [cTagTableCell sizeForTag:tag].height;
	return rv;
}

@end
