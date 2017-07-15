import std.stdio;
import derelict.sdl2.sdl;
import derelict.sdl2.image;
import std.conv;

void main()
{
	DerelictSDL2.load();
	DerelictSDL2Image.load();

	//  padding around image in pixels
	int padding = 20;

	// Initialise SDL
	if (SDL_Init(SDL_INIT_VIDEO) != 0) {
		writeln("SDL_Init: ", SDL_GetError());
	}

	// Initialise IMG
	int flags = IMG_INIT_PNG | IMG_INIT_JPG;
	if ((IMG_Init(flags) & flags) != flags) {
		writeln("IMG_Init: ", to!string(IMG_GetError()));
	}

	// Load image
	SDL_Surface *imgSurf = IMG_Load("grumpy-cat.jpg");
	if (imgSurf is null) {
		writeln("IMG_Load: ", to!string(IMG_GetError()));
	}

	// Create a window
	SDL_Window* appWin = SDL_CreateWindow(
		"Example #1",
		SDL_WINDOWPOS_UNDEFINED,
		SDL_WINDOWPOS_UNDEFINED,
		imgSurf.w + padding * 2,
		imgSurf.h + padding * 2,
		SDL_WINDOW_OPENGL
	);
	if (appWin is null) {
		writefln("SDL_CreateWindow: ", SDL_GetError());
		return;
	}

	// Get the window surface
	SDL_Surface *winSurf = SDL_GetWindowSurface(appWin);
	if (winSurf is null) {
		writeln("SDL_GetWindowSurface: ", SDL_GetError());
	}

	// Define a colour for the surface, based on RGB values
	int colour = SDL_MapRGB(winSurf.format, 0xFF, 0xFF, 0xFF);

	// Fill the window surface with the colour
	SDL_FillRect(winSurf, null, colour);

	// Copy loaded image to window surface
	SDL_Rect dstRect;
	dstRect.x = padding;
	dstRect.y = padding;
	SDL_BlitSurface(imgSurf, null, winSurf, &dstRect);

	// Copy the window surface to the screen
	SDL_UpdateWindowSurface(appWin);

	// Polling for events
	SDL_Event event;
	bool quit = false;
	while(!quit) {
			while (SDL_PollEvent(&event)) {
				if (event.type == SDL_QUIT) {
					quit = true;
				}

				if (event.type == SDL_KEYDOWN) {
					quit = true;
				}
			}
	}

	// Close and destroy the window
	if (appWin !is null) {
		SDL_DestroyWindow(appWin);
	}

	// Tidy up
	IMG_Quit();
	SDL_Quit();
}
