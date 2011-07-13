//
//  picturesViewController.m
//  pictureLibrary
//
//  Created by maliy on 6/4/11.
//

#import "picturesViewController.h"
#import "pageView.h"
#import "imageBackgroundView.h"


@interface picturesViewController ()
@property (nonatomic, retain) UIScrollView *pagesView;

- (void) freeMemmoryWithAbs:(NSInteger) diff;
- (pageView *) pageByIdx:(NSInteger) idx;
- (void) setToolBarFrame;
@end


@implementation picturesViewController
@synthesize delegate;
@synthesize pagesView;
@synthesize index, count;
@synthesize pagesWindow;
@synthesize toolBar, barsShowed;

- (id) init
{
    self = [super init];
    if (self)
	{
		self.wantsFullScreenLayout = YES;

		count = 0;
		index = 0;
		prewIndex = -1;
		pagesWindow = -1;
		pageStart= pageEnd = 0;
		
		pages = [[NSMutableArray alloc] init];
		pagesView = nil;
		progRotation = NO;

    }
    return self;
}

- (void)dealloc
{
	for (pageView *page in pages)
	{
		[page removeFromSuperview];
	}
	[pages release];
	pages = nil;
	self.count = 0;

    [super dealloc];
}


#pragma mark -

- (void) reloadData
{
	if (pagesView)
	{
		if (delegate)
		{
			self.count = [delegate picturesViewControllerPicturesCount:self];
		}
	}
}

- (pageView *) pageByIdx:(NSInteger) idx
{
	pageView *page;
	NSInteger i;
	for (i=0; i<[pages count]; i++)
	{
		page = [pages objectAtIndex:i];
		if (page.pageIdx==idx)
		{
			break;
		}
	}
	if (i==[pages count])
	{
		page = nil;
	}
	return page;
}

- (void) loadPage:(NSInteger) idx
{
	if (idx<0 || (idx>=count))
		return ;

/*
	if (idx>=[pages count])
	{
		pageView *page;
		CGRect rct = CGRectZero;
		rct.size = pagesView.bounds.size;
		rct.origin.x = rct.size.width*[pages count];
		while (idx>=[pages count])
		{
			page = [[pageView alloc] initWithFrame:rct];
			page.ibv.delegate = self;
			[pages addObject:page];
			[pagesView addSubview:page];
			[page release];
			
			rct.origin.x += rct.size.width;
		}
		
		count = [pages count];
		pagesView.contentSize = CGSizeMake(pagesView.bounds.size.width*count, pagesView.bounds.size.height);
	}
*/
	
	pageView *page = [self pageByIdx:idx];
	if (page && !page.image)
	{
		if (delegate && [delegate respondsToSelector:@selector(picturesViewController:imageById:)])
		{
			UIImage *img = [delegate picturesViewController:self imageById:idx];
			[self setImage:img forIndex:idx];
		}
	}
}

- (void) changeIndex
{
	[self loadPage:index];
	[self loadPage:index-1];
	[self loadPage:index+1];
	
	if (delegate && [delegate respondsToSelector:@selector(picturesViewController:titleForImage:)])
	{
		self.navigationItem.title = [delegate picturesViewController:self titleForImage:index];
	}
	else
	{
		if (infinitiCount)
		{
			self.navigationItem.title = [NSString stringWithFormat:NSLocalizedString(@"%d/∞", @""), index+1];
		}
		else
		{
			self.navigationItem.title = [NSString stringWithFormat:NSLocalizedString(@"%d/%d", @""), index+1, count];
		}
	}
	
	[self freeMemmoryWithAbs:3];
}

