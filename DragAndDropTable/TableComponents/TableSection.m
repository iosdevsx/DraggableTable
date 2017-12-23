//
//  TableSection.m
//  DragAndDropTable
//
//  Created by Юрий Логинов on 22.12.17.
//  Copyright © 2017 Yury Loginov. All rights reserved.
//

#import "TableSection.h"
#import "DraggableSection.h"

@implementation TableSection

+ (instancetype)sectionWithCells:(NSArray *)cells headerTitle:(NSString *)title {
    TableSection *section = [TableSection new];
    section.cells = [cells mutableCopy];
    section.headerTitle = title;
    return section;
}

@end
