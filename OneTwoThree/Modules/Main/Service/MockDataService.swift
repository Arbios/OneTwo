//
//  MockDataService.swift
//  OneTwoThree
//
//  Created by Andrey Torlopov on 18/03/2019.
//  Copyright © 2019 ARBI BASHAEV. All rights reserved.
//

import Foundation

enum MockDataServiceResult {
	case success(model: [String: Any])
	case failure(String?)
}

protocol MockDataServiceProtocol {
	func fetch(width: Int, height: Int, completion: @escaping(MockDataServiceResult) -> Void)
}

final class MockDataService: MockDataServiceProtocol {
	
	func fetch(width: Int, height: Int, completion: @escaping(MockDataServiceResult) -> Void) {
		let jsonString =
		"""
		{
		"6392":
		{
		"value_id": "-1",
		"value":"\(width)"
		},
		"6393":
		{
		"value_id": "-1",
		"value":"\(height)"
		},
		"6394":
		{
		"value_id": "-1",
		"value":"6"
		},
		"6395":
		{
		"value_id": "-1",
		"value":"700"
		}
		}
		"""
		guard let jsonData = jsonString.data(using: .utf8),
			let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
			let result = jsonObject else {
				completion(.failure(String(.errorParseJson)))
				return
		}
		completion(.success(model: result))
	}
}
