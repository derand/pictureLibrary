//
//  cPageSelectView.h
//  pictureLibrary
//
//  Created by Andrey Derevyagin on 8/1/11.
//  Copyright 2011 interMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "abstractView.h"

@interface cPageSelectView : abstractView <UIPickerViewDelegate, UIPickerViewDataSource>
{
	UIPickerView *pv;
}



@end
