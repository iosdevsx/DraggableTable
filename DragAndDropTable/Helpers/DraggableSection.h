//
//  DraggableSection.h
//  DragAndDropTable
//
//  Created by Юрий Логинов on 22.12.17.
//  Copyright © 2017 Yury Loginov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DraggableSection <NSObject>

@property (nonatomic, copy) NSMutableArray *cells;

@end
