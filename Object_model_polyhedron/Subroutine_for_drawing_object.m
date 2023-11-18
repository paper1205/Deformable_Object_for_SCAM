
%% Draw the motor information at the top
%% These are not feature points to be covered and do not necessarily need to be drawn.
plot3([0,55],[5,5],[91,91],'k');  %East
plot3([0,55],[-5,-5],[91,91],'k'); 
plot3([0,0],[-5,5],[91,91],'k');  
plot3([55,55],[-5,5],[91,91],'k');  

plot3([5,5],[0,-55],[91,91],'k');  %South
plot3([-5,-5],[0,-55],[91,91],'k');  
plot3([-5,5],[0,0],[91,91],'k');  
plot3([-5,5],[-55,-55],[91,91],'k');  

plot3([-55,0],[5,5],[91,91],'k');  %West
plot3([-55,0],[-5,-5],[91,91],'k'); 
plot3([0,0],[-5,5],[91,91],'k');  
plot3([-55,-55],[-5,5],[91,91],'k'); 

plot3([5,5],[0,55],[91,91],'k');  %North
plot3([-5,-5],[0,55],[91,91],'k');  
plot3([-5,5],[0,0],[91,91],'k');  
plot3([-5,5],[55,55],[91,91],'k');  

%%The trajectory range that the motor can move is shown in blue.  
Motor1_range_vertices=[-4,-motor_move_max,91;4,-motor_move_max,91;4,-motor_move_min,91;-4,-motor_move_min,91];
Motor3_range_vertices=[-4,motor_move_min,91;4,motor_move_min,91;4,motor_move_max,91;-4,motor_move_max,91];
Motor2_range_vertices=[motor_move_min,-4,91;motor_move_min,4,91;motor_move_max,4,91;motor_move_max,-4,91];
Motor4_range_vertices=[-motor_move_min,-4,91;-motor_move_min,4,91;-motor_move_max,4,91;-motor_move_max,-4,91];

drawColoredQuadrilateral(Motor1_range_vertices,Motor_range_color);
drawColoredQuadrilateral(Motor3_range_vertices,Motor_range_color);
drawColoredQuadrilateral(Motor2_range_vertices,Motor_range_color);
drawColoredQuadrilateral(Motor4_range_vertices,Motor_range_color);


%Draw the motors

Real_N= motor_position_NSEW(temp_tk,1);
Real_S= motor_position_NSEW(temp_tk,2);
Real_E= motor_position_NSEW(temp_tk,3);
Real_W= motor_position_NSEW(temp_tk,4);

Motor_N=[-motor_l/2,Real_N+motor_w/2,91;motor_l/2,Real_N+motor_w/2,91;motor_l/2,Real_N-motor_w/2,91;-motor_l/2,Real_N-motor_w/2,91;
    -motor_l/2,Real_N+motor_w/2,95;motor_l/2,Real_N+motor_w/2,95;motor_l/2,Real_N-motor_w/2,95;-motor_l/2,Real_N-motor_w/2,95];

Motor_S=[-4,-(Real_S+motor_w/2),91;4,-(Real_S+motor_w/2),91;4,-(Real_S-motor_w/2),91;-4,-(Real_S-motor_w/2),91;
    -4,-(Real_S+motor_w/2),95;4,-(Real_S+motor_w/2),95;4,-(Real_S-motor_w/2),95;-4,-(Real_S-motor_w/2),95];

Motor_E=[(Real_E-motor_w/2),-4,91;(Real_E-motor_w/2),4,91;(Real_E+motor_w/2),4,91;(Real_E+motor_w/2),-4,91;
    (Real_E-motor_w/2),-4,95;(Real_E-motor_w/2),4,95;(Real_E+motor_w/2),4,95;(Real_E+motor_w/2),-4,95];

Motor_W=[-(Real_W+motor_w/2),-4,91;-(Real_W+motor_w/2),4,91;-(Real_W-motor_w/2),4,91;-(Real_W-motor_w/2),-4,91;
    -(Real_W+motor_w/2),-4,95;-(Real_W+motor_w/2),4,95;-(Real_W-motor_w/2),4,95;-(Real_W-motor_w/2),-4,95];

drawCuboid(Motor_N, Motor_color);drawCuboid(Motor_S, Motor_color);
drawCuboid(Motor_E, Motor_color);drawCuboid(Motor_W, Motor_color);

%% Draw the faces
Segment_vertice_all=Segment_vertice_deform(:,:,temp_tk);

for k_face=1:32
temp_face_vertuces=[Segment_vertice_all(k_face,1),Segment_vertice_all(k_face,2),0;Segment_vertice_all(k_face+1,1),Segment_vertice_all(k_face+1,2),0;
                                    Segment_vertice_all(k_face+1,1),Segment_vertice_all(k_face+1,2),91;Segment_vertice_all(k_face,1),Segment_vertice_all(k_face,2),91];
drawColoredQuadrilateral(temp_face_vertuces,Face_mesh_color);
end


%%Draw the feature points on the face 
scatter3(Object_1(:,1),Object_1(:,2),Object_1(:,3),'b*');
quiver3(Object_1(:,1),Object_1(:,2),Object_1(:,3),Object_1(:,4),Object_1(:,5),Object_1(:,6),'LineWidth',1,'Color','b','MaxHeadSize',0.5);

%%Draw the square of the feature point 

for k_fp=1:224
temp_mesh_vertices(:,:,k_fp)=[Object_corner_1(k_fp,1:3);Object_corner_1(k_fp,4:6);Object_corner_1(k_fp,7:9);Object_corner_1(k_fp,10:12)];
drawColoredQuadrilateral(temp_mesh_vertices(:,:,k_fp),Mesh_color);
end

