#ifndef MODEL_ARRANGEMENT
#define MODEL_ARRANGEMENT

#include <stdlib.h>
#include <stdio.h>

//  Default of a glyth on the screen for computing approximate size of rects for display on the screen
#define GLYPH_WDT_PXL 30
#define GLYPH_HGT_PXL 40
#define MIN_DST_BW_RECT 10
#define PAD_FNT_BAK_LBL 10

/*
 * Configurations for how to go about creating a rectangle for a model
 */
typedef struct _model_rect_config {
    int glyphWidth;
    int glythHeight;

    /*
     * Min distance between boxes
     */ 
    int minHorizDistanceBetweenRects;

    int frontBackPaddingForLabel;

    int topBottomPaddingForLabel;
} model_rect_config;

/*
 * Rectangle for display on the screen
 */
typedef struct _rect {
    float x;
    float y;
    float width;
    float height;
    struct _rect *label_rect;   //  Rect for holding the text of a label contained in this rectangle
    model_rect_config *config;  //  Configuration for working with this rect
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
    ret->rect->label_rect = 0;
    ret->rect->config = 0;

    return ret;
}

model_rect_config *model_arrangement_model_rect_config_create();
model_rect_config *model_arrangement_model_rect_config_create() {
    model_rect_config *ret = malloc(sizeof(model_rect_config));
    
    ret->glyphWidth = GLYPH_WDT_PXL;
    ret->glythHeight = GLYPH_HGT_PXL;
    ret->minHorizDistanceBetweenRects = MIN_DST_BW_RECT;
    ret->frontBackPaddingForLabel = PAD_FNT_BAK_LBL;

    return ret;
}

model_rect_config model_arrangement_model_rect_config_destroy(model_rect_config *mrc);
model_rect_config model_arrangement_model_rect_config_destroy(model_rect_config *mrc) {
    free(mrc);
}

/*
 * Compute appropriate width and height for the given string
 */
model_arrangement_rect *model_arrangement_computeRectDimensionsFor(char *name, model_rect_config *config);
model_arrangement_rect *model_arrangement_computeRectDimensionsFor(char *name, model_rect_config *config) {

    int length = 0;
    do {
        if(*(name + (++length)) == '\0' ){
            break;
        }
    } while(1);

    int glyphWidth = config->glyphWidth;
    if(glyphWidth == 0) {
        glyphWidth = GLYPH_WDT_PXL;
    }
    int glyphHeight = config->glythHeight;
    if(glyphHeight == 0) {
        glyphHeight = GLYPH_HGT_PXL;
    }

    model_arrangement_rect *ret = malloc(sizeof(model_arrangement_rect));
    ret->height = (float)glyphHeight + config->topBottomPaddingForLabel;
    ret->width = (float)(length * glyphWidth) + config->frontBackPaddingForLabel;

    model_arrangement_rect *labelRect = malloc(sizeof(model_arrangement_rect));
    labelRect->width = (length * glyphWidth);
    labelRect->height = glyphHeight;
    ret -> label_rect = labelRect;
    ret -> config = config;

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

    float xDist = 0.0;  //  Current cursor position along X-axis
    float yDist = 0.0;  //  Current cursor position along Y-axis
    
    while (currentNode != NULL) {

        rect = currentNode -> rect;
        if(rect == NULL) {
            fprintf(stderr, "Node has a NULL rect!\n");
        }

        if(rect->config == NULL) {
            fprintf(stderr, "Rect has no config!\n");
        }

        int minDistanceHorizontal = rect->config->minHorizDistanceBetweenRects;

        rect->x = xDist + (double)minDistanceHorizontal;
        rect->y = yDist + 10.0;

        //  Now compute position of label if present
        if(rect -> label_rect != NULL) {

            model_arrangement_rect *labelRect = rect -> label_rect;
            float widthDifference = rect->config->frontBackPaddingForLabel * 0.5;

            float heightDifference = rect->height - labelRect -> height;
            //  TODO:  Make this configurable (see rect->config later on!)
            heightDifference /= 2;

            printf("wDiff=%f, hDiff=%f (parentW=%f, parentH=%f vs labelW=%f, labelH=%f)\n", widthDifference, heightDifference, rect->width, rect->height, 
                labelRect->width, labelRect->height
            );

            labelRect -> x = (rect->x + widthDifference);
            labelRect -> y = (rect->y + heightDifference);
        }

        xDist += (rect->width)+10.0;

        currentNode = currentNode -> next;
    }

}

#endif