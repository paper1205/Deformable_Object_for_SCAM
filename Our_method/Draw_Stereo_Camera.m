function Draw_Stereo_Camera(P, n)

global camera_p;
% global camera_p area n_sensor task iter model;

R_l = [1, 0, 0; 0, sind(camera_p.alpha_l), -cosd(camera_p.alpha_l); 0, cosd(camera_p.alpha_l), sind(camera_p.alpha_l)];
R_r = [1, 0, 0; 0, sind(camera_p.alpha_r), cosd(camera_p.alpha_r); 0, -cosd(camera_p.alpha_r), sind(camera_p.alpha_r)];
R = [cosd(P(3,n)),-sind(P(3,n)),0;sind(P(3,n)),cosd(P(3,n)),0;0,0,1]*[1,0,0;0,cosd(P(1,n)),-sind(P(1,n));0,sind(P(1,n)),cosd(P(1,n))]*[cosd(P(2,n)),0,sind(P(2,n));0,1,0;-sind(P(2,n)),0,cosd(P(2,n))]*[1,0,0;0,0,-1;0,1,0];
% 双目相机方向
p_c_r = (R^(-1))*[0; 0; 20]+[P(4,n);P(5,n);P(6,n)];  % 顶点坐标
% 左相机
p_cl_o = (R^(-1))*((R_l^(-1))*[0; 0; 0]+[0; -camera_p.PD/2; 0])+[P(4,n);P(5,n);P(6,n)];  % 顶点坐标
p_cl_r = (R^(-1))*((R_l^(-1))*[0; 0; 10]+[0; -camera_p.PD/2; 0])+[P(4,n);P(5,n);P(6,n)];  % 顶点方向
p_cl_F1 = (R^(-1))*((R_l^(-1))*[camera_p.d_Fl*tand(camera_p.angle_vl/2); camera_p.d_Fl*tand(camera_p.angle_ul/2); camera_p.d_Fl]+[0; -camera_p.PD/2; 0])+[P(4,n);P(5,n);P(6,n)];
p_cl_F2 = (R^(-1))*((R_l^(-1))*[-camera_p.d_Fl*tand(camera_p.angle_vl/2); camera_p.d_Fl*tand(camera_p.angle_ul/2); camera_p.d_Fl]+[0; -camera_p.PD/2; 0])+[P(4,n);P(5,n);P(6,n)];
p_cl_F3 = (R^(-1))*((R_l^(-1))*[-camera_p.d_Fl*tand(camera_p.angle_vl/2); -camera_p.d_Fl*tand(camera_p.angle_ul/2); camera_p.d_Fl]+[0; -camera_p.PD/2; 0])+[P(4,n);P(5,n);P(6,n)];
p_cl_F4 = (R^(-1))*((R_l^(-1))*[camera_p.d_Fl*tand(camera_p.angle_vl/2); -camera_p.d_Fl*tand(camera_p.angle_ul/2); camera_p.d_Fl]+[0; -camera_p.PD/2; 0])+[P(4,n);P(5,n);P(6,n)];
p_cl_F5 = (R^(-1))*((R_l^(-1))*[camera_p.d_Nl*tand(camera_p.angle_vl/2); camera_p.d_Nl*tand(camera_p.angle_ul/2); camera_p.d_Nl]+[0; -camera_p.PD/2; 0])+[P(4,n);P(5,n);P(6,n)];
p_cl_F6 = (R^(-1))*((R_l^(-1))*[-camera_p.d_Nl*tand(camera_p.angle_vl/2); camera_p.d_Nl*tand(camera_p.angle_ul/2); camera_p.d_Nl]+[0; -camera_p.PD/2; 0])+[P(4,n);P(5,n);P(6,n)];
p_cl_F7 = (R^(-1))*((R_l^(-1))*[-camera_p.d_Nl*tand(camera_p.angle_vl/2); -camera_p.d_Nl*tand(camera_p.angle_ul/2); camera_p.d_Nl]+[0; -camera_p.PD/2; 0])+[P(4,n);P(5,n);P(6,n)];
p_cl_F8 = (R^(-1))*((R_l^(-1))*[camera_p.d_Nl*tand(camera_p.angle_vl/2); -camera_p.d_Nl*tand(camera_p.angle_ul/2); camera_p.d_Nl]+[0; -camera_p.PD/2; 0])+[P(4,n);P(5,n);P(6,n)];

