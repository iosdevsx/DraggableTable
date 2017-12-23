//
//  ParentViewController.h
//  DragAndDropTable
//
//  Created by Юрий Логинов on 22.12.17.
//  Copyright © 2017 Yury Loginov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParentViewController : UIViewController

@property (nonatomic, strong, readonly) NSString *firstTitle;
@property (nonatomic, strong, readonly) NSString *secondTitle;

- (void)setupWithFirstTitle:(NSString *)firstTitle
                secondTitle:(NSString *)secondTitle;

@end
