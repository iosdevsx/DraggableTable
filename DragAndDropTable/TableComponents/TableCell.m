//
//  TableCell.m
//  DragAndDropTable
//
//  Created by Юрий Логинов on 22.12.17.
//  Copyright © 2017 Yury Loginov. All rights reserved.
//

#import "TableCell.h"


@interface TableCell()

@property (weak, nonatomic) IBOutlet UIView *separatorView;

@end

@implementation TableCell

+ (instancetype)cellWithTitle:(NSString *)title height:(CGFloat)height action:(dispatch_block_t)action {
    TableCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TableCell class]) owner:nil options:nil].firstObject;
    cell.titleLabel.text = title;
    cell.height = height;
    cell.actionBlock = action;
    return cell;
}

@end
