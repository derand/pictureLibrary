//
//  cPageSelectView.m
//  pictureLibrary
//
//  Created by Andrey Derevyagin on 8/1/11.
//  Copyright 2011 interMobile. All rights reserved.
//

#import "cPageSelectView.h"

@implementation cPageSelectView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
	{
        // Initialization code
		
		pv = [[UIPickerView alloc] initWithFrame:CGRectZero];
		pv.showsSelectionIndicator = YES;
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
	[pv release];
	
	[super dealloc];
}

#pragma mark -

- (void) setFrame:(CGRect)frame
{
	[super setFrame:frame];
	
	pv.frame = self.bounds;
}

- (CGSize) needSize
{
	return CGSizeMake(280.0, pv.frame.size.height);
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
	return 10;
}

@end
