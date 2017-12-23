//
//  UIGestureRecognizer+Utils.m
//  DragAndDropTable
//
//  Created by Юрий Логинов on 23.12.17.
//  Copyright © 2017 Yury Loginov. All rights reserved.
//

#import "UIGestureRecognizer+Utils.h"

@implementation UIGestureRecognizer (Utils)

- (void)cancel {
    [self setEnabled:NO];
    [self setEnabled:YES];
}

@end
