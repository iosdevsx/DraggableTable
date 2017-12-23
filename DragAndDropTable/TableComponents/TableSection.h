//
//  TableSection.h
//  DragAndDropTable
//
//  Created by Юрий Логинов on 22.12.17.
//  Copyright © 2017 Yury Loginov. All rights reserved.
//

typedef enum {
    SectionTypeFirst,
    SectionTypeSecond
} SectionType;

#import <Foundation/Foundation.h>
#import "DraggableSection.h"

@interface TableSection : NSObject <DraggableSection>

@property (nonatomic, copy) NSMutableArray *cells;
@property (nonatomic, strong) NSString *headerTitle;

@property (nonatomic, assign) SectionType type;

+ (instancetype)sectionWithCells:(NSArray *)cells headerTitle:(NSString *)title;

@end
