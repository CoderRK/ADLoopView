

#import "ADView.h"
#import "ADViewCell.h"

#define NUM_OF_SECTIONS 100

@interface ADView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic, strong) UICollectionViewFlowLayout *layout;
@property(nonatomic, weak)  UICollectionView *adView;
@property(nonatomic, assign)  NSInteger currentIndex;
@property(nonatomic, weak) UIPageControl *pageControl;
@property(nonatomic, weak) NSTimer *timer;

@end

@implementation ADView
+ (instancetype)viewWithFrame:(CGRect)frame
{
    return [[self alloc] initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor greenColor];
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing  = 0;
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.layout = layout;
        
        UICollectionView *adView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
        adView.showsHorizontalScrollIndicator = NO;
        adView.pagingEnabled = YES;
        adView.delegate = self;
        adView.dataSource = self;
        [adView registerClass:[ADViewCell class] forCellWithReuseIdentifier:@"ADViewCell"];
        self.adView = adView;
        [self addSubview:adView];
        self.automaticallyScrollDuration = 0.0f;
        self.loop = YES;
        
        UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-200)/2.0, self.bounds.size.height-44, 200, 44)];
        pageControl.pageIndicatorTintColor = [UIColor greenColor];
        pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
        [self addSubview:pageControl];
        self.pageControl = pageControl;
    }
    return self;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return NUM_OF_SECTIONS;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imgs.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ADViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ADViewCell" forIndexPath:indexPath];
    cell.imgName = self.imgs[indexPath.row];
    return cell;
}

-  (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.adDelegate respondsToSelector:@selector(adViewDidClick:)])
    {
        [self.adDelegate adViewDidClick:indexPath.row];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.loop == YES && self.automaticallyScrollDuration>0)
    {
         [self addTimer];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = (int)(scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5) % self.imgs.count;
    self.pageControl.currentPage = page;
}

- (NSIndexPath *)resetIndexPath
{
    NSIndexPath *currentIndexPath = [[self.adView indexPathsForVisibleItems] lastObject];
    NSIndexPath *currentIndexPathReset = [NSIndexPath indexPathForItem:currentIndexPath.item inSection:NUM_OF_SECTIONS/2];
    [self.adView scrollToItemAtIndexPath:currentIndexPathReset atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    return currentIndexPathReset;
}

- (void)imageAutoScrollToNextPage
{
    NSIndexPath *currentIndexPathReset = [self resetIndexPath];
    NSInteger nextItem = currentIndexPathReset.item + 1;
    NSInteger nextSection = currentIndexPathReset.section;
    if (nextItem == self.imgs.count)
    {
        nextItem = 0;
        nextSection++;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];
    [self.adView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

/**
 *  添加定时器
 */
- (void)addTimer
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.automaticallyScrollDuration target:self selector:@selector(imageAutoScrollToNextPage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
}
/**
 *  移除定时器
 */
- (void)removeTimer
{
    if (self.timer)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)setImgs:(NSArray *)imgs
{
    _imgs = imgs;
    self.pageControl.numberOfPages = imgs.count;
    [self.adView reloadData];
}

- (void)setLoop:(BOOL)loop
{
    _loop = loop;
}

- (void)setAutomaticallyScrollDuration:(NSTimeInterval)automaticallyScrollDuration
{
    _automaticallyScrollDuration = automaticallyScrollDuration;
    if (automaticallyScrollDuration>0 && !self.timer && self.loop == YES)
    {
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:automaticallyScrollDuration target:self selector:@selector(imageAutoScrollToNextPage) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        self.timer = timer;
    }
    else
    {
        [self removeTimer];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.adView.frame  = self.bounds;
    self.layout.itemSize = self.frame.size;
}

@end
