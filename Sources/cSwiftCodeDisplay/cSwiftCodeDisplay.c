#include <SDL2/SDL.h>
#include <stdio.h>

const int CODE_DISPLAY_SCREEN_WIDTH = 800;
const int CODE_DISPLAY_SCREEN_HEIGHT = 600;

int main(int argc, char const *argv[])
{
    
    //  SDL Setup
    if(SDL_Init(SDL_INIT_VIDEO) < 0){
        fprintf(stderr, "Failed to initialize SDL!\n");
    }

    //  Create window to show everything in
    SDL_Window *window = SDL_CreateWindow("Code Display", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, CODE_DISPLAY_SCREEN_WIDTH, CODE_DISPLAY_SCREEN_HEIGHT, SDL_WINDOW_SHOWN);
    if(window == NULL) {
        fprintf(stderr, "Failed to create window!\n");
    }

    //  Set up rendering
    SDL_Renderer *renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);

    SDL_Delay(1000);

    return 0;
}
