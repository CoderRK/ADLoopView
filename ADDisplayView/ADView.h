
#import <UIKit/UIKit.h>
@class ADViewCell;

@protocol ADViewCellDelegate <NSObject>

@optional
- (void)adViewDidClick:(NSInteger)index;

@end

@interface ADView : UIView

@property(nonatomic, strong) NSArray *imgs;

@property(nonatomic, strong) ADViewCell *singleCell;

@property(nonatomic, assign, getter=isLoop) BOOL loop;

@property(nonatomic, assign) NSTimeInterval automaticallyScrollDuration;

@property(nonatomic, assign) id<ADViewCellDelegate> adDelegate;

+ (instancetype)viewWithFrame:(CGRect)frame;

@end
