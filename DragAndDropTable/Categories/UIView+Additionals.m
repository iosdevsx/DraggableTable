//
//  UIView+Additionals.m
//  DragAndDropTable
//
//  Created by Юрий Логинов on 22.12.17.
//  Copyright © 2017 Yury Loginov. All rights reserved.
//

#import "UIView+Additionals.h"

@implementation UIView (Additionals)

- (UIView *)getSnapshot {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0f;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0f, 0.f);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}

@end