% 右相机
p_cr_o = (R^(-1))*((R_r^(-1))*[0; 0; 0]+[0; camera_p.PD/2; 0])+[P(4,n);P(5,n);P(6,n)];  % 顶点坐标
p_cr_r = (R^(-1))*((R_r^(-1))*[0; 0; 10]+[ 0; camera_p.PD/2; 0])+[P(4,n);P(5,n);P(6,n)];  % 顶点方向
p_cr_F1 = (R^(-1))*((R_r^(-1))*[camera_p.d_Fr*tand(camera_p.angle_vr/2); camera_p.d_Fr*tand(camera_p.angle_ur/2); camera_p.d_Fr]+[0; camera_p.PD/2; 0])+[P(4,n);P(5,n);P(6,n)];
p_cr_F2 = (R^(-1))*((R_r^(-1))*[-camera_p.d_Fr*tand(camera_p.angle_vr/2); camera_p.d_Fr*tand(camera_p.angle_ur/2); camera_p.d_Fr]+[0; camera_p.PD/2; 0])+[P(4,n);P(5,n);P(6,n)];
p_cr_F3 = (R^(-1))*((R_r^(-1))*[-camera_p.d_Fr*tand(camera_p.angle_vr/2); -camera_p.d_Fr*tand(camera_p.angle_ur/2); camera_p.d_Fr]+[0; camera_p.PD/2; 0])+[P(4,n);P(5,n);P(6,n)];
p_cr_F4 = (R^(-1))*((R_r^(-1))*[camera_p.d_Fr*tand(camera_p.angle_vr/2); -camera_p.d_Fr*tand(camera_p.angle_ur/2); camera_p.d_Fr]+[0; camera_p.PD/2; 0])+[P(4,n);P(5,n);P(6,n)];
p_cr_F5 = (R^(-1))*((R_r^(-1))*[camera_p.d_Nr*tand(camera_p.angle_vr/2); camera_p.d_Nr*tand(camera_p.angle_ur/2); camera_p.d_Nr]+[0; camera_p.PD/2; 0])+[P(4,n);P(5,n);P(6,n)];
p_cr_F6 = (R^(-1))*((R_r^(-1))*[-camera_p.d_Nr*tand(camera_p.angle_vr/2); camera_p.d_Nr*tand(camera_p.angle_ur/2); camera_p.d_Nr]+[0; camera_p.PD/2; 0])+[P(4,n);P(5,n);P(6,n)];
p_cr_F7 = (R^(-1))*((R_r^(-1))*[-camera_p.d_Nr*tand(camera_p.angle_vr/2); -camera_p.d_Nr*tand(camera_p.angle_ur/2); camera_p.d_Nr]+[0; camera_p.PD/2; 0])+[P(4,n);P(5,n);P(6,n)];
p_cr_F8 = (R^(-1))*((R_r^(-1))*[camera_p.d_Nr*tand(camera_p.angle_vr/2); -camera_p.d_Nr*tand(camera_p.angle_ur/2); camera_p.d_Nr]+[0; camera_p.PD/2; 0])+[P(4,n);P(5,n);P(6,n)];

