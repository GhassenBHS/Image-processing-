function[output] = FreehandMasking(input,method)
% Function that performs masking

%output = zeros(size(input,1),size(input,2));
switch method
case 1
mask = roipoly(input);% Select ROI using roipoly
case 2
figure, imshow(input)
h = imfreehand;      % Select ROI using imfreehand
pos = wait(h);
%output=h.createMask;

[rows,columns] = size(input);
mask = poly2mask(pos(:,1),pos(:,2),rows,columns);

end

%output(mask) = 1; 
output=mask ;
output = ~output;
output = 1-output;
output = (output == 0);
%output=m;
  % Perform masking to erase selected object