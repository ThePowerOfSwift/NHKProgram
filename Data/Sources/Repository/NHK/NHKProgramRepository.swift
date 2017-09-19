import Foundation

import RxSwift
import RxCocoa
import SwiftDate
import SwiftyJSON

import Domain

public final class NHKProgramRepository: ProgramRepositoryInterface {
    
    public init() {}
    
    public func loadDailyProgramList(year: Int, month: Int, day: Int) -> Observable<[Program]> {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let dateString = String.init(format: "%04d-%02d-%02d", year, month, day)
        let url = URL(string: "https://api.nhk.or.jp/v2/pg/list/270/g1/\(dateString).json?key=Ow3ZGKAmcpPYGPbNZ5t9iK33GzXYCE0A")!
        let data = session.rx.data(request: URLRequest(url: url))
        let json = data.map { JSON(data: $0) }
        let allProgramsArray = json.map { $0["list"]["g1"].arrayValue }
        let programs = allProgramsArray.map {
            $0.map { (program: JSON) -> Program in
                let id = program["id"].stringValue
                let title = program["title"].stringValue
                let subtitle = program["subtitle"].stringValue
                let content = program["content"].string
                let startTime = program["start_time"].stringValue
                let endTime = program["end_time"].stringValue
                
                let formatter = ISO8601DateFormatter()
                let formatStartTime = formatter.date(from: startTime)!
                let formatEndTime = formatter.date(from: endTime)!

                
                return Program(id: id, title: title, subtitle: subtitle, content: content, startTime: formatStartTime, endTime: formatEndTime, logoImageURL: nil)
            }
        }
        return programs
    }
}
