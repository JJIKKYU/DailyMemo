//
//  DiaryWritingInteractor.swift
//  Menual
//
//  Created by 정진균 on 2022/01/09.
//

import RIBs
import RxSwift
import RealmSwift
import RxRelay

protocol DiaryWritingRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
    func attachBottomSheet(weatherModelOb: BehaviorRelay<WeatherModel?>, placeModelOb: BehaviorRelay<PlaceModel?>, bottomSheetType: MenualBottomSheetType)
    func detachBottomSheet()
    
    func attachDiaryTempSave()
    func detachDiaryTempSave()
}

protocol DiaryWritingPresentable: Presentable {
    var listener: DiaryWritingPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    func pressedBackBtn()
    func setWeatherView(model: WeatherModel)
    func setPlaceView(model: PlaceModel)
    
    // 다이어리 수정 모드로 변경
    func setDiaryEditMode(diaryModel: DiaryModel)
}

protocol DiaryWritingListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func diaryWritingPressedBackBtn()
}

protocol DiaryWritingInteractorDependency {
    var diaryRepository: DiaryRepository { get }
}

final class DiaryWritingInteractor: PresentableInteractor<DiaryWritingPresentable>, DiaryWritingInteractable, DiaryWritingPresentableListener {
    
    var weatherHistoryModel: BehaviorRelay<[WeatherHistoryModel]> {
        dependency.diaryRepository.weatherHistory
    }
    var plcaeHistoryModel: BehaviorRelay<[PlaceHistoryModel]> {
        dependency.diaryRepository.placeHistory
    }

    var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy
    
    weak var router: DiaryWritingRouting?
    weak var listener: DiaryWritingListener?
    
    private let dependency: DiaryWritingInteractorDependency
    private var disposebag: DisposeBag
    
    // - 미사용 시작
    
    // - 미사용 끝
    
    var weatherModelValue: WeatherModel {
        weatherModelRelay.value ?? WeatherModel(uuid: "", weather: nil, detailText: "")
    }
    
    var placeModelValue: PlaceModel {
        placeModelRelay.value ?? PlaceModel(uuid: "", place: nil, detailText: "")
    }
    
    private let weatherModelRelay = BehaviorRelay<WeatherModel?>(value: nil)
    private let placeModelRelay = BehaviorRelay<PlaceModel?>(value: nil)
    
