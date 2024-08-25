//
//  Line.m
//  CaplessCoderPaint
//
//  Created by crossmo/yangcun on 14/10/29.
//  Copyright (c) 2014年 yangcun. All rights reserved.
//

#import "Line.h"

@implementation Line

@synthesize begin, end, color;

- (id)init
{
    self = [super init];
    if (self) {
        [self setColor:[UIColor blackColor]];
    }
    return self;
}

-(id)initWithString:(NSString*) string{
    self = [super init];
    if (self) {
        NSArray *firstSplit = [string componentsSeparatedByString:@" "];
        
        self.begin = CGPointMake( [firstSplit[0] floatValue], [firstSplit[1] floatValue]);
        self.end = CGPointMake( [firstSplit[2] floatValue], [firstSplit[3] floatValue]);
        [self setColor:  [UIColor colorWithRed:[firstSplit[4] floatValue] green:[firstSplit[5] floatValue] blue:[firstSplit[6] floatValue] alpha:[firstSplit[7] floatValue]  ] ];
    }
    return self;
}

-(NSString*)toString{
    CGFloat r=0,g=0,b=0,a=0;
    [self.copy getRed:&r green:&g blue:&b alpha:&a];
    return [NSString stringWithFormat:@"%f %f %f %f %f %f %f %f", self.begin.x, self.begin.y
            , self.end.x, self.end.y, r, g, b, a];
}



@end
