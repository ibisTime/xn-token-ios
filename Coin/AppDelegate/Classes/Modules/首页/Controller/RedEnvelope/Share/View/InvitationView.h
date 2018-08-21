
#import <UIKit/UIKit.h>
typedef void(^codeBlock)(void);

@interface InvitationView : UIView

@property (nonatomic ,copy) codeBlock codeblock;
@property (nonatomic ,copy) NSString* h5String;

@end