    // 수정하기일 경우에는 내용을 세팅해야하기 때문에 릴레이에 작접 accept 해줌
    private let diaryModelRelay = BehaviorRelay<DiaryModel?>(value: nil)

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: DiaryWritingPresentable,
        dependency: DiaryWritingInteractorDependency,
        diaryModel: DiaryModel?
    ) {
        self.dependency = dependency
        self.disposebag = DisposeBag()
        presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
        if let diaryModel = diaryModel {
            self.diaryModelRelay.accept(diaryModel)
        }
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()

        bind()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func bind() {
        weatherModelRelay
            .subscribe(onNext: { [weak self] model in
                guard let self = self,
                      let model = model
                else { return }
                print("weatherModelRealy: model = \(model)")
                self.presenter.setWeatherView(model: model)
            })
            .disposed(by: disposebag)
        
        placeModelRelay
            .subscribe(onNext: { [weak self] model in
                guard let self = self,
                      let model = model
                else { return }
                print("placeModelRelay: model = \(model)")
                self.presenter.setPlaceView(model: model)
            })
            .disposed(by: disposebag)
        
        dependency.diaryRepository
            .weatherHistory
            .subscribe(onNext: { [weak self] model in
                guard let self = self else { return }
                print("DiaryWritingInteractor :: weatherHistory = \(model)")
            })
            .disposed(by: disposebag)
        
        dependency.diaryRepository
            .placeHistory
            .subscribe(onNext: { [weak self] model in
                guard let self = self else { return }
                print("DiaryWritingInteractor :: placeHistory = \(model)")
            })
            .disposed(by: disposebag)
        
        diaryModelRelay
            .subscribe(onNext: { [weak self] diaryModel in
                guard let self = self,
                      let diaryModel = diaryModel
                else { return }
                
                print("수정하기 모드로 바꿔야 할걸? = \(diaryModel)")
                self.presenter.setDiaryEditMode(diaryModel: diaryModel)
            })
            .disposed(by: disposebag)
    }
    
    func pressedBackBtn() {
        listener?.diaryWritingPressedBackBtn()
    }
    
    // 글 작성할 때
    func writeDiary(info: DiaryModel) {
        // print("DiaryWritingInteractor :: writeDiary! info = \(info)")
        
        let newDiaryModel = DiaryModel(uuid: info.uuid,
                                       pageNum: info.pageNum,
                                       title: info.title,
                                       weather: info.weather,
                                       place: info.place,
                                       description: info.description,
                                       image: info.image,
                                       readCount: info.readCount,
                                       createdAt: info.createdAt,
                                       replies: info.replies,
                                       isDeleted: info.isDeleted,
                                       isHide: info.isHide
        )
        
        dependency.diaryRepository
            .addDiary(info: newDiaryModel)
        
        // weather, place가 Optional이므로, 존재할 경우에만 History 저장
        if let place = placeModelValue.place {
            let placeHistoryModel = PlaceHistoryModel(uuid: NSUUID().uuidString,
                                                      selectedPlace: place,
                                                      info: placeModelValue.detailText,
                                                      createdAt: info.createdAt,
                                                      isDeleted: false
            )
            dependency.diaryRepository
                .addPlaceHistory(info: placeHistoryModel)
        }
        
        if let weather = weatherModelValue.weather {
            let weatherHistoryModel = WeatherHistoryModel(uuid: NSUUID().uuidString,
                                                          selectedWeather: weather,
                                                          info: weatherModelValue.detailText,
                                                          createdAt: info.createdAt,
                                                          isDeleted: false
            )
            dependency.diaryRepository
                .addWeatherHistory(info: weatherHistoryModel)
        }
        
        listener?.diaryWritingPressedBackBtn()
    }
    
    // 글 수정할 때
    func updateDiary(info: DiaryModel) {
        print("interactor! updateDiary!")

        // 수정하기 당시에 들어왔던 오리지널 메뉴얼
        guard let originalDiaryModel = diaryModelRelay.value else { return }

        let newDiaryModel = DiaryModel(uuid: originalDiaryModel.uuid,
                                       pageNum: originalDiaryModel.pageNum,
                                       title: info.title,
                                       weather: info.weather,
                                       place: info.place,
                                       description: info.description,
                                       image: info.image,
                                       readCount: originalDiaryModel.readCount,
                                       createdAt: originalDiaryModel.createdAt,
                                       replies: originalDiaryModel.replies,
                                       isDeleted: originalDiaryModel.isDeleted,
                                       isHide: originalDiaryModel.isHide
        )
        print("newDiaryModel = \(newDiaryModel)")
        
        dependency.diaryRepository
            .updateDiary(info: newDiaryModel)
        diaryModelRelay.accept(newDiaryModel)
    }
    
    func testSaveImage(imageName: String, image: UIImage) {
        print("testSaveImage")
        dependency.diaryRepository
            .saveImageToDocumentDirectory(imageName: imageName, image: image)
    }
    
    // MARK: - DiaryBottomSheet
    
    func pressedWeatherPlaceAddBtn(type: BottomSheetSelectViewType) {
        // 이미 선택한 경우에 다시 선택했다면 뷰를 세팅해주어야 하기 때문
        // switch로 진행한 이유는 첫 뷰 세팅을 위해서
        switch type {
        case .place:
            router?.attachBottomSheet(weatherModelOb: weatherModelRelay, placeModelOb: placeModelRelay, bottomSheetType: .place)
        case .weather:
            router?.attachBottomSheet(weatherModelOb: weatherModelRelay, placeModelOb: placeModelRelay, bottomSheetType: .weather)
        }
    }
    
    func diaryBottomSheetPressedCloseBtn() {
        print("diaryBottomSheetPressedCloseBtn")
        router?.detachBottomSheet()
    }
    
    // MARK: - diaryTempSave
    
    func pressedTempSaveBtn() {
        // router?.attachDiaryTempSave()
        pressedWeatherPlaceAddBtn(type: .place)
    }
    
    func diaryTempSavePressentBackBtn() {
        router?.detachDiaryTempSave()
    }
    
    // MARK: - 미사용
    func filterWithWeatherPlace(weatherArr: [Weather], placeArr: [Place]) { }
    func filterWithWeatherPlacePressedFilterBtn() { }
}
