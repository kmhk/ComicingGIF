//
//  SectionDividerView.h
//  ComicApp
//
//  Created by Ramesh on 22/11/15.
//  Copyright © 2015 Ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+colorWithHexString.h"

@interface SectionDividerView : UIView
{
    NSString* sectionText ;
}
/* properties */
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UILabel *lblHeadText;
/* end */

/* Methods */
-(id)initWithHeaderText:(NSString*)headText;
/* end */
@end
