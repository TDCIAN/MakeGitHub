import RxSwift

let disposeBag = DisposeBag()

// - PublishSubject
//    - 빈 상태로 시작하여 새로운 값만을 subscriber에 방출
print("--- publishSubject ---")
let publishSubject = PublishSubject<String>()

publishSubject.onNext("1. 여러분 안녕하세요?")

let subscriber1 = publishSubject
    .subscribe(onNext: {
        print("onNext: \($0)")
    })
    .disposed(by: disposeBag)
 
publishSubject.onNext("2. 들리세요?")
publishSubject.on(.next("3. 안들리시나요?"))

//subscriber1.dispose()

let subscriber2 = publishSubject
    .subscribe(onNext: {
        print("onNext: \($0)")
    })
    .disposed(by: disposeBag)

publishSubject.onNext("4. 여보세요")
publishSubject.onCompleted()

publishSubject.onNext("5. 끝났나요")

//subscriber2.dispose()

publishSubject
    .subscribe {
        print("세번째 구독: \($0.element)")
    }
    .disposed(by: disposeBag)

publishSubject.onNext("6. 찍힐까요?")

// - BehaviorSubject
//    - 하나의 초기값을 가진 상태로 시작하여, 새로운 subscriber에게 초기값 또는 최신값을 방출한다
print("---- behaviorSubject ----")
enum SubjectError:  Error {
    case error1
}

let behaviorSubject = BehaviorSubject<String>(value: "0. 초기값")

behaviorSubject.onNext("1. 첫번째값")

behaviorSubject.subscribe {
    print("첫번째 구독:", $0.element ?? $0)
}
.disposed(by: disposeBag)

behaviorSubject.onError(SubjectError.error1)

behaviorSubject.subscribe {
    print("두번째 구독:", $0.element ?? $0)
}
.disposed(by: disposeBag)


// - ReplaySubject
//    - 버퍼를 두고 초기화하며, 버퍼 사이즈 만큼의 값들을 유지하면서 새로운 subscriber에게 방출한다
print("---- replaySubject ----")
let replaySubject = ReplaySubject<String>.create(bufferSize: 2)

replaySubject.onNext("1. 여러분")
replaySubject.onNext("2. 힘내세요")
replaySubject.onNext("3. 어렵지만")

replaySubject.subscribe {
    print("첫번째 구독:", $0.element ?? $0)
}
.disposed(by: disposeBag)

replaySubject.subscribe {
    print("두번째 구독:", $0.element ?? $0)
}
.disposed(by: disposeBag)

replaySubject.onNext("4. 할수있어요.")
replaySubject.onError(SubjectError.error1)
replaySubject.dispose()

replaySubject.subscribe {
    print("세번째 구독:", $0.element ?? $0)
}
.disposed(by: disposeBag)
