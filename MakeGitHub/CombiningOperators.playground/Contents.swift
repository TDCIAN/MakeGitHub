import RxSwift

let disposeBag = DisposeBag()

print("--- startWith ---")
let yellow = Observable.of("yello1", "yello2", "yello3")

yellow
    .enumerated()
    .map { index, element in
        return element + "어린이" + "\(index)"
    }
    .startWith("teacher")
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("--- concat1 ---")
let blue = Observable<String>.of("blue1", "blue2", "blue3")
let blueTeacher = Observable<String>.of("teacher")

let walkInLine = Observable
//    .concat([blueTeacher, blue])
    .concat([blue, blueTeacher])

walkInLine
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("--- concat2 ---")
blueTeacher
    .concat(blue)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("--- concatMap ---")
let kinderGarten: [String: Observable<String>] = [
    "yellow": Observable.of("yellow1", "yellow2", "yellow3"),
    "blue": Observable.of("blue1", "blue2")
]

Observable.of("yellow", "blue")
    .concatMap { ban in
        kinderGarten[ban] ?? .empty()
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("--- merge1 ---")
let gangBook = Observable.from(["gangBookGoo", "SeongBookGoo", "DongDaeMoonGu", "JongNoGoo"])
let gangNam = Observable.from(["gangNamGoo", "GangDongGoo", "YeongDeungPoGu", "YangCheonGoo"])

Observable.of(gangBook, gangNam)
    .merge()
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("--- merge2 ---")
Observable.of(gangBook, gangNam)
    .merge(maxConcurrent: 1)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("--- combineLatest1 ---")
let lastName = PublishSubject<String>()
let firstName = PublishSubject<String>()

let fullName = Observable
    .combineLatest(lastName, firstName) { last ,first in
        last + first
    }

fullName
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

lastName.onNext("김")
firstName.onNext("똘똘")
firstName.onNext("영수")
firstName.onNext("은영")
lastName.onNext("박")
lastName.onNext("이")
lastName.onNext("조")

print("--- combineLatest2 ---")
let dateFormat = Observable<DateFormatter.Style>.of(.short, .long)
let currentDate = Observable<Date>.of(Date())

let displayCurrentDate = Observable
    .combineLatest(
        dateFormat,
        currentDate,
        resultSelector: { format, date -> String in
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = format
            return dateFormatter.string(from: date)
        }
    )

displayCurrentDate
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("--- zip ---")
enum 승패 {
    case 승
    case 패
}

let 승부 = Observable<승패>.of(.승, .승, .패, .승, .패)
let 선수 = Observable<String>.of("Korea", "Swiss", "America", "Brazil", "Japan", "China")

let result = Observable
    .zip(승부, 선수) { 결과, 대표선수 in
        return 대표선수 + "선수" + " \(결과)"
    }

result
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
