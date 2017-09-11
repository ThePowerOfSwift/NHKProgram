import Foundation

import RxSwift
import SwiftDate

import Domain

public final class MockProgramRepository: ProgramRepositoryInterface {
    
    public init() {}
    
    public func loadDailyProgramList(year: Int, month: Int, day: Int) -> Observable<[Program]> {
        
        let startOfToday = Date().startOfDay
        
        let programs = [
            Program(id: "001",
                    title: "ニュース7",
                    subtitle: "午前7時のニュースをおしらせします",
                    content: "ニュースです",
                    startTime: startOfToday + 7.hours,
                    endTime: startOfToday + 7.hours + 59.minutes + 30.seconds,
                    logoImageURL: nil),
            Program(id: "002",
                    title: "contentのない番組",
                    subtitle: "この番組にはcontentがないです。\nすごいですね",
                    content: nil,
                    startTime: startOfToday + 8.hours,
                    endTime: startOfToday + 9.hours + 30.minutes + 15.seconds,
                    logoImageURL: nil),
            Program(id: "003",
                    title: "長い番組",
                    subtitle: "この番組は縦にも横にも長いので、セルの表示が崩れないようにするのが大変だと思いますが頑張ってください。よろしくお願いします。よく考えたら番組一覧のAPIでは画像が変えることはありませんでした。\nすごいですね\n見づらいです",
                    content: "contentも長いです\n\n\n\n\n\n長いです",
                    startTime: startOfToday + 9.hours + 31.minutes,
                    endTime: startOfToday + 12.hours,
                    logoImageURL: nil),
        ]
        
        return Observable<Int>
            .timer(1.0, scheduler: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .map { _ in programs }
    }
}
