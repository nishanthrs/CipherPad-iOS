//
//  QuestionObject.m
//  MyScript App
//
//  Created by Nishanth Salinamakki on 11/15/15.
//  Copyright © 2015 Nishanth Salinamakki. All rights reserved.
//

#import "QuestionObject.h"

@implementation QuestionObject

- (id) init {
    self = [self initWithQuestionTopic: nil andQuestion: nil andImage: nil];
    return self;
}

- (id) initWithQuestionTopic:(NSString *)topic andQuestion:(NSString *)string andImage:(UIImageView *)image {
    self = [super init];
    
    self.questionTopic = topic;
    self.questionString = string;
    self.questionImage = image;
    
    return self;
}

@end
