#import "HapticGenerator.h"
#import <UIKit/UIKit.h>

@interface HapticGenerator()

@property (nonatomic, assign) HapticStyle style;

@property (nonatomic, strong) UISelectionFeedbackGenerator *selectionFeedback;
@property (nonatomic, strong) UIImpactFeedbackGenerator *impactFeedback;

@end

@implementation HapticGenerator

- (instancetype)initWithStyle:(HapticStyle)style
{
    self = [super init];
    if (self) {
        self.style = style;
        switch (style) {
            case HapticStyleSelection:
                [self setupSelectionHaptic];
                break;
            case HapticStyleImpact:
                [self setupImpactHaptic];
                break;
        }
    }
    return self;
}

- (void)setupSelectionHaptic {
    self.selectionFeedback = [UISelectionFeedbackGenerator new];
    [self.selectionFeedback prepare];
}

- (void)setupImpactHaptic {
    self.impactFeedback = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
    [self.impactFeedback prepare];
}

- (void)activateFeedback {
    switch (self.style) {
        case HapticStyleSelection:
            if (self.selectionFeedback) {
                [self.selectionFeedback selectionChanged];
            }
            break;
        case HapticStyleImpact:
            if (self.impactFeedback) {
                [self.impactFeedback impactOccurred];
            }
            break;
    }
}

- (void)releaseFeedback {
    self.selectionFeedback = nil;
    self.impactFeedback = nil;
}

@end
