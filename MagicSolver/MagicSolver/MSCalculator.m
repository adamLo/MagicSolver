//
//  MSCalculator.m
//  MagicSolver
//
//  Created by Adam Lovastyik on 2013.06.10..
//  Copyright (c) 2013 Lovastyik. All rights reserved.
//

#import "MSCalculator.h"


@implementation MSCalculator

@synthesize formatter;

/**
 Custom initializer to initate number formatter
 */
- (id) init {
    self = [super init];
    
    if (self) {
        //Set up formatter
        self.formatter = [[NSNumberFormatter alloc] init];
    }
    
    return self;
}

#pragma mark -
#pragma mark Main function

- (NSNumber*)calculateLineOfString:(NSString *)line Error:(NSError *__autoreleasing *)error {
    *error = nil;
    
    //Interpret line
    NSMutableArray *interpreted = [self interpretLineOfString:line];
    if (*error) {
        return nil;
    }
    
    if ([interpreted count]<3) { //Not enough arguments
        *error = [NSError errorWithDomain:@"Calculator" code:100 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Not enough arguments for calculation", NSLocalizedFailureReasonErrorKey, nil]];
        return nil;
    }
    
    //get maximal prioroty to start with
    int maxPriority = [self maxPriorityOfInterpretedLine:interpreted];
    if (maxPriority == 0) { //Nothing to solve
        *error = [NSError errorWithDomain:@"Calculator" code:101 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"No operator in line", NSLocalizedFailureReasonErrorKey, nil]];
        return nil;
    }
    
    
    //start calculation
    while (!*error && (maxPriority>0)) {
        
        //Iterate through all arguments
        for (int position = 1; position < [interpreted count]-1; position++) {
            
            //get actual item
            id actualItem = [interpreted objectAtIndex:position];
            
            //check if actual item is an operator with desired priority level
            if ([actualItem isKindOfClass:[NSString class]] && ([self PriorityIfOperator:actualItem] == maxPriority)) {
                
                //get and check arg before operator
                id prevItem = [self findPrevItemInArray:interpreted fromPosition:position];
                
                //get and check arg after operator
                id nextItem = [self findNextItemInArray:interpreted fromPosition:position];
                
                //If we have both arguments do calculation
                if (prevItem && nextItem) {
                    //Calculate value
                    NSNumber *calculatedValue = [self calculateOperation:actualItem withNumber:prevItem andNumber:nextItem Error:error];
                
                    //Stop calculation on error
                    if (*error) {
                        return nil;
                    }
                
                    //Replace first argument with calculated
                    [interpreted setObject:calculatedValue atIndexedSubscript:[interpreted indexOfObject:prevItem]];
                    //Replace current operator to skip further calculations with it
                    [interpreted setObject:[NSDate date] atIndexedSubscript:position];
                    //Replace second argument to skip further calculations with it
                    [interpreted setObject:[NSDate date] atIndexedSubscript:[interpreted indexOfObject:nextItem]];
                    
                }                
            }
        }
        
        //Decrease priority to step one level back
        maxPriority--;
        
    }
    
    //First numeric value should be returned as result
    return [self findNextItemInArray:interpreted fromPosition:-1];
}

#pragma mark helper methods to find working arguments

- (id)findPrevItemInArray:(NSMutableArray*)array fromPosition:(int)position {
    position--;
    while (position >= 0) {
        id item = [array objectAtIndex:position];
        if ([item isKindOfClass:[NSNumber class]]) {
            return item;
        }
        position--;
    }
    return nil;
}

- (id)findNextItemInArray:(NSMutableArray*)array fromPosition:(int)position {
    position++;
    while (position <[array count]) {
        id item = [array objectAtIndex:position];
        if ([item isKindOfClass:[NSNumber class]]) {
            return item;
        }
        position++;
    }
    return nil;
}

#pragma mark -

