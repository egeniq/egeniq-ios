#import "Kiwi.h"

#import "NSString+Utilities.h"

SPEC_BEGIN(NSStringUtilitiesTests)

describe(@"The NSString Utilities extension", ^{
    
    context(@"when returning a random string", ^{
        
        it(@"should return a string", ^{
            [[[NSString randomStringOfLength:10] should] beNonNil];
        });
        
        it(@"should return a string of correct length", ^{
            [[theValue([[NSString randomStringOfLength:10] length]) should] equal:theValue(10)];
        });
        
        it(@"should return a string of correct length", ^{
            [[theValue([[NSString randomStringOfLength:0] length]) should] equal:theValue(0)];
        });
        
        it(@"should return a string of correct length", ^{
            [[theValue([[NSString randomStringOfLength:100] length]) should] equal:theValue(100)];
        });
    });
    
    context(@"when calculating a checksum", ^{
        
        it(@"should do so correctly for md5", ^{
            [[[@"Lorem ipsum" md5Hash] should] equal:@"0956d2fbd5d5c29844a4d21ed2f76e0c"];
        });
        
        it(@"should do so correctly for md5", ^{
            [[[@"" md5Hash] should] equal:@"d41d8cd98f00b204e9800998ecf8427e"];
        });
        
        it(@"should do so correctly for sha1", ^{
            [[[@"Lorem ipsum" sha1Hash] should] equal:@"94912be8b3fb47d4161ea50e5948c6296af6ca05"];
        });
        
        it(@"should do so correctly for sha1", ^{
            [[[@"" sha1Hash] should] equal:@"da39a3ee5e6b4b0d3255bfef95601890afd80709"];
        });
        
    });
    
    
    context(@"when dealing with HTML entities", ^{
        
        it(@"should correctly decode", ^{
            [[[@"&nbsp; &iexcl; &cent; &pound; &curren; &yen; &brvbar; &sect; &uml; &copy; &ordf; &laquo; &not; &shy; &reg; &macr; &deg; &plusmn; &sup2; &sup3; &acute; &micro; &para; &middot; &cedil; &sup1; &ordm; &raquo; &frac14; &frac12; &frac34; &iquest; &Agrave; &Aacute; &Acirc; &Atilde; &Auml; &Aring; &AElig; &Ccedil; &Egrave; &Eacute; &Ecirc; &Euml; &Igrave; &Iacute; &Icirc; &Iuml; &ETH; &Ntilde; &Ograve; &Oacute; &Ocirc; &Otilde; &Ouml; &times; &Oslash; &Ugrave; &Uacute; &Ucirc; &Uuml; &Yacute; &THORN; &szlig; &agrave; &aacute; &acirc; &atilde; &auml; &aring; &aelig; &ccedil; &egrave; &eacute; &ecirc; &euml; &igrave; &iacute; &icirc; &iuml; &eth; &ntilde; &ograve; &oacute; &ocirc; &otilde; &ouml; &divide; &oslash; &ugrave; &uacute; &ucirc; &uuml; &yacute; &thorn; &yuml;" decodeHTMLCharacterEntities] should] equal:@"  ¡ ¢ £ ¤ ¥ ¦ § ¨ © ª « ¬ ­ ® ¯ ° ± ² ³ ´ µ ¶ · ¸ ¹ º » ¼ ½ ¾ ¿ À Á Â Ã Ä Å Æ Ç È É Ê Ë Ì Í Î Ï Ð Ñ Ò Ó Ô Õ Ö × Ø Ù Ú Û Ü Ý Þ ß à á â ã ä å æ ç è é ê ë ì í î ï ð ñ ò ó ô õ ö ÷ ø ù ú û ü ý þ ÿ"];
        });
        
        it(@"should correctly encode", ^{
            [[[@"<&>" encodeHTMLCharacterEntities] should] equal:@"&lt;&amp;&gt;"];
        });
        
        
    });
});

SPEC_END