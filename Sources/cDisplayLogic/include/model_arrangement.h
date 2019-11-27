#ifndef MODEL_ARRANGEMENT
#define MODEL_ARRANGEMENT

#include <stdlib.h>
#include <stdio.h>

//  Default of a glyth on the screen for computing approximate size of rects for display on the screen
#define GLYPH_SQR_PXL 30


/*
 * Rectangle for display on the screen
 */
typedef struct _rect {
    float x;
    float y;
    float width;
    float height;
} model_arrangement_rect;

/*
 * For queueing all rectangles in a set in order to do geometric calculations
 */
typedef struct _rect_node {
    model_arrangement_rect *rect;
    struct _rect_node *next;
} model_arrangement_rect_node;

model_arrangement_rect_node *model_arrangement_new_rect_node();
model_arrangement_rect_node *model_arrangement_new_rect_node() {
    model_arrangement_rect_node *ret = malloc(sizeof(model_arrangement_rect_node));
    ret->next = 0;
    ret->rect = malloc(sizeof(model_arrangement_rect));

    return ret;
}

/*
 * Compute appropriate width and height for the given string
 */
model_arrangement_rect *model_arrangement_computeRectDimensionsFor(char *name, int glyth_square_size);
model_arrangement_rect *model_arrangement_computeRectDimensionsFor(char *name, int glyth_square_size) {

    int length = 0;
    do {
        if(*(name + (++length)) == '\0' ){
            break;
        }
    } while(1);

    int glyphSize = glyth_square_size;
    if(glyth_square_size == 0) {
        glyphSize = GLYPH_SQR_PXL;
    }

    model_arrangement_rect *ret = malloc(sizeof(model_arrangement_rect));
    ret->height = (float)glyphSize;
    ret->width = (float)(length * glyphSize);

    return ret;

}

/*
 * Compute optimal arrangement of the given nodes
 */
void model_arrangement_ArrangeRectangles(model_arrangement_rect_node *listOfNodes);
void model_arrangement_ArrangeRectangles(model_arrangement_rect_node *listOfNodes) {

    if(listOfNodes == NULL) {
        fprintf(stderr, "Node list was null!\n");
        return;
    }

    model_arrangement_rect_node *currentNode = listOfNodes;
    model_arrangement_rect *rect;

    float xDist = 0.0;
    float yDist = 0.0;
    
    
    while (currentNode != NULL) {

        printf("Processing node...\n");

        rect = currentNode -> rect;
        if(rect == NULL) {
            fprintf(stderr, "Node has a NULL rect!\n");
        }

        printf("width=%f\n", rect->width);

        rect->x = xDist + 10.0;
        rect->y = yDist + 10.0;

        xDist += (rect->width)+10.0;

        currentNode = currentNode -> next;
    }

}

#endif