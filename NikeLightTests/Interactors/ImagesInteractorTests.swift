//
//  ImagesInteractorTests.swift
//  UnitTests
//
//  Created by Slava Khlichkin on 21/04/2025.
//

import Combine
@testable import NikeLight
import Testing
import UIKit

@Suite struct ImagesInteractorTests {
    let sut: RealImagesInteractor
    let mockedWebRepository: MockedImageWebRepository
    let testImageURL = URL(string: "https://test.com/test.png")!
    let testImage = UIColor.red.image(CGSize(width: 40, height: 40))

    init() {
        mockedWebRepository = MockedImageWebRepository()
        sut = RealImagesInteractor(webRepository: mockedWebRepository)
    }

    func expectRepoActions(_ actions: [MockedImageWebRepository.Action]) {
        mockedWebRepository.actions = .init(expected: actions)
    }

    func verifyRepoActions(sourceLocation: SourceLocation = #_sourceLocation) {
        mockedWebRepository.verify(sourceLocation: sourceLocation)
    }

    @Test func loadImageNilURL() async throws {
        let state = BindingWithHistory(value: Loadable<UIImage>.notRequested)
        expectRepoActions([])
        sut.load(image: state.binding, url: nil)
        try await SuspendingClock().sleep(for: .seconds(0.5))
        #expect(state.history == [.notRequested, .notRequested])
        verifyRepoActions()
    }

    @Test func loadImageLoadedFromWeb() async throws {
        let state = BindingWithHistory(value: Loadable<UIImage>.notRequested)
        mockedWebRepository.imageResponses = [.success(testImage)]
        expectRepoActions([.loadImage(testImageURL)])
        sut.load(image: state.binding, url: testImageURL)
        try await SuspendingClock().sleep(for: .seconds(0.5))
        #expect(state.history == [
            .notRequested,
            .isLoading(last: nil, cancelBag: .test),
            .loaded(testImage)
        ])
        verifyRepoActions()
    }

    @Test func loadImageFailed() async throws {
        let state = BindingWithHistory(value: Loadable<UIImage>.notRequested)
        let error = NSError.test
        mockedWebRepository.imageResponses = [.failure(error)]
        expectRepoActions([.loadImage(testImageURL)])
        sut.load(image: state.binding, url: testImageURL)
        try await SuspendingClock().sleep(for: .seconds(0.5))
        #expect(state.history == [
            .notRequested,
            .isLoading(last: nil, cancelBag: .test),
            .failed(error)
        ])
        verifyRepoActions()
    }

    @Test func loadImageHadLoadedImage() async throws {
        let state = BindingWithHistory(value: Loadable<UIImage>.loaded(testImage))
        let error = NSError.test
        mockedWebRepository.imageResponses = [.failure(error)]
        expectRepoActions([.loadImage(testImageURL)])
        sut.load(image: state.binding, url: testImageURL)
        try await SuspendingClock().sleep(for: .seconds(0.5))
        #expect(state.history == [
            .loaded(self.testImage),
            .isLoading(last: self.testImage, cancelBag: .test),
            .failed(error)
        ])
        verifyRepoActions()
    }

    @Test func stubInteractor() async throws {
        let sut = StubImagesInteractor()
        let state = BindingWithHistory(value: Loadable<UIImage>.notRequested)
        sut.load(image: state.binding, url: testImageURL)
        try await SuspendingClock().sleep(for: .seconds(0.5))
        #expect(state.history == [.notRequested])
        verifyRepoActions()
    }
}