% 左相机上色
fill3([p_cl_F1(1) p_cl_F2(1) p_cl_F5(1)],[p_cl_F1(2) p_cl_F2(2) p_cl_F5(2)],[p_cl_F1(3) p_cl_F2(3) p_cl_F5(3)],[230, 255, 204]/255,'FaceAlpha','0.15','EdgeAlpha','0');
fill3([p_cl_F6(1) p_cl_F2(1) p_cl_F5(1)],[p_cl_F6(2) p_cl_F2(2) p_cl_F5(2)],[p_cl_F6(3) p_cl_F2(3) p_cl_F5(3)],[230, 255, 204]/255,'FaceAlpha','0.15','EdgeAlpha','0');
fill3([p_cl_F2(1) p_cl_F3(1) p_cl_F6(1)],[p_cl_F2(2) p_cl_F3(2) p_cl_F6(2)],[p_cl_F2(3) p_cl_F3(3) p_cl_F6(3)],[230, 255, 204]/255,'FaceAlpha','0.15','EdgeAlpha','0');
fill3([p_cl_F7(1) p_cl_F3(1) p_cl_F6(1)],[p_cl_F7(2) p_cl_F3(2) p_cl_F6(2)],[p_cl_F7(3) p_cl_F3(3) p_cl_F6(3)],[230, 255, 204]/255,'FaceAlpha','0.15','EdgeAlpha','0');
fill3([p_cl_F3(1) p_cl_F4(1) p_cl_F7(1)],[p_cl_F3(2) p_cl_F4(2) p_cl_F7(2)],[p_cl_F3(3) p_cl_F4(3) p_cl_F7(3)],[230, 255, 204]/255,'FaceAlpha','0.15','EdgeAlpha','0');
fill3([p_cl_F8(1) p_cl_F4(1) p_cl_F7(1)],[p_cl_F8(2) p_cl_F4(2) p_cl_F7(2)],[p_cl_F8(3) p_cl_F4(3) p_cl_F7(3)],[230, 255, 204]/255,'FaceAlpha','0.15','EdgeAlpha','0');
fill3([p_cl_F4(1) p_cl_F1(1) p_cl_F8(1)],[p_cl_F4(2) p_cl_F1(2) p_cl_F8(2)],[p_cl_F4(3) p_cl_F1(3) p_cl_F8(3)],[230, 255, 204]/255,'FaceAlpha','0.15','EdgeAlpha','0');
fill3([p_cl_F5(1) p_cl_F1(1) p_cl_F8(1)],[p_cl_F5(2) p_cl_F1(2) p_cl_F8(2)],[p_cl_F5(3) p_cl_F1(3) p_cl_F8(3)],[230, 255, 204]/255,'FaceAlpha','0.15','EdgeAlpha','0');
fill3([p_cl_F5(1) p_cl_F7(1) p_cl_F8(1)],[p_cl_F5(2) p_cl_F7(2) p_cl_F8(2)],[p_cl_F5(3) p_cl_F7(3) p_cl_F8(3)],[230, 255, 204]/255,'FaceAlpha','0.15','EdgeAlpha','0');
fill3([p_cl_F5(1) p_cl_F7(1) p_cl_F6(1)],[p_cl_F5(2) p_cl_F7(2) p_cl_F6(2)],[p_cl_F5(3) p_cl_F7(3) p_cl_F6(3)],[230, 255, 204]/255,'FaceAlpha','0.15','EdgeAlpha','0');
fill3([p_cl_F1(1) p_cl_F2(1) p_cl_F3(1)],[p_cl_F1(2) p_cl_F2(2) p_cl_F3(2)],[p_cl_F1(3) p_cl_F2(3) p_cl_F3(3)],[230, 255, 204]/255,'FaceAlpha','0.15','EdgeAlpha','0');
fill3([p_cl_F1(1) p_cl_F4(1) p_cl_F3(1)],[p_cl_F1(2) p_cl_F4(2) p_cl_F3(2)],[p_cl_F1(3) p_cl_F4(3) p_cl_F3(3)],[230, 255, 204]/255,'FaceAlpha','0.15','EdgeAlpha','0');

