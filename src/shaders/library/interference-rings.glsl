// name: INTERFERENCE RINGS
// category: light
// ported from prism-video-synth
void main(){vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;float t=u_time*u_speed;vec2 p=uv*u_scale;float amp=0.0;for(int i=0;i<3;i++){float fi=float(i);vec2 c=0.45*vec2(cos(t*(0.4+fi*0.13)+fi*2.094),sin(t*(0.3+fi*0.11)+fi*2.094));amp+=sin(length(p-c)*42.0-t*4.0);}float I=amp*amp/9.0;vec3 col=(0.5+0.5*cos(6.28318*(amp*0.12+t*0.05+vec3(0.0,0.33,0.67))))*I;col+=vec3(1.0)*pow(I,3.0)*0.4;col+=vec3(0.03,0.02,0.08);outColor=vec4(col*u_intensity,1.0);}
