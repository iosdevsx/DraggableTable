//
//  TableViewCellsDraggingDelegate.h
//  DragAndDropTable
//
//  Created by Юрий Логинов on 22.12.17.
//  Copyright © 2017 Yury Loginov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol DraggableSection;
@class TableSection;

@protocol TableViewCellsDraggingDelegate <NSObject>

/**
 Ask delegate for current section whose cells should be drag.

 @param indexPath for section
 @return section, can be nil
 */
- (_Nullable id <DraggableSection>)sectionForIndexPath:(NSIndexPath *_Nonnull)indexPath;

/**
 This method calls when cell drop.

 @param fromIndexPath indexPath where touch began
 @param toIndexPath indexPath where touch ended
 */
- (void)dragDidEndFromIndexPath:(NSIndexPath *_Nonnull)fromIndexPath toIndexPath:(NSIndexPath *_Nonnull)toIndexPath;

@optional

/**
 Override this method, if need select cell.
 Because long gesture recognizer intercept tableView:didSelectRowAtIndexPath.

 @param indexPath indexPath for selected row
 */
- (void)selectedRowAtIndexPath:(NSIndexPath *_Nonnull)indexPath;

/**
 Override this method if you want to manage manually, which cells in section should be drag.
 By default all cells in sections which conforms to DraggableSection protocol can be dragging.

 @param indexPath indexPath for selected
 @return Boolean value
 */
- (BOOL)shouldDragCellAtIndexPath:(NSIndexPath *_Nonnull)indexPath;

/**
 Override this method if you want to manage manually, in which position should drop draggable cell.
 It need only for animation.
 By default, it drops to indexPath, where touch ended.

 @param indexPath for ended
 @return Boolean value
 */
- (BOOL)shouldDropToIndexPath:(NSIndexPath *_Nonnull)indexPath;

@end

@interface TableCellsDraggingHandler : NSObject

@property (nonatomic, weak) _Nullable id<TableViewCellsDraggingDelegate> delegate;

+ (instancetype _Nonnull )handleDraggingOnTableView:(UITableView *_Nonnull)tableView;

@end