% 右相机上色
fill3([p_cr_F1(1) p_cr_F2(1) p_cr_F5(1)],[p_cr_F1(2) p_cr_F2(2) p_cr_F5(2)],[p_cr_F1(3) p_cr_F2(3) p_cr_F5(3)],[204, 248, 255]/255,'FaceAlpha','0.15','EdgeAlpha','0');
fill3([p_cr_F6(1) p_cr_F2(1) p_cr_F5(1)],[p_cr_F6(2) p_cr_F2(2) p_cr_F5(2)],[p_cr_F6(3) p_cr_F2(3) p_cr_F5(3)],[204, 248, 255]/255,'FaceAlpha','0.15','EdgeAlpha','0');
fill3([p_cr_F2(1) p_cr_F3(1) p_cr_F6(1)],[p_cr_F2(2) p_cr_F3(2) p_cr_F6(2)],[p_cr_F2(3) p_cr_F3(3) p_cr_F6(3)],[204, 248, 255]/255,'FaceAlpha','0.15','EdgeAlpha','0');
fill3([p_cr_F7(1) p_cr_F3(1) p_cr_F6(1)],[p_cr_F7(2) p_cr_F3(2) p_cr_F6(2)],[p_cr_F7(3) p_cr_F3(3) p_cr_F6(3)],[204, 248, 255]/255,'FaceAlpha','0.15','EdgeAlpha','0');
fill3([p_cr_F3(1) p_cr_F4(1) p_cr_F7(1)],[p_cr_F3(2) p_cr_F4(2) p_cr_F7(2)],[p_cr_F3(3) p_cr_F4(3) p_cr_F7(3)],[204, 248, 255]/255,'FaceAlpha','0.15','EdgeAlpha','0');
fill3([p_cr_F8(1) p_cr_F4(1) p_cr_F7(1)],[p_cr_F8(2) p_cr_F4(2) p_cr_F7(2)],[p_cr_F8(3) p_cr_F4(3) p_cr_F7(3)],[204, 248, 255]/255,'FaceAlpha','0.15','EdgeAlpha','0');
fill3([p_cr_F4(1) p_cr_F1(1) p_cr_F8(1)],[p_cr_F4(2) p_cr_F1(2) p_cr_F8(2)],[p_cr_F4(3) p_cr_F1(3) p_cr_F8(3)],[204, 248, 255]/255,'FaceAlpha','0.15','EdgeAlpha','0');
fill3([p_cr_F5(1) p_cr_F1(1) p_cr_F8(1)],[p_cr_F5(2) p_cr_F1(2) p_cr_F8(2)],[p_cr_F5(3) p_cr_F1(3) p_cr_F8(3)],[204, 248, 255]/255,'FaceAlpha','0.15','EdgeAlpha','0');
fill3([p_cr_F5(1) p_cr_F7(1) p_cr_F8(1)],[p_cr_F5(2) p_cr_F7(2) p_cr_F8(2)],[p_cr_F5(3) p_cr_F7(3) p_cr_F8(3)],[204, 248, 255]/255,'FaceAlpha','0.15','EdgeAlpha','0');
fill3([p_cr_F5(1) p_cr_F7(1) p_cr_F6(1)],[p_cr_F5(2) p_cr_F7(2) p_cr_F6(2)],[p_cr_F5(3) p_cr_F7(3) p_cr_F6(3)],[204, 248, 255]/255,'FaceAlpha','0.15','EdgeAlpha','0');
fill3([p_cr_F1(1) p_cr_F2(1) p_cr_F3(1)],[p_cr_F1(2) p_cr_F2(2) p_cr_F3(2)],[p_cr_F1(3) p_cr_F2(3) p_cr_F3(3)],[204, 248, 255]/255,'FaceAlpha','0.15','EdgeAlpha','0');
fill3([p_cr_F1(1) p_cr_F4(1) p_cr_F3(1)],[p_cr_F1(2) p_cr_F4(2) p_cr_F3(2)],[p_cr_F1(3) p_cr_F4(3) p_cr_F3(3)],[204, 248, 255]/255,'FaceAlpha','0.15','EdgeAlpha','0');

