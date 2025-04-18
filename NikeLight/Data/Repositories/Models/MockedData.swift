//
//  MockedData.swift
//  NikeLight
//
//  Created by Slava Khlichkin on 18/04/2025.
//

import Foundation

#if DEBUG

@MainActor
extension ApiModel.Product {
    static let mockedProducts: [ApiModel.Product] = [
        ApiModel.Product(
            id: 1,
            title: "Nike Air Max 270",
            price: 149.99,
            description: "Breathable mesh upper with Max Air unit for comfort.",
            image: "https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco/c27adfb1-347d-40a3-889c-d73857d0ab83/air-max-270-mens-shoes-KkLcGR.png"
        ),
        ApiModel.Product(
            id: 2,
            title: "Nike Air Force 1 '07",
            price: 109.99,
            description: "Classic design with bold street style and durability.",
            image: "https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco/1f7c1825-d700-4a56-90e1-3762e8b63d0e/air-force-1-07-mens-shoes-WrLlWX.png"
        ),
        ApiModel.Product(
            id: 3,
            title: "Nike Dunk Low",
            price: 119.99,
            description: "Retro basketball-inspired silhouette in fresh colorways.",
            image: "https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco/97fdc62b-51e5-4c4f-9689-13b281502f87/dunk-low-retro-mens-shoes-87q0hf.png"
        ),
        ApiModel.Product(
            id: 4,
            title: "Nike Blazer Mid '77",
            price: 99.99,
            description: "Vintage mid-top sneaker with suede overlays and old-school vibes.",
            image: "https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco/2820b4b5-f84a-4a56-9ff2-d9d496c82cb3/blazer-mid-77-vintage-shoes-MSZ5z8.png"
        ),
        ApiModel.Product(
            id: 5,
            title: "Nike React Infinity Run Flyknit 3",
            price: 159.99,
            description: "High-cushion performance running shoes built to reduce injuries.",
            image: "https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco/04653f47-4e38-4780-85b8-1f2e3872b63d/react-infinity-run-flyknit-3-mens-road-running-shoes-kqHflP.png"
        ),
        ApiModel.Product(
            id: 6,
            title: "Nike Pegasus 40",
            price: 139.99,
            description: "Versatile daily trainer with responsive cushioning.",
            image: "https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco/2c5cc048-9ba6-44cb-b94d-17adf891bd17/pegasus-40-mens-road-running-shoes-j0BLVx.png"
        ),
        ApiModel.Product(
            id: 7,
            title: "Nike Air Zoom Alphafly NEXT% 3",
            price: 274.99,
            description: "Elite racing shoe with carbon plate and ZoomX foam.",
            image: "https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco/babdb489-d66a-4bc1-b336-8410c134d6f0/alphafly-3-mens-road-racing-shoes-McWgsp.png"
        ),
        ApiModel.Product(
            id: 8,
            title: "Nike SB Chron 2",
            price: 74.99,
            description: "Skateboarding shoe with updated fit and classic look.",
            image: "https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco/2e27e763-f03d-4789-bdf2-f90f1c5d7388/sb-chron-2-skate-shoes-VtvRmw.png"
        ),
        ApiModel.Product(
            id: 9,
            title: "Nike Waffle One",
            price: 99.99,
            description: "Lifestyle sneaker blending heritage with modern vibes.",
            image: "https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco/5cc4ea0e-d3f4-43fd-bbb8-755d0c1980e4/waffle-one-mens-shoes-3kZKn1.png"
        ),
        ApiModel.Product(
            id: 10,
            title: "Nike Free RN 5.0",
            price: 99.99,
            description: "Lightweight running shoe that mimics barefoot feel.",
            image: "https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco/2cd1f9e5-68fd-4f97-b12e-0595f0df4e3d/free-rn-5-mens-road-running-shoes-7ZP3ZX.png"
        )
    ]
}

#endif
