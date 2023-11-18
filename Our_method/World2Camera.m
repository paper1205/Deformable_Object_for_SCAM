% 世界坐标系到相机坐标系 World2Camera()
% 输入
% x_W，y_W，z_W：世界坐标系下坐标；k：相机编号
% 输出
% x_C，y_C，z_C：相机坐标系下坐标

function [x_C, y_C, z_C] = World2Camera(x_W, y_W, z_W, P, n)

% 全局变量
global camera_p;

x_C = - (cosd(P(2,n))*cosd(P(3,n)) - sind(P(1,n))*sind(P(2,n))*sind(P(3,n)))*(P(4,n) - x_W) - (cosd(P(3,n))*sind(P(2,n)) + cosd(P(2,n))*sind(P(1,n))*sind(P(3,n)))*(P(5,n) - y_W) - cosd(P(1,n))*sind(P(3,n))*(P(6,n) - z_W);
y_C = cosd(P(1,n))*cosd(P(3,n))*(P(6,n) - z_W) - (sind(P(2,n))*sind(P(3,n)) - cosd(P(2,n))*cosd(P(3,n))*sind(P(1,n)))*(P(5,n) - y_W) - (cosd(P(2,n))*sind(P(3,n)) + cosd(P(3,n))*sind(P(1,n))*sind(P(2,n)))*(P(4,n) - x_W);
z_C = sind(P(1,n))*(P(6,n) - z_W) - cosd(P(1,n))*cosd(P(2,n))*(P(5,n) - y_W) + cosd(P(1,n))*sind(P(2,n))*(P(4,n) - x_W);

end