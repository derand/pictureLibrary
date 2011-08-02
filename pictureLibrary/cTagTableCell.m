//
//  tagTableCell.m
//  Amagami
//
//  Created by Andrey Derevyagin on 7/1/11.
//  Copyright 2011 interMobile. All rights reserved.
//

#import "tagTableCell.h"


#define TEXT_FONT	[UIFont boldSystemFontOfSize:12.0]


@interface tagTableCell ()
@property (nonatomic, retain) UILabel *nameLabel;
@end



@implementation tagTableCell
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

- (void) setTagName:(NSString *) _tagName
{
	nameLabel.text = _tagName;
	[self layoutSubviews];
}

- (NSString *) tagName
{
	return nameLabel.text;
}

+ (CGSize) sizeForTag:(NSString *) tag
{
	CGSize rv = [tag sizeWithFont:TEXT_FONT];
	rv.height += 2.0;
	return rv;
}


#pragma mark -

- (void) layoutSubviews
{
	[super layoutSubviews];
	CGRect contentRect = [self.contentView bounds];
	
	nameLabel.frame = contentRect;
/*	
	CGFloat diff = contentRect.size.width*.02;
	CGRect rct;
	CGSize sz;
	
	sz = [nameLabel.text sizeWithFont:caption.font constrainedToSize:CGSizeMake(contentRect.size.width, contentRect.size.height)];
	rct = CGRectMake(contentRect.origin.x, contentRect.size.height-sz.height-diff,
					 contentRect.size.width, sz.height);
	nameLabel.frame = rct;
*/
}


@end
