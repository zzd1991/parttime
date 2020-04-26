//
//  JXCommonTool.m
//  JiXuJianZhi
//
//  Created by John Mr on 2020/4/24.
//  Copyright © 2020 oneteam. All rights reserved.
//

#import "JXCommonTool.h"

static const char * ConstantsBlockActionWrapperBlockActions = "ConstantsBlockActionWrapperBlockActions";

@interface ConstantsBlockActionWrapper : NSObject

@property (nonatomic, copy) void (^blockAction)(void);

- (void)invokeBlock;

@end

@implementation ConstantsBlockActionWrapper

@synthesize blockAction;

- (void)dealloc
{
    [self setBlockAction:nil];
}

- (void)invokeBlock
{
    [self blockAction]();
}

@end


@implementation JXCommonTool


+ (void)resignCurrentFirstResponder
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow endEditing:YES];
}

+ (void)addTappedBlockWith:(id)view andBlock:(void(^)(void))tapBlock;
{
    if ([view respondsToSelector:@selector(addGestureRecognizer:)]) {
        NSMutableArray * blockActions = objc_getAssociatedObject(self, &ConstantsBlockActionWrapperBlockActions);
        
        if (blockActions == nil) {
            blockActions = [NSMutableArray array];
            objc_setAssociatedObject(self, &ConstantsBlockActionWrapperBlockActions, blockActions, OBJC_ASSOCIATION_RETAIN);
        }
        
        ConstantsBlockActionWrapper *target = [[ConstantsBlockActionWrapper alloc] init];
        [target setBlockAction:tapBlock];
        [blockActions addObject:target];
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:target action:@selector(invokeBlock)];
        [view addGestureRecognizer:tapGR];
        
        [(UIView *)view setUserInteractionEnabled:YES];
    }
}


@end
