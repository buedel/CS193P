//
//  CalculatorBrain.h
//  Calculator
//
//  Created by DOUGLAS BUEDEL on 10/13/12.
//  Copyright (c) 2012 buedel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(double)operand;
- (double)performOperation:(NSString *) operation;
- (void)pushVariable:(NSString *)variable;

- (void) clear;

- (BOOL)canPerformOperation:(NSString *)operation;

// returns an object of unspecified class which
// represents the sequence of operands and operations
// since last clear.
// NOTE: program will always be a property list
@property (nonatomic, readonly) id program;

// a string representing (to an end user) the passed program
// (programs are obtained from the program @property of a CalculatorBrain instance)
+ (NSString *)descriptionOfProgram:(id)program;

// runs the program (obtained from the program @property of a CalculatorBrain instance)
// if the last thing done in the program was pushOperand:, this returns that operand
// if the last thing done in the program was performOperation:, this evaluates it (recursively)
+ (double)runProgram:(id)program;

+ (double)runProgram:(id)program
 usingVariableValues:(NSDictionary *)variableValues;

+ (NSSet *) variablesUsedInProgram:(id)program;

@end
