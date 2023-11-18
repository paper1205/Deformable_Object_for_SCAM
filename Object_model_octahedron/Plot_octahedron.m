%%Take a certain octahedron as an example，and how to display it 

clear
close all

%% Load object data and corner data

%% This data name is 'Pyramid_1',its dimension is 392*6
%% that is, the object has 392 feature point, each point has 6 dimensions (x,y,z,alpha,beta,gamma)
load('octahedron_model_1.mat'); 

%%  This data name is 'Pyramid_corner_1',its dimension is 392*9, 
%% Each feature point represents a triangle piece, and a triangle has three vertices (named A,B,C).
%% The three vertices coordinates of a triangle is 9 dimensions, 
%% A=Pyramid_corner_1(:,1:3);B=Pyramid_corner_1(:,4:6); C=Pyramid_corner_1(:,7:9);
load('octahedron_model_corner_1.mat');


%% Load the vertices of the deformable octahedron
%% This data name is 'Pyramid_vertex',its dimension is 9*3*16, 
%% That is, 9 vertices * coordinates(x,y,z) * pattern sequence
%% This object model has a total of 16 patterns
%% Note that thess vertices are to show the object boundaries, not the target point to be covered.
load('Set_Pyramid_vertex.mat');



%% Assign data to target object
target_object=Pyramid_1;
target_object_corner=Pyramid_corner_1;
target_object_vertex=Pyramid_vertex(:,:,1);
singleobject_num=length(Pyramid_1(:,1));


%% The unit of the object is m, we can change it to cm, and zoom in 100 times.
target_object(:,1:3)=100*target_object(:,1:3);
target_object_corner=100*target_object_corner;
target_object_vertex=100*target_object_vertex;

%% Given a length, as the length of the drawn direction
fa_norm_plot=10;


figure(1)
scatter3(0,0,0,'w*');
axis([-200 200 -200 200 0 150]);
axis equal
hold on

% draw object vertices and connect them
scatter3(target_object_vertex(1,1),target_object_vertex(1,2),target_object_vertex(1,3),'g*');
scatter3(target_object_vertex(2:5,1),target_object_vertex(2:5,2),target_object_vertex(2:5,3),'b*');
scatter3(target_object_vertex(6:9,1),target_object_vertex(6:9,2),target_object_vertex(6:9,3),'r*');

plot3([target_object_vertex(1,1),target_object_vertex(2,1)],[target_object_vertex(1,2),target_object_vertex(2,2)],[target_object_vertex(1,3),target_object_vertex(2,3)],'b-');
plot3([target_object_vertex(1,1),target_object_vertex(3,1)],[target_object_vertex(1,2),target_object_vertex(3,2)],[target_object_vertex(1,3),target_object_vertex(3,3)],'b-');
plot3([target_object_vertex(1,1),target_object_vertex(4,1)],[target_object_vertex(1,2),target_object_vertex(4,2)],[target_object_vertex(1,3),target_object_vertex(4,3)],'b-');
plot3([target_object_vertex(1,1),target_object_vertex(5,1)],[target_object_vertex(1,2),target_object_vertex(5,2)],[target_object_vertex(1,3),target_object_vertex(5,3)],'b-');

plot3([target_object_vertex(1,1),target_object_vertex(6,1)],[target_object_vertex(1,2),target_object_vertex(6,2)],[target_object_vertex(1,3),target_object_vertex(6,3)],'k-');
plot3([target_object_vertex(1,1),target_object_vertex(7,1)],[target_object_vertex(1,2),target_object_vertex(7,2)],[target_object_vertex(1,3),target_object_vertex(7,3)],'k-');
plot3([target_object_vertex(1,1),target_object_vertex(8,1)],[target_object_vertex(1,2),target_object_vertex(8,2)],[target_object_vertex(1,3),target_object_vertex(8,3)],'k-');
plot3([target_object_vertex(1,1),target_object_vertex(9,1)],[target_object_vertex(1,2),target_object_vertex(9,2)],[target_object_vertex(1,3),target_object_vertex(9,3)],'k-');

plot3([target_object_vertex(2,1) target_object_vertex(6,1)],[target_object_vertex(2,2) target_object_vertex(6,2)],[target_object_vertex(2,3) target_object_vertex(6,3)],'k-');
plot3([target_object_vertex(3,1) target_object_vertex(7,1)],[target_object_vertex(3,2) target_object_vertex(7,2)],[target_object_vertex(3,3) target_object_vertex(7,3)],'k-');
plot3([target_object_vertex(4,1) target_object_vertex(8,1)],[target_object_vertex(4,2) target_object_vertex(8,2)],[target_object_vertex(4,3) target_object_vertex(8,3)],'k-');
plot3([target_object_vertex(5,1) target_object_vertex(9,1)],[target_object_vertex(5,2) target_object_vertex(9,2)],[target_object_vertex(5,3) target_object_vertex(9,3)],'k-');

plot3([target_object_vertex(3,1) target_object_vertex(6,1)],[target_object_vertex(3,2) target_object_vertex(6,2)],[target_object_vertex(3,3) target_object_vertex(6,3)],'k-');
plot3([target_object_vertex(4,1) target_object_vertex(7,1)],[target_object_vertex(4,2) target_object_vertex(7,2)],[target_object_vertex(4,3) target_object_vertex(7,3)],'k-');
plot3([target_object_vertex(5,1) target_object_vertex(8,1)],[target_object_vertex(5,2) target_object_vertex(8,2)],[target_object_vertex(5,3) target_object_vertex(8,3)],'k-');
plot3([target_object_vertex(2,1) target_object_vertex(9,1)],[target_object_vertex(2,2) target_object_vertex(9,2)],[target_object_vertex(2,3) target_object_vertex(9,3)],'k-');

%% Draw a set of covering target points (feature points)
for k_sfp=1: singleobject_num
    quiver3(target_object(k_sfp,1),target_object(k_sfp,2),target_object(k_sfp,3),target_object(k_sfp,4)*fa_norm_plot,target_object(k_sfp,5)*fa_norm_plot,target_object(k_sfp,6)*fa_norm_plot,'LineWidth',1,'Color','b','MaxHeadSize',0.5);
    
    
    fill3([target_object_corner(k_sfp,1) target_object_corner(k_sfp,4) target_object_corner(k_sfp,7)],[target_object_corner(k_sfp,2) target_object_corner(k_sfp,5) target_object_corner(k_sfp,8)],[target_object_corner(k_sfp,3) target_object_corner(k_sfp,6) target_object_corner(k_sfp,9)],[72, 40, 54]/255,'FaceAlpha','0.15','EdgeAlpha','0');
 
end
hold off