- (int)PriorityIfOperator:(NSString*)value {
    
    if (!value) {
        return 0;
    }
    
    if ([value isEqualToString:@"+"]) {
        return 1;
    }
    else if ([value isEqualToString:@"-"]) {
        return 1;
    }
    else if ([value isEqualToString:@"*"]) {
        return 2;
    }
    else if ([value isEqualToString:@"/"]) {
        return 2;
    }
    
    return 0;
}

- (NSMutableArray*)interpretLineOfString:(NSString *)line {
    
    if (!line ) {
        //Nil for nil
        return nil;
    }
    
    //Construct return array
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    
    //Buffer for iteration
    NSString *buffer = @"";
    
    for (int position = 0; position < [line length]; position++) {
        
        //Actual string under test
        NSString *actual = [line substringWithRange:NSMakeRange(position, 1)];
        
        //Actual string is an operator
        if ([self PriorityIfOperator:actual] > 0) {
            
            //convert string to number
            NSNumber *num = [formatter numberFromString:buffer];
            
            if (num) {
                //add buffer to return array
                [ret addObject:num];
            }
            
            //reset buffer
            buffer = @"";
            
            //Add actual operator
            [ret addObject:actual];
            
        }
        else {
            //add actual to buffer
            buffer = [NSString stringWithFormat:@"%@%@", buffer, actual];
        }
    }
    
    if ([buffer length]>0) {
        //add remaining buffer to return
        [ret addObject:[formatter numberFromString:buffer]];
    }
    
    //return interpreted line
    return ret;
}

- (NSNumber*)calculateOperation:(NSString *)operation withNumber:(NSNumber *)num1 andNumber:(NSNumber *)num2 Error:(NSError  **)error {
    
    //reset error
    *error = nil;
    
    if (!operation || ([operation length]!=1)) {
        //No operation
        *error = [[NSError alloc] initWithDomain:@"Calculator" code:1 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Invalid operator", NSLocalizedFailureReasonErrorKey, nil]];
        return nil;
    }
    
    if (!num1 || ![num1 isKindOfClass:[NSNumber class]]) {
        //Invalid arg 1
        *error = [NSError errorWithDomain:@"Calculator" code:2 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"First numeric argument is invalid", NSLocalizedFailureReasonErrorKey, nil]];
        return nil;
    }
    
    if (!num2 || ![num2 isKindOfClass:[NSNumber class]]) {
        //Invalid arg 2
        *error = [NSError errorWithDomain:@"Calculator" code:3 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Second numeric argument is invalid", NSLocalizedFailureReasonErrorKey, nil]];
        return nil;
    }
    
    if ([operation isEqualToString:@"+"]) {
         //Add values
        return [NSNumber numberWithDouble:[num1 doubleValue] + [num2 doubleValue]];
    }
    
    if ([operation isEqualToString:@"-"]) {
        //Substract values
        return [NSNumber numberWithDouble:[num1 doubleValue] - [num2 doubleValue]];
    }
    
    if ([operation isEqualToString:@"*"]) { //Multiply values
        return [NSNumber numberWithDouble:[num1 doubleValue] * [num2 doubleValue]];
    }
    
    if ([operation isEqualToString:@"/"]) {
        //divide values
        if ([num2 isEqualToNumber:@0]) {
            //Division by zero
            *error = [NSError errorWithDomain:@"Calculator" code:4 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Division by zero", NSLocalizedFailureReasonErrorKey, nil]];
            return nil;
        }
        
        return [NSNumber numberWithDouble:[num1 doubleValue] / [num2 doubleValue]];
    }
    
    //Unhandled operation returns nil
    return nil;
}

- (int)maxPriorityOfInterpretedLine:(NSArray *)interpretedLine {
    
    //Default return value
    int ret = 0;
    
    //iterate through array
    for (int position = 0; position < [interpretedLine count]; position++) {
        
        //get actual item to check
        id actualItem = [interpretedLine objectAtIndex:position];
        
        //Check actual item priority value
        if ([actualItem isKindOfClass:[NSString class]]) {
            int actual = [self PriorityIfOperator:actualItem];
            if (actual > ret) {
                //Set current maximum
                ret = actual;
            }
        }
    }
    
    //Return maximum
    return ret;
}

@end
