import RxSwift

let disposeBag = DisposeBag()

enum TraitsError: Error {
    case single
    case maybe
    case completable
}

print("---- single1 ----")
Single<String>.just("✅")
    .subscribe(
        onSuccess: {
            print("onSuccess: \($0)")
        },
        onFailure: {
            print("onFailure: \($0)")
        },
        onDisposed: {
            print("disposed")
        }
    )
    .disposed(by: disposeBag)

print("---- single2 ----")
//Observable<String>.just("✅")
Observable<String>
    .create { observer -> Disposable in
        observer.onError(TraitsError.single)
        return Disposables.create()
    }
    .asSingle()
    .subscribe(
        onSuccess: {
            print("onSuccess: \($0)")
        },
        onFailure: {
            print("onFailure: \($0.localizedDescription)")
        },
        onDisposed: {
            print("disposed")
        }
    )

print("---- single 3 ----")
struct SomeJSON: Decodable {
    let name: String
}

enum JSONError: Error {
    case decodingError
}

let json1 = """
    {"name": "park"}
    """

let json2 = """
    {"my_name": "young"}
    """

func decode(json: String) -> Single<SomeJSON> {
    Single<SomeJSON>.create { observer -> Disposable in
        guard let data = json.data(using: .utf8),
              let json = try? JSONDecoder().decode(SomeJSON.self, from: data) else {
                  observer(.failure(JSONError.decodingError))
                  return Disposables.create()
              }
        
        observer(.success(json))
        return Disposables.create()
    }
}

decode(json: json1)
    .subscribe {
        switch $0 {
        case .success(let json):
            print("json1 success: \(json.name)")
        case .failure(let error):
            print("json1 error: \(error.localizedDescription)")
        }
    }
    .disposed(by: disposeBag)

decode(json: json2)
    .subscribe {
        switch $0 {
        case .success(let json):
            print("json2 success: \(json.name)")
        case .failure(let error):
            print("json2 error: \(error.localizedDescription)")
        }
    }
    .disposed(by: disposeBag)

print("---- maybe 1 ----") // maybe는 single과 다르게 onSuccess, onError 말고 onCompleted가 더 있다
Maybe<String>.just("✅")
    .subscribe(
        onSuccess: {
            print("onSuccess: \($0)")
        },
        onError: {
            print("onError: \($0)")
        },
        onCompleted: {
            print("completed")
        },
        onDisposed: {
            print("disposed")
        }
    )
    .disposed(by: disposeBag)

print("---- maybe 2 ----")
Observable<String>.create { observer -> Disposable in
    observer.onError(TraitsError.maybe)
    return Disposables.create()
}
.asMaybe()
.subscribe(
    onSuccess: {
        print("onSuccess: \($0)")
    },
    onError: {
        print("onError: \($0)")
    },
    onCompleted: {
        print("completed")
    },
    onDisposed: {
        print("disposed")
    }
)
.disposed(by: disposeBag)

print("---- completable ----")
Completable.create { observer -> Disposable in
    observer(.error(TraitsError.completable))
    return Disposables.create()
}
.subscribe(
    onCompleted: {
        print("onCompleted")
    },
    onError: {
        print("onError: \($0)")
    },
    onDisposed: {
        print("disposed")
    }
)
.disposed(by: disposeBag)

print("---- completable2 ----")
Completable.create { observer -> Disposable in
    observer(.completed)
    return Disposables.create()
}
.subscribe {
    print("subscribe: \($0)")
}
.disposed(by: disposeBag)
