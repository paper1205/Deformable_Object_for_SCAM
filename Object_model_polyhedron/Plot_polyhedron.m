%%Take a certain poly as an example，and how to display it 

clear
close all
%% Load object data and corner data

%% This data name is 'Object_1',its dimension is 224*6
%% that is, the object has 224 feature point, each point has 6 dimensions (x,y,z,alpha,beta,gamma)
load('polyhedron_model_1.mat'); 

%%  This data name is 'Object_corner_1',its dimension is 224*12, 
%% Each feature point represents a square area, and a square has 4 vertices (named A,B,C,D).
%% A=Object_corner_1(:,1:3),B=Object_corner_1(:,4:6);C=Object_corner_1(:,7:9);D=Object_corner_1(:,10:12);
load('polyhedron_model_corner_1.mat');


%% Load some scene data for plotting
%% Note that these data are not the target points to be covered and mapped.
load('Segment_vertice_all_deforms.mat');%% This data name is 'Segment_vertice_defor',its dimension is 32*2*12, 
load('motor_position_NSEW_deforms.mat');%% This data name is 'motor_position_NSEW',its dimension is 12*4,

%% Other data for plotting
center_z=91;
center_object=[0,0,center_z];%% top center point 
Length=10;%%Each face is 10cm wide
%The movable length of rod is 28-50cm
motor_move_max=50; 
motor_move_min=28;
Deform_Times=11; %% deformation times
Num_Patterns=Deform_Times+1; %% deformation patterns
Time=Deform_Times+1;
% Motor size is 8*6*4 cm.
motor_l=8;motor_w=6;motor_h=4;

basic_margin=5;%The width of each feature
basic_margin_z=4;%The height of each feature
floor_Face_mesh=7;% Sample 7 features per face
z_mesh_paixu=(35:floor_Face_mesh+1:91)+basic_margin_z; % Calculate the height of 7 features
z_mesh_paixu(floor_Face_mesh+1)=[];
fa_vector_plot_norm=4;%%The length of the direction for plotting

%% some colors 
Face_mesh_color=[255, 255, 255]/255;
Motor_color =[133,193,233]/255;  % 浅蓝色
Motor_range_color =[93, 109, 126]/255;  % 灰褐色
Mesh_color=[189, 195, 199]/255;

%%
target_object=Object_1;
target_object_corner=Object_corner_1;
singleobject_num=length(Object_1(:,1));
temp_tk=1;

figure(1)
scatter3(center_object(1),center_object(2),center_object(3),'r*'); %画圆点
hold on
Subroutine_for_drawing_object
axis([-120 120 -120 120 0 100]);
axis equal
view(-34,27)
xlabel('X');
ylabel('Y');
zlabel('Z');


% fa_norm_plot=4;