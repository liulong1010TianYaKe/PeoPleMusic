//
//  JMNewfeatureViewController.h
//

#import "BasicsViewController.h"

typedef enum:NSInteger
{
    NewfeatureTypeFromeSetting,     //从设置界面进入该页
    NewfeatureTypeFromeWelcom,      //第一次安装的时候进入
} NewfeatureType;

@interface NewfeatureViewController : BasicsViewController

@property (nonatomic, assign) NewfeatureType newfeatureType;
@property (nonatomic, assign) id target;

@end
