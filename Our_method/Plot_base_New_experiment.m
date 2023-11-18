%%画基础部分

%四条杆，依次是东南西北。
plot3([0,55],[5,5],[91,91],'k');  %东
plot3([0,55],[-5,-5],[91,91],'k'); 
plot3([0,0],[-5,5],[91,91],'k');  
plot3([55,55],[-5,5],[91,91],'k');  

plot3([5,5],[0,-55],[91,91],'k');  %南
plot3([-5,-5],[0,-55],[91,91],'k');  
plot3([-5,5],[0,0],[91,91],'k');  
plot3([-5,5],[-55,-55],[91,91],'k');  

plot3([-55,0],[5,5],[91,91],'k');  %西
plot3([-55,0],[-5,-5],[91,91],'k'); 
plot3([0,0],[-5,5],[91,91],'k');  
plot3([-55,-55],[-5,5],[91,91],'k'); 

plot3([5,5],[0,55],[91,91],'k');  %北
plot3([-5,-5],[0,55],[91,91],'k');  
plot3([-5,5],[0,0],[91,91],'k');  
plot3([-5,5],[55,55],[91,91],'k');  

%%画出电机可以移动的轨迹范围，用蓝色表示   
Motor_range_color =[93, 109, 126]/255;  % 灰褐色
Motor1_range_vertices=[-4,-motor_move_max,91;4,-motor_move_max,91;4,-motor_move_min,91;-4,-motor_move_min,91];
Motor3_range_vertices=[-4,motor_move_min,91;4,motor_move_min,91;4,motor_move_max,91;-4,motor_move_max,91];
Motor2_range_vertices=[motor_move_min,-4,91;motor_move_min,4,91;motor_move_max,4,91;motor_move_max,-4,91];
Motor4_range_vertices=[-motor_move_min,-4,91;-motor_move_min,4,91;-motor_move_max,4,91;-motor_move_max,-4,91];

drawColoredQuadrilateral(Motor1_range_vertices,Motor_range_color);
drawColoredQuadrilateral(Motor3_range_vertices,Motor_range_color);
drawColoredQuadrilateral(Motor2_range_vertices,Motor_range_color);
drawColoredQuadrilateral(Motor4_range_vertices,Motor_range_color);