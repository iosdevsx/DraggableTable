//
//  TableViewCellsDraggingDelegate.m
//  DragAndDropTable
//
//  Created by Юрий Логинов on 22.12.17.
//  Copyright © 2017 Yury Loginov. All rights reserved.
//

#import "TableCellsDraggingHandler.h"
#import "UIView+Additionals.h"
#import "HapticGenerator.h"
#import "DraggableSection.h"
#import "UIGestureRecognizer+Utils.h"


@interface TableCellsDraggingHandler()

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;
@property (nonatomic, strong) HapticGenerator *hapticGenerator;

@end

@implementation TableCellsDraggingHandler

+ (instancetype)handleDraggingOnTableView:(UITableView *)tableView {
    TableCellsDraggingHandler *draggingDelegate = [TableCellsDraggingHandler new];
    draggingDelegate.tableView = tableView;
    draggingDelegate.hapticGenerator = [[HapticGenerator alloc] initWithStyle:HapticStyleSelection];
    [draggingDelegate setupGesture];
    
    return draggingDelegate;
}

- (void)setupGesture {
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureActivated:)];
    self.longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureActivated:)];
    
    [self.tableView addGestureRecognizer:self.tapGesture];
    [self.tableView addGestureRecognizer:self.longPressGesture];
}

- (void)tapGestureActivated:(UITapGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    if ([self.delegate respondsToSelector:@selector(selectedRowAtIndexPath:)]) {
        [self.delegate selectedRowAtIndexPath:indexPath];
    }
}

- (void)longPressGestureActivated:(UILongPressGestureRecognizer *)gesture {
    UIGestureRecognizerState state = gesture.state;
    
    CGPoint location = [gesture locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    
    if ([self.delegate respondsToSelector:@selector(shouldDragCellAtIndexPath:)]) {
        if (![self.delegate shouldDragCellAtIndexPath:indexPath]) {
            [gesture cancel];
            return;
        }
    }
    
    id<DraggableSection> currentSection = [self.delegate sectionForIndexPath:indexPath];
    UITableViewCell *cell = currentSection.cells[indexPath.row];
    __block CGPoint cellCenter = cell.center;
    
    static UIView *snapshot = nil;
    static NSIndexPath *sourceIndexPath = nil;
    static NSIndexPath *initialIndexPath = nil;
    static UITableViewCell *initialCell = nil;
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                if (!currentSection || ![currentSection conformsToProtocol:@protocol(DraggableSection)]) {
                    [gesture cancel];
                    return;
                }
                
                initialCell = cell;
                sourceIndexPath = indexPath;
                initialIndexPath = indexPath;
                
                snapshot = [cell getSnapshot];
                snapshot.center = cell.center;
                snapshot.alpha = 0.f;
                [self.tableView addSubview:snapshot];
                
                [UIView animateWithDuration:0.2 animations:^{
                    
                    cellCenter.y = location.y;
                    snapshot.center = cellCenter;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98f;
                    
                    cell.alpha = 0.f;
                } completion:^(BOOL finished) {
                    cell.hidden = YES;
                }];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;
            
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                [self.hapticGenerator activateFeedback];
                [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                [self.tableView deselectRowAtIndexPath:sourceIndexPath animated:YES];
                sourceIndexPath = indexPath;
            }
            break;
        }
        default: {
            [self.tableView deselectRowAtIndexPath:initialIndexPath animated:NO];
            [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
            
            [self.delegate dragDidEndFromIndexPath:initialIndexPath toIndexPath:sourceIndexPath];
            
            BOOL shouldDropToSource = NO;
            
            if ([self.delegate respondsToSelector:@selector(shouldDropToIndexPath:)]) {
                shouldDropToSource = [self.delegate shouldDropToIndexPath:indexPath];
            }
            
            shouldDropToSource &= [currentSection conformsToProtocol:@protocol(DraggableSection)];
            
            [UIView animateWithDuration:0.4 animations:^{
                snapshot.transform = CGAffineTransformIdentity;
                if (shouldDropToSource) {
                    snapshot.center = cell.center;
                } else {
                    snapshot.center = initialCell.center;
                }
                initialCell.alpha = 1.0f;
            } completion:^(BOOL finished) {
                initialCell.hidden = NO;
                sourceIndexPath = nil;
                [snapshot removeFromSuperview];
                snapshot = nil;
            }];
            
            break;
        }
    }
}

@end
