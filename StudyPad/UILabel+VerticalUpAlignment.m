//
//  UILabel+VerticalUpAlignment.m
//  StudyPad
//
//  Created by Hanning Ni on 8/11/15.
//  Copyright (c) 2015 Hanning Ni. All rights reserved.
//

#import "UILabel+VerticalUpAlignment.h"

@implementation UILabel (VerticalUpAlignment)

- (void)verticalUpAlignmentWithText:(NSString *)text maxHeight:(CGFloat)maxHeight
{
    CGRect frame = self.frame;
    CGSize size = [text sizeWithFont:self.font constrainedToSize:CGSizeMake(frame.size.width, maxHeight)];
    frame.size = CGSizeMake(frame.size.width, size.height);
    self.frame = frame;
    self.text = text;
}

@end
