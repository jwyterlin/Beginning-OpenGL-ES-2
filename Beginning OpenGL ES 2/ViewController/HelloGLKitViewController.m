//
//  HelloGLKitViewController.m
//  Beginning OpenGL ES 2
//
//  Created by Jhonathan Wyterlin on 10/05/15.
//  Copyright (c) 2015 Jhonathan Wyterlin. All rights reserved.
//

#import "HelloGLKitViewController.h"

@interface HelloGLKitViewController () {
    
    float _curRed;
    BOOL _increasing;
    GLuint _vertexBuffer;
    GLuint _indexBuffer;
    float _rotation;
    
}

@property(strong,nonatomic) EAGLContext *context;
@property(strong,nonatomic) GLKBaseEffect *effect;

@end

typedef struct {
    float Position[3];
    float Color[4];
} Vertex;

const Vertex Vertices[] = {
    {{1, -1, 0}, {1, 0, 0, 1}},
    {{1, 1, 0}, {0, 1, 0, 1}},
    {{-1, 1, 0}, {0, 0, 1, 1}},
    {{-1, -1, 0}, {0, 0, 0, 1}}
};

const GLubyte Indices[] = {
    0, 1, 2,
    2, 3, 0
};

@implementation HelloGLKitViewController

@synthesize context = _context;
@synthesize effect = _effect;

#pragma mark - View Lifecycle

-(void)setupGL {
    
    [EAGLContext setCurrentContext:self.context];
    self.effect = [[GLKBaseEffect alloc] init];
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(Vertices), Vertices, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(Indices), Indices, GL_STATIC_DRAW);
    
}

-(void)tearDownGL {
    
    [EAGLContext setCurrentContext:self.context];
    
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteBuffers(1, &_indexBuffer);
    
    self.effect = nil;
    
}

-(void)viewDidLoad {
 
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if ( ! self.context )
        NSLog( @"Failed to create ES context" );

    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    
    [self setupGL];

}

-(void)viewDidUnload {

    [super viewDidUnload];

    if ( [EAGLContext currentContext] == self.context )
        [EAGLContext setCurrentContext:nil];

    self.context = nil;

    [self tearDownGL];
    
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.paused = !self.paused;
}

#pragma mark - GLKViewDelegate

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    glClearColor(_curRed, 0.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
}

#pragma mark - GLKViewControllerDelegate

-(void)update {
 
    if (_increasing) {
        _curRed += 1.0 * self.timeSinceLastUpdate;
    } else {
        _curRed -= 1.0 * self.timeSinceLastUpdate;
    }
    
    if (_curRed >= 1.0) {
        _curRed = 1.0;
        _increasing = NO;
    }
    
    if (_curRed <= 0.0) {
        _curRed = 0.0;
        _increasing = YES;
    }
    
    float aspect = fabs( self.view.bounds.size.width / self.view.bounds.size.height );
    
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 4.0f, 10.0f);
    
    self.effect.transform.projectionMatrix = projectionMatrix;
    
    GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -6.0f);
    _rotation += 90 * self.timeSinceLastUpdate;
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(_rotation), 0, 0, 1);
    self.effect.transform.modelviewMatrix = modelViewMatrix;

}

@end
