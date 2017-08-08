import Foundation

import RxSwift
import RxCocoa
import SwiftyJSON

import Domain

private let endpoint = "http://api.nhk.or.jp/v2/pg/list"

public final class NHKProgramRepository: ProgramRepositoryInterface {
    private let area: Area
    private let service: Service
    
    public init(area: Area, service: Service) {
        self.area = area
        self.service = service
    }
    
    public func loadDailyProgramList(year: Int, month: Int, day: Int) -> Observable<[Program]> {
        let y = String(format: "%04d", year)
        let m = String(format: "%02d", month)
        let d = String(format: "%02d", day)
        let area = self.area
        
        guard let url = URL(string: "\(endpoint)/\(area.rawValue)/\(service.rawValue)/\(y)-\(m)-\(d).json?key=\(NHKSecret.apiKey)") else {
            return Observable.error(AppError.illegalArgument)
        }
        
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        return session.rx.data(request: URLRequest(url: url))
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .catchError { _ in Observable.error(WebAPIError.unknown) }
            .map { JSON(data: $0) }
            .map { obj -> [Program] in
                guard let programs = obj["list"][area.rawValue].array else { return [] }
                return try programs.map(NHKProgramRepository.toDomainObject)
        }
    }
    
    private static func toDomainObject(from json: JSON) throws -> Program {
        guard
            let id = json["id"].string,
            let startTimeString = json["start_time"].string,
            let endTimeString = json["end_time"].string,
            let title = json["title"].string,
            let subtitle = json["subtitle"].string
        else {
            throw WebAPIError.illegalResponse
        }
        
        let dateFormatter = ISO8601DateFormatter()
        guard
            let startTime = dateFormatter.date(from: startTimeString),
            let endTime = dateFormatter.date(from: endTimeString)
        else {
            throw WebAPIError.illegalResponse
        }
        
        return Program(id: id, startTime: startTime, endTime: endTime, title: title, subtitle: subtitle)
    }
}

public extension NHKProgramRepository {
    public enum Area: String {
        case 札幌 = "010"
        case 函館 = "011"
        case 旭川 = "012"
        case 帯広 = "013"
        case 釧路 = "014"
        case 北見 = "015"
        case 室蘭 = "016"
        case 青森 = "020"
        case 盛岡 = "030"
        case 仙台 = "040"
        case 秋田 = "050"
        case 山形 = "060"
        case 福島 = "070"
        case 水戸 = "080"
        case 宇都宮 = "090"
        case 前橋 = "100"
        case さいたま = "110"
        case 千葉 = "120"
        case 東京 = "130"
        case 横浜 = "140"
        case 新潟 = "150"
        case 富山 = "160"
        case 金沢 = "170"
        case 福井 = "180"
        case 甲府 = "190"
        case 長野 = "200"
        case 岐阜 = "210"
        case 静岡 = "220"
        case 名古屋 = "230"
        case 津 = "240"
        case 大津 = "250"
        case 京都 = "260"
        case 大阪 = "270"
        case 神戸 = "280"
        case 奈良 = "290"
        case 和歌山 = "300"
        case 鳥取 = "310"
        case 松江 = "320"
        case 岡山 = "330"
        case 広島 = "340"
        case 山口 = "350"
        case 徳島 = "360"
        case 高松 = "370"
        case 松山 = "380"
        case 高知 = "390"
        case 福岡 = "400"
        case 北九州 = "401"
        case 佐賀 = "410"
        case 長崎 = "420"
        case 熊本 = "430"
        case 大分 = "440"
        case 宮崎 = "450"
        case 鹿児島 = "460"
        case 沖縄 = "470"
    }
    
    public enum Service: String {
        case nhkGeneral1 = "g1"
        case nhkGeneral2 = "g2"
        case nhkETV1 = "e1"
        case nhkETV2 = "e2"
        case nhkETV3 = "e3"
        case nhk1Seg2 = "e4"
        case nhkBS1 = "s1"
        case nhkBS1_102Ch = "s2"
        case nhkBSPremium = "s3"
        case nhkBSPremium_104ch = "s4"
        case nhkRadio1 = "r1"
        case nhkRadio2 = "r2"
        case nhkFM = "r3"
        case nhkNetRadio1 = "n1"
        case nhkNetRadio2 = "n2"
        case nhkNetRadioFM  = "n3"
    }
}