% 左相机侧面虚线棱
plot3([p_cl_o(1) p_cl_F5(1)],[p_cl_o(2) p_cl_F5(2)],[p_cl_o(3) p_cl_F5(3)],'LineWidth',0.7,'Color',[113, 125, 126]/255,'LineStyle','--');
plot3([p_cl_o(1) p_cl_F6(1)],[p_cl_o(2) p_cl_F6(2)],[p_cl_o(3) p_cl_F6(3)],'LineWidth',0.7,'Color',[113, 125, 126]/255,'LineStyle','--');
plot3([p_cl_o(1) p_cl_F7(1)],[p_cl_o(2) p_cl_F7(2)],[p_cl_o(3) p_cl_F7(3)],'LineWidth',0.7,'Color',[113, 125, 126]/255,'LineStyle','--');
plot3([p_cl_o(1) p_cl_F8(1)],[p_cl_o(2) p_cl_F8(2)],[p_cl_o(3) p_cl_F8(3)],'LineWidth',0.7,'Color',[113, 125, 126]/255,'LineStyle','--');
% 左相机侧面实线棱
plot3([p_cl_F1(1) p_cl_F5(1)],[p_cl_F1(2) p_cl_F5(2)],[p_cl_F1(3) p_cl_F5(3)],'LineWidth',0.7,'Color',[0, 0, 0]/255,'LineStyle','-');
plot3([p_cl_F2(1) p_cl_F6(1)],[p_cl_F2(2) p_cl_F6(2)],[p_cl_F2(3) p_cl_F6(3)],'LineWidth',0.7,'Color',[0, 0, 0]/255,'LineStyle','-');
plot3([p_cl_F3(1) p_cl_F7(1)],[p_cl_F3(2) p_cl_F7(2)],[p_cl_F3(3) p_cl_F7(3)],'LineWidth',0.7,'Color',[0, 0, 0]/255,'LineStyle','-');
plot3([p_cl_F4(1) p_cl_F8(1)],[p_cl_F4(2) p_cl_F8(2)],[p_cl_F4(3) p_cl_F8(3)],'LineWidth',0.7,'Color',[0, 0, 0]/255,'LineStyle','-');
% 左相机近平面棱
plot3([p_cl_F5(1) p_cl_F6(1)],[p_cl_F5(2) p_cl_F6(2)],[p_cl_F5(3) p_cl_F6(3)],'LineWidth',0.7,'Color',[0, 0, 0]/255,'LineStyle','-');
plot3([p_cl_F6(1) p_cl_F7(1)],[p_cl_F6(2) p_cl_F7(2)],[p_cl_F6(3) p_cl_F7(3)],'LineWidth',0.7,'Color',[0, 0, 0]/255,'LineStyle','-');
plot3([p_cl_F7(1) p_cl_F8(1)],[p_cl_F7(2) p_cl_F8(2)],[p_cl_F7(3) p_cl_F8(3)],'LineWidth',0.7,'Color',[0, 0, 0]/255,'LineStyle','-');
plot3([p_cl_F8(1) p_cl_F5(1)],[p_cl_F8(2) p_cl_F5(2)],[p_cl_F8(3) p_cl_F5(3)],'LineWidth',0.7,'Color',[0, 0, 0]/255,'LineStyle','-');
% 左相机远平面棱
plot3([p_cl_F1(1) p_cl_F2(1)],[p_cl_F1(2) p_cl_F2(2)],[p_cl_F1(3) p_cl_F2(3)],'LineWidth',0.7,'Color',[0, 0, 0]/255,'LineStyle','-');
plot3([p_cl_F2(1) p_cl_F3(1)],[p_cl_F2(2) p_cl_F3(2)],[p_cl_F2(3) p_cl_F3(3)],'LineWidth',0.7,'Color',[0, 0, 0]/255,'LineStyle','-');
plot3([p_cl_F3(1) p_cl_F4(1)],[p_cl_F3(2) p_cl_F4(2)],[p_cl_F3(3) p_cl_F4(3)],'LineWidth',0.7,'Color',[0, 0, 0]/255,'LineStyle','-');
plot3([p_cl_F4(1) p_cl_F1(1)],[p_cl_F4(2) p_cl_F1(2)],[p_cl_F4(3) p_cl_F1(3)],'LineWidth',0.7,'Color',[0, 0, 0]/255,'LineStyle','-');

