import RxSwift

let disposeBag = DisposeBag()

print("--- ignoreElements ---") // -> onNext는 무시, onCompleted나 onError만 받음
let sleepMode = PublishSubject<String>()

sleepMode
    .ignoreElements()
    .subscribe { _ in
        print("Sun")
    }
    .disposed(by: disposeBag)

sleepMode.onNext("Alarm")
sleepMode.onNext("Alarm")
sleepMode.onNext("Alarm")

sleepMode.onCompleted()

print("--- elementAt ---") // -> 특정 인덱스만 받음
let twiceMan = PublishSubject<String>()

twiceMan
    .element(at: 2)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

twiceMan.onNext("1")
twiceMan.onNext("2")
twiceMan.onNext("3")
twiceMan.onNext("4")

print("--- filter ---")
Observable.of(1, 2, 3, 4, 5, 6, 7, 8)
    .filter { $0 % 2 == 0 }
    .subscribe(onNext: {
        print("onNext: \($0)")
    })
    .disposed(by: disposeBag)

print("--- skip ---")
Observable.of("1", "2", "3", "4", "5")
    .skip(2)
    .subscribe(onNext: {
        print("onNext: \($0)")
    })
    .disposed(by: disposeBag)

print("--- skipWhile ---")
Observable.of("1", "2", "3", "4", "5")
    .skip(while: {
        $0 != "3"
    })
    .subscribe(onNext: {
        print("onNext: \($0)")
    })
    .disposed(by: disposeBag)

print("--- skipUntil ---")
let guest = PublishSubject<String>()
let openTime = PublishSubject<String>()

guest
    .skip(until: openTime)
    .subscribe(onNext: {
        print("onNext: \($0)")
    })
    .disposed(by: disposeBag)

guest.onNext("1")
guest.onNext("2")

openTime.onNext("Open!")
guest.onNext("3")

print("--- take ---") // take와 skip은 서로 반대
Observable.of("1", "2", "3", "4", "5")
    .take(3)
    .subscribe(onNext: {
        print("onNext: \($0)")
    })
    .disposed(by: disposeBag)

print("--- takeWhile ---")
Observable.of("1", "2", "3", "4", "5")
    .take(while: {
        $0 != "3"
    })
    .subscribe(onNext: {
        print("onNext: \($0)")
    })
    .disposed(by: disposeBag)

print("--- enumerated ---")
Observable.of("1", "2", "3", "4", "5", "6")
    .enumerated()
    .takeWhile {
        $0.index < 3
    }
    .subscribe(onNext: {
        print("onNext: \($0)")
    })
    .disposed(by: disposeBag)

print("--- takeUntil ---")
let enroll = PublishSubject<String>()
let enrollEnded = PublishSubject<String>()

enroll
    .take(until: enrollEnded) // enrollEnded가 트리거 역할
    .subscribe(onNext: {
        print("onNext: \($0)")
    })
    .disposed(by: disposeBag)

enroll.onNext("1")
enroll.onNext("2")

enrollEnded.onNext("End!")
enroll.onNext("3")

print("--- distinctUntilChanged ---")
Observable.of("저는", "저는", "앵무새", "앵무새", "앵무새", "앵무새", "입니다", "입니다", "입니다", "저는", "앵무새", "일까요?", "일까요?")
    .distinctUntilChanged()
    .subscribe(onNext: {
        print("onNext: \($0)")
    })
    .disposed(by: disposeBag)