- (void) setIndex:(NSInteger) _index animated:(BOOL) animated
{
	if (index!=_index)
	{
		for (pageView *page in pages)
		{
			if (page.pageIdx==index)
			{
				[page setZoomScale:1.0 animated:NO];
				break;
			}
		}
		
		prewIndex = index;
		index = _index;
	}

//	if (index<pageStart+1 && index>pageEnd-1 )
	{
		CGPoint offset = CGPointZero;
		CGSize size = CGSizeMake(0.0, pagesView.bounds.size.height);
		// fix infinity count, if position = end
		if (infinitiCount && index==(count-1))
		{
			count++;
		}
		// calc window page start & end
		if (pagesWindow>2 && count>pagesWindow)
		{
			pageStart = index-pagesWindow/2;
			if (pageStart<0) pageStart=0;
			if ((pageStart+pagesWindow)>count) pageStart = count-pagesWindow;
			pageEnd = pageStart+pagesWindow;
		}
		else
		{
			pageEnd = count;
		}
		size.width = (pageEnd-pageStart)*pagesView.bounds.size.width;
		if (abs(pagesView.contentSize.width-size.width)>1.0)
		{
			pagesView.contentSize = size;
		}
		
		if (pageEnd<pageStart)
		{
			pageStart = pageEnd;
		}
		if (pages)
		{
			NSMutableArray *__pages = [[NSMutableArray alloc] initWithCapacity:pageEnd-pageStart];
			pageView *page;
			CGRect rct = CGRectMake(0.0, 0.0, pagesView.bounds.size.width, pagesView.bounds.size.height);
			for (NSInteger i=pageStart; i<pageEnd; i++)
			{
				NSInteger j=[pages count];
				BOOL founded = NO;
				while (j-->0)
				{
					page = [pages objectAtIndex:j];
					if (page.pageIdx==i)
					{
						[__pages addObject:page];
						[pages removeObjectAtIndex:j];
						founded = YES;
						break;
					}
				}
				if (!founded)
				{
					page = [[pageView alloc] initWithFrame:CGRectZero];
					page.pageIdx = i;
					page.ibv.delegate = self;
					[__pages addObject:page];
					[pagesView addSubview:page];
					[page release];
				}
				
				rct.origin.x = (i-pageStart)*rct.size.width;
				page.frame = rct;
			}
			for (pageView *page in pages)
			{
				[page removeFromSuperview];
			}
			[pages removeAllObjects];
			[pages release];
			pages = __pages;
		}
		
		offset.x = (index-pageStart)*pagesView.bounds.size.width;
		[pagesView setContentOffset:offset animated:animated];
	}
	

	if (delegate && [delegate respondsToSelector:@selector(picturesViewController:changeImageTo:)] && pages)
	{
		[delegate picturesViewController:self changeImageTo:index];
	}
	
	[self changeIndex];
}

- (void) setIndex:(NSInteger) _index
{
	[self setIndex:_index animated:NO];
}

- (void) setCount:(NSInteger) _count
{
	if (_count<-1 || count==_count)
		return ;
	
	count = _count;
	infinitiCount = count==-1;
	if (infinitiCount)
	{
		count = 2;
	}
	
	NSInteger localCount = count;
	if (pagesWindow>2 && count>pagesWindow)
	{
		localCount = pagesWindow;
	}

	CGSize cs = CGSizeMake(pagesView.bounds.size.width*localCount, pagesView.bounds.size.height);
	pagesView.contentSize = cs;

	for (pageView *page in pages)
	{
		page.image = nil;
		[page removeFromSuperview];
	}
	[pages removeAllObjects];
	
	pageView *page;
	CGRect rct = CGRectZero;
	rct.size = pagesView.bounds.size;
	for (NSInteger i=0; i<localCount; i++)
	{
		page = [[pageView alloc] initWithFrame:rct];
		page.pageIdx = i;
		page.ibv.delegate = self;
		[pages addObject:page];
		[pagesView addSubview:page];
		[page release];

		rct.origin.x += rct.size.width;
	}
	
	self.index = index>=count?0:index;
}

- (void) setImage:(UIImage *) _image forIndex:(NSInteger) idx
{
	if (_image)
	{
		if (_image.size.width*_image.size.height>25000000.0)
		{
			NSLog(@"Image to big (size: %.2fx%.2f)", _image.size.width, _image.size.height);
			return ;
		}
		
		if (idx>0 || idx<[pages count])
		{
			pageView *page = [self pageByIdx:idx];
			if (page)
			{
				page.image = _image;
			}
		}
	}
}

- (void) setDelegate:(id<picturesViewControllerDelegate>) _delegate
{
	delegate = _delegate;
	
//	[self reloadData];
}

- (void) freeMemmoryWithAbs:(NSInteger) diff
{
	pageView *page;
	for (NSInteger i=0; i<[pages count]; i++)
	{
		page = [pages objectAtIndex:i];
		if (abs(page.pageIdx-index)>diff && page.image)
		{
			page.image = nil;
			NSLog(@"remove image #%d", page.pageIdx);
		}
	}
}

- (void) setToolBar:(UIToolbar *) _toolBar
{
	[toolBar removeFromSuperview];
	[toolBar release];
	toolBar = [_toolBar retain];
	
	toolBar.translucent = YES;
	toolBar.tintColor = [UIColor blackColor];
	
	
	[self setToolBarFrame];
	if (pagesView)
	{
		[self.view addSubview:toolBar];
	}
}

