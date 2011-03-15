/**
 * Category for NSData which adds a utility method for converting the
 * data object to a hexidecimal string.
 */
@interface NSData (Hex)

/**
 * Returns a hexadecimal representation of the data object's contents.
 *
 * @return hexadecimal string representation
 */
- (NSString *)hexStringValue;

@end