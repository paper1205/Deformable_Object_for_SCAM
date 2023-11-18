% ��������ϵ���������ϵ World2Camera()
% ����
% x_W��y_W��z_W����������ϵ�����ꣻk��������
% ���
% x_C��y_C��z_C���������ϵ������

function [x_C, y_C, z_C] = World2Camera(x_W, y_W, z_W, P, n)

% ȫ�ֱ���
global camera_p;

x_C = - (cosd(P(2,n))*cosd(P(3,n)) - sind(P(1,n))*sind(P(2,n))*sind(P(3,n)))*(P(4,n) - x_W) - (cosd(P(3,n))*sind(P(2,n)) + cosd(P(2,n))*sind(P(1,n))*sind(P(3,n)))*(P(5,n) - y_W) - cosd(P(1,n))*sind(P(3,n))*(P(6,n) - z_W);
y_C = cosd(P(1,n))*cosd(P(3,n))*(P(6,n) - z_W) - (sind(P(2,n))*sind(P(3,n)) - cosd(P(2,n))*cosd(P(3,n))*sind(P(1,n)))*(P(5,n) - y_W) - (cosd(P(2,n))*sind(P(3,n)) + cosd(P(3,n))*sind(P(1,n))*sind(P(2,n)))*(P(4,n) - x_W);
z_C = sind(P(1,n))*(P(6,n) - z_W) - cosd(P(1,n))*cosd(P(2,n))*(P(5,n) - y_W) + cosd(P(1,n))*sind(P(2,n))*(P(4,n) - x_W);

end