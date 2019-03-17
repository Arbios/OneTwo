import Foundation

extension String {
	
	enum Strings: String {
		case ok
		case error
		case currentProjectIsFail
		case serverErrorMessage
		case errorParseJson
		case widthHeightEmpty
		case currency
		case noPriceAndDate
	}
	
	//MARK: - Inits

	func localized() -> String {
		return NSLocalizedString(self, comment: self)
	}

	//MARK: - Inits

	init(_ localized: Strings) {
		self.init(localized.rawValue.localized())
	}
}
