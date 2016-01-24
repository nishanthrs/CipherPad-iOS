//
//  QuestionObject.h
//  MyScript App
//
//  Created by Nishanth Salinamakki on 11/15/15.
//  Copyright © 2015 Nishanth Salinamakki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface QuestionObject : NSObject

@property (strong, nonatomic) NSString *questionTopic;
@property (strong, nonatomic) NSString *questionString;
@property (strong, nonatomic) UIImageView *questionImage;

- (id) initWithQuestionTopic: (NSString *) topic andQuestion: (NSString *) string andImage: (UIImageView *) image;

@end
