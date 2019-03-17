import Foundation

private extension URL {
	
	func appendingQueryParameters(_ parameters: [String: String]) -> URL {
		var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true)!
		var items = urlComponents.queryItems ?? []
		items += parameters.map({ URLQueryItem(name: $0, value: $1) })
		urlComponents.queryItems = items
		return urlComponents.url!
	}
}

enum APIRequest {
	case getProjectIk(projectId: Int)
	case silentCalculate(projectId: Int, params: [String: Any])
}

extension APIRequest {
	static private let apiURL: URL = URL(string: "http://system123.ru/api")!
	static private let userAgent: String = { return "OneTwoThree:ios" }()
	static private let token = "80614a86-4b9f-4df7-9e91-7500e2a239ed"
	static private let tokenHeaderField = "XAUTHSUBJECT"
	
	var request: URLRequest {
		let components = self.components
		let url = APIRequest.apiURL.appendingPathComponent(components.path).appendingQueryParameters(components.urlParameters)
		
		var request = URLRequest(url: url)
		
		request.httpMethod = self.method
		
		components.headers.forEach { (key: String, value: String) in
			request.setValue(value, forHTTPHeaderField: key)
		}
		
		if components.asJson {
			request.httpBody = try! JSONSerialization.data(withJSONObject: components.parameters, options: [])
		}
		else {
			request.httpBody = urlEncodedParameters(params: components.parameters).data(using: .utf8)
		}
		
		if components.needToken {
			request.setValue(APIRequest.token, forHTTPHeaderField: APIRequest.tokenHeaderField)
		}
		
		return request
	}
	
	private struct Components {
		var path: String!
		var parameters: [String: Any] = [:]
		var urlParameters: [String: String] = [:]
		var headers: [String: String] = ["Content-Type": "application/json"]
		var emptyBody: Bool = false
		var asJson: Bool = true
		var needToken: Bool = false
	}
	
	private var components: Components {
		var components = Components()
		
		switch self {
		case let .getProjectIk(projectId):
			components.path = "/get_project_ik"
			components.parameters["dir_id"] = projectId
			return components
		case let .silentCalculate(projectId, params):
			components.path = "/ik/silent_calculate/\(projectId)"
			components.headers["Accept"] = "application/json"
			components.parameters = params
			components.needToken = true
			return components
		}
	}
	
	private var method: String {
		switch self {
		case .getProjectIk, .silentCalculate:
			return "POST"
		}
	}
	
	private func urlEncodedParameters(params: [String: Any]?) -> String {
		var result = ""
		guard let keys = params?.keys else { return result }
		
		var stringParameters: [String] = []
		for key in keys {
			let value = params![key] ?? ""
			var stringValue: String = ""
			if value is String {
				if let val = value as? String {
					stringValue = escapeValue(string: val)
				}
			}
			else {
				stringValue = escapeValue(string: "\(value)")
			}
			stringParameters.append("\(key)=\(stringValue)")
		}
		result = stringParameters.joined(separator: "&")
		return result
	}
	
	private func escapeValue(string: Any) -> String {
		var result = ""
		if let string = string as? String {
			result = string
		}
		else {
			result = String(describing: string)
		}
		return result.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
	}
}
