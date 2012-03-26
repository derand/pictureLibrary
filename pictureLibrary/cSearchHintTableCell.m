//
//  cSearchHintTableCell.m
//  pictureLibrary
//
//  Created by Andrey Derevyagin on 3/8/12.
//  Copyright (c) 2012 interMobile. All rights reserved.
//

#import "cSearchHintTableCell.h"


#define TEXT_FONT	[UIFont boldSystemFontOfSize:14.0]


@interface cSearchHintTableCell ()
@property (nonatomic, retain) UILabel *nameLabel;
@end



@implementation cSearchHintTableCell
@synthesize nameLabel;

#pragma mark lifeCycle

- (id) initWithReuseIdentifier:(NSString *) reuseIdentifier
{
	if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])
	{
        // Initialization code
		self.accessoryType = UITableViewCellAccessoryNone;
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		nameLabel.backgroundColor = [UIColor clearColor];
		nameLabel.opaque = NO;
		nameLabel.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];
		//		nameLabel.textColor = [UIColor colorWithRed:63.0/256.0 green:65.0/256.0 blue:67.0/256.0 alpha:1.0];
		nameLabel.font = TEXT_FONT;
		//		nameLabel.font = [UIFont boldSystemFontOfSize:<#(CGFloat)#>];
        nameLabel.textAlignment = UITextAlignmentCenter;
		[self.contentView addSubview:nameLabel];
	}
	return self;
}

- (void) dealloc
{
	self.nameLabel = nil;
	
	[super dealloc];
}

#pragma mark -

- (void) setHint:(NSString *)hint
{
	nameLabel.text = hint;
	[self layoutSubviews];
}

- (NSString *) hint
{
	return nameLabel.text;
}

+ (CGSize) sizeForHint:(NSString *)hint
{
	CGSize rv = [hint sizeWithFont:TEXT_FONT];
	rv.height += 10.0;
	return rv;
}


#pragma mark -

- (void) layoutSubviews
{
	[super layoutSubviews];
	CGRect contentRect = [self.contentView bounds];
	
	nameLabel.frame = contentRect;
}

@end