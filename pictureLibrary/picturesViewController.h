//
//  picturesViewController.h
//  pictureLibrary
//
//  Created by maliy on 6/4/11.
//

#import <UIKit/UIKit.h>
#import "imageBackgroundView.h"


@class picturesViewController;
@class abstractView;


@protocol picturesViewControllerDelegate <NSObject>

- (NSInteger) picturesViewControllerPicturesCount:(picturesViewController *) sender;

@optional
- (UIImage *) picturesViewController:(picturesViewController *) sender imageById:(NSInteger) idx;
//- (UIImage *) picturesViewController:(picturesViewController *) sender imageById:(NSInteger) idx withZoom:(CGFloat) zoom;
- (void) picturesViewController:(picturesViewController *) sender changeImageTo:(NSInteger) idx;

- (void) picturesViewController:(picturesViewController *) sender changeInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation
					   duration:(NSTimeInterval) duration frame:(CGRect) frame;

- (NSString *) picturesViewController:(picturesViewController *) sender titleForImage:(NSInteger) idx;
- (void) picturesViewController:(picturesViewController *) sender titleTouched:(NSInteger) idx;
@end


@interface picturesViewController : UIViewController <UIScrollViewDelegate, imageBackgroundViewDelegate>
{
	id<picturesViewControllerDelegate> delegate;
	
	UIScrollView *pagesView;
	NSMutableArray *pages;
	
	NSInteger index;
	NSInteger prewIndex;
	NSInteger count;
	BOOL infinitiCount;
	
	NSInteger pagesWindow;
	NSInteger pageStart;
	NSInteger pageEnd;
	
	UIBarStyle savedBarStyle;
	UIStatusBarStyle savedStatusBarStyle;
	BOOL barsShowed;
	UIToolbar *toolBar;
	CGRect screenRect;
	BOOL progRotation;
	
	UIButton *titleBtn;
	BOOL loaded;
}

@property (nonatomic, assign) id<picturesViewControllerDelegate> delegate;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger pagesWindow;
@property (nonatomic, retain) UIToolbar *toolBar;
@property (nonatomic, readonly) BOOL barsShowed;

- (void) reloadData;
- (void) setIndex:(NSInteger) _index animated:(BOOL) animated;
- (void) setImage:(UIImage *) _image forIndex:(NSInteger) idx;

- (void) addSubview:(abstractView *) subview;

@end
