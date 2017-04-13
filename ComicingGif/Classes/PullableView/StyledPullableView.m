
#import "StyledPullableView.h"
#import "FriendPageVC.h"

/**
 @author Fabio Rodella fabio@crocodella.com.br
 */

@implementation StyledPullableView

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        
//        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
//        imgView.frame = CGRectMake(0, 0, 320, 460);
//        [self addSubview:imgView];
//        imgView = nil;
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main_MainPage" bundle: nil];
        FriendPageVC * mainControllerView = (FriendPageVC *)[mainStoryboard instantiateViewControllerWithIdentifier:@"FriendPage"];
        mainControllerView.view.frame= frame;
        mainStoryboard = nil;
        [self addSubview:mainControllerView.view];
    }
    return self;
}

@end
