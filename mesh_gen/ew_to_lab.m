function [body_real] = ew_to_lab(rot_mat,realc,indices)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

body_3d = [realc{1}(indices(:,1))',realc{2}(indices(:,2))',realc{3}(indices(:,3))'];
body_real = rot_mat*body_3d';

end