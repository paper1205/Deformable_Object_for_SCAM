function drawCuboid(vertices, color)
    % 输入参数：
    % vertices：包含8个顶点坐标的矩阵，每个点是一个行向量 [x, y, z]
    % color：所需的颜色，可以是字符串或RGB元组

    % 定义连接这些顶点的面
    faces = [
        1, 2, 3, 4;  % 底面
        5, 6, 7, 8;  % 顶面
        1, 2, 6, 5;  % 侧面1
        2, 3, 7, 6;  % 侧面2
        3, 4, 8, 7;  % 侧面3
        4, 1, 5, 8;  % 侧面4
    ];

    % 使用 fill3 函数填充长方体

    patch('Vertices', vertices, 'Faces', faces, 'FaceColor', color, 'EdgeColor', 'k');



    % 设置图形属性

    axis equal;  % 保持坐标轴比例相等
    grid on;
end

