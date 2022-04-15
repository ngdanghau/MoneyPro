//
//  StringExt.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 15/04/2022.
//

import Foundation

extension String
{
    func encodeUrl() -> String?
    {
        return self.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
    }
    func decodeUrl() -> String?
    {
        return self.removingPercentEncoding
    }
}