% 右相机侧面虚线棱
plot3([p_cr_o(1) p_cr_F5(1)],[p_cr_o(2) p_cr_F5(2)],[p_cr_o(3) p_cr_F5(3)],'LineWidth',0.7,'Color',[113, 125, 126]/255,'LineStyle','--');
plot3([p_cr_o(1) p_cr_F6(1)],[p_cr_o(2) p_cr_F6(2)],[p_cr_o(3) p_cr_F6(3)],'LineWidth',0.7,'Color',[113, 125, 126]/255,'LineStyle','--');
plot3([p_cr_o(1) p_cr_F7(1)],[p_cr_o(2) p_cr_F7(2)],[p_cr_o(3) p_cr_F7(3)],'LineWidth',0.7,'Color',[113, 125, 126]/255,'LineStyle','--');
plot3([p_cr_o(1) p_cr_F8(1)],[p_cr_o(2) p_cr_F8(2)],[p_cr_o(3) p_cr_F8(3)],'LineWidth',0.7,'Color',[113, 125, 126]/255,'LineStyle','--');
% 右相机侧面实线棱
plot3([p_cr_F1(1) p_cr_F5(1)],[p_cr_F1(2) p_cr_F5(2)],[p_cr_F1(3) p_cr_F5(3)],'LineWidth',0.7,'Color',[0, 0, 0]/255,'LineStyle','-');
plot3([p_cr_F2(1) p_cr_F6(1)],[p_cr_F2(2) p_cr_F6(2)],[p_cr_F2(3) p_cr_F6(3)],'LineWidth',0.7,'Color',[0, 0, 0]/255,'LineStyle','-');
plot3([p_cr_F3(1) p_cr_F7(1)],[p_cr_F3(2) p_cr_F7(2)],[p_cr_F3(3) p_cr_F7(3)],'LineWidth',0.7,'Color',[0, 0, 0]/255,'LineStyle','-');
plot3([p_cr_F4(1) p_cr_F8(1)],[p_cr_F4(2) p_cr_F8(2)],[p_cr_F4(3) p_cr_F8(3)],'LineWidth',0.7,'Color',[0, 0, 0]/255,'LineStyle','-');
% 右相机近平面棱
plot3([p_cr_F5(1) p_cr_F6(1)],[p_cr_F5(2) p_cr_F6(2)],[p_cr_F5(3) p_cr_F6(3)],'LineWidth',0.7,'Color',[0, 0, 0]/255,'LineStyle','-');
plot3([p_cr_F6(1) p_cr_F7(1)],[p_cr_F6(2) p_cr_F7(2)],[p_cr_F6(3) p_cr_F7(3)],'LineWidth',0.7,'Color',[0, 0, 0]/255,'LineStyle','-');
plot3([p_cr_F7(1) p_cr_F8(1)],[p_cr_F7(2) p_cr_F8(2)],[p_cr_F7(3) p_cr_F8(3)],'LineWidth',0.7,'Color',[0, 0, 0]/255,'LineStyle','-');
plot3([p_cr_F8(1) p_cr_F5(1)],[p_cr_F8(2) p_cr_F5(2)],[p_cr_F8(3) p_cr_F5(3)],'LineWidth',0.7,'Color',[0, 0, 0]/255,'LineStyle','-');
% 右相机远平面棱
plot3([p_cr_F1(1) p_cr_F2(1)],[p_cr_F1(2) p_cr_F2(2)],[p_cr_F1(3) p_cr_F2(3)],'LineWidth',0.7,'Color',[0, 0, 0]/255,'LineStyle','-');
plot3([p_cr_F2(1) p_cr_F3(1)],[p_cr_F2(2) p_cr_F3(2)],[p_cr_F2(3) p_cr_F3(3)],'LineWidth',0.7,'Color',[0, 0, 0]/255,'LineStyle','-');
plot3([p_cr_F3(1) p_cr_F4(1)],[p_cr_F3(2) p_cr_F4(2)],[p_cr_F3(3) p_cr_F4(3)],'LineWidth',0.7,'Color',[0, 0, 0]/255,'LineStyle','-');
plot3([p_cr_F4(1) p_cr_F1(1)],[p_cr_F4(2) p_cr_F1(2)],[p_cr_F4(3) p_cr_F1(3)],'LineWidth',0.7,'Color',[0, 0, 0]/255,'LineStyle','-');
% 基线
plot3([p_cl_o(1) p_cr_o(1)],[p_cl_o(2) p_cr_o(2)],[p_cl_o(3) p_cr_o(3)],'LineWidth',0.7,'Color',[0, 0, 0]/255,'LineStyle','-');

% 左相机顶点及方向
scatter3(p_cl_o(1),p_cl_o(2),p_cl_o(3),5,'filled','Marker','o','MarkerFaceColor','r','MarkerEdgeColor','r');
quiver3(p_cl_o(1),p_cl_o(2),p_cl_o(3),p_cl_r(1)-p_cl_o(1),p_cl_r(2)-p_cl_o(2),p_cl_r(3)-p_cl_o(3),'LineWidth',1,'Color','b','MaxHeadSize',0.5);
% 右相机顶点及方向
scatter3(p_cr_o(1),p_cr_o(2),p_cr_o(3),5,'filled','Marker','o','MarkerFaceColor','r','MarkerEdgeColor','r');
quiver3(p_cr_o(1),p_cr_o(2),p_cr_o(3),p_cr_r(1)-p_cr_o(1),p_cr_r(2)-p_cr_o(2),p_cr_r(3)-p_cr_o(3),'LineWidth',1,'Color','b','MaxHeadSize',0.5);
% 双目相机顶点及方向
scatter3(P(4,n),P(5,n),P(6,n),15,'filled','Marker','o','MarkerFaceColor','r','MarkerEdgeColor','r');
quiver3(P(4,n),P(5,n),P(6,n),p_c_r(1)-P(4,n),p_c_r(2)-P(5,n),p_c_r(3)-P(6,n),'LineWidth',1,'Color','r','MaxHeadSize',0.5);