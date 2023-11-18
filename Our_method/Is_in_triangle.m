% function result=Is_in_triangle(p,a,b,c)
% 计算点是否位于三角形内的函数,p可为n*3矩阵，对应输出result为n维向量
function result=Is_in_triangle(p,a,b,c)
% 通过面积计算是否在三角形内
Sabc=0.5*sqrt(sum((cross(b-a,c-a,2).^2)')');%%整个三角形的面积  %%该处值得优化，改为导入计算的三角形面积
%%三个三角形的面积
s1=0.5*sqrt(sum((cross(a-p,b-p,2).^2)')');   
s2=0.5*sqrt(sum((cross(a-p,c-p,2).^2)')');
s3=0.5*sqrt(sum((cross(c-p,b-p,2).^2)')');
 %%判断面积是否相等，
if   abs(Sabc-s1-s2-s3)<0.01
    result = 1;  %%点在三角形内，即存在遮挡
else
    result = 0; %%点在三角形外
end

