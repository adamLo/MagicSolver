//
//  MSCalculator.h
//  MagicSolver
//
//  Created by Adam Lovastyik on 2013.06.10..
//  Copyright (c) 2013 Lovastyik. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Class for solving the problem above:
 
 Overview:
 This is a short exercise to test basic Objective-C skills and problem-solving ability. Feel free to use the resources you would have available in the workplace (internet, books) as we’re trying to ascertain how you’d tackle a problem in a day to day work environment. The exercise itself is not one we’d expect any potential candidate to have a problem solving – we’re just as interested in how something is done as simply reaching a functional solution.
 
 The Exercise:
 Write an application that evaluates a string expression consisting of positive integers and the +, -, /,* operands only, taking into account normal mathematical rules of operator precedence. No brackets or support for input variables is required.
 
 For example:
 an input string of "4+5*2" should output 14
 an input string of "4+5/2" should output 6.5
 an input string of "4+5/2-1" should output 5.5
 
 */
@interface MSCalculator : NSObject

@property (nonatomic, retain) NSNumberFormatter *formatter; /** Formatter to convert String to Numeric value */

/**
 Main routine to complete task. Gives back the calculated value of interpreted line of string.
 @param line String line containing the formula to interpret and calculate
 @param error indicate if there was an error that blocks calculation
 @return Calculated value, null if cannot be calculated due to error
 */
- (NSNumber*)calculateLineOfString:(NSString*)line Error:(NSError**)error;

/*
 The following methods are only private to help testing
 */

/**
 Check whether a string is an operator or not and return priority value if yes
 @param value String to chek if an operator
 @return 0 if value is not an operator positive number otherwise. The higher it returns the higher priority it has
 */
- (int)PriorityIfOperator:(NSString*)value;


/**
 Translates a line of string into number and operator pieces.
 @param line String to interpret
 @return mutable array of NSNumber (value) and NSString (operator)
 */
- (NSMutableArray*)interpretLineOfString:(NSString*)line;

/**
 Do calculation of an operator with two numbers. Operation is always "second on first": 1-2, 1/2, 1+2, 1*2
 @param operation String of operation
 @param num1 First numeric argument
 @param num2 Second numeric argument
 @param error Indicate if there was an error (e.g. division by zero)
 @return Numeric result or nil on error
 */
- (NSNumber*)calculateOperation:(NSString*)operation withNumber:(NSNumber*)num1 andNumber:(NSNumber*)num2 Error:(NSError **)error;

/**
 Gets maximal priority operation value in given line of string
 @param line Interpreted array to examine
 @return maximum value of priority
 */
- (int)maxPriorityOfInterpretedLine:(NSArray*)interpretedLine;

@end
