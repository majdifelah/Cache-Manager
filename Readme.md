#PixabaySearchImage

- There are two cache managers created, one for requests and other for the images.
- You should manage whether to load an image from the in-memory cache or the disk cache. The disk cache will persist between launches."
- API returns a lot of data but I have only displayed the image, with the retrieved height/width aspect ratio. All the table view cells have different height according to the aspect ratio of the image.
- The cache retrieval complexity is O(1), as there are no loops involved.
- Pixabay API URL is stuffed statically in the project. In an ideal world, I would have created an Endpoint class which would have taken care of the API endpoint details.

- This project is built with XCode 11.4, targeting iOS 13.4. It supports all orientations.
