//
//  ISWebRecognizer.h
//  ISWebRecognition
//
//  Created by Erick Xi on 12/17/13.
//  Copyright (c) 2013 Intsig. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 * Recognition language mask
 */
typedef NS_OPTIONS(NSInteger, BCRLanguage)
{
    BCRLanguageEnglish = 1U << 0, //English can not be turned off
    BCRLanguageChinese_Simplified = 1U << 1,
    BCRLanguageChinese_Traditional = 1U << 2,
    BCRLanguageJapanese = 1U << 3,
    BCRLanguageKorean = 1U << 4,
    BCRLanguageFrench = 1U << 5,
    BCRLanguageSpanish = 1U << 6,
    BCRLanguagePortuguese = 1U << 7,
    BCRLanguageGerman = 1U << 8,
    BCRLanguageItalian = 1U << 9,
    BCRLanguageDutch = 1U << 10,
    BCRLanguageSwedish = 1U << 14,
    BCRLanguageFinnish = 1U << 15,
    BCRLanguageDanish = 1U << 16,
    BCRLanguageNorwegian = 1U << 17,
    BCRLanguageHungarian = 1U << 18
};


typedef void (^ISRecognitionCompletionHandler)(NSString *vCardRepresentation, NSError *error);
typedef void (^ISRecogmitionCropHandler)(UIImage *cropAndEnhancedImage);

/*!
 * Base Class for Card Recognizer
 */


@interface ISWebRecognizer : NSObject

/*!
 *  Set the recognition language
 */
@property (nonatomic, assign) BCRLanguage language;

/*!
 * Must set the user and pass before recognize image
 */
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *password;

/*
 * Optional
 */
@property (nonatomic, copy) NSString *companyId;

/*! Recognize an image and give the vcf string back
 *  @param image: the image to be recognized, the smallest recommend image size is 1024 * 768
 *  @param completionHandler: a block object to be executed when the recognition is completed
 */
- (void) recognizeImage:(UIImage *)image
      completionHandler:(ISRecognitionCompletionHandler)completionHandler;


/*! Crop an image and recognize the cropped image and give the vcf string back
 *  @param image: the image to be cropped, the smallest recommend image size is 1024 * 768
 *  @param croppedHandler: a block object to be executed after cropping image
 *  @param completionHandler: a block object to be executed after the recognition is completed
 */
- (void) cropAndRecognizeImage:(UIImage *)image
                croppedHandler:(ISRecogmitionCropHandler)croppedHandler
             completionHandler:(ISRecognitionCompletionHandler)completionHandler;

@end
