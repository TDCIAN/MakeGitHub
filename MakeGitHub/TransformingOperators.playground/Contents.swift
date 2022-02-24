import RxSwift

let disposeBag = DisposeBag()

print("--- toArray ---")
Observable.of("A", "B", "C")
    .toArray()
    .subscribe(onSuccess: {
//    .subscribe(onNext: {
        print("onSuccess: \($0)")
    })
    .disposed(by: disposeBag)

print("--- map ---")
Observable.of(Date())
    .map { date -> String in
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: date)
    }
    .subscribe(onNext: {
        print("onNext: \($0)")
    })
    .disposed(by: disposeBag)

print("--- flatMap ---")
protocol player {
    var score: BehaviorSubject<Int> { get }
}

struct archer: player {
    var score: BehaviorSubject<Int>
}

let korean = archer(score: BehaviorSubject<Int>(value: 10))
let american = archer(score: BehaviorSubject<Int>(value: 8))

let olympicMatch = PublishSubject<player>()

olympicMatch
    .flatMap { player in
        player.score
    }
    .subscribe(onNext: {
        print("onNext:", $0)
    })
    .disposed(by: disposeBag)

olympicMatch.onNext(korean)
korean.score.onNext(10)

olympicMatch.onNext(american)
american.score.onNext(8)

print("--- flatMapLatest ---")
struct jumpPlayer: player {
    var score: BehaviorSubject<Int>
}

let seoul = jumpPlayer(score: BehaviorSubject<Int>(value: 7))
let jeju = jumpPlayer(score: BehaviorSubject<Int>(value: 6))

let nationalCompetition = PublishSubject<player>()

nationalCompetition
    .flatMapLatest { player in
        player.score
    }
    .subscribe(onNext: {
        print("onNext: \($0)")
    })
    .disposed(by: disposeBag)

nationalCompetition.onNext(seoul)
seoul.score.onNext(9)

nationalCompetition.onNext(jeju)
seoul.score.onNext(10)
jeju.score.onNext(8)

print("--- materialize and dematerialize ---")
enum Foul: Error {
    case falseStart
}

struct runner: player {
    var score: BehaviorSubject<Int>
}

let rabitKim = runner(score: BehaviorSubject<Int>(value: 0))
let cheetahPark = runner(score: BehaviorSubject<Int>(value: 1))

let run100M = BehaviorSubject<player>(value: rabitKim)

run100M
    .flatMapLatest { player in
        player.score
            .materialize()
    }
    .filter {
        guard let error = $0.error else { return true }
        print("filter - error: \(error)")
        return false
    }
    .dematerialize()
    .subscribe(onNext: {
        print("onNext: \($0)")
    })
    .disposed(by: disposeBag)

rabitKim.score.onNext(1)
rabitKim.score.onError(Foul.falseStart)
rabitKim.score.onNext(2)

run100M.onNext(cheetahPark)

print("--- phoneNumber ---")
let input = PublishSubject<Int?>()

let list: [Int] = [1]

input
    .flatMap {
        $0 == nil ? Observable.empty() : Observable.just($0)
    }
    .map { $0! }
    .skip(while: { $0 != 0 })
    .take(11)
    .toArray()
    .asObservable()
    .map {
        $0.map { "\($0)"}
    }
    .map { numbers in
        var numberList = numbers
        numberList.insert("-", at: 3)
        numberList.insert("-", at: 8)
        let number = numberList.reduce(" ", +)
        return number
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

input.onNext(10)
input.onNext(0)
input.onNext(nil)
input.onNext(1)
input.onNext(0)
input.onNext(4)
input.onNext(3)
input.onNext(nil)
input.onNext(1)
input.onNext(8)
input.onNext(9)
input.onNext(4)
input.onNext(9)
input.onNext(1)
