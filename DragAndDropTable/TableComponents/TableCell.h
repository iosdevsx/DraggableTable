//
//  TableCell.h
//  DragAndDropTable
//
//  Created by Юрий Логинов on 22.12.17.
//  Copyright © 2017 Yury Loginov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, copy) dispatch_block_t actionBlock;
@property (nonatomic, assign) CGFloat height;

+ (instancetype)cellWithTitle:(NSString *)title height:(CGFloat)height action:(dispatch_block_t)action;

@end
