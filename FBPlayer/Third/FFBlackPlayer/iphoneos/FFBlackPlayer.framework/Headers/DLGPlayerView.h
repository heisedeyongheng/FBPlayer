//
//  DLGPlayerView.h
//  DLGPlayer
//
//  Created by Liu Junqi on 05/12/2016.
//  Copyright © 2016 Liu Junqi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DLGPlayerRGBFragmentShader @"varying highp vec2 v_texcoord;uniform sampler2D s_texture;void main() {gl_FragColor = texture2D(s_texture, v_texcoord);}"
#define DLGPlayerVertexShader @"attribute vec4 position;attribute vec2 texcoord;uniform mat4 projection;varying vec2 v_texcoord;void main() {gl_Position = projection * position;v_texcoord = texcoord.xy;}"
#define DLGPlayerYUVFragmentShader @"varying highp vec2 v_texcoord;uniform sampler2D s_texture_y;uniform sampler2D s_texture_u;uniform sampler2D s_texture_v;void main() {highp float y = texture2D(s_texture_y, v_texcoord).r;highp float u = texture2D(s_texture_u, v_texcoord).r - 0.5;highp float v = texture2D(s_texture_v, v_texcoord).r - 0.5;highp float r = y + 1.402 * v;highp float g = y - 0.344 * u - 0.714 * v;highp float b = y + 1.772 * u;gl_FragColor = vec4(r, g, b, 1);}"

@class DLGPlayerVideoFrame;

@interface DLGPlayerView : UIView

@property (nonatomic) CGSize contentSize;
@property (nonatomic) BOOL isYUV;
@property (nonatomic) BOOL keepLastFrame;

- (void)render:(DLGPlayerVideoFrame *)frame;
- (void)clear;

@end
