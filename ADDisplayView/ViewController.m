
#import "ViewController.h"
#import "ADView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    ADView *adView = [ADView viewWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 200)];
    adView.imgs = @[@"ad1",@"ad2",@"ad3",@"ad4",@"ad5",@"ad6",@"ad7",@"ad8"];
    adView.loop = YES;
    adView.automaticallyScrollDuration = 1.0f;
    [self.view addSubview:adView];
}
@end
