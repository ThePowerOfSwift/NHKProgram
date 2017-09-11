import Foundation

import RxSwift
import RxCocoa
import SwiftDate
import SwiftyJSON

import Domain

public final class NHKProgramRepository: ProgramRepositoryInterface {
    
    public func loadDailyProgramList(year: Int, month: Int, day: Int) -> Observable<[Program]> {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let url = URL(string: "http://api.nhk.or.jp/v2/pg/list/270/g1/\(year)-\(month)-\(day).json?key=Ow3ZGKAmcpPYGPbNZ5t9iK33GzXYCE0A")!
        let data = session.rx.data(request: URLRequest(url: url))
        let json = data.map { JSON(data: $0) }
        let allProgramsArray = json.map { $0["list"]["g1"].arrayValue }
        let programs = allProgramsArray.map {
            $0.map { (program: JSON) -> Program in
                let id = program["id"].stringValue
                let title = program["title"].stringValue
                let subtitle = program["subtitle"].stringValue
                let content = program["content"].string
                let startTime = program["startTime"].stringValue
                let endTime = program["endTime"].stringValue
                
                let formatter = ISO8601DateFormatter()
                let formatStartTime = formatter.date(from: startTime)!
                let formatEndTime = formatter.date(from: endTime)!

                
                return Program(id: id, title: title, subtitle: subtitle, content: content, startTime: formatStartTime, endTime: formatEndTime, logoImageURL: nil)
            }
        }
        return programs
    }
}
