function drawColoredQuadrilateral( vertices, color)
    % 输入参数：
    % A, B, C, D：四个点的坐标，每个点是一个行向量 [x, y, z]
    % color：所需的颜色，可以是字符串或RGB元组


    % 定义连接这些顶点的面
    faces = [1, 2, 3, 4];

    % 使用 fill3 函数填充四边形
    fill3(vertices(:, 1), vertices(:, 2), vertices(:, 3), color, 'EdgeColor', 'k');


    % 设置图形属性

    axis equal;  % 保持坐标轴比例相等
    grid on;
end