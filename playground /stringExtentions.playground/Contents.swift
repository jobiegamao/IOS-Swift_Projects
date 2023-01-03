import UIKit

let word = "pet"
let word2 = "he110 ther3"
let word3 = "this\nis\na\ntest"


extension String {
	func withPrefix(_ prefix: String) -> String {
		guard self.hasPrefix(prefix) else { return String(prefix + self) }
		return self
	}
	
	func isNumeric() -> Bool {
		var digits = [String]()
		for num in 0...9 {
			digits.append(String(num))
		}
		
		guard digits.contains(where: self.contains) else {return false}
		return true
	}
	
	var arrayFromString: [String] {
		guard self.contains("\n") else {return []}
		return self.components(separatedBy: "\n")
	}
}

word.withPrefix("car")
word.isNumeric()
word2.isNumeric()
word3.arrayFromString
word2.arrayFromString
