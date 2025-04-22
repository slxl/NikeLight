# NikeLight iOS App

## Architecture

The app uses Clean Architecture as the design pattern. It was chosen intentionally as a way to practice and explore the architecture since I've never worked with it in a production environment before.

### Main Layers

- Entities: Core business objects, such as products and cart items.

- Interactors: Application-specific business logic for handling data retrieval, cart management, and payment processing.

- Repositories: Data access layers that abstract how data is fetched (e.g., from the network or local storage).

- Views: SwiftUI-based UI elements that display the data

- Dependency Injection is handled via AppEnvironment, which initializes and wires all components such as repositories, interactors, and system event handlers.

## Business structure

I've followed up the requirements and app essentially has all the necessary parts:

- Product List: Displays a list of products from the Fake Store API.

- Product Details: Shows detailed product info and allows adding to cart.

- Cart: you can view products, remove them and adjust quantity. Cart is persisted across launches using SwiftData. This view also has checkout done: app simulates a checkout process with polling. Handles both timeout and success states.

## Key features

- Clean Architecture: Clear separation of concerns and modularity.

- Dependency Injection: Managed via AppEnvironment, ensuring decoupling and testability.

- SwiftData Persistence: local storage that keeps cart persistent in between app launches.

- Caching mechanism - images are being cached for better networking efficency.

- Polling Mechanism: Simulates async backend checkout operation. I don't really get the idea of having a polling mechanism there but at the time of implementation it was too late to ask (weekend/Easter holidays).

- SwiftLint for coding style consistenency across the different files

## Enhancements and known downsides

Some areas for potential improvement:

- Navigation and routing is implemented via SwiftUI build in mechanism (NavigationStack / NavigationLink). For bigger app and more complicated scenarios (like deeplinking or non-linear navigation) and for better separation of concerns its better to use some kind of external routing mechanism.  

- Cart Badge: Display the number of cart items in the tab bar icon.

- Better Transitions: Use matchedGeometryEffect or similar for smoother view transitions and wow-factor.

- Improved Error Messaging: Provide clearer, contextual messages with retry options.

- Business Logic in Views: Some views currently contain business logic that should be extracted into presenters or view models for better separation of concerns.

- Unit tests been implemented via SwiftTests that I've been using for the first time either.

- No UI Testing: UI tests are not yet implemented.

## AI usage

Im actively using AI in my day to day professional life. Key scenarios for me: 

- Writing large chunks of dummy data (mocks/stubs etc)

- Writing a function/class documentation. Its just fast and easy way to explain what's going on inside of the fuction, while its only required for complex/non-obvious solutions. 

- Drafting the code skeleton which I can iteratively improve later myself according to my ideas. General rule - I'm using AI at the beginning where write a simple query and get a results is faster then writing code myself. And somewhere until the point where I'd better code myself rather than try to explain AI exactly what I need. 

Although professional usage must be always regulated by the company policy (like using only internal company's model to avoid data breaches and other limitations.  


## Final Thoughts

Generally, I like the result and it looks really Nikey =)

## Screenshots

![Product list](/Images/nike-light-1.png)
![Product Details](/Images/nike-light-2.png)
![Cart View](/Images/nike-light-3.png)
