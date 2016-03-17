

#import "ADViewCell.h"

@interface ADViewCell()
@property(nonatomic, weak) UIImageView *imgView;
@end

@implementation ADViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor grayColor];
        [self setupADViewCell];
    }
    return self;
}


- (void)setupADViewCell
{
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.contentMode = UIViewContentModeScaleToFill;
    imgView.backgroundColor = [UIColor orangeColor];
    self.imgView = imgView;
    [self.contentView addSubview:imgView];
}

- (void)setImgName:(NSString *)imgName
{
    _imgName = imgName;
    self.imgView.image = [UIImage imageNamed:imgName];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.imgView.frame = self.bounds;
}
@end