- (void) setToolBarFrame
{
	if (!toolBar)
		return;

	CGRect rct = toolBar.frame;
	rct = CGRectMake(0.0, screenRect.size.height, screenRect.size.width, rct.size.height);
	if (barsShowed)
	{
		rct.origin.y -= rct.size.height;
	}
	toolBar.frame = rct;
}

- (void) addSubview:(UIView *) subview
{
	[self.view addSubview:subview];
}



#pragma mark imageBackgroundViewDelegate;

- (void) imageBackgroundViewSingleTouch:(imageBackgroundView *) ibv
{
	[[UIApplication sharedApplication] setStatusBarHidden:barsShowed withAnimation:UIStatusBarAnimationSlide];
	[self.navigationController setNavigationBarHidden:barsShowed animated:YES];
	barsShowed = !barsShowed;
	[UIView animateWithDuration:.3f
					 animations:^{
						 [self setToolBarFrame];
					 }
					 completion:^(BOOL finished) {
					 }];

	progRotation = YES;
	[self willAnimateRotationToInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation duration:.0];
	progRotation = NO;
}



#pragma mark UIScrollViewDelegate

- (void) scrollViewDidScroll:(UIScrollView *) sender
{
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *) scrollView
{
	
	CGFloat pageWidth = scrollView.bounds.size.width;
	
	NSInteger _idx = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1 + pageStart;
	if (_idx!=index)
	{
		self.index = _idx;
	}
}


#pragma mark - View lifecycle

- (void) viewWillAppear:(BOOL)animated
{
	savedBarStyle = self.navigationController.navigationBar.barStyle;
	savedStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
	self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackTranslucent;
	barsShowed = YES;
	[self setToolBarFrame];
}

- (void) viewWillDisappear:(BOOL)animated
{
	self.navigationController.navigationBar.barStyle = savedBarStyle;
	[UIApplication sharedApplication].statusBarStyle = savedStatusBarStyle;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation
{
	return YES;
}

- (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation
										  duration:(NSTimeInterval) duration
{
    screenRect = self.view.bounds;
//	NSLog(@"%fx%f", screenRect.size.width, screenRect.size.height);

	CGRect rct = [[UIScreen mainScreen] bounds];
	self.view.frame = rct;
	
	rct = self.view.bounds;
	pagesView.frame = screenRect;
	pagesView.contentSize = CGSizeMake(pagesView.bounds.size.width*[pages count], pagesView.bounds.size.height);
	pagesView.contentOffset = CGPointMake(pagesView.bounds.size.width*(index-pageStart), 0.0);
	
	rct = CGRectZero;
	rct.size = pagesView.bounds.size;
	for (pageView *page in pages)
	{
		rct.origin.x = (page.pageIdx-pageStart)*rct.size.width;
		page.frame = rct;
	}

	if (!progRotation)
	{
		[self setToolBarFrame];
	}
	
	if (delegate && [delegate respondsToSelector:@selector(picturesViewController:changeInterfaceOrientation:duration:frame:)])
	{
		[delegate picturesViewController:self
			  changeInterfaceOrientation:interfaceOrientation
								duration:duration
								   frame:screenRect];
	}
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
	[super loadView];
	
	CGRect applicationFrame = [[UIScreen mainScreen] bounds];
	UIView *contentView = [[UIView alloc] initWithFrame:applicationFrame];
	
	// important for view orientation rotation
//	contentView.autoresizesSubviews = YES;
	contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;	
	self.view = contentView;	
	[contentView release];
	
	pagesView = [[UIScrollView alloc] initWithFrame:CGRectZero];
	pagesView.backgroundColor = [UIColor clearColor];
	pagesView.clipsToBounds = YES;
	pagesView.delegate = self;
	pagesView.clearsContextBeforeDrawing = NO;
    pagesView.pagingEnabled = YES;
    pagesView.showsVerticalScrollIndicator = NO;
    pagesView.showsHorizontalScrollIndicator = NO;
    pagesView.scrollsToTop = NO;
	[self.view addSubview:pagesView];
//	pagesView.scrollEnabled = NO;
	
	if (toolBar)
	{
		[self.view addSubview:toolBar];
	}

    [self performSelector:@selector(checkSize) withObject:nil afterDelay:.05];
}

- (void) checkSize
{
    [self willAnimateRotationToInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation] duration:.0];
	
	[self reloadData];
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
}

- (void) didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
	[self freeMemmoryWithAbs:1];
}


@end
