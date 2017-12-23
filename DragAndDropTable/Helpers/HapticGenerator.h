#import <Foundation/Foundation.h>


typedef NS_ENUM(int16_t, HapticStyle) {
    HapticStyleImpact,
    HapticStyleSelection,
};

@interface HapticGenerator : NSObject

/**
 Use this method for initialize haptic feedback

 @param style send style param for initialize different haptic feedback
 @return instance
 */
- (instancetype)initWithStyle:(HapticStyle)style;


/**
 Use this method for activate and prepare to use TapticEngine
 */
- (void)activateFeedback;


/**
 Use this method for return TapticEngine to idle state. 
 You should call this method when you go out from screen, or deallocate object, which uses TapticEngine
 */
- (void)releaseFeedback;

@end
