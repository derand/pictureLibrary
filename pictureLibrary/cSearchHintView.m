//
//  cSearchHintView.m
//  pictureLibrary
//
//  Created by Andrey Derevyagin on 3/8/12.
//  Copyright (c) 2012 interMobile. All rights reserved.
//

#import "cSearchHintView.h"
#import "cSearchHintTableCell.h"



@interface cSearchHintView ()
@property (nonatomic, retain) UITableView *tv;
@property (nonatomic, retain) NSArray *showedHintList;

- (void) filterHintByString:(NSString *)string;

@end


@implementation cSearchHintView
@synthesize tv;
@synthesize hintsList, showedHintList;
@synthesize filterString;
@synthesize delegate;

#pragma mark lifeCycle
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
	{
		self.backgroundColor = [UIColor clearColor];
		self.layer.cornerRadius = 10.0;
		self.layer.borderWidth = 1.0;
		self.layer.borderColor = [UIColor colorWithWhite:.1 alpha:0.65].CGColor;
		self.layer.backgroundColor = [UIColor colorWithWhite:.1 alpha:.5].CGColor;
		
		self.verticalAlign = verticalViewAlignTop;
		self.horizontalAlign = horizontalViewAlignRight;
		considerKeyboardBorders = YES;
		
		tv = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
		tv.backgroundColor = [UIColor clearColor];
		tv.delegate = self;
		tv.dataSource = self;
		tv.autoresizesSubviews = YES;
		tv.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		tv.separatorStyle = UITableViewCellSeparatorStyleNone;
		[self addSubview:tv];
		
		showedHintList = [[NSMutableArray alloc] init];
		filterString = [@"" retain];
    }
    return self;
}

- (void) dealloc
{
	[filterString release];
	filterString = nil;
	self.tv = nil;
	self.hintsList = nil;
	self.showedHintList = nil;
	
	[super dealloc];
}

#pragma mark -

- (void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
	
	tv.frame = self.bounds;
}

- (void)setHintsList:(NSArray *)_hintsList
{
	[_hintsList retain];
	[hintsList release];
	hintsList = _hintsList;
	
	if (self.filterString)
	{
		[self filterHintByString:self.filterString];
	}
}

- (void)setFilterString:(NSString *)_filterString
{
	[_filterString retain];
	[filterString release];
	filterString = _filterString;
	
	if (!filterString)
	{
		filterString = [@"" retain];
	}
	[self filterHintByString:filterString];
}

- (CGSize) needSize
{
	CGSize rv = CGSizeZero;
	CGSize tmpSz;
	for (NSString *hint in showedHintList)
	{
		tmpSz = [cSearchHintTableCell sizeForHint:hint];
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
	return self.showedHintList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	cSearchHintTableCell *rv = nil;
	
	static NSString *cellID = @"hintCell_ID";
	rv = [tableView dequeueReusableCellWithIdentifier:cellID];
	if (rv == nil)
	{
		rv = [[[cSearchHintTableCell alloc] initWithReuseIdentifier:cellID] autorelease];
	}
	rv.hint = [showedHintList objectAtIndex:indexPath.row];
	return rv;
}

- (void) deselect
{
	[tv deselectRowAtIndexPath:[tv indexPathForSelectedRow] animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self performSelector:@selector(deselect) withObject:nil afterDelay:.5];
	
	[delegate searchHintView:self selectHint:[showedHintList objectAtIndex:indexPath.row]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [cSearchHintTableCell sizeForHint:[showedHintList objectAtIndex:indexPath.row]].height;
}

#pragma mark -

- (void) filterHintByString:(NSString *)string
{
	[showedHintList removeAllObjects];
	
	NSString *upString = [string uppercaseString];
	NSRange range;
	
	for (NSString *hint in hintsList)
	{
		if ([string length]==0)
		{
			[showedHintList addObject:hint];
			continue;
		}
		
		range = [[hint uppercaseString] rangeOfString:upString];
		if (range.location != NSNotFound)
		{
			[showedHintList addObject:hint];
			continue;
		}
	}
	
	if (tv)
	{
		[tv reloadData];
	}

	if (self.superview)
	{
		[self setViewSizeInFrame:self.superview.bounds animated:YES];
	}
}



@end
